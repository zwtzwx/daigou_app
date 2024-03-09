import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/withdrawal_item_model.dart';
import 'package:shop_app_client/services/agent_service.dart';

class AgentWithdrawDetailController extends GlobalController {
  final detailModel = Rxn<WithdrawalItemModel?>();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    getDetail();
  }

  getDetail() async {
    showLoading();
    var data = await AgentService.getWithdrawDetail(Get.arguments['id']);
    hideLoading();
    detailModel.value = data;
  }
}
