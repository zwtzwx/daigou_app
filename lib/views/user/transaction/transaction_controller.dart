import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/services/balance_service.dart';

class BeeTradeLogic extends GlobalController {
  int pageIndex = 0;
  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    return BalanceService.getTransactionList({
      "page": (++pageIndex),
    });
  }

  // 交易类型
  String getType(int type) {
    String typeName = '';
    switch (type) {
      case 1:
        typeName = '消费';
        break;
      case 2:
        typeName = '充值';
        break;
      case 3:
        typeName = '退款';
        break;
      case 4:
        typeName = '提现';
        break;
      case 6:
        typeName = '充值赠送';
        break;
    }
    return typeName;
  }
}
