import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/services/balance_service.dart';

class RechargeHistoryController extends GlobalLogic {
  RechargeHistoryController();

  int pageIndex = 0;

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
    };
    var data = await BalanceService.getRechargeList(dic);
    return data;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
