import 'package:get/get.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/state/i10n.dart';

// 字符串添加翻译方法

RegExp _reg = RegExp(r'[\u4e00-\u9fa5]');

extension StringTranslation on String {
  String get inte {
    Locale i10n = Get.find<Locale>();
    Map<String, dynamic> translations = i10n.translations ?? {};
    return (translations[this] ?? '').isNotEmpty ? translations[this] : this;
  }

  String inArgs(Map<String, dynamic> value) {
    Locale i10n = Get.find<Locale>();
    Map<String, dynamic> translations = i10n.translations ?? {};
    String lang = translations[this] ?? this;
    // 清除 '{}' 之间可能会存在的空格
    lang = lang.replaceAll(RegExp(r'{\s+'), '{');
    lang = lang.replaceAll(RegExp(r'\s+}'), '}');
    // 获取所有的占位符
    List<String> holders = BaseUtils.parsePlaceholder(lang);
    for (var item in holders) {
      RegExp exp = RegExp('{$item}');
      lang = lang.replaceAll(exp, value[item].toString());
    }
    return lang;
  }

  bool get contianCN {
    return _reg.hasMatch(this);
  }

  String get wordBreak {
    String breakWord = '';
    for (var e in runes) {
      breakWord += String.fromCharCode(e);
      breakWord += '\u200B';
    }
    return breakWord;
  }
}
