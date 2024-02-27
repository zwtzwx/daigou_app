import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/models/user_order_count_model.dart';
import 'package:huanting_shop/models/user_vip_model.dart';
import 'package:huanting_shop/services/user_service.dart';

class BeeSuperUserLogic extends GlobalLogic {
  final isloading = false.obs;

  //各种统计，包括余额
  UserOrderCountModel? userOrderModel;

  //会员中心基础信息
  final userVipModel = Rxn<UserVipModel?>();

  UserModel? userInfo = Get.find<AppStore>().userInfo.value;

  final selectButton = 999.obs;

  @override
  onInit() {
    super.onInit();
    created();
  }

  created([bool init = true]) async {
    showLoading();
    var data = await UserService.getVipMemberData();
    hideLoading();
    userVipModel.value = data;
    if (init) {
      isloading.value = true;
    }
  }

  onPay() async {
    var a = await BeeNav.push('/OrderPayPage', arg: {
      'model': userVipModel.value!.priceList[selectButton.value],
      'payModel': 0
    });
    if (a == null) return;
    String content = a.toString();
    if (content == 'succeed') {
      created(false);
      selectButton.value = 999;
    }
  }
}
