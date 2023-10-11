import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/shop/shop_order_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class ShopOrderDetailController extends GlobalLogic {
  final orderModel = Rxn<ShopOrderModel?>();
  final isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments['id'] != null) {
      getDetail();
    }
  }

  // 订单详情
  Future<void> getDetail() async {
    isLoading.value = true;
    var data = await ShopService.getOrderDetail(Get.arguments['id']);
    if (data != null) {
      orderModel.value = data;
      isLoading.value = false;
    }
  }
}
