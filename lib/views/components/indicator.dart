import 'package:flutter/cupertino.dart';
import 'package:huanting_shop/config/color_config.dart';

class Indicator extends StatelessWidget {
  const Indicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator(
      color: AppColors.textNormal,
    );
  }
}
