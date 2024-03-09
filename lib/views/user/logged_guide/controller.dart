import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/language_change_event.dart';
import 'package:shop_app_client/models/currency_rate_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/state/i10n.dart';
import 'package:shop_app_client/storage/language_storage.dart';
import 'package:shop_app_client/storage/user_storage.dart';

class LoggedGuideController extends GlobalController {
  final langList = Get.find<AppStore>().langList;
  final rateList = Get.find<AppStore>().rateList;
  final i10n = Get.find<Locale>();
  final PageController pageController = PageController();
  final step = 0.obs;

  onLanguagePicker(String code) async {
    if (code == i10n.language) return;
    LocaleStorage.setLanguage(code);
    i10n.setLanguage(code);
    await i10n.loadTranslations(Options(extra: {'loading': true}));
    ApplicationEvent.getInstance().event.fire(LanguageChangeEvent());
  }

  onCurrencyPicker(CurrencyRateModel rateItem) {
    if (rateItem.code == currencyModel.value?.code) return;
    LocaleStorage.setCurrency(jsonEncode({
      'code': rateItem.code,
      'symbol': rateItem.symbol,
    }));
    Get.find<AppStore>().setCurrency(rateItem);
  }

  onSkip() {
    CommonStorage.setNewUser();
    GlobalPages.pop();
  }
}
