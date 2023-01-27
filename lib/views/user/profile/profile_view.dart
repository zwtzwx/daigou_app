/*
  个人信息
*/

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/user/profile/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '个人信息'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: <Widget>[
                avatarCell(context),
                Container(
                  height: 50,
                  color: BaseStylesConfig.white,
                ),
                Sized.line,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: BaseStylesConfig.white,
                    height: 55,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              color: BaseStylesConfig.white,
                              height: 55,
                              width: 90,
                              alignment: Alignment.centerLeft,
                              child: ZHTextLine(
                                str: '用户昵称'.ts,
                              ),
                            ),
                            Container(
                              color: BaseStylesConfig.white,
                              height: 55,
                              width: ScreenUtil().screenWidth - 25 - 100,
                              alignment: Alignment.centerLeft,
                              child: NormalInput(
                                hintText: '请输入昵称'.ts,
                                textAlign: TextAlign.left,
                                contentPadding:
                                    const EdgeInsets.only(top: 17, bottom: 0),
                                controller: controller.nameController,
                                focusNode: controller.nameNode,
                                autoFocus: false,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Sized.line,
                Container(
                  color: BaseStylesConfig.white,
                  height: 55,
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            color: BaseStylesConfig.white,
                            height: 55,
                            width: 90,
                            alignment: Alignment.centerLeft,
                            child: ZHTextLine(
                              str: '用户ID'.ts,
                            ),
                          ),
                          ZHTextLine(
                            str:
                                controller.userModel.value?.id.toString() ?? '',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Sized.line,
                GestureDetector(
                  onTap: () {
                    Routers.push(Routers.changeMobileAndEmail, {'type': 1});
                  },
                  child: Container(
                    color: BaseStylesConfig.white,
                    height: 55,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              color: BaseStylesConfig.white,
                              height: 55,
                              width: 90,
                              alignment: Alignment.centerLeft,
                              child: ZHTextLine(
                                str: '手机号码'.ts,
                              ),
                            ),
                            ZHTextLine(
                              str: controller.userModel.value?.phone == null ||
                                      controller.userModel.value!.phone!.isEmpty
                                  ? '绑定手机号'.ts
                                  : controller.userModel.value!.phone!,
                              color: controller.userModel.value?.phone ==
                                          null ||
                                      controller.userModel.value!.phone!.isEmpty
                                  ? BaseStylesConfig.textGray
                                  : BaseStylesConfig.textDark,
                            ),
                          ],
                        ),
                        controller.userModel.value?.phone == null ||
                                controller.userModel.value!.phone!.isEmpty
                            ? const Icon(
                                Icons.arrow_forward_ios,
                                color: BaseStylesConfig.textGrayC,
                                size: 18,
                              )
                            : ZHTextLine(
                                str: '更改手机号'.ts,
                                color: BaseStylesConfig.primary,
                              )
                      ],
                    ),
                  ),
                ),
                Sized.line,
                GestureDetector(
                  onTap: () {
                    Routers.push(Routers.changeMobileAndEmail, {'type': 2});
                  },
                  child: Container(
                    color: BaseStylesConfig.white,
                    height: 55,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              color: BaseStylesConfig.white,
                              height: 55,
                              width: 90,
                              alignment: Alignment.centerLeft,
                              child: ZHTextLine(
                                str: '电子邮箱'.ts,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 55,
                              child: ZHTextLine(
                                // fontSize: 14,
                                lines: 2,
                                str:
                                    controller.userModel.value?.email == null ||
                                            controller
                                                .userModel.value!.email!.isEmpty
                                        ? '绑定电子邮箱'.ts
                                        : controller.userModel.value!.email!,
                                color:
                                    controller.userModel.value?.email == null ||
                                            controller
                                                .userModel.value!.email!.isEmpty
                                        ? BaseStylesConfig.textGray
                                        : BaseStylesConfig.textDark,
                              ),
                            )
                          ],
                        ),
                        controller.userModel.value?.email == null ||
                                controller.userModel.value!.email!.isEmpty
                            ? const Icon(
                                Icons.arrow_forward_ios,
                                color: BaseStylesConfig.textGrayC,
                                size: 18,
                              )
                            : ZHTextLine(
                                str: '更改邮箱'.ts,
                                color: BaseStylesConfig.primary,
                              )
                      ],
                    ),
                  ),
                ),
                Sized.line,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: BaseStylesConfig.white,
                    height: 55,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              color: BaseStylesConfig.white,
                              height: 55,
                              width: 90,
                              alignment: Alignment.centerLeft,
                              child: ZHTextLine(
                                str: '现居城市'.ts,
                              ),
                            ),
                            Container(
                              color: BaseStylesConfig.white,
                              height: 55,
                              width: 200,
                              alignment: Alignment.centerLeft,
                              child: NormalInput(
                                hintText: '请输入现居城市'.ts,
                                textAlign: TextAlign.left,
                                contentPadding:
                                    const EdgeInsets.only(top: 19, bottom: 0),
                                controller: controller.cityNameController,
                                focusNode: controller.cityName,
                                autoFocus: false,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Sized.line,
                Sized.vGap20,
                SizedBox(
                  width: ScreenUtil().screenWidth - 30,
                  height: 40,
                  child: MainButton(
                    text: '确认',
                    onPressed: controller.onSubmit,
                  ),
                ),
                Sized.vGap20,
                Offstage(
                  offstage: controller.deleteShow.value,
                  child: SizedBox(
                    width: ScreenUtil().screenWidth - 30,
                    height: 40,
                    child: MainButton(
                      text: '注销',
                      backgroundColor: BaseStylesConfig.textRed,
                      onPressed: () async {
                        var confirmed = await BaseDialog.cupertinoConfirmDialog(
                            context, '您确定要注销吗？可能会造成无法挽回的损失！');
                        if (confirmed!) {}
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget avatarCell(BuildContext context) {
    var headerView = Container(
        padding: const EdgeInsets.only(left: 15, top: 50, right: 15),
        color: BaseStylesConfig.white,
        constraints: const BoxConstraints.expand(
          height: 150.0,
        ),
        //设置背景图片
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    UploadUtil.imagePicker(
                      onSuccessCallback: (imageUrl) async {
                        controller.userImg.value = imageUrl;
                      },
                      context: context,
                      child: CupertinoActionSheet(
                        title: Text('请选择上传方式'.ts),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text('相册'.ts),
                            onPressed: () {
                              Navigator.pop(context, 'gallery');
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('照相机'.ts),
                            onPressed: () {
                              Navigator.pop(context, 'camera');
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('取消'.ts),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: BaseStylesConfig.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Obx(
                        () => LoadImage(
                          controller.userImg.value.isEmpty
                              ? (controller.userModel.value?.avatar ?? '')
                              : controller.userImg.value,
                          fit: BoxFit.fitWidth,
                          holderImg: "AboutMe/about-logo",
                          format: "png",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
    return headerView;
  }
}
