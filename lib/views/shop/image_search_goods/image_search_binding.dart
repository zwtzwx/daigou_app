import 'package:get/get.dart';
import 'package:huanting_shop/views/shop/image_search_goods/image_search_logic.dart';

class GoodsImageSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsImageSearchLogic());
  }
}
