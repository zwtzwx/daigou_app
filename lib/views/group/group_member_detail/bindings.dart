import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupUsersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeGroupUsersController>(() => BeeGroupUsersController());
  }
}
