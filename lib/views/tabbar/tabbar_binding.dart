import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/components/language_cell/language_cell_controller.dart';
import 'package:huanting_shop/views/home/home_controller.dart';
import 'package:huanting_shop/views/tabbar/tabbar_controller.dart';
import 'package:huanting_shop/views/user/me/me_controller.dart';

class BeeBottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BeeBottomNavLogic());
    Get.lazyPut(() => IndexLogic());
    Get.lazyPut(() => BeeCenterLogic());
    Get.lazyPut(() => LanguageCellController());
  }
}
