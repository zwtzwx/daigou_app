import 'package:get/get.dart';
import 'package:huanting_shop/views/shop/category/controller.dart';

class GoodsCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsCategoryController());
  }
}
