import 'package:get/get.dart';

import 'controller.dart';

class QuestionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionController>(() => QuestionController());
  }
}
