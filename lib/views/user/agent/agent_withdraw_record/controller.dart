import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/services/agent_service.dart';

class AgentWithdrawRecordController extends GlobalLogic {
  AgentWithdrawRecordController();

  int pageIndex = 0;
  final dataList = <String>[].obs;

  loadData({type = ''}) async {
    pageIndex = 0;
    return loadMoreData();
  }

  loadMoreData() async {
    var data = await AgentService.getCommissionList({'page': (++pageIndex)});
    return data;
  }
}
