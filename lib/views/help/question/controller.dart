import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/article_model.dart';
import 'package:huanting_shop/services/article_service.dart';

class BeeQusLogic extends GlobalLogic {
  final articles = <ArticleModel>[].obs;
  final pageTitle = ''.obs;
  final type = 1.obs;

  @override
  void onInit() {
    super.onInit();
    type.value = Get.arguments['type'];
    getPageTitle();
    loadList();
  }

  loadList() async {
    showLoading();
    var data = await ArticleService.getList({'type': Get.arguments['type']});
    hideLoading();
    articles.value = data;
  }

  void getPageTitle() {
    String _pageTitle = '';
    switch (type.value) {
      case 1:
        _pageTitle = '常见问题';
        break;
      case 2:
        _pageTitle = '禁运物品';
        break;
      case 3:
        _pageTitle = '如何下单';
        break;
    }
    pageTitle.value = _pageTitle;
  }
}
