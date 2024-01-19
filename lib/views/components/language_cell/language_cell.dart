import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/language_cell/language_cell_controller.dart';

class LanguageCell extends GetView<LanguageCellController> {
  const LanguageCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 12.w),
      // padding:
      //     EdgeInsets.fromLTRB(0, ScreenUtil().statusBarHeight + 5.h, 0, 10.h),
      child: UnconstrainedBox(
        child: GestureDetector(
          onTap: () {
            controller.showSetting(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0x24000000),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(
                    () => AppText(
                      str: controller.i10n.language.split('_').last +
                          (controller.currency.value != null
                              ? '/${controller.currency.value!.symbol}'
                              : ''),
                    ),
                  ),
                ),
                15.horizontalSpace,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
