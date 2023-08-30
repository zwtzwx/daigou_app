import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/language_model.dart';
import 'package:jiyun_app_client/models/shop/goods_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/state/i10n.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';

class HomeController extends BaseController {
  final ScrollController scrollerController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final I10n i10n = Get.find<I10n>();
  RxList<LanguageModel> langList = <LanguageModel>[].obs;
  UserModel? userInfo = Get.find<UserInfoModel>().userInfo.value;
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final RxList<GoodsModel> hotGoodsList = <GoodsModel>[].obs;
  final loadingUtil = LoadingUtil<PlatformGoodsModel>().obs;

  @override
  void onInit() {
    super.onInit();
    categoryList.add(GoodsCategoryModel(
      id: 0,
      name: '自营商城',
      image: 'Home/shop',
    ));
    getIndexAnnoucement();
    loadingUtil.value.initListener(getRecommendGoods);
  }

  @override
  void onClose() {
    scrollerController.dispose();
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

  // 页面刷新
  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await getIndexAnnoucement();
    await getHotGoodsList();
    await getRecommendGoods();
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
      var data = await ShopService.getDaigouGoods(
          {'keyword': '推荐', 'page': ++loadingUtil.value.pageIndex});
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
      Routers.push(Routers.shopCenter);
    }
  }
}
