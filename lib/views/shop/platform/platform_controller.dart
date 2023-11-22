import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class PlatformController extends GlobalLogic {
  String platform = '';
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final loadingUtil = LoadingUtil<PlatformGoodsModel>().obs;
  String keyword = '';

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    platform = arguments['platform'];

    loadingUtil.value.initListener(getGoods);
    getPlatformCategory();
  }

  String getPlatformName() {
    String title = '';
    switch (platform) {
      case 'taobao':
        title = '淘宝';
        break;
      case 'jd':
        title = '京东';
        break;
      case 'pinduoduo':
        title = '拼多多';
        break;
      case '1688':
        title = '1688';
        break;
    }
    return title;
  }

  Future<void> getGoods() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'keyword': keyword.isNotEmpty ? keyword : '衣服',
        'page': ++loadingUtil.value.pageIndex,
        'platform': platform,
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

  // 代购分类
  getPlatformCategory() async {
    var list = await ShopService.getCategoryList();
    categoryList.value = list;
  }

  // 页面刷新
  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await getGoods();
    await getPlatformCategory();
  }

  onSearch(String value) {
    keyword = value;
    loadingUtil.value.clear();
    getGoods();
  }
}
