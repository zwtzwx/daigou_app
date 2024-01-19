import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/transport/transport_center/transport_center_controller.dart';

class CommentListWidget extends StatelessWidget {
  const CommentListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransportCenterController>();
    return Obx(
      () => controller.commentList.isNotEmpty
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          str: '用户评价'.ts,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      10.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          BeeNav.push(BeeNav.comment);
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textNormal,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  14.verticalSpaceFromWidth,
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.commentList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 5 / 7.2,
                      ),
                      itemBuilder: (context, index) {
                        var item = controller.commentList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: ImgItem(
                                  item.images.isNotEmpty
                                      ? item.images.first
                                      : '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 9.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      minHeight: 29.h,
                                    ),
                                    child: AppText(
                                      str: item.content,
                                      fontSize: 12,
                                      lines: 2,
                                    ),
                                  ),
                                  8.verticalSpaceFromWidth,
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: ImgItem(
                                          item.user?.avatar ?? '',
                                          width: 20.w,
                                          height: 20.w,
                                        ),
                                      ),
                                      6.horizontalSpace,
                                      Expanded(
                                        child: AppText(
                                          str: item.user?.name ?? '',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                ],
              ),
            )
          : AppGaps.empty,
    );
  }
}
