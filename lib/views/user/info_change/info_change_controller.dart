import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/profile_model.dart';
import 'package:shop_app_client/config/color_config.dart';
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

  final selectedCountryModel = Rxn<CountryModel?>();

  final userProfile = Rxn<ProfileModel?>();

  final timezone = '0086'.obs;
  final birth = ''.obs;
  final code = ''.obs;
  // final city = ''.obs;
  // final door_no = ''.obs;
  // final phone = ''.obs;
  // final receiver_name = ''.obs;
  // final postcode = ''.obs;
  final country_id = ''.obs;

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
    //  获取个人信息
    getUserInfo();

  }

  Future<DateTime?> showDatePickerForTheme(BuildContext context) {
    return showDatePicker(
      context: context, // 上下文
      initialDate: DateTime.now(), // 初始化选中日期
      firstDate: DateTime(1900, 1), // 开始日期
      lastDate: DateTime(2100, 1), // 结束日期
      currentDate: DateTime.now(), // 当前日期
      initialEntryMode: DatePickerEntryMode
          .calendarOnly, // 日历弹框样式 calendar: 默认显示日历，可切换成输入模式，input:默认显示输入模式，可切换到日历，calendarOnly:只显示日历，inputOnly:只显示输入模式
      selectableDayPredicate: (dayTime) {
        // 自定义哪些日期可选
        // if (dayTime == DateTime(2022, 5, 6) || dayTime == DateTime(2022, 6, 8)) {
        //   return false;
        // }
        return true;
      },
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.red,
          ),
          child: child!,
        );
      },
      helpText: "请选择日期", // 左上角提示文字
      cancelText: "Cancel", // 取消按钮 文案
      confirmText: "OK", // 确认按钮 文案
      initialDatePickerMode: DatePickerMode.day, // 日期选择模式 默认为天
      useRootNavigator: true, // 是否使用根导航器
      textDirection: TextDirection.ltr, // 水平方向 显示方向 默认 ltr
    );
  }

  // 保存个人信息
  void saveInfo() async{
      Map<String,dynamic> params = {
        'birth':birth.value,
        'city':cityNameController.text,
        'receiver_name':nameController.text,
        'country_id':country_id.value,
        'door_no':doorCodeController.text,
        'postcode':postCodeController.text,
        'street':streetNameController.text,
        'timezone':timezone.value,
        'phone':phoneController.text,
      };
      var res = await UserService.updateUserInfo(params);
      if(res['ok']) {
        Get.offAllNamed(GlobalPages.home, arguments: {'index': 2});
      }
  }

  // 获取个人资料
  void getUserInfo() async{
     var res =  await UserService.getUserInfo();
     nameController.text = res['receiver_name']??'';
     phoneController.text = res['phone']??'';
     cityNameController.text = res['city']??'';
     streetNameController.text = res['street']??'';
     postCodeController.text = res['postcode']??'';
     doorCodeController.text = res['door_no']??'';
     streetNameController.text = res['street']??'';
     birth.value = res['birth']??'';
     timezone.value = res['timezone']??'';
     code.value = res['personal_code'];
     country_id.value = res['country_id'].toString()??'';
     selectedCountryModel.value = CountryModel.fromJson(res['country']);

  }

  // 选择手机区号
  void onTimezone() async {
    var s = await GlobalPages.push(GlobalPages.country);
    if (s != null) {
      CountryModel a = s as CountryModel;
      timezone.value = a.timezone!;
    }
  }

  // 选择国家
  void onCountry() async {
    var tmp = await GlobalPages.push(GlobalPages.country);
    if (tmp == null) return;
    selectedCountryModel.value = tmp as CountryModel;
    country_id.value = (selectedCountryModel.value?.id??"").toString();
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
