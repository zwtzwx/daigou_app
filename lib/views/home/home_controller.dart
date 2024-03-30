import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/common/loading_util.dart';
import 'package:shop_app_client/common/version_util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/language_change_event.dart';
import 'package:shop_app_client/events/logined_event.dart';
import 'package:shop_app_client/models/ads_pic_model.dart';

import 'package:shop_app_client/models/announcement_model.dart';
import 'package:shop_app_client/models/goods_category_model.dart';
import 'package:shop_app_client/models/language_model.dart';
import 'package:shop_app_client/models/shop/platform_goods_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/ads_service.dart';
import 'package:shop_app_client/services/announcement_service.dart';
import 'package:shop_app_client/services/common_service.dart';
import 'package:shop_app_client/services/shop_service.dart';
import 'package:shop_app_client/services/user_service.dart';
import 'package:shop_app_client/state/i10n.dart';
import 'package:shop_app_client/storage/annoucement_storage.dart';
import 'package:shop_app_client/storage/user_storage.dart';
import 'package:shop_app_client/views/components/update_dialog.dart';
import 'package:shop_app_client/views/home/widget/ad_dialog.dart';

import 'package:shop_app_client/views/home/widget/annoucement_dialog.dart';
import 'package:shop_app_client/views/tabbar/tabbar_controller.dart';

class IndexLogic extends GlobalController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Locale i10n = Get.find<Locale>();
  RxList<LanguageModel> langList = <LanguageModel>[].obs;

  final userModel = Get.find<AppStore>().userInfo;
  final noticeList = <AnnouncementModel>[].obs;
  final Rx<ListLoadingModel<PlatformGoodsModel>> loadingUtil =
      ListLoadingModel<PlatformGoodsModel>().obs;
  final goodsLoading = true.obs;
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final tabController = Get.find<TabbarManager>();
  final agentStatus = 3.obs;
  // 是否有未读消息
  final hasNotRead = false.obs;


  @override
  void onInit() {
    super.onInit();
    getAnnoucementList();
    getIndexAnnoucement();
    getLatestApkInfo();
    getCategory();
    getAds();
    getAgentStatus();
    hasReadMessage();
    loadingUtil.value.initListener(
      getRecommendGoods,
      recordPosition: true,
      onPositionChange: (value) {
        tabController.showToTopIcon.value = value > 300.h;
      },
    );
    ApplicationEvent.getInstance()
        .event
        .on<LanguageChangeEvent>()
        .listen((event) {
      handleRefresh();
    });
    ApplicationEvent.getInstance().event.on<LoginedEvent>().listen((event) {
      getAgentStatus();
    });
  }

  // 获取最新版本的安装包
  getLatestApkInfo() async {
    var res = await CommonService.getLatestApkInfo();
    if (res != null) {
      var needUpdate = await VersionUtil.isAppUpdatedRequired(res.version);
      var lastTime = CommonStorage.getVersionTime();
      var nowTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (needUpdate && (lastTime == null || lastTime + 24 * 3600 < nowTime)) {
        Get.dialog(UpdateDialog(appModel: res), barrierDismissible: false);
      }
    }
  }

  getAgentStatus() async {
    if (userModel.value != null) {
      var data = await UserService.getAgentStatus();
      if (data != null) {
        agentStatus.value = data.id.toInt();
      }
    }
  }

  // 代购商品分类列表
  getCategory() async {
    var list = await ShopService.getCategoryList();
    categoryList.value = list;
  }

  // 公告列表
  getAnnoucementList() async {
    var data = await AnnouncementService.getList();
    if (data['dataList'] != null) {
      noticeList.value = data['dataList'];
    }
  }

  // 最新公告
  getIndexAnnoucement() async {
    var data = await AnnouncementService.getLatest();
    String uniqueId = NoticeStorage.getUniqueId();
    if (data != null && data.uniqueId != uniqueId) {
      NoticeStorage.setUniqueId(data.uniqueId);
      onShowAnnoucement(data);
    }
  }

  // 显示公告弹窗
  onShowAnnoucement(AnnouncementModel data) async {
    bool detail = await Get.dialog(
      AnnoucementDialog(model: data),
      barrierDismissible: false,
    );
    if (detail) {
      GlobalPages.push(GlobalPages.webview, arg: {
        'id': data.id,
        'title': data.title,
        'time': data.createdAt,
        'type': 'notice',
      });
    }
  }

  // 获取弹窗、活动广告
  getAds() async {
    List<BannerModel> result = await AdsService.getList({"source": 4});
    List<BannerModel> adList = [];
    for (var item in result) {
      if (item.type == 4) {
        adList.add(item);
      }
    }
    for (var item in adList) {
      Get.dialog(
        AdDialog(adItem: item),
      );
    }
  }

  // 推荐商品
  getRecommendGoods() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'page': ++loadingUtil.value.pageIndex,
        'page_size': 10,
        'platform': '1688',
        'keyword': '服饰'
      });
      loadingUtil.value.isLoading = false;
      if (data['dataList'] != null) {
        loadingUtil.value.list.addAll(data['dataList']);
        if (data['dataList'].isEmpty && data['pageIndex'] == 1) {
          loadingUtil.value.isEmpty = true;
        } else if (data['total'] == data['pageIndex']) {
          loadingUtil.value.hasMoreData = false;
        }
      }
    } catch (e) {
      loadingUtil.value.isLoading = false;
      loadingUtil.value.pageIndex--;
      loadingUtil.value.hasError = true;
    } finally {
      loadingUtil.refresh();
    }
  }

   hasReadMessage() async {
    var res = await CommonService.hasUnReadInfo();
    if(res == true) {
      hasNotRead.value = true;
      // hasNotRead.refresh();
    }
  }

  // 页面刷新
  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await getAds();
    await getRecommendGoods();
    await getCategory();
    await getAnnoucementList();
    //未读消息
    await hasReadMessage();

  }
}
