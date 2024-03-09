import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/transaction/transaction_controller.dart';

class BeeTradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeTradeLogic());
  }
}
