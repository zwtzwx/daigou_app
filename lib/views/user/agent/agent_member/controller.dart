import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/services/agent_service.dart';

class AgentMemberController extends GlobalController {
  int promotionType = 1;
  int pageIndex = 0;

  @override
  onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) promotionType = arguments;
  }

  loadData({type}) async {
    pageIndex = 0;
    return await loadMoreData();
  }

  loadMoreData() async {
    var data = await AgentService.getSubList({
      'page': ++pageIndex,
      'has_order': promotionType - 1,
    });
    return data;
  }
}
