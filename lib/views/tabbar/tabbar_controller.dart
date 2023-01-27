import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/firebase/notification.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class TabbarController extends BaseController {
  final pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final selectIndex = 0.obs;
  UserInfoModel userInfoModel = Get.find<UserInfoModel>();

  @override
  void onInit() {
    super.onInit();
    // 初始化 notification
    Notifications.initialized();
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      showToast('登录凭证已失效');
      pushToLogin();
    });

    ApplicationEvent.getInstance()
        .event
        .on<ChangePageIndexEvent>()
        .listen((event) {
      int index = jumpToIndex(event.pageName);
      onPageSelect(index);
      pageController.jumpToPage(index);
    });
  }

  //选择每一页
  void onPageSelect(int indexSelect) {
    selectIndex.value = indexSelect;
  }

  pushToLogin() async {
    var token = userInfoModel.token.value;
    if (token != '') {
      userInfoModel.clear();
    }
    onTap(0);
  }

  int jumpToIndex(String pageName) {
    int index = 0;
    switch (pageName) {
      case 'home':
        index = 0;
        break;
      case 'express':
        index = 1;
        break;
      case 'orders':
        index = 2;
        break;
    }

    return index;
  }

  void onTap(int index) async {
    //Token存在Model状态管理器中的
    if (userInfoModel.token.value.isEmpty && index != 1 && index != 0) {
      Routers.push(Routers.login);
      return;
    }
    pageController.jumpToPage(index);
  }
}
