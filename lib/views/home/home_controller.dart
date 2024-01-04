import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/common/version_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/ads_pic_model.dart';

import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/language_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/shop/goods_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/ads_service.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/state/i10n.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/update_dialog.dart';
import 'package:jiyun_app_client/views/home/widget/ad_dialog.dart';

import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';

class IndexLogic extends GlobalLogic {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final I10n i10n = Get.find<I10n>();
  RxList<LanguageModel> langList = <LanguageModel>[].obs;
  final noticeUnRead = false.obs;
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final RxList<GoodsModel> hotGoodsList = <GoodsModel>[].obs;
  final loadingUtil = LoadingUtil<PlatformGoodsModel>().obs;

  final userModel = Get.find<UserInfoModel>().userInfo;
  final amountModel = Get.find<UserInfoModel>().amountInfo;
  final vipModel = Get.find<UserInfoModel>().vipInfo;
  final activityPicList = <BannerModel>[].obs;
  final lineList = <ShipLineModel>[].obs;
  final TextEditingController keywordController = TextEditingController();
  final FocusNode keywordNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    getIndexAnnoucement();
    // onGetUnReadNotice();
    getLatestApkInfo();
    // getPlatformCategory();
    getAds();
    getGreatLine();
    // loadingUtil.value.initListener(getRecommendGoods);
    // ApplicationEvent.getInstance()
    //     .event
    //     .on<NoticeRefreshEvent>()
    //     .listen((event) {
    //   onGetUnReadNotice();
    // });
    // ApplicationEvent.getInstance()
    //     .event
    //     .on<LanguageChangeEvent>()
    //     .listen((event) {
    //   getPlatformCategory();
    //   getHotGoodsList();
    //   loadingUtil.value.clear();
    //   getRecommendGoods();
    // });
  }

  // 获取最新版本的安装包
  getLatestApkInfo() async {
    var res = await CommonService.getLatestApkInfo();
    if (res != null) {
      var needUpdate = await VersionUtils.isAppUpdatedRequired(res.version);
      var lastTime = UserStorage.getVersionTime();
      var nowTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (needUpdate && (lastTime == null || lastTime + 24 * 3600 < nowTime)) {
        Get.dialog(UpdateDialog(appModel: res), barrierDismissible: false);
      }
    }
  }

  @override
  void dispose() {
    loadingUtil.value.controllerDestroy();
    super.dispose();
  }

  // 最新公告
  getIndexAnnoucement() async {
    var data = await AnnouncementService.getLatest();
    String uniqueId = AnnoucementStorage.getUniqueId();
    if (data != null && data.uniqueId != uniqueId) {
      AnnoucementStorage.setUniqueId(data.uniqueId);
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
      BeeNav.push(BeeNav.webview, {
        'id': data.id,
        'title': data.title,
        'time': data.createdAt,
        'type': 'notice',
      });
    }
  }

  // 代购分类
  getPlatformCategory() async {
    var list = await ShopService.getCategoryList();
    categoryList.value = list;
    categoryList.insert(
      0,
      GoodsCategoryModel(
        id: 0,
        name: '自营商城',
        image: 'Home/shop',
      ),
    );
  }

  // 是否有未读消息
  onGetUnReadNotice() async {
    var token = Get.find<UserInfoModel>().token.value;
    if (token.isEmpty) return;
    var res = await CommonService.hasUnReadInfo();
    noticeUnRead.value = res;
  }

  // 获取弹窗、活动广告
  getAds() async {
    List<BannerModel> result = await AdsService.getList({"source": 4});
    List<BannerModel> adList = [];
    List<BannerModel> pics = [];
    for (var item in result) {
      if (item.type == 4) {
        adList.add(item);
      } else if (item.position == 1 && item.type == 2) {
        pics.add(item);
      }
    }
    activityPicList.value = pics;
    for (var item in adList) {
      Get.dialog(
        AdDialog(adItem: item),
      );
    }
  }

  // 推荐线路
  getGreatLine() async {
    Map result = await ShipLineService.getList(
      params: {
        'is_great_value': 1,
      },
      option: Options(
        extra: {'loading': false, 'showSuccess': false, 'showError': false},
      ),
    );

    lineList.value = result['list'];
  }

  // 页面刷新
  Future<void> handleRefresh() async {
    // loadingUtil.value.clear();
    // await getIndexAnnoucement();
    // await getHotGoodsList();
    // await getRecommendGoods();
    // await getPlatformCategory();
    await getAds();
    await getGreatLine();
  }

  // 自营商城商品列表
  Future<void> getHotGoodsList() async {
    var data = await ShopService.getRecommendGoods({'type': 1, 'size': 10});
    if (data['dataList'] != null) {
      hotGoodsList.value = data['dataList'];
    }
  }

  // 代购推荐商品
  Future<void> getRecommendGoods() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'keyword': '服饰',
        'page': ++loadingUtil.value.pageIndex,
        'platform': '1688',
        'page_size': 10,
      });
      loadingUtil.value.isLoading = false;
      if (data['dataList'] != null) {
        if (data.isNotEmpty) {
          loadingUtil.value.list.addAll(data['dataList']);
        } else if (loadingUtil.value.list.isEmpty) {
          loadingUtil.value.isEmpty = true;
        } else {
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

  // 分类
  void onCategory([GoodsCategoryModel? model]) {
    if (model == null || model.id == 0) {
      // 自营商城
      BeeNav.push(BeeNav.shopCenter);
    } else {
      BeeNav.push(BeeNav.platformGoodsList,
          {'keyword': model.nameCn, 'origin': model.name});
    }
  }

  onPlatform({
    required String platform,
  }) async {
    BeeNav.push(BeeNav.platform, {'platform': platform});
  }
}
