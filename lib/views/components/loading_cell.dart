import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_box.dart';
import 'package:jiyun_app_client/views/components/error_box.dart';

class LoadingCell extends StatelessWidget {
  const LoadingCell({
    Key? key,
    required this.util,
    this.onRefresh,
    this.emptyHeight,
    this.emptyText,
  }) : super(key: key);
  final LoadingUtil util;
  final Function? onRefresh;
  final double? emptyHeight;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    if (util.isEmpty) {
      return emptyBox(emptyText ?? '没有找到商品');
    } else if (util.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(
                color: BaseStylesConfig.textNormal),
            5.horizontalSpace,
            Obx(
              () => ZHTextLine(
                str: '加载中'.ts + '...',
                color: BaseStylesConfig.textNormal,
              ),
            ),
          ],
        ),
      );
    } else if (!util.hasMoreData) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 12.h, 0, 20.h),
        child: Center(
          child: Obx(
            () => ZHTextLine(
              str: '没有更多商品了'.ts,
              fontSize: 14,
              color: BaseStylesConfig.textNormal,
            ),
          ),
        ),
      );
    } else if (onRefresh != null && util.hasError) {
      return SizedBox(
        height: emptyHeight,
        child: ErrorBox(
          onRefresh: onRefresh,
        ),
      );
    }
    return Sized.empty;
  }
}
