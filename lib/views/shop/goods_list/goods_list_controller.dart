import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/shop/category_model.dart';
import 'package:jiyun_app_client/models/shop/goods_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class GoodsListController extends BaseController {
  Map<String, dynamic>? arguments;
  final RxInt categoryId = 0.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final orderBy = ''.obs;
  final sortType = ''.obs;
  String keyword = '';
  final Rx<LoadingUtil<GoodsModel>> loadingUtil = LoadingUtil<GoodsModel>().obs;

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    if (arguments?['id'] != null) {
      categoryId.value = arguments?['id'];
      getChildCategories();
    } else if (arguments?['keyword'] != null) {
      keyword = arguments!['keyword'];
    }
    loadingUtil.value.initListener(loadMoreList);
  }

  // 二级分类列表
  void getChildCategories() async {
    var data = await ShopService.getCategories({'parent_id': categoryId.value});
    if (data != null) {
      categories.value = data;
    }
    categories.insert(0, CategoryModel(id: categoryId.value, name: '全部'));
  }

  void onSearch(String value) async {
    keyword = value;
    categoryId.value = categories.first.id;
    orderBy.value = '';
    sortType.value = '';
    handleRefresh();
  }

  loadMoreList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getGoodsList({
        'page': ++loadingUtil.value.pageIndex,
        'keyword': keyword,
        'category_id': categoryId.value != 0 ? categoryId.value : '',
        'order_by': orderBy.value,
        'sort_type': sortType.value,
        'size': 10
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

  onOrderBy(String value) {
    orderBy.value = value;
    if (sortType.isEmpty) {
      sortType.value = 'asc';
    } else {
      sortType.value = sortType.value == 'asc' ? 'desc' : 'asc';
    }
    handleRefresh();
  }

  onSortBy(String value) {
    if (orderBy.value == value) return;
    orderBy.value = value;
    sortType.value = '';
    handleRefresh();
  }

  // 选择分类
  onCategory(int id) {
    if (categoryId.value == id) return;
    categoryId.value = id;
    handleRefresh();
  }

  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await loadMoreList();
  }
}
