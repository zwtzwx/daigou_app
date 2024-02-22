import 'package:get/instance_manager.dart';
import 'package:huanting_shop/models/order_model.dart';
import 'package:huanting_shop/services/order_service.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/order/center/order_center_controller.dart';
import 'package:huanting_shop/views/order/widget/order_item_cell.dart';

/*
  订单列表
*/

class TransportOrderList extends StatefulWidget {
  const TransportOrderList({
    Key? key,
    required this.status,
  }) : super(key: key);
  final int status;

  @override
  State<TransportOrderList> createState() => _TransportOrderListState();
}

class _TransportOrderListState extends State<TransportOrderList> {
  int pageIndex = 0;
  final controller = Get.find<BeeOrderIndexLogic>();

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      'status': widget.status,
      'page': (++pageIndex),
      'keyword': controller.keyword,
    };
    var data = await OrderService.getList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshView(
        renderItem: renderItem,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget renderItem(int index, OrderModel orderModel) {
    return BeeOrderItem(
      orderModel: orderModel,
    );
  }
}
