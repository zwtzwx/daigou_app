import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/change_page_index_event.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/contact_cell.dart';
import 'package:huanting_shop/views/components/language_cell/language_cell.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/home/widget/activity_widget.dart';
import 'package:huanting_shop/views/home/widget/recommend_line_widget.dart';
import 'package:huanting_shop/views/shop/platform_center/platform_shop_center_controller.dart';

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
        leadingWidth: 140.w,
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
    List<Map<String, dynamic>> list = [
      {
        'label': '新手指引',
        'icon': 'Home/xszy',
        'route': BeeNav.help,
        'params': {'index': 3},
      },
      {
        'label': '集运转运',
        'icon': 'Home/jyzy',
      },
      {
        'label': '代购代买',
        'icon': 'Home/dgdm',
        'route': BeeNav.manualOrder,
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
                  child: GestureDetector(
                    onTap: () {
                      BeeNav.push(BeeNav.shopOrderList);
                    },
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
                ),
                10.horizontalSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      BeeNav.push(BeeNav.orderCenter);
                    },
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
          Obx(
            () => BaseSearch(
              hintText: '粘贴商品链接或输入商品名'.ts,
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
                      onTap: () {
                        if (e['route'] != null) {
                          BeeNav.push(e['route']!, e['params']);
                        } else if (e['icon'] == 'Home/jyzy') {
                          ApplicationEvent.getInstance().event.fire(
                              ChangePageIndexEvent(pageName: 'transport'));
                        } else {
                          Get.find<AppStore>().setShopPlatformType(2);
                          bool isRegistered =
                              Get.isRegistered<PlatformShopCenterController>();
                          if (isRegistered) {
                            Get.find<PlatformShopCenterController>()
                                .platformType
                                .value = 2;
                          }
                          ApplicationEvent.getInstance()
                              .event
                              .fire(ChangePageIndexEvent(pageName: 'shop'));
                        }
                      },
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
                                str: (e['label']! as String).ts,
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
}
