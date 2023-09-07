import 'package:get/get.dart';

import 'controller.dart';

class CodeScanBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CodeScanController>(() => CodeScanController());
  }
}
