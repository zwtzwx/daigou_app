import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';

class LineDetailController extends BaseController {
  late final lineModel = Rxn<ShipLineModel>();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    lineModel.value = arguments['line'];
  }

  // showReginsList(BuildContext context) {
  //   UsualDialog.normalDialog(
  //     context,
  //     title: lineModel.value!.name,
  //     child: getAreaList(),
  //   );
  // }
}
