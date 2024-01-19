import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/transaction/transaction_controller.dart';

class BeeTradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeTradeLogic());
  }
}
