import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/ad_cell.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/goods_list_cell.dart';
import 'package:jiyun_app_client/views/components/goods/search_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/home/widget/title_cell.dart';
import 'package:jiyun_app_client/views/shop/center/shop_center_controller.dart';

class ShopCenterView extends GetView<ShopCenterController> {
  const ShopCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: AppText(
          str: '自营商城'.ts,
          fontSize: 18,
        ),
        elevation: 0,
      ),
      backgroundColor: AppColors.bgGray,
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.loadingUtil.value.scrollController,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, AppColors.bgGray],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.4],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
                    child: SearchCell(
                      searchText: '搜索',
                      onSearch: controller.onSearch,
                    ),
                  ),
                  const AdsCell(type: 5),
                  20.verticalSpaceFromWidth,
                  categoryCell(),
                  goodsListCell(),
                ],
              ),
            ),
            30.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  // 商品分类
  Widget categoryCell() {
    return FutureBuilder(
      future: controller.getCategory(),
      builder: (context, snapshot) {
        var state = snapshot.connectionState;
        if (state == ConnectionState.done) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            height: controller.categories.length < 6 ? 60.h : 120.h,
            child: ListView.builder(
              itemCount: (controller.categories.length / 8).ceil(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                int currentLen = controller.categories.length - (index * 8);
                var list = controller.categories
                    .sublist(index * 8, index * 8 + currentLen);
                return SizedBox(
                  width: 1.sw - 30.w,
                  child: Wrap(
                    runSpacing: 20.w,
                    children: list
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              controller.onCategory(e.id);
                            },
                            child: Container(
                              width: (1.sw - 30.w) / 5,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ImgItem(
                                    e.image ?? '',
                                    holderImg: 'Shop/goods_cate_none',
                                    width: ScreenUtil().setWidth(40),
                                    height: ScreenUtil().setWidth(40),
                                  ),
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

  // 热销商品
  Widget goodsListCell() {
    return Column(
      children: [
        const TitleCell(
          title: '热销商品',
        ),
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: BeeShopGoodsList(
                goodsList: controller.loadingUtil.value.list,
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
