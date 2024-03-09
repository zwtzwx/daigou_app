import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/goods/goods_list_cell.dart';
import 'package:shop_app_client/views/components/goods/search_input.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/loading_cell.dart';
import 'package:shop_app_client/views/shop/platform/platform_controller.dart';
import 'package:shop_app_client/views/shop/widget/app_bar_bottom.dart';

class PlatformView extends GetView<PlatformController> {
  const PlatformView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppText(
          str: controller.getPlatformName().inte,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        bottom: AppBarBottom(
          height: 30.h,
          child: Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
            child: SearchCell(
              onSearch: (value) {
                controller.onSearch(value);
              },
            ),
          ),
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        color: AppStyles.primary,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.loadingUtil.value.scrollController,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, AppStyles.bgGray],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.3],
                ),
              ),
              child: Column(
                children: [
                  categoryCell(),
                  recommendGoodsList(),
                ],
              ),
            ),
            30.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  Widget categoryCell() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        margin: EdgeInsets.only(top: 20.h),
        height: controller.categoryList.length < 6 ? 70.h : 170.h,
        child: ListView.builder(
          itemCount: (controller.categoryList.length / 10).ceil(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            int currentLen = controller.categoryList.length - (index * 10);
            var list = controller.categoryList
                .sublist(index * 10, index * 10 + currentLen);
            return SizedBox(
              width: 1.sw - 30.w,
              child: Wrap(
                runSpacing: 20.w,
                children: list
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          controller.onSearch(e.nameCn ?? e.name);
                        },
                        child: Container(
                          width: (1.sw - 30.w) / 5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImgItem(
                                e.image ?? 'Home/shop',
                                holderImg: 'Shop/goods_cate_none',
                                width: 40.w,
                                height: 40.w,
                              ),
                              AppText(
                                str: e.name,
                                fontSize: 12,
                                lines: 2,
                                alignment: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget recommendGoodsList() {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: BeeShopGoodsList(
                isPlatformGoods: true,
                platformGoodsList: controller.loadingUtil.value.list,
              ),
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
}
