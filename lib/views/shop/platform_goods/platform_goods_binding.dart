import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_controller.dart';

class PlatformGoodsBinding extends Bindings {
  final String tag;
  PlatformGoodsBinding({required this.tag});

  @override
  void dependencies() {
    Get.put(PlatformGoodsController(), tag: tag);
  }
}
