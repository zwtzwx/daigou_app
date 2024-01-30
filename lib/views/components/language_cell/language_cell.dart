import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/language_cell/language_cell_controller.dart';

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
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 12.w),
          width: 120.w,
          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0x24000000),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
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
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
