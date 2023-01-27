import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';

class OrderCenterController extends BaseController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //各类包裹统计
  final userOrderCountModel = Rxn<UserOrderCountModel?>();

  @override
  onInit() {
    super.onInit();
    getDatas();
    ApplicationEvent.getInstance()
        .event
        .on<OrderCountRefreshEvent>()
        .listen((event) {
      getDatas();
    });
  }

  Future<void> getDatas() async {
    var countData = await UserService.getOrderDataCount();
    userOrderCountModel.value = countData;
  }
}
