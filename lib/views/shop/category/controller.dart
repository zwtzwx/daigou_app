import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/goods_category_model.dart';
import 'package:shop_app_client/services/goods_service.dart';
import 'package:shop_app_client/services/shop_service.dart';

class GoodsCategoryController extends GlobalController {
  final categories = <GoodsCategoryModel>[].obs;
  final topCategory = Rxn<GoodsCategoryModel?>();
  final isLoading = true.obs;
  bool searchAutoFocus = false;
  bool pickerProps = false; // 是否是选择物品属性

  @override
  onInit() {
    super.onInit();
    if (Get.arguments?['autoFocus'] != null) {
      searchAutoFocus = true;
    }
    pickerProps = Get.arguments?['props'] ?? false;
    getClassification();
  }

  // 物品分类
  getClassification() async {
    var data = await (pickerProps
        ? GoodsService.getCategoryList()
        : ShopService.getCategoryList());

    categories.value = data;
    if (data.isNotEmpty) {
      topCategory.value = data.first;
    }
    isLoading.value = false;
  }

  onTopSelect(GoodsCategoryModel value) {
    if (value.id != topCategory.value?.id) {
      topCategory.value = value;
    }
  }

  // 选择分类
  onSelect(GoodsCategoryModel model) {
    // LYRouter.pop(model);
  }
}
