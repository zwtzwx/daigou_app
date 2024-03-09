import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/loading_util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/shop/platform_goods_model.dart';
import 'package:shop_app_client/services/shop_service.dart';

class PlatformGoodsController extends GlobalController {
  String keyword = '';
  final Rx<ListLoadingModel<PlatformGoodsModel>> loadingUtil =
      ListLoadingModel<PlatformGoodsModel>().obs;
  final orderBy = ''.obs;
  final platform = '1688'.obs; // 默认拼多多平台商品
  final filterShow = false.obs;
  String originKeyword = '';
  bool hideSearch = false;
  List<Map<String, String>> platforms = [
    {'name': '1688', 'value': '1688'},
    {'name': '淘宝', 'value': 'taobao'},
    // {'name': '京东', 'value': 'jd'},
  ];

  @override
  onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments?['keyword'] != null) {
      keyword = arguments!['keyword'];
    }
    hideSearch = arguments?['hideSearch'] ?? false;
    originKeyword = arguments['origin'] ?? '';
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
