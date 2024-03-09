import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/loading_util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/language_change_event.dart';
import 'package:shop_app_client/models/goods_category_model.dart';
import 'package:shop_app_client/models/shop/category_model.dart';
import 'package:shop_app_client/models/shop/goods_model.dart';
import 'package:shop_app_client/models/shop/platform_goods_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/shop_service.dart';

class PlatformShopCenterController extends GlobalController {
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final RxList<CategoryModel> selfShopCategories = <CategoryModel>[].obs;
  final categoryIndex = RxnInt();
  final loadingUtil = ListLoadingModel<PlatformGoodsModel>().obs;
  final selfShopLoadingUtil = ListLoadingModel<GoodsModel>().obs;
  final platformType = 1.obs; // 1-->代购 2-->自营
  final daigouPlatform = '1688'.obs;

  @override
  onInit() {
    super.onInit();
    platformType.value = Get.find<AppStore>().shopPlatformType;
    getPlatformCategory();
    loadingUtil.value.initListener(getList);
    selfShopLoadingUtil.value.initListener(getSelfList);
    ApplicationEvent.getInstance()
        .event
        .on<LanguageChangeEvent>()
        .listen((event) {
      getPlatformCategory();
      getSelfShopCategory();
      loadingUtil.value.clear();
      selfShopLoadingUtil.value.clear();
      getList();
      getSelfList();
    });
  }

  // 代购分类
  getPlatformCategory() async {
    var list = await ShopService.getCategoryList();
    categoryList.value = list;
  }

  // 自营商城分类
  getSelfShopCategory() async {
    var data = await ShopService.getCategories();
    if (data != null) {
      selfShopCategories.value = data;
    }
  }

  // 代购商品列表
  Future<void> getList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'keyword': categoryIndex.value == null
            ? '衣服'
            : categoryList[categoryIndex.value!].nameCn ??
                categoryList[categoryIndex.value!].name,
        'page': ++loadingUtil.value.pageIndex,
        'page_size': 10,
        'platform': daigouPlatform.value,
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

  // 自营商品列表
  Future<void> getSelfList() async {
    if (selfShopLoadingUtil.value.isLoading) return;
    selfShopLoadingUtil.value.isLoading = true;
    selfShopLoadingUtil.refresh();
    try {
      var data = await ShopService.getRecommendGoods({
        'type': 2,
        'page': ++selfShopLoadingUtil.value.pageIndex,
        'size': 10
      });
      selfShopLoadingUtil.value.isLoading = false;
      if (data['dataList'] != null) {
        selfShopLoadingUtil.value.list.addAll(data['dataList']);
        if (data['dataList'].isEmpty && data['page'] == 1) {
          selfShopLoadingUtil.value.isEmpty = true;
        } else if (data['totalPage'] == data['page']) {
          selfShopLoadingUtil.value.hasMoreData = false;
        }
      }
    } catch (e) {
      selfShopLoadingUtil.value.isLoading = false;
      selfShopLoadingUtil.value.pageIndex--;
      selfShopLoadingUtil.value.hasError = true;
    } finally {
      selfShopLoadingUtil.refresh();
    }
  }

  Future<void> handleRefresh() async {
    if (platformType.value == 1) {
      loadingUtil.value.clear();
      await getPlatformCategory();
      await getList();
    } else {
      selfShopLoadingUtil.value.clear();
      await getSelfShopCategory();
      await getSelfList();
    }
  }

  // 选择分类
  void onCategory(index) {
    categoryIndex.value = index;
    loadingUtil.value.clear();
    getList();
  }

  // 选择自营商品分类
  void onSelfShopCategory(int id) {
    GlobalPages.push(GlobalPages.goodsList, arg: {'id': id});
  }

  @override
  void dispose() {
    loadingUtil.value.controllerDestroy();
    selfShopLoadingUtil.value.controllerDestroy();
    super.dispose();
  }
}
