import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/services/order_service.dart';

class BeeOrdersLogic extends GlobalLogic {
  final pageIndex = 0.obs;
  final pageTitle = ''.obs;

  @override
  onReady() {
    super.onReady();
    getPageTitle();
  }

  loadList({type}) async {
    pageIndex.value = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var arguments = Get.arguments;
    Map<String, dynamic> dic = {
      'status': arguments['index'], // 待处理订单
      'page': (++pageIndex.value),
    };
    var data = await OrderService.getList(dic);
    return data;
  }

  void getPageTitle() {
    String _pageTitle;
    var arguments = Get.arguments;
    switch (arguments['index']) {
      case 1:
        _pageTitle = '待处理订单';
        break;
      case 2:
        _pageTitle = '待支付订单';
        break;
      case 3:
        _pageTitle = '待发货订单';
        break;
      case 4:
        _pageTitle = '已发货订单';
        break;
      default:
        _pageTitle = '已签收订单';
        break;
    }
    pageTitle.value = _pageTitle;
  }
}
