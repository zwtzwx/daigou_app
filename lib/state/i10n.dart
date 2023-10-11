import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/services/language_service.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';

class I10n {
  final RxMap<String, dynamic> _translations = <String, dynamic>{}.obs;

  final RxString _language = ''.obs;

  Map<String, dynamic>? get translations => _translations;

  String get language => _language.value;

  I10n() {
    _language.value = LanguageStore.getLanguage();
    var translateValue = LanguageStore.geTranslate();
    if (translateValue != null) {
      _translations.value = translateValue;
    }
    loadTranslations();
  }

  Future<void> loadTranslations([Options? option]) async {
    var value = await LanguageService.getTransform({'source': 3}, option);
    if (value != null) {
      _translations.value = value;
      LanguageStore.setTranslate(value);
    }
  }

  setLanguage(String data) {
    _language.value = data;
  }
}
