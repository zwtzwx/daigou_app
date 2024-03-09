import 'package:get/get.dart';
import 'package:shop_app_client/views/shop/image_search_goods/image_search_logic.dart';

class GoodsImageSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsImageSearchLogic());
  }
}
