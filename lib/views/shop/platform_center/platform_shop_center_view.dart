import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/ad_cell.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/contact_cell.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/goods/goods_list_cell.dart';
import 'package:jiyun_app_client/views/components/goods/search_input.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/shop/platform_center/platform_shop_center_controller.dart';

class PlatformShopCenterView extends GetView<PlatformShopCenterController> {
  const PlatformShopCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      body: Stack(
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
                      stops: [0.9, 1],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LanguageCell(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
                        child: const SearchCell(goPlatformGoods: true),
                      ),
                      const AdsCell(type: 5),
                      20.verticalSpaceFromWidth,
                      stepCell(),
                      25.verticalSpaceFromWidth,
                      categoryList(),
                      15.verticalSpaceFromWidth,
                    ],
                  ),
                ),
                goodsList(),
                30.verticalSpaceFromWidth,
              ],
            ),
          ),
          const ContactCell(),
        ],
      ),
    );
  }

  Widget stepCell() {
    List<Map<String, String>> list = [
      {'img': 'step1', 'name': '支付订单'},
      {'img': 'step2', 'name': '采购验货'},
      {'img': 'step3', 'name': '申请发货'},
      {'img': 'step4', 'name': '支付运费'},
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AppText(
              str: '代购流程'.ts,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: list
                      .map(
                        (e) => Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoadImage(
                              'Shop/${e['img']}',
                              width: 40.w,
                              height: 40.w,
                            ),
                            3.verticalSpace,
                            Obx(
                              () => AppText(
                                str: e['name']!.ts,
                                fontSize: 12,
                                lines: 4,
                                alignment: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 19.w,
                  child: const LoadImage(
                    'Shop/line',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: 20.h,
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
                  margin: EdgeInsets.only(left: index == 0 ? 0 : 20.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: controller.categoryIndex.value == index
                          ? BorderSide(color: AppColors.primary, width: 2.h)
                          : BorderSide.none,
                    ),
                  ),
                  child: controller.categoryList[index].id == 0
                      ? Obx(
                          () => AppText(
                            str: controller.categoryList[index].name.ts,
                            fontSize: controller.categoryIndex.value == index
                                ? 16
                                : 14,
                            color: controller.categoryIndex.value == index
                                ? AppColors.textDark
                                : AppColors.textNormal,
                            fontWeight: controller.categoryIndex.value == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        )
                      : AppText(
                          str: controller.categoryList[index].name,
                          fontSize:
                              controller.categoryIndex.value == index ? 16 : 14,
                          color: controller.categoryIndex.value == index
                              ? AppColors.textDark
                              : AppColors.textNormal,
                          fontWeight: controller.categoryIndex.value == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget goodsList() {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GoodsListCell(
                isPlatformGoods: true,
                platformGoodsList: controller.loadingUtil.value.list,
                firstPlaceholder: true,
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
