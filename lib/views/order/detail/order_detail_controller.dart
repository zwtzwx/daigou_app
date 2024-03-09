import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/list_refresh_event.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/models/order_model.dart';
import 'package:shop_app_client/services/order_service.dart';

class BeeOrderLogic extends GlobalController {
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
          BaseUtils.getOrderStatusName(data.status, data.stationOrder);
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
    var s = await GlobalPages.push(GlobalPages.orderComment,
        arg: {'order': model.value});
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
    return (price ?? 0).priceConvert();
  }
}
