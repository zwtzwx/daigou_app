import 'package:get/get.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/state/i10n.dart';

// 字符串添加翻译方法
extension StringTranslation on String {
  String get ts {
    I10n i10n = Get.find<I10n>();
    Map<String, dynamic> translations = i10n.translations ?? {};
    return translations[this] ?? this;
  }

  String tsArgs(Map<String, dynamic> value) {
    I10n i10n = Get.find<I10n>();
    Map<String, dynamic> translations = i10n.translations ?? {};
    String lang = translations[this] ?? this;
    // 清除 '{}' 之间可能会存在的空格
    lang = lang.replaceAll(RegExp(r'{\s+'), '{');
    lang = lang.replaceAll(RegExp(r'\s+}'), '}');
    // 获取所有的占位符
    List<String> holders = CommonMethods.parsePlaceholder(lang);
    for (var item in holders) {
      RegExp exp = RegExp('{$item}');
      lang = lang.replaceAll(exp, value[item].toString());
    }
    return lang;
  }
}
