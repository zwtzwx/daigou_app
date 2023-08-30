import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class TitleCell extends StatelessWidget {
  const TitleCell({
    Key? key,
    required this.title,
    this.onMore,
    this.other,
  }) : super(key: key);
  final String title;
  final Function? onMore;
  final Widget? other;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                ZHTextLine(
                  str: title.ts,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                other ?? Sized.empty
              ],
            ),
          ),
          onMore != null
              ? GestureDetector(
                  onTap: () {
                    onMore!();
                  },
                  child: Row(
                    children: [
                      ZHTextLine(
                        str: '更多'.ts,
                        fontSize: 14,
                        color: BaseStylesConfig.textNormal,
                      ),
                      5.horizontalSpace,
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: BaseStylesConfig.textNormal,
                        size: 14,
                      ),
                    ],
                  ),
                )
              : Sized.empty,
        ],
      ),
    );
  }
}
