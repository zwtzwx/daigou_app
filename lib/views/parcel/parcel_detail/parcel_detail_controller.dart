import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';

class ParcelDetailController extends BaseController {
  final isLoadingLocal = false.obs;

  late final parcelModel = Rxn<ParcelModel>();

  @override
  void onReady() {
    super.onReady();
    getDetail();
  }

  getDetail() async {
    var id = Get.arguments['id'];
    showLoading();
    var data = await ParcelService.getDetail(id);
    hideLoading();
    if (data != null) {
      parcelModel.value = data;
      isLoadingLocal.value = true;
    }
  }
}
