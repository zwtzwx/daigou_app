import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';

class AgentCommissionController extends GlobalLogic {
  final selModelList = <WithdrawalModel>[].obs;
  final allModelList = <WithdrawalModel>[].obs;

  final selectNum = 0.obs;
  int pageIndex = 0;

  onApply() async {
    List<int> ids = [];
    for (var item in selModelList) {
      ids.add(item.id);
    }
    if (ids.isEmpty) {
      showToast('请选择要提现的订单');
      return;
    }
    BeeNav.push(BeeNav.agentCommissionApply, {'ids': ids});
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await AgentService.getAvailableWithDrawList(
        {'is_withdraw_list': '1', 'page': (++pageIndex), 'size': 20});

    return data;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
