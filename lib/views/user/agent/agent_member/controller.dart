import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/agent_data_count_model.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/services/agent_service.dart';

class AgentMemberController extends GlobalLogic {
  final promotionType = 1.obs;

  final countModel = Rxn<AgentDataCountModel?>();
  final userInfo = Get.find<AppStore>().userInfo;
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
