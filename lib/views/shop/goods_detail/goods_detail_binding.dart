import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_controller.dart';

class GoodsDetailBinding extends Bindings {
  final String tag;
  GoodsDetailBinding({required this.tag});

  @override
  void dependencies() {
    Get.put(GoodsDetailController(), tag: tag);
  }
}
