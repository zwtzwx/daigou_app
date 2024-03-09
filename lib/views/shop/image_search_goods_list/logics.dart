import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/loading_util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/shop/platform_goods_model.dart';
import 'package:shop_app_client/services/common_service.dart';

class GoodsImageSearchResultLogic extends GlobalController {
  final Rx<ListLoadingModel<PlatformGoodsModel>> loadingUtil =
      ListLoadingModel<PlatformGoodsModel>().obs;

  String url = '';

  @override
  void onInit() {
    super.onInit();
    url = Get.arguments['url'];
    loadingUtil.value.initListener(getGoods);
  }

  getGoods() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await CommonService.goodsQueryByImg({
        'page': ++loadingUtil.value.pageIndex,
        'page_size': 10,
        'img': url,
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

  Future<void> onRefresh() async {
    loadingUtil.value.clear();
    await getGoods();
  }
}
