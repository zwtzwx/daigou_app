import 'package:get/get.dart';
import 'package:huanting_shop/views/shop/image_search_goods_list/logics.dart';

class GoodsImageSearchResultBinding extends Bindings {
  final String tag;

  GoodsImageSearchResultBinding({required this.tag});

  @override
  void dependencies() {
    Get.put(GoodsImageSearchResultLogic(), tag: tag);
  }
}
