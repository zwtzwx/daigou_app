import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/banner.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/empty_app_bar.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/help/customer/controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox(
              height: 240.h,
              child: const BannerBox(
                imgType: 'support_image',
              ),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: kTextTabBarHeight + 10.h),
                height: 30.h,
                child: NavigationToolbar(
                  leading: Padding(
                    padding: EdgeInsets.only(left: 14.w),
                    child: const BackButton(color: Colors.black),
                  ),
                  middle: AppText(
                    str: '客服'.ts,
                    fontSize: 17,
                  ),
                ),
              ),
              30.verticalSpaceFromWidth,
              Container(
                padding: EdgeInsets.only(right: 20.w),
                alignment: Alignment.centerRight,
                child: AppText(
                  str: 'HI~\n${'有什么可以帮助您'.ts}！',
                  fontSize: 14,
                  lines: 10,
                  lineHeight: 1.6,
                ),
              ),
              50.verticalSpaceFromWidth,
              ...controller.customers.map(
                (e) => GestureDetector(
                  onTap: () {
                    CommonMethods.onCustomerContact(e['type']!);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                    child: Row(
                      children: [
                        LoadAssetImage(
                          e['icon']!,
                          width: 40.w,
                          height: 40.w,
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                str: (e['name'] as String).ts,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              8.verticalSpaceFromWidth,
                              AppText(
                                str: '${'工作时间'.ts}：${'工作日'.ts}10:00-18:00',
                                fontSize: 14,
                                color: AppColors.textNormal,
                              ),
                            ],
                          ),
                        ),
                        10.horizontalSpace,
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: AppColors.textNormal,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
