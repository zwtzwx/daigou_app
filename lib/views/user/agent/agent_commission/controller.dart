import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';

class AgentCommissionController extends BaseController {
  final selModelList = <WithdrawalModel>[].obs;
  final allModelList = <WithdrawalModel>[].obs;

  final selectNum = 0.obs;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  onApply() async {
    List<int> ids = [];
    for (var item in selModelList) {
      ids.add(item.id);
    }
    if (ids.isEmpty) {
      showToast('请选择要提现的订单');
      return;
    }
    Routers.push(Routers.agentCommissionApply, {'ids': ids});
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
