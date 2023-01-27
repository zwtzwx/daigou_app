//文本设置
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:flutter/material.dart';

class TextConfig {
  static const middleSize = 14.0;
  static const defaultSize = 12.0;
  static const smallSize = 10.0;
  static const extraSmallSize = 8.0;
  static const largeSize = 16.0;
  static const extraLargeSize = 18.0;

  static const middleText = TextStyle(
    color: BaseStylesConfig.mainTextColor,
    fontSize: middleSize,
  );

  static const middleSubText = TextStyle(
    color: BaseStylesConfig.subTextColor,
    fontSize: middleSize,
  );

  static const TextStyle textMain12 = TextStyle(
    fontSize: defaultSize,
    color: BaseStylesConfig.mainTextColor,
  );
  static const TextStyle textMain14 = TextStyle(
    fontSize: middleSize,
    color: BaseStylesConfig.mainTextColor,
  );
  static const TextStyle textNormal12 = TextStyle(
    fontSize: defaultSize,
    color: BaseStylesConfig.textNormal,
  );
  static const TextStyle textDark12 = TextStyle(
    fontSize: defaultSize,
    color: BaseStylesConfig.textDark,
  );
  static const TextStyle textDark14 = TextStyle(
    fontSize: middleSize,
    color: BaseStylesConfig.textDark,
  );
  static const TextStyle textDark16 = TextStyle(
    fontSize: largeSize,
    color: BaseStylesConfig.textDark,
  );
  static const TextStyle warningText14 = TextStyle(
      fontSize: middleSize,
      color: BaseStylesConfig.warningText,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark14 = TextStyle(
      fontSize: middleSize,
      color: BaseStylesConfig.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark16 = TextStyle(
      fontSize: largeSize,
      color: BaseStylesConfig.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark18 = TextStyle(
      fontSize: extraLargeSize,
      color: BaseStylesConfig.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark24 = TextStyle(
      fontSize: 24.0,
      color: BaseStylesConfig.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textBoldDark26 = TextStyle(
      fontSize: 26.0,
      color: BaseStylesConfig.textDark,
      fontWeight: FontWeight.bold);
  static const TextStyle textGray10 = TextStyle(
    fontSize: smallSize,
    color: BaseStylesConfig.textGray,
  );
  static const TextStyle textGray12 = TextStyle(
    fontSize: defaultSize,
    color: BaseStylesConfig.textGray,
  );
  static const TextStyle textGray13 = TextStyle(
    fontSize: defaultSize + 1,
    color: BaseStylesConfig.textGray,
  );
  static const TextStyle textGray14 = TextStyle(
    fontSize: middleSize,
    color: BaseStylesConfig.textGray,
  );
  static const TextStyle textGray16 = TextStyle(
    fontSize: largeSize,
    color: BaseStylesConfig.textGray,
  );
  static const TextStyle textGrayC12 = TextStyle(
    fontSize: defaultSize,
    color: BaseStylesConfig.textGrayC,
  );
  static const TextStyle textGrayC14 = TextStyle(
    fontSize: middleSize,
    color: BaseStylesConfig.textGrayC,
  );
}
