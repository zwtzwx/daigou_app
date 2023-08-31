import 'package:get/get.dart';

import 'controller.dart';

class CommentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentController>(() => CommentController());
  }
}
