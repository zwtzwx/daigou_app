import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/shop_order_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/goods/shop_order_item.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';

class ShopOrderList extends StatefulWidget {
  const ShopOrderList({
    Key? key,
    required this.status,
  }) : super(key: key);
  final int status;

  @override
  State<ShopOrderList> createState() => _ShopOrderListState();
}

class _ShopOrderListState extends State<ShopOrderList> {
  int page = 0;

  loadData({type}) async {
    page = 0;
    return await loadMoreData();
  }

  loadMoreData() async {
    var params = {'page': ++page, 'size': 10};
    if (widget.status != 0) {
      for (var i = 0; i < statusList.length; i++) {
        params['status[$i]'] = statusList[i];
      }
    }
    var data = await ShopService.getOrderList(params);
    return data;
  }

  List<int> get statusList {
    List<int> list = [];
    switch (widget.status) {
      case 1:
        list = [0];
        break;
      case 2:
        list = [1, 2];
        break;
      case 3:
        list = [3, 4];
        break;
      case 4:
        list = [5];
        break;
      case 5:
        list = [6];
        break;
      case 6:
        list = [10];
        break;
    }
    return list;
  }

  // 订单支付
  void orderPay({
    required String orderSn,
  }) async {
    var s = await Routers.push(Routers.shopOrderPay, {
      'order': [orderSn],
      'fromOrderList': true,
    });
    if (s != null) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  // 取消订单
  void orderCancel({
    required BuildContext context,
    required int orderId,
    Function? onSuccess,
  }) async {
    var confirmed = await BaseDialog.cupertinoConfirmDialog(
      context,
      '您确定要取消订单吗'.ts,
    );
    if (confirmed != true) return;
    var res = await ShopService.orderCancel(orderId);
    if (res['ok']) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      child: ListRefresh(
        renderItem: (int index, ShopOrderModel model) {
          return ShopOrderItem(
            model: model,
            onPay: () {
              orderPay(orderSn: model.orderSn);
            },
            onCancel: () {
              orderCancel(context: context, orderId: model.id);
            },
          );
        },
        refresh: loadData,
        more: loadMoreData,
      ),
    );
  }
}
