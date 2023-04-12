import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';

class CountryController extends BaseController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  RxList<AlphabeticalCountryModel> dataList = <AlphabeticalCountryModel>[].obs;

  RxBool isSearch = false.obs;

  @override
  void onInit() {
    super.onInit();
    created();
  }

  loadList(String str) async {
    if (str.isNotEmpty) {
      showLoading('搜索中');
    }
    var routeParams = Get.arguments;
    var tmp = await CommonService.getCountryListByAlphabetical({
      'keyword': str,
      'warehouse_id': routeParams?['warehouseId'] ?? '',
    });
    hideLoading();
    dataList.value = tmp;
  }

  created() async {
    showLoading('加载中');
    loadList("");
  }

  onSearch() {
    isSearch.value = !isSearch.value;
    if (isSearch.value) {
      created();
    }
  }

  onCountrySelect(CountryModel model) {
    Routers.pop(model);
  }
}
