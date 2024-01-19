import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/common/country/country_controller.dart';

class CountryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CountryController());
  }
}
