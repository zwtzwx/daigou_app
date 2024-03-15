import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/user/info_change/info_change_controller.dart';

class InfoPage extends GetView<BeeInfoLogic> {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '个人资料'.inte,
          fontSize: 17,
        ),
      ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 40,right: 40,bottom: 20),
          child: SizedBox(
            height: 46,
            child: BeeButton(
              text: '保存',
              backgroundColor: AppStyles.primary,
              textColor: const Color(0xFFFFE1E2),
              onPressed: () {

              },
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            inPutItem(context, '姓名', '请输入真实姓名', controller.nameController),
            selectTimeZone(context),
            selectBirthday(context),
            selectCountry(context),
            inPutItem(context, '联系电话', '请输入收件人电话', controller.phoneController),
            inPutItem(context, '城市', '请输入城市', controller.cityNameController),
            inPutItem(context, '街道', '请输入街道', controller.streetNameController),
            inPutItem(context, '邮编', '请输入邮编', controller.postCodeController),
            inPutItem(context, '门牌号', '请输入门牌号', controller.doorCodeController),
          ],
        ),
      )
    );
  }




// 电话区号
selectTimeZone(BuildContext context) {
    var selectView = Container(
      padding: EdgeInsets.only(top: 15,bottom: 15),
      margin: EdgeInsets.only(left: 10,right: 30),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffF1F1F1), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            str: '电话区号'.inte,
            color: Color(0xff333333),
          ),
          GestureDetector(
            onTap: controller.onTimezone,
            child: Row(
              children: [
                AppText(
                  str: controller.timezone.value!=''?'+' +
                      controller.formatTimezone(
                          controller.timezone.value):'请选择'.inte,
                ),
                AppGaps.hGap4,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppStyles.textNormal,
                ),
                AppGaps.hGap5,
              ],
            ),
          ),
        ],
      )
    );
    return selectView;
}

  selectCountry(BuildContext context) {
    var selectView = Container(
        padding: EdgeInsets.only(top: 15,bottom: 15),
        margin: EdgeInsets.only(left: 10,right: 30),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffF1F1F1), width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              str: '国家/地区'.inte,
              color: Color(0xff333333),
            ),
            GestureDetector(
              onTap: controller.onTimezone,
              child: Row(
                children: [
                  AppText(
                    str: controller.timezone.value!=''?'+' +
                        controller.formatTimezone(
                            controller.timezone.value):'请选择'.inte,
                  ),
                  AppGaps.hGap4,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppStyles.textNormal,
                  ),
                  AppGaps.hGap5,
                ],
              ),
            ),
          ],
        )
    );
    return selectView;
  }

  selectBirthday(BuildContext context) {
    var selectView = Container(
        padding: EdgeInsets.only(top: 15,bottom: 15),
        margin: EdgeInsets.only(left: 10,right: 30),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffF1F1F1), width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              str: '生日'.inte,
              color: Color(0xff333333),
            ),
            GestureDetector(
              onTap: controller.onTimezone,
              child: Row(
                children: [
                  AppText(
                    str: controller.timezone.value!=''?'+' +
                        controller.formatTimezone(
                            controller.timezone.value):'请选择'.inte,
                  ),
                  AppGaps.hGap4,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppStyles.textNormal,
                  ),
                  AppGaps.hGap5,
                ],
              ),
            ),
          ],
        )
    );
    return selectView;
  }


  inPutItem(BuildContext context,String title, String placeholder,TextEditingController _controller) {
    var inputAccountView = Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      decoration: const BoxDecoration(
        color: AppStyles.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppStyles.line, style: BorderStyle.solid)),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child:
            AppText(
              str: title.inte,
              color: Color(0xff333333),
            ),),
          Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  // obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: placeholder.inte,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                ),
              ))
        ],
      ),
    );
    return inputAccountView;
  }
}