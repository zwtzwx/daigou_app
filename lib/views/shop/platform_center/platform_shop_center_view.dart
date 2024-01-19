import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/shop/platform_center/platform_shop_center_controller.dart';
import 'package:huanting_shop/views/shop/platform_center/widget/daigou_widget.dart';
import 'package:huanting_shop/views/shop/platform_center/widget/self_shop_widget.dart';
import 'package:huanting_shop/views/shop/widget/app_bar_bottom.dart';

class PlatformShopCenterView extends GetView<PlatformShopCenterController> {
  const PlatformShopCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBottom(
        height: 50.h,
        child: Obx(
          () => platformList(),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        color: AppColors.primary,
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.platformType.value == 1
                ? controller.loadingUtil.value.scrollController
                : controller.selfShopLoadingUtil.value.scrollController,
            children: [
              Offstage(
                offstage: controller.platformType.value == 2,
                child: const DaigouWidget(),
              ),
              Offstage(
                offstage: controller.platformType.value == 1,
                child: const SelfShopWidget(),
              ),
              30.verticalSpaceFromWidth,
            ],
          ),
        ),
      ),
    );
  }

  Widget platformList() {
    List<String> list = ['代购', '自营'];
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().statusBarHeight + 5.h, left: 14.w, bottom: 10.h),
      child: Wrap(
        spacing: 20.w,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: list
            .asMap()
            .keys
            .map(
              (index) => GestureDetector(
                onTap: () {
                  if (controller.platformType.value == index + 1) return;
                  controller.platformType.value = index + 1;
                },
                child: AppText(
                  str: list[index].ts,
                  fontSize:
                      controller.platformType.value == index + 1 ? 18 : 16,
                  fontWeight: controller.platformType.value == index + 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
