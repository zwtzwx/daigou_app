import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class PlatformShopCenterController extends BaseController {
  final RxList<GoodsCategoryModel> categoryList = <GoodsCategoryModel>[].obs;
  final categoryIndex = 0.obs;
  final loadingUtil = LoadingUtil<PlatformGoodsModel>().obs;

  @override
  onInit() {
    super.onInit();
    categoryList.add(GoodsCategoryModel(
      id: 0,
      name: '推荐',
      image: 'Home/shop',
    ));
    loadingUtil.value.initListener(getList);
  }

  Future<void> getCategory() async {}

  Future<void> getList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'keyword': categoryList[categoryIndex.value].name,
        'page': ++loadingUtil.value.pageIndex
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
    await getCategory();
    await getList();
  }
}
