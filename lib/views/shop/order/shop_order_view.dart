import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/shop/order/shop_order_controller.dart';
import 'package:jiyun_app_client/views/shop/widget/shop_order_list.dart';

class ShopOrderView extends GetView<ShopOrderController> {
  const ShopOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '我的订单'.ts,
          fontSize: 17,
        ),
        backgroundColor: AppColors.bgGray,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        bottom: TabBar(
          isScrollable: true,
          tabs: tabListCell(),
          controller: controller.tabController,
          indicator: const BoxDecoration(),
          onTap: (index) {
            controller.pageController.jumpToPage(index);
            controller.tabIndex.value = index;
          },
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: PageView.builder(
        itemCount: 7,
        onPageChanged: (value) {
          controller.tabController.animateTo(value);
          controller.tabIndex.value = value;
        },
        controller: controller.pageController,
        itemBuilder: (context, index) => ShopOrderList(
          status: index,
        ),
      ),
    );
  }

  List<Widget> tabListCell() {
    List<String> tabs = ['全部', '待付款', '采购中', '待入库', '已入库', '交易完成', '已取消'];
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
                    str: tabs[index].ts,
                    fontWeight: controller.tabIndex.value == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: controller.tabIndex.value == index
                        ? AppColors.textDark
                        : AppColors.textNormal,
                  ),
                  Container(
                    width: 20.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: controller.tabIndex.value == index
                          ? AppColors.primary
                          : AppColors.bgGray,
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
