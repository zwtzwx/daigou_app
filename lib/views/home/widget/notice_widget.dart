import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/home/home_controller.dart';

class NoticeWidget extends StatelessWidget {
  const NoticeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var list = Get.find<IndexLogic>().noticeList;
      return Container(
        height: 36.h,
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            LoadAssetImage(
              'Home/ico_gg',
              width: 20.w,
              height: 20.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, right: 16.w),
              child: AppText(
                str: '公告'.inte,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Swiper(
                loop: list.length > 1,
                autoplay: list.length > 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      GlobalPages.push(GlobalPages.webview,
                          arg: {'type': 'notice', 'id': list[index].id});
                    },
                    child: Container(
                      height: 36.h,
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        str: list[index].title,
                        fontSize: 14,
                        color: AppStyles.textNormal,
                      ),
                    ),
                  );
                },
                itemCount: list.length,
              ),
            ),
            5.horizontalSpace,
            GestureDetector(
              onTap: () {
                GlobalPages.push(GlobalPages.help);
              },
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: AppStyles.textNormal,
              ),
            ),
          ],
        ),
      );
    });
  }
}
