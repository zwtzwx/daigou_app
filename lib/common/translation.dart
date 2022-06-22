import 'package:flutter/material.dart';
import 'package:jiyun_app_client/provider/language_provider.dart';
import 'package:provider/provider.dart';

class Translation {
  static String t(
    BuildContext context,
    String key, {
    bool listen = false,
    Map? value,
  }) {
    // 因为是在首页更换语言、所以只有首页、底部 tab 栏需要试试刷新 widget 树
    Map<String, dynamic>? _translations =
        Provider.of<LanguageProvider>(context, listen: listen).translations;
    Map<String, dynamic> translations = _translations ?? {};
    String lang = translations[key] ?? key;
    if (value != null) {
      // 清除 '{}' 之间可能会存在的空格
      lang = lang.replaceAll(RegExp(r'{\s+'), '{');
      lang = lang.replaceAll(RegExp(r'\s+}'), '}');
      // 获取所有的占位符
      List<String> holders = _parsePlaceholder(lang);
      for (var item in holders) {
        RegExp exp = RegExp('{$item}');
        lang = lang.replaceAll(exp, value[item]);
      }
    }
    return lang;
  }

  static List<String> _parsePlaceholder(String str) {
    List<String> list = [];
    int position = 0;
    int strLength = str.length;
    while (position < strLength) {
      String char = str[position++];
      if (char == '{') {
        String sub = '';
        if (position < strLength) {
          char = str[position++];
        }
        while (position < strLength && char != '}') {
          sub += char;
          char = str[position++];
        }
        list.add(sub);
      }
    }
    return list;
  }
}
