import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/goods_item.dart';
import 'package:jiyun_app_client/views/components/goods/search_input.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/shop/goods_list/goods_list_controller.dart';
import 'package:jiyun_app_client/views/shop/widget/sliver_header_delegate.dart';

class GoodsListView extends GetView<GoodsListController> {
  const GoodsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseStylesConfig.bgGray,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: ZHTextLine(
          str: '自营商城'.ts,
          fontSize: 18,
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
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
                      orderByItem('销量', 'sale_count'),
                      orderByItem('价格', 'goods_lowest_price', sorted: true),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            return GoodsItem(
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
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchCell(
            searchText: '搜索',
            onSearch: controller.onSearch,
            needCheck: false,
            initData: controller.keyword,
          ),
          15.verticalSpaceFromWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.arguments?['id'] != null
                  ? SizedBox(
                      height: 20.h,
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.categories.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var e = controller.categories[index];
                            return GestureDetector(
                              onTap: () {
                                controller.onCategory(e.id);
                              },
                              child: Obx(
                                () => Container(
                                  margin: EdgeInsets.only(
                                      left: index == 0 ? 0 : 25.w),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: controller.categoryId.value ==
                                              e.id
                                          ? BorderSide(
                                              width: 3.h,
                                              color: BaseStylesConfig.primary,
                                            )
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: ZHTextLine(
                                    str: index == 0 ? e.name.ts : e.name,
                                    fontSize: 16,
                                    fontWeight:
                                        controller.categoryId.value == e.id
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color: controller.categoryId.value == e.id
                                        ? BaseStylesConfig.textDark
                                        : BaseStylesConfig.textGrayC9,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Sized.empty,
            ],
          ),
        ],
      ),
    );
  }

  Widget orderByItem(String label, String value, {bool sorted = false}) {
    if (sorted) {
      return GestureDetector(
        onTap: () {
          controller.onOrderBy(value);
        },
        child: Container(
          alignment: Alignment.center,
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => ZHTextLine(
                  str: label.ts,
                  color: controller.orderBy.value == value
                      ? BaseStylesConfig.textDark
                      : BaseStylesConfig.textGrayC9,
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
                        color: controller.sortType.value == 'asc'
                            ? BaseStylesConfig.textDark
                            : BaseStylesConfig.textGrayC9,
                        size: 25,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: controller.sortType.value == 'desc'
                            ? BaseStylesConfig.textDark
                            : BaseStylesConfig.textGrayC9,
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
    }
    return GestureDetector(
      onTap: () {
        controller.onSortBy(value);
      },
      child: Obx(
        () => ZHTextLine(
          str: label.ts,
          color: controller.orderBy.value == value
              ? BaseStylesConfig.textDark
              : BaseStylesConfig.textGrayC9,
        ),
      ),
    );
  }
}
