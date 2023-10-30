import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/language_change_event.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class PlatformShopCenterController extends GlobalLogic {
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final categoryIndex = 0.obs;
  final loadingUtil = LoadingUtil<PlatformGoodsModel>().obs;

  @override
  onInit() {
    super.onInit();
    getPlatformCategory();
    loadingUtil.value.initListener(getList);
    ApplicationEvent.getInstance()
        .event
        .on<LanguageChangeEvent>()
        .listen((event) {
      getPlatformCategory();
      loadingUtil.value.clear();
      getList();
    });
  }

  // 代购分类
  getPlatformCategory() async {
    var list = await ShopService.getCategoryList();
    categoryList.value = list;
    categoryList.insert(0, GoodsCategoryModel(id: 0, name: '推荐'));
  }

  Future<void> getList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'keyword': categoryIndex.value == 0
            ? '服饰'
            : categoryList[categoryIndex.value].name,
        'page': ++loadingUtil.value.pageIndex,
        'page_size': 10,
        'platform': 'pinduoduo',
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

  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await getPlatformCategory();
    await getList();
  }

  // 选择分类
  void onCategory(index) {
    categoryIndex.value = index;
    loadingUtil.value.clear();
    getList();
  }

  @override
  void dispose() {
    loadingUtil.value.controllerDestroy();
    super.dispose();
  }
}
