import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/shop/order/shop_order_controller.dart';
import 'package:huanting_shop/views/shop/widget/app_bar_bottom.dart';
import 'package:huanting_shop/views/shop/widget/proble_order_list.dart';
import 'package:huanting_shop/views/shop/widget/shop_order_list.dart';

class ShopOrderView extends GetView<ShopOrderController> {
  const ShopOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '购物订单'.ts,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        bottom: AppBarBottom(
            height:
                30.h + (myTabbar() as PreferredSizeWidget).preferredSize.height,
            child: topWidget()),
      ),
      backgroundColor: AppColors.bgGray,
      body: Obx(
        () => PageView.builder(
          itemCount: controller.orderType.value == 1 ? 7 : 3,
          onPageChanged: (value) {
            if (controller.orderType.value == 1) {
              controller.tabController.animateTo(value);
              controller.tabIndex.value = value;
            } else {
              controller.problemTabController.animateTo(value);
              controller.problemTabIndex.value = value;
            }
          },
          controller: controller.pageController,
          itemBuilder: (context, index) => Obx(
            () => controller.orderType.value == 1
                ? ShopOrderList(
                    status: index,
                  )
                : ProbleShopOrder(
                    status: index,
                  ),
          ),
        ),
      ),
    );
  }

  Widget topWidget() {
    List<String> orderTypes = ['购物订单', '异常订单'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 26.h,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: orderTypes
                  .asMap()
                  .keys
                  .map(
                    (index) => GestureDetector(
                      onTap: () {
                        if (controller.orderType.value == index + 1) return;
                        controller.orderType.value = index + 1;
                        controller.pageController.jumpToPage(0);
                        if (controller.orderType.value == 1) {
                          controller.tabIndex.value = 0;
                        } else {
                          controller.problemTabIndex.value = 0;
                        }
                      },
                      child: AppText(
                        str: orderTypes[index].ts,
                        fontSize:
                            controller.orderType.value == index + 1 ? 18 : 16,
                        color: controller.orderType.value == index + 1
                            ? AppColors.textDark
                            : AppColors.textNormal,
                        fontWeight: controller.orderType.value == index + 1
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        10.verticalSpaceFromWidth,
        Obx(() => myTabbar()),
      ],
    );
  }

  Widget myTabbar() {
    return TabBar(
      isScrollable: controller.orderType.value == 1,
      tabs: controller.orderType.value == 1
          ? tabListCell()
          : problemTabListCell(),
      controller: controller.orderType.value == 1
          ? controller.tabController
          : controller.problemTabController,
      indicator: const BoxDecoration(),
      onTap: (index) {
        controller.pageController.jumpToPage(index);
        if (controller.orderType.value == 1) {
          controller.tabIndex.value = index;
        } else {
          controller.problemTabIndex.value = index;
        }
      },
    );
  }

  List<Widget> tabListCell() {
    List<String> tabs = ['全部', '待付款', '采购中', '待入库', '已入库', '交易完成', '已取消'];
    return tabs
        .asMap()
        .keys
        .map(
          (index) => Obx(
            () => Column(
              children: [
                AppText(
                  str: tabs[index].ts,
                  fontWeight: controller.tabIndex.value == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: controller.tabIndex.value == index
                      ? AppColors.textDark
                      : AppColors.textNormal,
                  fontSize: controller.tabIndex.value == index ? 16 : 14,
                ),
                3.verticalSpaceFromWidth,
                Container(
                  width: 24.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: controller.tabIndex.value == index
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Widget> problemTabListCell() {
    List<String> tabs = ['全部', '退款', '补款'];
    return tabs
        .asMap()
        .keys
        .map(
          (index) => Obx(
            () => Column(
              children: [
                AppText(
                  str: tabs[index].ts,
                  fontWeight: controller.problemTabIndex.value == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: controller.problemTabIndex.value == index
                      ? AppColors.textDark
                      : AppColors.textNormal,
                  fontSize: controller.problemTabIndex.value == index ? 16 : 14,
                ),
                3.verticalSpaceFromWidth,
                Container(
                  width: 24.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: controller.problemTabIndex.value == index
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
