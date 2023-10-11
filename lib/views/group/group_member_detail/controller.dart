import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/services/group_service.dart';

class BeeGroupUsersController extends GlobalLogic {
  final groupModel = Rxn<GroupModel?>();

  @override
  void onInit() {
    super.onInit();
    getDetail();
  }

  void getDetail() async {
    showLoading();
    var data = await GroupService.getGroupMemberDetail(Get.arguments['id']);
    hideLoading();
    groupModel.value = data;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
