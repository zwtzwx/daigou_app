import 'package:flutter/material.dart';
import 'package:jiyun_app_client/services/language_service.dart';

class LanguageProvider with ChangeNotifier {
  LanguageProvider(this._language);

  String _language;

  Map<String, dynamic>? _translations;

  String get languge => _language;

  Map<String, dynamic>? get translations => _translations;

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  void loadTranslations() async {
    _translations = await LanguageService.getTransform({'source': 3});
    notifyListeners();
  }
}
