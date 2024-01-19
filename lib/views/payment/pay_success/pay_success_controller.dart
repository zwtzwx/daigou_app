import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';

class PaySuccessController extends GlobalLogic {
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
    Get.offAllNamed(BeeNav.home, arguments: {'index': 2});
  }

  void onOrderDetail() {
    if (isShopOrder.value) {
      BeeNav.redirect(BeeNav.shopOrderDetail, {'id': orderId.value});
    } else {
      BeeNav.redirect(BeeNav.orderDetail, {'id': orderId.value});
    }
  }
}
