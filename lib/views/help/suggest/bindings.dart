import 'package:get/get.dart';

import 'controller.dart';

class SuggestBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuggestController>(() => SuggestController());
  }
}
