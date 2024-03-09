import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/ad_cell.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/contact_cell.dart';
import 'package:shop_app_client/views/components/goods/goods_list_cell.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/loading_cell.dart';
import 'package:shop_app_client/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_client/views/home/widget/header.dart';
import 'package:shop_app_client/views/home/widget/notice_widget.dart';
import 'package:shop_app_client/views/shop/platform_goods/platform_goods_binding.dart';
import 'package:shop_app_client/views/shop/platform_goods/platform_goods_list_view.dart';

class IndexPage extends GetView<IndexLogic> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      child: Scaffold(
        primary: false,
        appBar: const HomeHeader(),
        key: controller.scaffoldKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 1.sh),
                child: RefreshIndicator(
                  onRefresh: controller.handleRefresh,
                  color: AppStyles.primary,
                  child: ListView(
                    shrinkWrap: true,
                    controller: controller.loadingUtil.value.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      AdsCell(type: 5, padding: 14.w),
                      buildLinks(),
                      const NoticeWidget(),
                      categoryBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Obx(
                          () => AppText(
                            str: '大家在看什么'.inte,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      15.verticalSpaceFromWidth,
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: BeeShopGoodsList(
                            isPlatformGoods: true,
                            platformGoodsList:
                                controller.loadingUtil.value.list,
                          ),
                        ),
                      ),
                      Obx(
                        () => Center(
                          child: LoadingCell(
                            util: controller.loadingUtil.value,
                          ),
                        ),
                      ),
                      50.verticalSpaceFromWidth,
                    ],
                  ),
                ),
              ),
              const CartCell(),
            ],
          ),
        ),
      ),
      value: SystemUiOverlayStyle.dark,
    );
  }

  // 商品分类
  Widget categoryBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 25.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F7FF),
            Color(0xFFF7FBFE),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => AppText(
                    str: '精选分类'.inte,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    GlobalPages.push(GlobalPages.goodsCategory);
                  },
                  child: AppText(
                    str: '查看全部'.inte,
                    fontSize: 14,
                    color: AppStyles.textNormal,
                  ),
                ),
              ),
              5.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios,
                size: 13.sp,
                color: AppStyles.textNormal,
              ),
            ],
          ),
          15.verticalSpaceFromWidth,
          SizedBox(
            height: 100.w,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categoryList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Get.to(
                        PlatformGoodsListView(
                            controllerTag: controller.categoryList[index].name),
                        arguments: {
                          'keyword': controller.categoryList[index].nameCn,
                          'origin': controller.categoryList[index].name,
                          // 'hideSearch': true,
                        },
                        binding: PlatformGoodsBinding(
                            tag: controller.categoryList[index].name));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 14.w),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          width: 68.w,
                          height: 68.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.all(8.w),
                          child: (controller.categoryList[index].image ?? '')
                                  .isNotEmpty
                              ? ImgItem(
                                  controller.categoryList[index].image ?? '',
                                  holderColor: Colors.white,
                                )
                              : null,
                        ),
                        10.verticalSpaceFromWidth,
                        AppText(
                          str: controller.categoryList[index].name,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLinks() {
    List<Map<String, dynamic>> list = [
      {
        'label': '新手指引',
        'icon': 'Home/ico_xszy',
        'route': GlobalPages.guide,
      },
      {
        'label': '运费估算',
        'icon': 'Home/ico_yfgs',
        'route': GlobalPages.lineQuery,
      },
      {
        'label': '推广联盟',
        'icon': 'Home/ico_tglm',
        'route': GlobalPages.agentApplyInstruct,
      },
      {
        'label': '提交转运',
        'icon': 'Home/ico_zydd',
        'route': GlobalPages.orderCenter,
        'params': 1
      },
    ];
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 20.h, 14.w, 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map(
              (e) => Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (e['route'] == GlobalPages.agentApplyInstruct &&
                        controller.agentStatus.value == 1) {
                      GlobalPages.push(GlobalPages.agentCenter);
                    } else {
                      GlobalPages.push(e['route']!, arg: e['params']);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ImgItem(
                          e['icon']!,
                          width: 42.w,
                          height: 42.w,
                        ),
                        5.verticalSpaceFromWidth,
                        Obx(
                          () => AppText(
                            str: (e['label']! as String).inte,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
