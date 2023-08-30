import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';

class PaySuccessController extends BaseController {
  final isShopOrder = false.obs;
  final orderId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments['fromShop'] == true) {
      isShopOrder.value = true;
    }
    if (arguments['id'] != null) {
      orderId.value = arguments['id'];
    }
  }

  void onShopCenter() {
    Get.offAllNamed(Routers.home, arguments: {'index': 2});
  }

  void onOrderDetail() {
    if (isShopOrder.value) {
      Routers.redirect(Routers.shopOrderDetail, {'id': orderId.value});
    } else {
      Routers.redirect(Routers.orderDetail, {'id': orderId.value});
    }
  }
}
