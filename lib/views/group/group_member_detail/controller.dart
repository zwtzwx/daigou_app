import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/group_model.dart';
import 'package:huanting_shop/services/group_service.dart';

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
