import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/parcel_model.dart';
import 'package:huanting_shop/services/parcel_service.dart';

class BeePackageDetailLogic extends GlobalLogic {
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
