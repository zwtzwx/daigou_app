import 'package:get/get.dart';

import 'controller.dart';

class CouponBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CouponController>(() => CouponController());
  }
}
