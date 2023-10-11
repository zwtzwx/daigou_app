import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/services/common_service.dart';

class BeeSupportLogic extends GlobalLogic {
  final banner = Rxn<String?>();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    var data = await CommonService.getAllBannersInfo();
    banner.value = data?.supportImage;
  }
}
