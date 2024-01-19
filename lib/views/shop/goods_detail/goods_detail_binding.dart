import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/shop/goods_detail/goods_detail_controller.dart';

class GoodsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsDetailController());
  }
}
