// ignore_for_file: unnecessary_new

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/order/list/order_list_controller.dart';
import 'package:jiyun_app_client/views/order/widget/order_item_cell.dart';

/*
  订单列表
*/

class OrderListView extends GetView<OrderListController> {
  const OrderListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Obx(
          () => ZHTextLine(
            str: controller.pageTitle.value.ts,
            color: BaseStylesConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: SafeArea(
        child: ListRefresh(
          renderItem: renderItem,
          refresh: controller.loadList,
          more: controller.loadMoreList,
        ),
      ),
    );
  }

  Widget renderItem(int index, OrderModel orderModel) {
    return OrderItemCell(
      orderModel: orderModel,
    );
  }
}
