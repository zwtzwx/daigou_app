import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/models/goods_category_model.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/shop/category/controller.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_binding.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_list_view.dart';

class GoodsCategoryView extends GetView<GoodsCategoryController> {
  const GoodsCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseSearch(),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: AppColors.bgGray,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Column(
                children: [
                  10.verticalSpaceFromWidth,
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 0.3.sw,
                          color: Colors.white,
                          child: Obx(
                            () => ListView.builder(
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                return topCategotyCell(
                                    controller.categories[index]);
                              },
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Obx(
                            () => (controller.topCategory.value?.children ?? [])
                                    .isNotEmpty
                                ? leafCategoryCell()
                                : AppGaps.empty,
                          ),
                        ),
                        10.horizontalSpace,
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget topCategotyCell(GoodsCategoryModel model) {
    return GestureDetector(
      onTap: () {
        controller.onTopSelect(model);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 13.w),
        alignment: Alignment.center,
        child: Obx(
          () => AppText(
            str: model.name,
            fontSize: controller.topCategory.value?.id == model.id ? 16 : 14,
            fontWeight: controller.topCategory.value?.id == model.id
                ? FontWeight.bold
                : FontWeight.w400,
            lines: 3,
            alignment: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget leafCategoryCell() {
    var model = controller.topCategory.value?.children ?? [];
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      child: GridView.builder(
          itemCount: model.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemBuilder: (context, index) {
            var child = model[index];
            return GestureDetector(
              onTap: () {
                Get.to(PlatformGoodsListView(controllerTag: child.name),
                    arguments: {
                      'keyword': child.nameCn,
                      'origin': child.name,
                      'hideSearch': true,
                    },
                    binding: PlatformGoodsBinding(tag: child.name));
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    ImgItem(
                      child.image ?? '',
                      width: 38.w,
                      height: 38.w,
                      fit: BoxFit.fill,
                    ),
                    2.verticalSpaceFromWidth,
                    AppText(
                      str: child.name,
                      fontSize: 14,
                      lines: 2,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
