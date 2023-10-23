import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/dropdown_menu.dart';
import 'package:jiyun_app_client/views/components/goods/platform_goods_item.dart';
import 'package:jiyun_app_client/views/components/goods/search_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/shop/platform_goods/platform_goods_controller.dart';
import 'package:jiyun_app_client/views/shop/widget/sliver_header_delegate.dart';

class PlatformGoodsListView extends GetView<PlatformGoodsController> {
  const PlatformGoodsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: AppText(
            str: '代购商品'.ts,
            fontSize: 18,
          ),
          elevation: 0,
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
                  SliverToBoxAdapter(
                    child: filtersCell(),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverHeaderDelegate(
                      maxHeight: 33.h,
                      minHeight: 33.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            orderByItem('综合', ''),
                            orderByItem('销量', 'sale'),
                            orderByItem('价格', 'bid2', sorted: true),
                            orderByItem('筛选', '', filter: true),
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
            Obx(
              () => PlatformDropdownMenu(
                show: controller.filterShow.value,
                offset: controller.loadingUtil.value.position,
                platform: controller.platform.value,
                onHide: controller.onHideFilter,
                onConfirm: (String value) {
                  controller.onHideFilter();
                  controller.platform.value = value;
                  controller.handleRefresh();
                },
              ),
            ),
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
      child: SearchCell(
        searchText: '搜索',
        onSearch: controller.onSearch,
        needCheck: false,
        initData: controller.keyword,
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
                      top: -6,
                      child: Icon(
                        Icons.arrow_drop_up_sharp,
                        color: controller.orderBy.value == 'bid2'
                            ? AppColors.textDark
                            : AppColors.textGrayC9,
                        size: 25,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: controller.orderBy.value == '_bid2'
                            ? AppColors.textDark
                            : AppColors.textGrayC9,
                        size: 25,
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
                color: controller.platform.value != 'pinduoduo'
                    ? AppColors.textDark
                    : AppColors.textGrayC9,
              ),
              ImgItem(
                controller.platform.value != 'pinduoduo'
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
      child: Obx(
        () => AppText(
          str: label.ts,
          color: controller.orderBy.value == value
              ? AppColors.textDark
              : AppColors.textGrayC9,
        ),
      ),
    );
  }
}
