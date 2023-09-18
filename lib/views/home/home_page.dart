import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/ad_cell.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/contact_cell.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/goods/goods_item.dart';
import 'package:jiyun_app_client/views/components/goods/goods_list_cell.dart';
import 'package:jiyun_app_client/views/components/goods/search_input.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/home/widget/title_cell.dart';

/*
  首页
*/

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: controller.handleRefresh,
              color: AppColors.primary,
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
                        stops: [0.6, 0.7],
                      ),
                    ),
                    child: Column(
                      children: [
                        const LanguageCell(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
                          child: Row(
                            children: [
                              const Expanded(
                                child: SearchCell(goPlatformGoods: true),
                              ),
                              14.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  Routers.push(Routers.notice);
                                },
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    LoadImage(
                                      'Home/bell',
                                      width: 28.w,
                                      height: 28.w,
                                    ),
                                    Obx(() => controller.noticeUnRead.value
                                        ? ClipOval(
                                            child: Container(
                                              width: 6.w,
                                              height: 6.w,
                                              color: AppColors.textRed,
                                            ),
                                          )
                                        : AppGaps.empty)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const AdsCell(type: 5),
                        categoryCell(),
                        hotSaleGoodsCell(),
                      ],
                    ),
                  ),
                  20.verticalSpaceFromWidth,
                  recommendGoodsList(),
                  30.verticalSpaceFromWidth,
                ],
              ),
            ),
            const ContactCell(),
          ],
        ),
      ),
    );
  }

  // 代购分类
  Widget categoryCell() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        margin: EdgeInsets.only(top: 20.h),
        height: controller.categoryList.length < 6 ? 70.h : 140.h,
        child: ListView.builder(
          itemCount: (controller.categoryList.length / 8).ceil(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            int currentLen = controller.categoryList.length - (index * 8);
            var list = controller.categoryList
                .sublist(index * 8, index * 8 + currentLen);
            return SizedBox(
              width: 1.sw - 30.w,
              child: Wrap(
                runSpacing: 20.w,
                children: list
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          controller.onCategory(e);
                        },
                        child: Container(
                          width: (1.sw - 30.w) / 5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LoadImage(
                                e.image ?? 'Home/shop',
                                holderImg: 'Shop/goods_cate_none',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              ),
                              e.id == 0
                                  ? Obx(
                                      () => AppText(
                                        str: e.name.ts,
                                        fontSize: 12,
                                      ),
                                    )
                                  : AppText(
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
      ),
    );
  }

  // 精选商品
  Widget hotSaleGoodsCell() {
    return Column(
      children: [
        TitleCell(
          title: '精选商品',
          onMore: () {
            controller.onCategory();
          },
        ),
        Container(
          margin: EdgeInsets.only(left: 12.w),
          child: FutureBuilder(
              future: controller.getHotGoodsList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return controller.hotGoodsList.isNotEmpty
                      ? SizedBox(
                          height: (1.sw - 34.w) / 2.5 * (12 / 7.5),
                          child: ListView.builder(
                            itemCount: controller.hotGoodsList.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GoodsItem(
                              width: (1.sw - 34.w) / 2.5,
                              goods: controller.hotGoodsList[index],
                              margin: EdgeInsets.only(right: 10.w),
                            ),
                          ),
                        )
                      : AppGaps.empty;
                } else {
                  return SizedBox(
                    height: (1.sw - 34.w) / 2.5 * (12 / 7.5),
                    child: const Skeleton(
                      type: SkeletonType.goodsSkeleton,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }

  // 推荐商品（代购商品）
  Widget recommendGoodsList() {
    return Column(
      children: [
        const TitleCell(
          title: '推荐商品',
        ),
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GoodsListCell(
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
