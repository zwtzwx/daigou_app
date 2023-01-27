import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/express/express_query_controller.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';
import 'package:jiyun_app_client/views/order/center/order_center_controller.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_controller.dart';
import 'package:jiyun_app_client/views/user/me/me_controller.dart';

class TabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabbarController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ExpressQueryController());
    Get.lazyPut(() => OrderCenterController());
    Get.lazyPut(() => MeController());
  }
}
