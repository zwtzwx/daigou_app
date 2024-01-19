import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/payment/shop_pay/shop_order_pay_conctroller.dart';

class ShopOrderPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderPayController());
  }
}
