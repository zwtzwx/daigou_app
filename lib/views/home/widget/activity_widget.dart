import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AppText(
              str: '活动公告'.ts,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          15.verticalSpaceFromWidth,
          Obx(() {
            var ads = Get.find<AppStore>()
                .adList
                .where((item) => item.position == 1 && item.type == 2)
                .toList();
            return ads.isNotEmpty
                ? (ads.length == 1
                    ? GestureDetector(
                        child: ImgItem(
                          ads.first.fullPath,
                          width: 1.sw - 24.w,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 14.w),
                              child: GestureDetector(
                                child: ImgItem(
                                  ads[index].fullPath,
                                  width: ads.length == 1
                                      ? 1.sw - 24.w
                                      : 1.sw - 60.w,
                                  fit: ads.length == 1
                                      ? BoxFit.fill
                                      : BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ))
                : AppGaps.empty;
          }),
        ],
      ),
    );
  }
}
