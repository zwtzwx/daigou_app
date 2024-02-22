import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/config/color_config.dart';

class Indicator extends StatelessWidget {
  const Indicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const CircularProgressIndicator(
            color: AppColors.textNormal,
          )
        : const CupertinoActivityIndicator(
            color: AppColors.textNormal,
          );
  }
}
