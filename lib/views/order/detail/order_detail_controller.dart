import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/list_refresh_event.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/models/order_model.dart';
import 'package:huanting_shop/services/order_service.dart';

class BeeOrderLogic extends GlobalLogic {
  final model = Rxn<OrderModel?>();
  late int orderId;
  final isLoading = false.obs;

  final statusStr = ''.obs;

  @override
  void onReady() {
    super.onReady();
    var arguments = Get.arguments;
    orderId = arguments['id'];
    getOrderDetail();
  }

  getOrderDetail() async {
    showLoading();
    var data = await OrderService.getDetail(orderId);
    hideLoading();
    if (data != null) {
      model.value = data;
      statusStr.value =
          CommonMethods.getOrderStatusName(data.status, data.stationOrder);
      isLoading.value = true;
    }
  }

  void onSign() async {
    showLoading();
    var result = await OrderService.signed(orderId);
    hideLoading();
    if (result['ok']) {
      showSuccess('签收成功');
      onRefresh();
    } else {
      showError(result['msg']);
    }
  }

  void onComment() async {
    var s = await BeeNav.push(BeeNav.orderComment, {'order': model.value});
    if (s == 'success') {
      getOrderDetail();
    }
  }

  void onRefresh() {
    getOrderDetail();
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
  }

  String getPriceStr(num? price) {
    return (price ?? 0).rate();
  }
}
