import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/shop/platform_goods/platform_goods_controller.dart';

class PlatformGoodsBinding extends Bindings {
  final String tag;
  PlatformGoodsBinding({required this.tag});

  @override
  void dependencies() {
    Get.put(PlatformGoodsController(), tag: tag);
  }
}
