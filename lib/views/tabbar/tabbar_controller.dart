import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/cart_count_refresh_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/firebase/notification.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class BeeBottomNavLogic extends GlobalLogic {
  late final pageController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final selectIndex = 0.obs;
  final cartCount = 0.obs;
  UserInfoModel userInfoModel = Get.find<UserInfoModel>();

  @override
  void onInit() {
    super.onInit();
    // 初始化 notification
    Notifications.initialized();
    if (Get.arguments is Map && Get.arguments['index'] != null) {
      selectIndex.value = Get.arguments['index'];
      pageController = PageController(initialPage: Get.arguments['index']);
    } else {
      pageController = PageController(initialPage: 0);
    }
    getCartCount();
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

    ApplicationEvent.getInstance()
        .event
        .on<CartCountRefreshEvent>()
        .listen((event) {
      getCartCount();
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
    if (userInfoModel.token.value.isEmpty && [3, 4].contains(index)) {
      BeeNav.push(BeeNav.login);
      return;
    }
    pageController.jumpToPage(index);
  }

  // 购物车商品数量
  void getCartCount() async {
    var token = UserStorage.getToken();
    if (token.isNotEmpty) {
      var data = await ShopService.getCartCount();
      cartCount.value = data ?? 0;
    } else {
      cartCount.value = 0;
    }
  }
}
