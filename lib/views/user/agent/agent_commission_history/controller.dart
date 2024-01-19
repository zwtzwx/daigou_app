import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/withdrawal_item_model.dart';
import 'package:huanting_shop/services/agent_service.dart';

class AgentCommissionHistoryController extends GlobalLogic {
  int pageIndex = 0;

  //提现记录列表
  final dataList = <WithdrawalItemModel>[];

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
    };

    var data = await AgentService.getCheckoutWithDrawList(dic);

    return data;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
