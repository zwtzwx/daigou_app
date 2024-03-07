import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/home/home_controller.dart';

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
                str: '公告'.ts,
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
                      BeeNav.push(BeeNav.webview,
                          arg: {'type': 'notice', 'id': list[index].id});
                    },
                    child: Container(
                      height: 36.h,
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        str: list[index].title,
                        fontSize: 14,
                        color: AppColors.textNormal,
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
                BeeNav.push(BeeNav.help);
              },
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: AppColors.textNormal,
              ),
            ),
          ],
        ),
      );
    });
  }
}
