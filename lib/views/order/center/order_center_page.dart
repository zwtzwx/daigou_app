import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/order/center/order_center_controller.dart';
import 'package:huanting_shop/views/order/list/order_list_view.dart';
import 'package:huanting_shop/views/parcel/parcel_list/parcel_list_page.dart';

/*
  包裹&订单
  订单中心
*/

class BeeOrderIndexPage extends GetView<BeeOrderIndexLogic> {
  const BeeOrderIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: '集运/转运包裹'.ts,
            fontSize: 17,
          ),
        ),
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
      bottomNavigationBar: Obx(
        () => controller.tabIndex.value == 1
            ? Container(
                color: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: Checkbox(
                                      shape: const CircleBorder(),
                                      activeColor: AppColors.primary,
                                      checkColor: Colors.black,
                                      value: controller.checkedIds.isNotEmpty &&
                                          controller.checkedIds.length ==
                                              controller.allParcels.length,
                                      onChanged: (value) {
                                        controller.onAllChecked();
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text('全选'.ts),
                                )
                              ],
                            ),
                            5.verticalSpaceFromWidth,
                            Obx(
                              () => AppText(
                                str: '已选{count}件'.tsArgs(
                                    {'count': controller.checkedIds.length}),
                                fontSize: 14,
                                color: AppColors.textGrayC9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Container(
                        height: 36.h,
                        constraints: BoxConstraints(minWidth: 110.w),
                        child: BeeButton(
                          text: '申请合箱',
                          onPressed: controller.onSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AppGaps.empty,
      ),
      body: PageView.builder(
          itemCount: 7,
          onPageChanged: (value) {
            controller.tabController.animateTo(value);
            controller.tabIndex.value = value;
          },
          controller: controller.pageController,
          itemBuilder: (context, index) {
            if (index < 2) {
              return ParcelListWidget(status: index + 1);
            } else {
              return TransportOrderList(status: index - 1);
            }
          }),
    );
  }

  List<Widget> tabListCell() {
    List<String> tabs = ['未入库', '已入库', '待处理', '待支付', '待发货', '已发货', '已签收'];
    return tabs
        .asMap()
        .keys
        .map(
          (index) => Obx(
            () => Column(
              children: [
                AppText(
                  str: tabs[index].ts + controller.getCountStr(index),
                  fontWeight: controller.tabIndex.value == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: controller.tabIndex.value == index
                      ? AppColors.textDark
                      : AppColors.textNormal,
                ),
                5.verticalSpaceFromWidth,
                Container(
                  width: 30.w,
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
}
