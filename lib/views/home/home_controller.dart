import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/version_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/ads_pic_model.dart';

import 'package:huanting_shop/models/announcement_model.dart';
import 'package:huanting_shop/models/language_model.dart';
import 'package:huanting_shop/models/ship_line_model.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/services/ads_service.dart';
import 'package:huanting_shop/services/announcement_service.dart';
import 'package:huanting_shop/services/common_service.dart';
import 'package:huanting_shop/services/ship_line_service.dart';
import 'package:huanting_shop/state/i10n.dart';
import 'package:huanting_shop/storage/annoucement_storage.dart';
import 'package:huanting_shop/storage/user_storage.dart';
import 'package:huanting_shop/views/components/update_dialog.dart';
import 'package:huanting_shop/views/home/widget/ad_dialog.dart';

import 'package:huanting_shop/views/home/widget/annoucement_dialog.dart';

class IndexLogic extends GlobalLogic {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final I10n i10n = Get.find<I10n>();
  RxList<LanguageModel> langList = <LanguageModel>[].obs;

  final userModel = Get.find<AppStore>().userInfo;
  final amountModel = Get.find<AppStore>().amountInfo;
  final vipModel = Get.find<AppStore>().vipInfo;
  final lineList = <ShipLineModel>[].obs;

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

  // 是否有未读消息
  // onGetUnReadNotice() async {
  //   var token = Get.find<AppStore>().token.value;
  //   if (token.isEmpty) return;
  //   var res = await CommonService.hasUnReadInfo();
  //   noticeUnRead.value = res;
  // }

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
    await getAds();
    await getGreatLine();
  }
}
