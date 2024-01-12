import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/agent_data_count_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';

class AgentMemberController extends GlobalLogic {
  final promotionType = 1.obs;

  final countModel = Rxn<AgentDataCountModel?>();
  final userInfo = Get.find<UserInfoModel>().userInfo;
  final userList = <UserModel>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // getSubCount();
    getList();
  }

  getSubCount() async {
    var data = await AgentService.getDataCount();
    countModel.value = data;
  }

  getList() async {
    loading.value = true;
    userList.clear();
    var data = await AgentService.getSubList({
      'size': 999,
      'has_order': promotionType.value - 1,
    });
    userList.value = data['dataList'];
    loading.value = false;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
