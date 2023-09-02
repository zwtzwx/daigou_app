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
    loadTranslations();
  }

  Future<void> loadTranslations([Options? option]) async {
    _translations.value =
        await LanguageService.getTransform({'source': 3}, option) ?? {};
  }

  setLanguage(String data) {
    _language.value = data;
  }
}
