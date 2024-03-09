import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/language_change_event.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/state/i10n.dart';
import 'package:shop_app_client/storage/language_storage.dart';
import 'package:shop_app_client/views/components/action_sheet.dart';

class SettingLocaleController extends GlobalController {
  final langList = Get.find<AppStore>().langList;
  final i10n = Get.find<Locale>();

  // 显示语言列表
  showLanguage() {
    Get.bottomSheet(
      ActionSheet(
        datas: langList.map((e) => e.name).toList(),
        onSelected: (index) async {
          var code = langList[index].languageCode;
          if (code == i10n.language) return;
          LocaleStorage.setLanguage(code);
          i10n.setLanguage(code);
          await i10n.loadTranslations(Options(extra: {'loading': true}));
          ApplicationEvent.getInstance().event.fire(LanguageChangeEvent());
        },
      ),
    );
  }

  // 显示货币列表
  showCurrency() async {
    var list = Get.find<AppStore>().rateList;
    Get.bottomSheet(
      ActionSheet(
        datas: list.map((e) => e.code).toList(),
        onSelected: (index) async {
          var rateItem = list[index];
          if (rateItem.code == currencyModel.value?.code) return;
          LocaleStorage.setCurrency(jsonEncode({
            'code': rateItem.code,
            'symbol': rateItem.symbol,
          }));
          Get.find<AppStore>().setCurrency(rateItem);
        },
      ),
    );
  }
}
