import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/user/setting_locale/controller.dart';

class SettingLocaleView extends GetView<SettingLocaleController> {
  const SettingLocaleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          str: '语言/币种'.ts,
          fontSize: 17,
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(
          () => Column(
            children: settingList(),
          ),
        ),
      ),
    );
  }

  List<Widget> settingList() {
    List<Map<String, dynamic>> list = [
      {
        'label': '语言',
        'value': controller.langList
                .firstWhereOrNull(
                    (e) => e.languageCode == controller.i10n.language)
                ?.name ??
            '',
        'onTap': controller.showLanguage,
      },
      {
        'label': '币种',
        'value': controller.currencyModel.value?.code ?? '',
        'onTap': controller.showCurrency,
      },
    ];
    return list
        .map(
          (e) => GestureDetector(
            onTap: e['onTap'],
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: e['label'] == list.first['label']
                      ? const BorderSide(color: Color(0xFFECECEC), width: 0.5)
                      : BorderSide.none,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      str: (e['label'] as String).ts,
                      fontSize: 16,
                    ),
                  ),
                  10.horizontalSpace,
                  AppText(
                    str: e['value'],
                    fontSize: 14,
                  ),
                  10.horizontalSpace,
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 13.sp,
                    color: AppColors.textNormal,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
