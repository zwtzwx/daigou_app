import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/list_refresh_event.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/order/center/order_center_controller.dart';
import 'package:huanting_shop/views/order/list/order_list_view.dart';
import 'package:huanting_shop/views/parcel/parcel_list/parcel_list_page.dart';

/*
  包裹&订单中心
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
        title: BaseSearch(
          showScan: false,
          needCheck: false,
          hintText: '包裹号/订单号'.ts,
          onSearch: (value) {
            controller.keyword = value;
            ApplicationEvent.getInstance()
                .event
                .fire(ListRefreshEvent(type: 'refresh'));
          },
        ),
        leadingWidth: 25.w,
        leading: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: const BackButton(color: Colors.black)),
        bottom: tabListCell() as PreferredSizeWidget,
        // actions: [
        //   GestureDetector(
        //     child: Container(
        //       color: Colors.white,
        //       margin: EdgeInsets.only(right: 14.w),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           LoadAssetImage(
        //             'Transport/ico_bkdd',
        //             width: 20.w,
        //           ),
        //           2.verticalSpaceFromWidth,
        //           AppText(
        //             str: '补款订单'.ts,
        //             fontSize: 10,
        //             color: AppColors.textNormal,
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
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
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: index < 2
                  ? ParcelListWidget(status: index + 1)
                  : TransportOrderList(status: index - 1),
            );
          }),
    );
  }

  Widget tabListCell() {
    List<String> tabs = ['未入库', '已入库', '待处理', '待支付', '待发货', '已发货', '已签收'];
    return TabBar(
      isScrollable: true,
      tabs: tabs
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
                  ),
                  7.verticalSpaceFromWidth,
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
          .toList(),
      controller: controller.tabController,
      indicator: const BoxDecoration(),
      onTap: (index) {
        controller.pageController.jumpToPage(index);
        controller.tabIndex.value = index;
      },
    );
  }
}
