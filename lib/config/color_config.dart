import 'package:flutter/material.dart';

//颜色配置
class BaseStylesConfig {
  static const Color primary = Color(0xFF0E6224);
  static const Color themeRed = Color(0xffe4382d);
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteGray = Color(0xFFF8F8F8);
  static const Color whiteGrays = Color(0xBFF8F8F8);
  static const Color mainTextColor = Color(0xFF121917);
  static const Color subTextColor = Color(0xff959595);
  static const Color textDark = Color(0xFF333333);
  static const Color textBlack = Color(0xFF1C1717);
  static const Color textNormal = Color(0xFF666666);
  static const Color textGray = Color(0xFFB8B8B8);
  static const Color textGrayC = Color(0xFFcccccc);
  static const Color textGrayCS = Color(0x72F0F0F0);
  static const Color textGrayC9 = Color(0xFF999999);
  static const Color bgGray = Color(0xFFF5F5F5); //Color(0xFFF0F0F0)
  static const Color line = Color(0xffF0F0F0);
  static const Color orderLine = Color(0xFFDDDDDD);
  static const Color textRed = Color(0xFFFF4759);
  static const Color main = Color(0xFF9FA2C2);
  static const Color vipBG = Color(0xFFAE886D);
  static const Color vipNormal = Color(0xFFab8d3b);
  static const Color warningBg = Color(0xFFFFFDE7);
  static const Color warningText = Color(0xFFF7A63E);
  static const Color warningTextDark = Color(0xFFFFAB00);
  static const Color warningTextDark80 = Color(0x7FFFAB00);
  static const Color warningTextDark50 = Color(0x19FFAB00);
  static const Color warningText85 = Color(0x21FFD400);
  static const Color tabbarSelectColor = Color(0xffe4382d);
  static const Color green = Color(0xFF3FBF3F);
  static const Color mainAlpha = Color(0xFFF7F8FE);
}

class WidgetColor {
  static const int fontColor = 0xFF607173;
  static const int iconColor = 0xFF607173;
  static const int borderColor = 0xFFEFEFEF;
  static const int themeColor = 0xFF512DA8;
}

/// 间隔
class Sized {
  /// 水平间隔
  static const Widget hGap1 = SizedBox(width: 1.0);
  static const Widget hGap4 = SizedBox(width: 4.0);
  static const Widget hGap5 = SizedBox(width: 5.0);
  static const Widget hGap8 = SizedBox(width: 8.0);
  static const Widget hGap10 = SizedBox(width: 10.0);
  static const Widget hGap12 = SizedBox(width: 12.0);
  static const Widget hGap15 = SizedBox(width: 15.0);
  static const Widget hGap16 = SizedBox(width: 16.0);

  /// 垂直间隔
  static const Widget vGap4 = SizedBox(height: 4.0);
  static const Widget vGap5 = SizedBox(height: 5.0);
  static const Widget vGap8 = SizedBox(height: 8.0);
  static const Widget vGap10 = SizedBox(height: 10.0);
  static const Widget vGap12 = SizedBox(height: 12.0);
  static const Widget vGap15 = SizedBox(height: 15.0);
  static const Widget vGap16 = SizedBox(height: 16.0);
  static const Widget vGap20 = SizedBox(height: 20.0);
  static const Widget vGap50 = SizedBox(height: 50);

  static Widget line = const SizedBox(
    height: 1,
    width: double.infinity,
    child:
        DecoratedBox(decoration: BoxDecoration(color: BaseStylesConfig.line)),
  );

  static Widget verticalBar = const SizedBox(
    height: 44,
    width: 12.5,
    child:
        DecoratedBox(decoration: BoxDecoration(color: BaseStylesConfig.green)),
  );

  static Widget br = const SizedBox(
    height: 20,
    width: double.infinity,
    child:
        DecoratedBox(decoration: BoxDecoration(color: BaseStylesConfig.line)),
  );

  static Widget lowBr = const SizedBox(
    height: 10,
    width: double.infinity,
    child:
        DecoratedBox(decoration: BoxDecoration(color: BaseStylesConfig.line)),
  );

  static Widget lowBr5 = const SizedBox(
    height: 5,
    width: double.infinity,
    child:
        DecoratedBox(decoration: BoxDecoration(color: BaseStylesConfig.line)),
  );

  static Widget columnsLine = const SizedBox(
    height: double.infinity,
    width: 1,
    child:
        DecoratedBox(decoration: BoxDecoration(color: BaseStylesConfig.line)),
  );

  static const Widget empty = SizedBox();
}
