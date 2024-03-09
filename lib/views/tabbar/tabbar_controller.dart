import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/change_page_index_event.dart';
import 'package:shop_app_client/events/un_authenticate_event.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/views/home/home_controller.dart';

class TabbarManager extends GlobalController {
  late final PageController pageController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final selectIndex = 0.obs;
  final showToTopIcon = false.obs;
  AppStore userInfoModel = Get.find<AppStore>();

  @override
  void onInit() {
    super.onInit();
    // 初始化 notification
    // Notifications.initialized();
    if (Get.arguments is Map && Get.arguments['index'] != null) {
      selectIndex.value = Get.arguments['index'];
      pageController = PageController(initialPage: Get.arguments['index']);
    } else {
      pageController = PageController(initialPage: 0);
    }
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
      case 'center':
        index = 1;
        break;
    }

    return index;
  }

  void onTap(int index) async {
    //Token存在Model状态管理器中的
    if (userInfoModel.token.value.isEmpty && index != 0) {
      GlobalPages.push(GlobalPages.login);
      return;
    }
    selectIndex.value = index;
    if (index == 0 && showToTopIcon.value) {
      Get.find<IndexLogic>().loadingUtil.value.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
    } else {
      pageController.jumpToPage(index);
    }
  }
}
