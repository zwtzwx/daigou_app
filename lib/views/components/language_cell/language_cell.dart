import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/language_cell/language_cell_controller.dart';

class LanguageCell extends GetView<LanguageCellController> {
  const LanguageCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.showSetting(context);
      },
      child: UnconstrainedBox(
        child: Container(
          width: 100.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: const Color(0x7DD7D7D7),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => AppText(
                  str: controller.i10n.language.split('_').last +
                      (controller.currency.value != null
                          ? '/${controller.currency.value!.code}'
                          : ''),
                ),
              ),
              5.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
