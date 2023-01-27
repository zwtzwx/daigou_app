// 轮播图组件
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/state/i10n.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';

class BannerCell extends GetView<HomeController> {
  const BannerCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          child: LoadImage(
            'Home/bg',
            fit: BoxFit.fitWidth,
          ),
        ),
        buildLanguageView(),
        buildUserInfoCell(),
      ],
    );
  }

  // 支持语言
  Widget buildLanguageView() {
    final I10n i10n = Get.find<I10n>();
    return Positioned(
      left: 10,
      top: ScreenUtil().statusBarHeight + 10,
      child: GestureDetector(
        onTap: controller.showLanguage,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0x33000000),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4DFFFFFF)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                // child: ZHTextLine(
                //   str: codeStr,
                // ),
                child: Obx(() {
                  String language = i10n.language;
                  var codeList = language.split('_');
                  String codeStr =
                      codeList.length > 1 ? codeList[1] : codeList[0];
                  return ZHTextLine(
                    str: codeStr,
                  );
                }),
              ),
              Sized.hGap15,
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 个人信息
  Widget buildUserInfoCell() {
    return Positioned(
        left: 10,
        right: 10,
        top: ScreenUtil().statusBarHeight + 60,
        child: Obx(() {
          var userInfo = Get.find<UserInfoModel>().userInfo.value;
          return userInfo != null
              ? Row(
                  children: [
                    ClipOval(
                      child: LoadImage(
                        userInfo.avatar.isNotEmpty
                            ? userInfo.avatar
                            : 'AboutMe/u',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Sized.hGap15,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ScreenUtil().screenWidth - 120,
                          ),
                          child: ZHTextLine(
                            str: userInfo.name,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            lines: 2,
                          ),
                        ),
                        Sized.vGap4,
                        ZHTextLine(
                          str: userInfo.phone ?? userInfo.email ?? '',
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                )
              : Sized.empty;
        }));
  }
}
