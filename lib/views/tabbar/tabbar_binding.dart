import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/components/language_cell/language_cell_controller.dart';
import 'package:shop_app_client/views/home/home_controller.dart';
import 'package:shop_app_client/views/tabbar/tabbar_controller.dart';
import 'package:shop_app_client/views/user/me/me_controller.dart';

class TabbarLinker extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabbarManager());
    Get.lazyPut(() => IndexLogic());
    Get.lazyPut(() => BeeCenterLogic());
    Get.lazyPut(() => LanguageCellController());
  }
}
