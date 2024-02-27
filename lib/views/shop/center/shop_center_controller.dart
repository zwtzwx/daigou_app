import 'package:get/state_manager.dart';
import 'package:huanting_shop/common/loading_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/shop/category_model.dart';
import 'package:huanting_shop/models/shop/goods_model.dart';
import 'package:huanting_shop/services/shop_service.dart';

/*
  自营商城中心
 */
class ShopCenterController extends GlobalLogic {
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<LoadingUtil<GoodsModel>> loadingUtil = LoadingUtil<GoodsModel>().obs;

  @override
  onInit() {
    super.onInit();
    loadingUtil.value.initListener(getList);
  }

  Future<void> getCategory() async {
    var data = await ShopService.getCategories();
    if (data != null) {
      categories.value = data;
    }
  }

  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await getCategory();
    await getList();
  }

  Future<void> getList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getRecommendGoods(
          {'type': 2, 'page': ++loadingUtil.value.pageIndex, 'size': 10});
      loadingUtil.value.isLoading = false;
      if (data['dataList'] != null) {
        loadingUtil.value.list.addAll(data['dataList']);
        if (data['dataList'].isEmpty && data['page'] == 1) {
          loadingUtil.value.isEmpty = true;
        } else if (data['totalPage'] == data['page']) {
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

  // 商品列表
  void onCategory(int id) {
    BeeNav.push(BeeNav.goodsList, arg: {'id': id});
  }

  // 搜索商品
  void onSearch(String value) {
    BeeNav.push(BeeNav.goodsList, arg: {'keyword': value});
  }

  @override
  void dispose() {
    loadingUtil.value.controllerDestroy();
    super.dispose();
  }
}
