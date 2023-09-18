import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/point_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';

class GrowthValueController extends BaseController {
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
