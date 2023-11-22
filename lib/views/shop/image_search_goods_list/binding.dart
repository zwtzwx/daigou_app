import 'package:get/get.dart';
import 'package:jiyun_app_client/views/shop/image_search_goods_list/logics.dart';

class GoodsImageSearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsImageSearchResultLogic());
  }
}
