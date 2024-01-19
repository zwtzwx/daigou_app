import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/goods_list_cell.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/loading_cell.dart';
import 'package:huanting_shop/views/shop/platform_center/platform_shop_center_controller.dart';

class DaigouWidget extends GetView<PlatformShopCenterController> {
  const DaigouWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          10.verticalSpaceFromWidth,
          platformList(),
          15.verticalSpaceFromWidth,
          const BaseSearch(),
          18.verticalSpaceFromWidth,
          Obx(() => controller.categoryList.isNotEmpty
              ? categoryList()
              : AppGaps.empty),
          goodsList(),
        ],
      ),
    );
  }

  Widget platformList() {
    List<Map<String, String>> list = [
      {'icon': 'Shop/tb', 'value': 'taobao'},
      {'icon': 'Shop/pdd', 'value': 'pinduoduo'},
      {'icon': 'Shop/jd', 'value': 'jd'},
      {'icon': 'Shop/1688', 'value': '1688'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: list
          .map(
            (e) => GestureDetector(
              onTap: () {
                if (controller.daigouPlatform.value == e['value']) return;
                controller.daigouPlatform.value = e['value']!;
                controller.handleRefresh();
              },
              child: ImgItem(
                e['icon']!,
                width: 42.w,
                height: 42.w,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget goodsList() {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: BeeShopGoodsList(
              isPlatformGoods: true,
              platformGoodsList: controller.loadingUtil.value.list,
            ),
          ),
        ),
        Obx(
          () => LoadingCell(
            util: controller.loadingUtil.value,
          ),
        ),
      ],
    );
  }

  Widget categoryList() {
    return Container(
      height: 30.h,
      margin: EdgeInsets.only(bottom: 15.h),
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.onCategory(index);
              },
              child: Obx(
                () => Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 15.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.categoryIndex.value == index
                          ? AppColors.primary
                          : const Color(
                              0xFFE4E4E4,
                            ),
                    ),
                    color: controller.categoryIndex.value == index
                        ? const Color(0xFFFFF9E7)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: AppText(
                    str: controller.categoryList[index].name,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
