import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/services/station_service.dart';

class StationController extends GlobalLogic {
  final pageIndex = 0.obs;

  loadList({type}) async {
    pageIndex.value = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      'page': (++pageIndex.value),
    };
    var data = await StationService.getList(dic);
    return data;
  }
}
