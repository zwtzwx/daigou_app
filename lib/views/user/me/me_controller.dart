import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/profile_updated_event.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';

class MeController extends BaseController {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //会员中心基础信息
  final userVipModel = Rxn<UserVipModel?>();
  final isloading = false.obs;
  UserInfoModel userInfoModel = Get.find<UserInfoModel>();
  @override
  void onInit() {
    super.onInit();
    ApplicationEvent.getInstance()
        .event
        .on<ProfileUpdateEvent>()
        .listen((event) {
      created();
    });
    created();
  }

  /*
    用户基础数据统计
    余额，收益，积分
    个人基础信息
   */
  Future<void> created() async {
    var token = userInfoModel.token;
    if (token.isNotEmpty) {
      userVipModel.value = await UserService.getVipMemberData();
      isloading.value = true;
    }
  }

  /* 注销登录 */
  void onLogout() async {
    //清除TOKEN
    userInfoModel.clear();
    ApplicationEvent.getInstance()
        .event
        .fire(ChangePageIndexEvent(pageName: 'home'));
  }
}
