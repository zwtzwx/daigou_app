import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/shop/problem_order/problem_order_controller.dart';
import 'package:shop_app_client/views/shop/widget/proble_order_list.dart';

class ProblemOrderView extends GetView<ProblemOrderController> {
  const ProblemOrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '代购问题商品'.inte,
          fontSize: 17,
        ),
        backgroundColor: AppStyles.bgGray,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        // bottom: TabBar(
        //   isScrollable: true,
        //   tabs: tabListCell(),
        //   controller: controller.tabController,
        //   indicator: const BoxDecoration(),
        //   onTap: (index) {
        //     controller.pageController.jumpToPage(index);
        //     controller.tabIndex.value = index;
        //   },
        // ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: tabListCell(),
            controller: controller.tabController,
            indicator: const BoxDecoration(),
            onTap: (index) {
              controller.pageController.jumpToPage(index);
              controller.tabIndex.value = index;
            },
          ),
          Expanded(child: PageView.builder(
            itemCount: 7,
            onPageChanged: (value) {
              controller.tabController.animateTo(value);
              controller.tabIndex.value = value;
            },
            controller: controller.pageController,
            itemBuilder: (context, index) => ProbleShopOrder(
              status: index,
            ),
          ),),
        ],
      )
    );
  }


  List<Widget> tabListCell() {
    List<String> tabs = ['全部', '退款', '补款'];
    return tabs
        .asMap()
        .keys
        .map(
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Obx(
              () => Column(
                children: [
                  AppText(
                    str: tabs[index].inte,
                    fontWeight: controller.tabIndex.value == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: controller.tabIndex.value == index
                        ? AppStyles.textDark
                        : AppStyles.textNormal,
                  ),
                  Container(
                    width: 20.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: controller.tabIndex.value == index
                          ? AppStyles.primary
                          : AppStyles.bgGray,
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
