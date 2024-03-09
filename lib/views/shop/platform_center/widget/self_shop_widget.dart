import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/ad_cell.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/goods/goods_list_cell.dart';
import 'package:shop_app_client/views/components/goods/search_input.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/loading_cell.dart';
import 'package:shop_app_client/views/components/skeleton/skeleton.dart';
import 'package:shop_app_client/views/shop/platform_center/platform_shop_center_controller.dart';

class SelfShopWidget extends GetView<PlatformShopCenterController> {
  const SelfShopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpaceFromWidth,
          SearchCell(
            onSearch: (value) {
              GlobalPages.push(GlobalPages.goodsList, arg: {'keyword': value});
            },
            cleanContentWhenSearch: true,
          ),
          15.verticalSpaceFromWidth,
          const AdsCell(type: 5, padding: 0),
          13.verticalSpaceFromWidth,
          categoryCell(),
          15.verticalSpaceFromWidth,
          Obx(
            () => AppText(
              str: '热销商品'.inte,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          15.verticalSpaceFromWidth,
          goodsList(),
        ],
      ),
    );
  }

  Widget categoryCell() {
    return FutureBuilder(
      future: controller.getSelfShopCategory(),
      builder: (context, snapshot) {
        var state = snapshot.connectionState;
        if (state == ConnectionState.done) {
          return SizedBox(
            height: controller.selfShopCategories.length < 5 ? 80.h : 150.h,
            child: ListView.builder(
              itemCount: (controller.selfShopCategories.length / 8).ceil(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                int currentLen =
                    controller.selfShopCategories.length - (index * 8);
                var list = controller.selfShopCategories
                    .sublist(index * 8, index * 8 + currentLen);
                return SizedBox(
                  width: 1.sw - 30.w,
                  child: Wrap(
                    runSpacing: 20.w,
                    children: list
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              controller.onSelfShopCategory(e.id);
                            },
                            child: Container(
                              width: (1.sw - 30.w) / 4,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ImgItem(
                                    e.image ?? '',
                                    holderImg: 'Shop/goods_cate_none',
                                    width: 50.w,
                                    height: 50.w,
                                  ),
                                  5.verticalSpaceFromWidth,
                                  AppText(
                                    str: e.name,
                                    fontSize: 12,
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
          );
        }
        return Skeleton(
          type: SkeletonType.singleSkeleton,
          lineCount: 4,
          height: 100.h,
          margin: const EdgeInsets.symmetric(vertical: 15),
        );
      },
    );
  }

  Widget goodsList() {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible: controller.selfShopLoadingUtil.value.list.isNotEmpty,
            child: BeeShopGoodsList(
              goodsList: controller.selfShopLoadingUtil.value.list,
            ),
          ),
        ),
        Obx(
          () => LoadingCell(
            util: controller.selfShopLoadingUtil.value,
          ),
        ),
      ],
    );
  }
}
