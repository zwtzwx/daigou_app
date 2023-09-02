import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/language_change_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/currency_rate_model.dart';
import 'package:jiyun_app_client/models/language_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/language_service.dart';
import 'package:jiyun_app_client/state/i10n.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class LanguageCellController extends GetxController {
  final RxList<LanguageModel> langList = <LanguageModel>[].obs;
  final I10n i10n = Get.find<I10n>();
  final currency = Get.find<UserInfoModel>().currencyModel;

  @override
  onInit() {
    super.onInit();
    getLanguages();
  }

  // 获取语言列表
  getLanguages() async {
    var data = await LanguageService.getLanguage();
    langList.value = data;
  }

  // 语言、货币设置
  showSetting(BuildContext context) async {
    String languageCode = i10n.language;

    String language = '';
    var findList = langList.where((ele) => ele.languageCode == languageCode);
    if (findList.isNotEmpty) {
      language = findList.first.name;
    }
    List<Map> list = [
      {'type': 'lang', 'label': '多语言', 'value': language},
      {
        'type': 'currency',
        'label': '币种',
        'value': (currency.value?.symbol ?? '') + (currency.value?.code ?? '')
      },
    ];
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: ZHTextLine(
              str: '设置'.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            actions: list
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (e['type'] == 'lang') {
                        showLanguage();
                      } else {
                        showCurrency();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 10.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              (e['label'] as String).ts,
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          Text(
                            e['value'],
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                          5.horizontalSpace,
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '取消'.ts,
              ),
            ),
          );
        });
  }

  // 显示货币列表
  showCurrency() async {
    var list = Get.find<UserInfoModel>().rateList;
    var rate = await Get.bottomSheet<CurrencyRateModel?>(CupertinoActionSheet(
      actions: list.map((e) {
        return CupertinoActionSheetAction(
            onPressed: () {
              Get.back<CurrencyRateModel>(result: e);
            },
            child: Text(
              e.symbol + e.code,
            ));
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Get.back();
        },
        child: Text('取消'.ts),
      ),
    ));
    if (rate != null) {
      if (rate.code == currency.value?.code) return;
      LanguageStore.setCurrency(jsonEncode({
        'code': rate.code,
        'symbol': rate.symbol,
      }));
      Get.find<UserInfoModel>().setCurrency(rate);
    }
  }

  // 显示语言列表
  showLanguage() async {
    var code = await Get.bottomSheet<String>(CupertinoActionSheet(
      actions: langList.map((e) {
        return CupertinoActionSheetAction(
            onPressed: () {
              Get.back<String>(result: e.languageCode);
            },
            child: Text(
              e.name,
            ));
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Get.back();
        },
        child: Text('取消'.ts),
      ),
    ));
    if (code != null) {
      String languge = LanguageStore.getLanguage();
      if (code == languge) return;
      LanguageStore.setLanguage(code);
      i10n.setLanguage(code);
      await i10n.loadTranslations(Options(extra: {'loading': true}));
      ApplicationEvent.getInstance().event.fire(LanguageChangeEvent());
    }
  }
}
