import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/language_cell/language_cell.dart';
import 'package:huanting_shop/views/components/load_image.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(14.w, kToolbarHeight, 14.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LanguageCell(),
          12.verticalSpaceFromWidth,
          Row(
            children: [
              const Expanded(child: BaseSearch()),
              8.horizontalSpace,
              Obx(() {
                var cartCount = Get.find<AppStore>().cartCount.value;
                return GestureDetector(
                  onTap: () {
                    BeeNav.push(BeeNav.cart);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      LoadAssetImage(
                        'Home/ico_gwc',
                        width: 28.w,
                        height: 28.w,
                      ),
                      if (cartCount != 0)
                        Positioned(
                          right: -4.w,
                          top: -4.w,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.w),
                            child: AppText(
                              str: cartCount.toString(),
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(85.h + kToolbarHeight);
}
