import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/user/profile/profile_controller.dart';

class BeeUserInfoPage extends GetView<BeeUserInfoLogic> {
  const BeeUserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '账户安全'.inte,
          fontSize: 17,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(
          () => Column(
            children: [
              ...controller.btnList.map(
                (e) => GestureDetector(
                  onTap: () async {
                    if (e['route'] != null) {
                      GlobalPages.push(e['route']!, arg: e['params']);
                    } else {
                      var confirmed = await BaseDialog.cupertinoConfirmDialog(
                          context, '您确定要注销吗？可能会造成无法挽回的损失！'.inte);
                      if (confirmed!) {}
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: e['route'] != null
                            ? const BorderSide(color: Color(0xFFECECEC))
                            : BorderSide.none,
                      ),
                      color: Colors.transparent,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            str: (e['name'] as String).inte,
                            fontSize: 16,
                          ),
                        ),
                        10.horizontalSpace,
                        if (e['route'] != null)
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppStyles.textNormal,
                            size: 14.sp,
                          ),
                      ],
                    ),
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
}
