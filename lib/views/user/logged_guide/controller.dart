import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/language_change_event.dart';
import 'package:huanting_shop/models/currency_rate_model.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/state/i10n.dart';
import 'package:huanting_shop/storage/language_storage.dart';
import 'package:huanting_shop/storage/user_storage.dart';

class LoggedGuideController extends GlobalLogic {
  final langList = Get.find<AppStore>().langList;
  final rateList = Get.find<AppStore>().rateList;
  final i10n = Get.find<I10n>();
  final PageController pageController = PageController();
  final step = 0.obs;

  onLanguagePicker(String code) async {
    if (code == i10n.language) return;
    LanguageStore.setLanguage(code);
    i10n.setLanguage(code);
    await i10n.loadTranslations(Options(extra: {'loading': true}));
    ApplicationEvent.getInstance().event.fire(LanguageChangeEvent());
  }

  onCurrencyPicker(CurrencyRateModel rateItem) {
    if (rateItem.code == currencyModel.value?.code) return;
    LanguageStore.setCurrency(jsonEncode({
      'code': rateItem.code,
      'symbol': rateItem.symbol,
    }));
    Get.find<AppStore>().setCurrency(rateItem);
  }

  onSkip() {
    UserStorage.setNewUser();
    BeeNav.pop();
  }
}
