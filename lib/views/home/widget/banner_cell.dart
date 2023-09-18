// 轮播图组件
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
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
    return Positioned(
      left: 10,
      top: ScreenUtil().statusBarHeight + 10,
      child: LanguageCell(),
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
                    AppGaps.hGap15,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ScreenUtil().screenWidth - 120,
                          ),
                          child: AppText(
                            str: userInfo.name,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            lines: 2,
                          ),
                        ),
                        AppGaps.vGap4,
                        AppText(
                          str: userInfo.phone ?? userInfo.email ?? '',
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                )
              : AppGaps.empty;
        }));
  }
}
