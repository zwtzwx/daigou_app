import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/group_order_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/group/group_order/controller.dart';

class GroupOrderPage extends GetView<GroupOrderController> {
  const GroupOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: AppText(
          str: '我的团单'.ts,
          fontSize: 17,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: controller.tabController,
          tabs: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppText(
                str: '未签收'.ts,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppText(
                str: '已签收'.ts,
              ),
            ),
          ],
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          onTap: (value) {
            controller.tabController.animateTo(value);

            controller.pageController.jumpToPage(value);
          },
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.tabController.animateTo(value);
        },
        itemBuilder: (context, index) {
          return ListRefresh(
            renderItem: groupOrderItemCell,
            refresh: controller.loadList,
            more: controller.loadMoreList,
          );
        },
      ),
    );
  }

  Widget groupOrderItemCell(int index, GroupOrderModel model) {
    return GestureDetector(
      onTap: () {
        Routers.push(Routers.groupOrderPorcess, {'id': model.id});
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LoadImage(
                  'PackageAndOrder/group-buy',
                  width: 25,
                  height: 25,
                ),
                AppGaps.hGap5,
                AppText(
                  str: model.orderSn,
                ),
                AppGaps.hGap10,
                AppText(
                  str: '${'子订单'.ts}：${model.subOrdersCount}',
                  color: AppColors.textGray,
                  fontSize: 13,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ClipOval(
                        child: Container(
                          color: const Color(0xFF9bbf4d),
                          width: 8,
                          height: 8,
                        ),
                      ),
                      AppGaps.vGap20,
                      AppText(
                        str: model.warehouse!.warehouseName!,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: Column(
                      children: [
                        const LoadImage(
                          'PackageAndOrder/fly',
                          width: 24,
                          height: 24,
                        ),
                        AppGaps.vGap4,
                        AppText(
                          str: Util.getOrderStatusName(
                              model.status!, model.stationOrder),
                          color: AppColors.primary,
                          fontSize: 14,
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ClipOval(
                        child: Container(
                          color: const Color(0xFFff4326),
                          width: 8,
                          height: 8,
                        ),
                      ),
                      AppGaps.vGap20,
                      AppText(
                        str: model.address?.countryName ?? '',
                      )
                    ],
                  ),
                ],
              ),
            ),
            AppGaps.line,
            AppGaps.vGap15,
            AppText(
              str:
                  '${model.address?.receiverName} ${model.address?.timezone} ${model.address?.phone}',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              lines: 2,
            ),
            AppGaps.vGap5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      str:
                          '${model.address?.area != null ? '${model.address?.area?.name} ' : ''}${model.address?.subArea != null ? '${model.address?.subArea!.name} ' : ''}${model.address?.street} ${model.address?.doorNo} ${model.address?.city}',
                      lines: 2,
                    ),
                    AppText(
                      str: model.station == null
                          ? '送货上门'.ts
                          : '${'自提收货'.ts}-${model.station!.name}',
                    ),
                  ],
                ),
                AppGaps.hGap10,
                model.status == 1
                    ? Column(
                        children: [
                          AppText(
                            str: '打包进度'.ts,
                          ),
                          AppText(
                            str: '${model.finished}/${model.all}',
                          ),
                        ],
                      )
                    : AppGaps.empty,
                model.status == 2 && model.mode != 1
                    ? Column(
                        children: [
                          AppText(
                            str: '支付进度'.ts,
                          ),
                          AppText(
                            str: '${model.finished}/${model.all}',
                          ),
                        ],
                      )
                    : AppGaps.empty,
                model.status == 4
                    ? Column(
                        children: [
                          AppText(
                            str: '签收进度'.ts,
                          ),
                          AppText(
                            str: '${model.finished}/${model.all}',
                          ),
                        ],
                      )
                    : AppGaps.empty,
              ],
            ),
            AppGaps.vGap5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: '${'提交时间'.ts}：${model.createdAt}',
                  color: AppColors.textGray,
                ),
              ],
            ),
            (model.status == 2 || model.status == 12) && model.mode == 1
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: MainButton(
                      text: '团长代付',
                      onPressed: () {
                        Routers.push(Routers.transportPay, {
                          'id': model.id,
                          'payModel': 1,
                          'deliveryStatus': 1,
                          'isLeader': 1
                        });
                      },
                    ),
                  )
                : AppGaps.empty,
          ],
        ),
      ),
    );
  }
}
