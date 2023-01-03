// ignore_for_file: unnecessary_new

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/order/widget/order_item_cell.dart';
import 'package:provider/provider.dart';

/*
  订单列表
*/
class OrderListPage extends StatefulWidget {
  final Map arguments;

  const OrderListPage({Key? key, required this.arguments}) : super(key: key);

  @override
  OrderListPageState createState() => OrderListPageState();
}

class OrderListPageState extends State<OrderListPage> {
  LocalizationModel? localizationInfo;
  int pageIndex = 0;
  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    getPageTitle();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      'status': widget.arguments['index'], // 待处理订单
      'page': (++pageIndex),
    };
    var data = await OrderService.getList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: Translation.t(context, pageTitle),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SafeArea(
        child: ListRefresh(
          renderItem: renderItem,
          refresh: loadList,
          more: loadMoreList,
        ),
      ),
    );
  }

  Widget renderItem(int index, OrderModel orderModel) {
    return OrderItemCell(
      orderModel: orderModel,
    );
  }

  void getPageTitle() {
    String _pageTitle;
    switch (widget.arguments['index']) {
      case 1:
        _pageTitle = '待处理订单';
        break;
      case 2:
        _pageTitle = '待支付订单';
        break;
      case 3:
        _pageTitle = '待发货订单';
        break;
      case 4:
        _pageTitle = '已发货订单';
        break;
      default:
        _pageTitle = '已签收订单';
        break;
    }
    setState(() {
      pageTitle = _pageTitle;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
