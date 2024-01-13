import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/contact_cell.dart';
import 'package:jiyun_app_client/views/components/goods/goods_item.dart';
import 'package:jiyun_app_client/views/components/goods/goods_list_cell.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/home/widget/activity_widget.dart';
import 'package:jiyun_app_client/views/home/widget/recommend_line_widget.dart';
import 'package:jiyun_app_client/views/home/widget/title_cell.dart';

/*
  首页
*/

class IndexPage extends GetView<IndexLogic> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      // primary: false,
      // appBar: const EmptyAppBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const LanguageCell(),
        elevation: 0,
        leadingWidth: 120.w,
      ),
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
                children: [
                  Obx(() => buildUserInfo()),
                  buildLinks(),
                  40.verticalSpaceFromWidth,
                  const ActivityWidget(),
                  30.verticalSpaceFromWidth,
                  const RecommendLineWidget(),
                  // const AdsCell(type: 5),
                  // platformCell(),
                  // categoryCell(),
                  // hotSaleGoodsCell(),
                  // recommendGoodsList(),
                  50.verticalSpaceFromWidth,
                ],
              ),
            ),
            const ContactCell(),
          ],
        ),
      ),
    );
  }

  // 个人信息
  Widget buildUserInfo() {
    List<Map<String, String>> list = [
      {
        'label': '余额',
        'value': (controller.amountModel.value?.balance ?? 0)
            .rate(showPriceSymbol: false)
      },
      {
        'label': '优惠券',
        'value': (controller.amountModel.value?.couponCount ?? 0).toString()
      },
    ];
    if (controller.vipModel.value?.pointStatus == 1) {
      list.add({
        'label': '积分',
        'value': (controller.vipModel.value?.profile.point ?? 0).toString()
      });
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topLeft,
          fit: BoxFit.fill,
          image: AssetImage('assets/images/Home/user-bg.png'),
        ),
      ),
      child: Column(
        children: [
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  ClipOval(
                    child: ImgItem(
                      controller.userModel.value?.avatar ?? 'Center/logo',
                      width: 66.w,
                      height: 66.w,
                      holderImg: 'Center/logo',
                    ),
                  ),
                  12.horizontalSpace,
                  controller.userModel.value == null
                      ? BeeButton(
                          text: '点击登录',
                          onPressed: () {
                            BeeNav.push(BeeNav.login);
                          },
                        )
                      : const Column()
                ],
              ),
            ),
          ),
          25.verticalSpaceFromWidth,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: list
                .map(
                  (e) => Flexible(
                    child: Column(
                      children: [
                        AppText(
                          str: e['value']!,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        4.verticalSpace,
                        AppText(
                          str: e['label']!.ts,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildLinks() {
    List<Map<String, String>> list = [
      {
        'label': '新手指引',
        'icon': 'Home/xszy',
      },
      {
        'label': '集运转运',
        'icon': 'Home/jyzy',
      },
      {
        'label': '代购代买',
        'icon': 'Home/dgdm',
      },
      {
        'label': '自营商城',
        'icon': 'Home/zysc',
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          16.verticalSpaceFromWidth,
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F1),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    padding: EdgeInsets.only(top: 15.h, bottom: 25.h),
                    child: Column(
                      children: [
                        ImgItem(
                          'Home/dgscdd',
                          width: 55.w,
                          height: 55.w,
                        ),
                        10.verticalSpaceFromWidth,
                        Obx(
                          () => AppText(
                            str: '代购/商城订单'.ts,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    padding: EdgeInsets.only(top: 15.h, bottom: 25.h),
                    child: Column(
                      children: [
                        ImgItem(
                          'Home/jyzybg',
                          width: 55.w,
                          height: 55.w,
                        ),
                        10.verticalSpaceFromWidth,
                        Obx(
                          () => AppText(
                            str: '集运/转运包裹'.ts,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          18.verticalSpaceFromWidth,
          const ImgItem(
            'Home/banne',
            fit: BoxFit.fitWidth,
          ),
          18.verticalSpaceFromWidth,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: AppColors.bgGray,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.only(left: 20.w, right: 5.w),
                    child: Obx(
                      () => BaseInput(
                        board: true,
                        isCollapsed: true,
                        maxLength: 200,
                        autoRemoveController: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        controller: controller.keywordController,
                        focusNode: controller.keywordNode,
                        hintText: '粘贴商品链接或输入商品名'.ts,
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                BeeButton(
                  text: '代购',
                  borderRadis: 14,
                )
              ],
            ),
          ),
          28.verticalSpaceFromWidth,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list
                .map(
                  (e) => Flexible(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            ImgItem(
                              e['icon']!,
                              width: 50.w,
                              height: 50.w,
                            ),
                            5.verticalSpaceFromWidth,
                            Obx(
                              () => AppText(
                                str: e['label']!.ts,
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
          )
        ],
      ),
    );
  }

  Widget platformCell() {
    List<Map<String, String>> list = [
      {
        'name': '淘宝',
        'icon': 't-logo',
        'value': 'taobao',
      },
      {'name': '京东', 'icon': 'j-logo', 'value': 'jd'},
      {'name': '1688', 'icon': '1688-logo', 'value': '1688'},
      {'name': '拼多多', 'icon': 'pdd-logo', 'value': 'pinduoduo'},
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 0),
      child: Row(
        children: list
            .map(
              (e) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.onPlatform(platform: e['value']!);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ImgItem(
                          'Home/${e['icon']}',
                          width: 40.w,
                          height: 40.w,
                        ),
                        2.verticalSpaceFromWidth,
                        Obx(
                          () => AppText(
                            str: (e['name'] as String).ts,
                            fontSize: 12,
                            lines: 2,
                            alignment: TextAlign.center,
                          ),
                        )
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

  // 代购分类
  Widget categoryCell() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        margin: EdgeInsets.only(top: 20.h),
        height: controller.categoryList.length < 6 ? 70.h : 160.h,
        child: ListView.builder(
          itemCount: (controller.categoryList.length / 10).ceil(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var length = (controller.categoryList.length / 10).ceil();
            int currentLen = controller.categoryList.length - (index * 10);
            var list = controller.categoryList.sublist(index * 10,
                index * 10 + (index == length - 1 ? currentLen : 10));
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
                              ImgItem(
                                e.image ?? 'Home/shop',
                                holderImg: 'Shop/goods_cate_none',
                                width: 40.w,
                                height: 40.w,
                              ),
                              e.id == 0
                                  ? Obx(
                                      () => AppText(
                                        str: e.name.ts,
                                        fontSize: 12,
                                        lines: 2,
                                        alignment: TextAlign.center,
                                      ),
                                    )
                                  : AppText(
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
                            itemBuilder: (context, index) => BeeShopGoods(
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
