import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/models/language_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/services/language_service.dart';
import 'package:jiyun_app_client/state/i10n.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';
import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';

class HomeController extends BaseController {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final I10n i10n = Get.find<I10n>();
  RxList<LanguageModel> langList = <LanguageModel>[].obs;
  UserModel? userInfo = Get.find<UserInfoModel>().userInfo.value;

  @override
  void onInit() {
    super.onInit();
    getIndexAnnoucement();
    getLanguages();
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
      Routers.push(Routers.webview, {
        'id': data.id,
        'title': data.title,
        'time': data.createdAt,
        'type': 'notice',
      });
    }
  }

  // 获取语言列表
  getLanguages() async {
    var data = await LanguageService.getLanguage();
    langList.value = data;
  }

  // 页面刷新
  Future<void> handleRefresh() async {
    getIndexAnnoucement();
    getLanguages();
  }

  // 显示语言列表
  showLanguage() async {
    var code = await Get.bottomSheet<String>(CupertinoActionSheet(
      actions: langList.map((e) {
        return CupertinoActionSheetAction(
            onPressed: () {
              Get.back<String>(result: e.languageCode);
            },
            child: Text(
              e.name,
            ));
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Get.back();
        },
        child: Text('取消'.tr),
      ),
    ));
    if (code != null) {
      String languge = LanguageStore.getLanguage();
      if (code == languge) return;
      LanguageStore.setLanguage(code);
      i10n.setLanguage(code);
      showLoading();
      await i10n.loadTranslations();
      hideLoading();
    }
  }
}
