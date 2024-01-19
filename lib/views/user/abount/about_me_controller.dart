import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/article_model.dart';
import 'package:huanting_shop/services/article_service.dart';

class BeeLogic extends GlobalLogic {
  final aboutList = <ArticleModel>[].obs;

  @override
  onInit() {
    super.onInit();
    getList();
  }

  getList() async {
    var data = await ArticleService.getList({'type': 5});
    aboutList.value = data;
  }
}
