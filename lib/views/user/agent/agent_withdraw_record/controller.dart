import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/services/agent_service.dart';

class AgentWithdrawRecordController extends BaseController {
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
