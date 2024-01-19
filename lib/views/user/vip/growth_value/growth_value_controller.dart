import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/user_vip_model.dart';
import 'package:huanting_shop/services/point_service.dart';
import 'package:huanting_shop/services/user_service.dart';

class BeeValuesLogic extends GlobalLogic {
  final isloading = false.obs;
  int pageIndex = 0;
  final vipDataModel = Rxn<UserVipModel?>();

  @override
  onInit() {
    super.onInit();
    created();
  }

  created({type}) async {
    var _vipDataModel = await UserService.getVipMemberData();
    vipDataModel.value = _vipDataModel;
    isloading.value = true;
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
      'size': 20,
    };
    var data = await PointService.getGrowthValueList(dic);
    return data;
  }
}
