import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox({
    Key? key,
    this.onRefresh,
  }) : super(key: key);
  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_tethering_error_outlined,
          size: 60.sp,
          color: BaseStylesConfig.textGray,
        ),
        ZHTextLine(
          str: '出现错误了'.ts,
        ),
        5.verticalSpace,
        MainButton(
          text: '重新请求',
          borderRadis: 999,
          onPressed: onRefresh,
        ),
      ],
    );
  }
}
