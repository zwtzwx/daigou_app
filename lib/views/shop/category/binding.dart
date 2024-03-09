import 'package:get/get.dart';
import 'package:shop_app_client/views/shop/category/controller.dart';

class GoodsCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsCategoryController());
  }
}
