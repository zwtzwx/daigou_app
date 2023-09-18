import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class PlatformGoodsController extends BaseController {
  String keyword = '';
  final Rx<LoadingUtil<PlatformGoodsModel>> loadingUtil =
      LoadingUtil<PlatformGoodsModel>().obs;
  final orderBy = ''.obs;
  final platform = 'pinduoduo'.obs; // 默认拼多多平台商品
  final filterShow = false.obs;

  @override
  onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments?['keyword'] != null) {
      keyword = arguments!['keyword'];
    }
    loadingUtil.value.initListener(loadMoreList, recordPosition: true);
  }

  loadMoreList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'page': ++loadingUtil.value.pageIndex,
        'keyword': keyword,
        'sort': orderBy.value,
        'page_size': 10,
        'platform': platform.value,
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

  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await loadMoreList();
  }

  void onSearch(String value) async {
    keyword = value;
    orderBy.value = '';
    handleRefresh();
  }

  void onSortBy(String value) async {
    orderBy.value = value;
    handleRefresh();
  }

  void onHideFilter() {
    filterShow.value = false;
  }

  @override
  void dispose() {
    loadingUtil.value.controllerDestroy();
    super.dispose();
  }
}
