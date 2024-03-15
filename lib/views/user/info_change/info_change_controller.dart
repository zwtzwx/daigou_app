import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/user_service.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/country_model.dart';


class BeeInfoLogic extends GlobalController {
  final userModel = Get.find<AppStore>().userInfo.value;
  // 姓名
  final TextEditingController nameController = TextEditingController();
  // 电话
  final TextEditingController phoneController = TextEditingController();
  // 城市
  final TextEditingController cityNameController = TextEditingController();
  // 街道
  final TextEditingController streetNameController = TextEditingController();
  // 邮编
  final TextEditingController postCodeController = TextEditingController();
  // 门牌号
  final TextEditingController doorCodeController = TextEditingController();

  final timezone = '0086'.obs;

  // created() async{
  //   EasyLoading.show();
  //   userModel = await UserService.getProfile();
  //   EasyLoading.dismiss();
  //   _cityNameController.text = userModel!.liveCity;
  //   _nameController.text = userModel!.name;
  // }
  @override
  void onInit() {
    super.onInit();
  }

  // 选择手机区号
  void onTimezone() async {
    var s = await GlobalPages.push(GlobalPages.country);
    if (s != null) {
      CountryModel a = s as CountryModel;
      timezone.value = a.timezone!;
    }
  }

  String formatTimezone(String timezone) {
    var reg = RegExp(r'^0{1,}');
    return timezone.replaceAll(reg, '');
  }

  // 更改个人信息
  onSubmit() async {
    Map<String, dynamic> upData = {
      'name': userModel!.name,
      // 'avatar': userImg.isEmpty ? userModel!.avatar : userImg,
      'gender': userModel!.gender, // 性别
      'wechat_id': userModel!.wechatId, // 微信
      'birth': userModel!.birth ?? '', // 生日
      'live_city': userModel!.liveCity, // 当前城市
    };
    EasyLoading.show();
    var result = await UserService.updateByModel(upData);
    EasyLoading.dismiss();
    // 存储个人信息
    // if (result['ok']) {
    //   Provider.of<Model>(context, listen: false).setUserInfo(result['data']);
    //   await UserStorage.setUserInfo(result['data']);
    //   EasyLoading.showSuccess(result['msg']);
    //   Routers.pop(context);
    // } else {
    //   EasyLoading.showToast(result['msg']);
    // }
  }
}
