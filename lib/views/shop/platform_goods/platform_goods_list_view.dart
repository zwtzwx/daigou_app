import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/platform_goods_item.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/loading_cell.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_controller.dart';
import 'package:huanting_shop/views/shop/widget/sliver_header_delegate.dart';

class PlatformGoodsListView extends GetView<PlatformGoodsController> {
  const PlatformGoodsListView({Key? key, required this.controllerTag})
      : super(key: key);
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: const BackButton(color: Colors.black)),
          backgroundColor: AppColors.bgGray,
          title: controller.hideSearch
              ? AppText(
                  str: controller.keyword,
                  fontSize: 17,
                )
              : BaseSearch(
                  onSearch: controller.onSearch,
                  needCheck: false,
                  initData: controller.originKeyword,
                  whiteBg: true,
                ),
          elevation: 0,
          leadingWidth: 40.w,
        ),
        backgroundColor: AppColors.bgGray,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: controller.handleRefresh,
              color: AppColors.primary,
              child: CustomScrollView(
                controller: controller.loadingUtil.value.scrollController,
                slivers: [
                  // SliverToBoxAdapter(
                  //   child: filtersCell(),
                  // ),
                  SliverPadding(padding: EdgeInsets.only(top: 10.h)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverHeaderDelegate(
                      maxHeight: 33.h,
                      minHeight: 33.h,
                      bgColor: AppColors.bgGray,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Row(
                              children: controller.platforms
                                  .map(
                                    (e) => Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          controller.platform.value =
                                              e['value']!;
                                          controller.handleRefresh();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          margin: EdgeInsets.only(right: 15.w),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 20.h,
                                                child: AppText(
                                                  str: e['name']!.ts,
                                                  color: controller
                                                              .platform.value ==
                                                          e['value']
                                                      ? AppColors.textDark
                                                      : AppColors.textGrayC9,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r),
                                                  color: controller
                                                              .platform.value ==
                                                          e['value']
                                                      ? AppColors.primary
                                                      : AppColors.bgGray,
                                                ),
                                                width: 22.w,
                                                height: 3.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )),
                            orderByItem('销量', 'sale'),
                            15.horizontalSpace,
                            orderByItem('价格', 'bid2', sorted: true),
                            // orderByItem('筛选', '', filter: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                    sliver: goodsList(),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(
                      () => LoadingCell(
                        util: controller.loadingUtil.value,
                        onRefresh: controller.handleRefresh,
                        emptyHeight: 1.sh -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            150.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => controller.loadingUtil.value.position.value > 200.h
                ? Positioned(
                    right: 14.w,
                    bottom: 100.h,
                    child: GestureDetector(
                      onTap: () {
                        controller.loadingUtil.value.scrollController
                            .animateTo(0,
                                duration: const Duration(
                                  milliseconds: 500,
                                ),
                                curve: Curves.easeInOut);
                      },
                      child: LoadAssetImage(
                        'Shop/ico_db',
                        width: 38.w,
                        height: 38.w,
                      ),
                    ))
                : AppGaps.empty),
          ],
        ));
  }

  Widget goodsList() {
    return Obx(
      () => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.w,
          childAspectRatio: 7 / 11,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return PlatformGoodsCell(
              goods: controller.loadingUtil.value.list[index],
            );
          },
          childCount: controller.loadingUtil.value.list.length,
        ),
      ),
    );
  }

  Widget filtersCell() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 5.h),
      child: BaseSearch(
        onSearch: controller.onSearch,
        needCheck: false,
        initData: controller.originKeyword,
      ),
    );
  }

  Widget orderByItem(
    String label,
    String value, {
    bool sorted = false,
    bool filter = false,
  }) {
    if (sorted) {
      return GestureDetector(
        onTap: () {
          var cur = controller.orderBy.value;
          controller.onHideFilter();
          controller.onSortBy(cur == 'bid2' ? '_bid2' : value);
        },
        child: Container(
          alignment: Alignment.center,
          height: 20.h,
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => AppText(
                  str: label.ts,
                  color: ['bid2', '_bid2'].contains(controller.orderBy.value)
                      ? AppColors.textDark
                      : AppColors.textGrayC9,
                  fontSize: 14,
                ),
              ),
              Obx(
                () => Stack(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 16.h,
                    ),
                    Positioned(
                      top: -5.w,
                      right: 2.w,
                      child: Icon(
                        Icons.arrow_drop_up_sharp,
                        color: controller.orderBy.value == 'bid2'
                            ? AppColors.textDark
                            : AppColors.textGrayC9,
                        size: 22.sp,
                      ),
                    ),
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: controller.orderBy.value == '_bid2'
                            ? AppColors.textDark
                            : AppColors.textGrayC9,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (filter) {
      return GestureDetector(
        onTap: () {
          controller.filterShow.value = !controller.filterShow.value;
        },
        child: Obx(
          () => Row(
            children: [
              AppText(
                str: label.ts,
                color: controller.platform.value != '1688'
                    ? AppColors.textDark
                    : AppColors.textGrayC9,
              ),
              ImgItem(
                controller.platform.value != '1688'
                    ? 'Shop/filter_s'
                    : 'Shop/filter',
                width: 20.w,
              )
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        controller.onHideFilter();
        controller.onSortBy(value);
      },
      child: Container(
        alignment: Alignment.center,
        height: 20.h,
        child: Obx(
          () => AppText(
            str: label.ts,
            color: controller.orderBy.value == value
                ? AppColors.textDark
                : AppColors.textGrayC9,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
