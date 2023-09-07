import 'package:get/get.dart';

import 'controller.dart';

class GroupChooseParcelBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupChooseParcelController>(() => GroupChooseParcelController());
  }
}
