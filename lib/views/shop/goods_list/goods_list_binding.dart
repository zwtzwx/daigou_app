import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/shop/goods_list/goods_list_controller.dart';

class GoodsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoodsListController());
  }
}
