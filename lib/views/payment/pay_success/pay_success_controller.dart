import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';

class PaySuccessController extends GlobalController {
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
    Get.offAllNamed(GlobalPages.home, arguments: {'index': 2});
  }

  void onOrderDetail() {
    if (isShopOrder.value) {
      GlobalPages.redirect(GlobalPages.shopOrderDetail, {'id': orderId.value});
    } else {
      GlobalPages.redirect(GlobalPages.orderDetail, {'id': orderId.value});
    }
  }
}
