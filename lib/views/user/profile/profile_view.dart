import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/user/profile/profile_controller.dart';

class BeeUserInfoPage extends GetView<BeeUserInfoLogic> {
  const BeeUserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '个人信息'.ts,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: AppColors.bgGray,
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: <Widget>[
              userInfo(),
              40.verticalSpaceFromWidth,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                height: 38.h,
                width: double.infinity,
                child: BeeButton(
                  text: '确认',
                  onPressed: controller.onSubmit,
                ),
              ),
              20.verticalSpaceFromWidth,
              Offstage(
                offstage: controller.deleteShow.value,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.w),
                  height: 38.h,
                  width: double.infinity,
                  child: BeeButton(
                    text: '注销',
                    backgroundColor: AppColors.textRed,
                    onPressed: () async {
                      var confirmed = await BaseDialog.cupertinoConfirmDialog(
                          context, '您确定要注销吗？可能会造成无法挽回的损失！'.ts);
                      if (confirmed!) {}
                    },
                  ),
                ),
              ),
              30.verticalSpaceFromWidth,
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfo() {
    return _baseBox(
      child: Column(
        children: [
          15.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppText(
                  str: '用户头像'.ts,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: controller.onUploadAvatar,
                child: ClipOval(
                  child: SizedBox(
                    height: 40.w,
                    width: 40.w,
                    child: Obx(
                      () => ImgItem(
                        controller.userImg.value.isEmpty
                            ? (controller.userModel.value?.avatar ?? '')
                            : controller.userImg.value,
                        fit: BoxFit.fitWidth,
                        holderImg: "Center/logo",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            children: [
              AppText(
                str: '用户昵称'.ts,
                fontSize: 14,
              ),
              10.horizontalSpace,
              Expanded(
                child: BaseInput(
                  controller: controller.nameController,
                  focusNode: controller.nameNode,
                  autoShowRemove: false,
                  autoRemoveController: false,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppText(
                  str: '用户ID'.ts,
                  fontSize: 14,
                ),
              ),
              10.horizontalSpace,
              GestureDetector(
                onLongPress: controller.onCopyUserId,
                child: AppText(
                  str: controller.userModel.value?.id.toString() ?? '',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppText(
                  str: '手机号码'.ts,
                  fontSize: 14,
                ),
              ),
              10.horizontalSpace,
              AppText(
                str: controller.userModel.value?.phone ?? '',
                fontSize: 14,
              ),
            ],
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppText(
                  str: '电子邮箱'.ts,
                  fontSize: 14,
                ),
              ),
              10.horizontalSpace,
              AppText(
                str: controller.userModel.value?.email ?? '',
                fontSize: 14,
              ),
            ],
          ),
          15.verticalSpace,
        ],
      ),
    );
  }

  Widget _baseBox({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: child,
    );
  }
}
