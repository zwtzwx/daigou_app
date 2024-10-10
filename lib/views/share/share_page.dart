import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/share/share_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class shareView extends GetView<ShareLogic> {
  const shareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = controller.userInfoModel.userInfo.value;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/Center/share_bk.png"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        appBar: const EmptyAppBar(),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 80.h), // 设置水平方向的空隙为16.0// 将您的组件放置在Padding内
              ),
              RepaintBoundary(
                key: controller.globalKey,
                child: Container(
                  height: 480,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/Center/qyCode_bk.png"),
                    fit: BoxFit.fill,
                  )),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipOval(
                          child: ImgItem(
                            userModel?.avatar ?? '',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.h), // 设置水平方向的空隙为16.0// 将您的组件放置在Padding内
                      ),
                      AppText(
                        str: userModel?.name ?? '',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10), // 设置水平方向的空隙为16.0// 将您的组件放置在Padding内
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            str: '邀请码'.inte + '：',
                            fontSize: 14,
                            color: const Color(0xFF888888),
                          ),
                          AppText(
                            alignment: TextAlign.center,
                            str: '${userModel?.id ?? ''}',
                            fontSize: 14,
                            color: const Color(0xFF888888),
                          ),
                          5.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: userModel?.id));
                              controller.showToast('邀请码复制成功');
                            },
                            child: AppText(
                              str: '复制'.inte,
                              fontSize: 14,
                              color: AppStyles.primary,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 40), // 设置水平方向的空隙为16.0// 将您的组件放置在Padding内
                      ),
                      Container(
                        child: Image.network(
                          '',
                          width: 200.w,
                          height: 200.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Container(
                child: SizedBox(
                  height: 35.h,
                  width: 240.w,
                  child: BeeButton(
                    text: '生成海报',
                    backgroundColor: AppStyles.primary,
                    textColor: const Color(0xFFFFE1E2),
                    onPressed: () {
                      controller.saveImage();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
