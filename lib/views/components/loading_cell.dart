import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/common/loading_util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/empty_box.dart';
import 'package:huanting_shop/views/components/error_box.dart';

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
            const CupertinoActivityIndicator(color: AppColors.textNormal),
            5.horizontalSpace,
            Obx(
              () => AppText(
                str: '加载中'.ts + '...',
                color: AppColors.textNormal,
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
            () => AppText(
              str: '没有更多商品了'.ts,
              fontSize: 14,
              color: AppColors.textNormal,
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
    return AppGaps.empty;
  }
}
