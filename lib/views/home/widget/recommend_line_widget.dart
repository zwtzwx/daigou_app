import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/home/home_controller.dart';

class RecommendLineWidget extends GetView<IndexLogic> {
  const RecommendLineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFF6F6F6),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AppText(
              str: '精选渠道'.ts,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          15.verticalSpaceFromWidth,
          Obx(
            () => SizedBox(
              height: 90.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.lineList.length,
                itemBuilder: (context, index) {
                  var line = controller.lineList[index];
                  return GestureDetector(
                    onTap: () {
                      BeeNav.push(
                          BeeNav.lineDetail, {'id': line.id, 'type': 1});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 14.w),
                      width: controller.langList.length == 1
                          ? 1.sw - 24.w
                          : 1.sw - 90.w,
                      padding: EdgeInsets.fromLTRB(14.w, 10.h, 18.w, 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            str: line.name,
                            fontWeight: FontWeight.bold,
                          ),
                          8.verticalSpaceFromWidth,
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppText(
                                    str: line.region?.referenceTime ?? '',
                                    fontSize: 14,
                                  ),
                                ),
                                10.horizontalSpace,
                                AppText(
                                  str: '{amount}起'.tsArgs(
                                    {
                                      'amount': num.parse(line.basePrice).rate(
                                        needFormat: false,
                                      ),
                                    },
                                  ),
                                  color: const Color(0xFFFD5959),
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          8.verticalSpaceFromWidth,
                          AppText(
                            str: '接受'.ts + '：' + line.propStr,
                            fontSize: 12,
                            color: AppColors.textGrayC9,
                            lines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          22.verticalSpaceFromWidth,
          SizedBox(
            height: 40.h,
            width: 1.sw - 24.w,
            child: BeeButton(
              text: '运费估算',
              onPressed: () {
                BeeNav.push(BeeNav.lineQuery);
              },
            ),
          ),
        ],
      ),
    );
  }
}
