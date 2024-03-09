import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/group_order_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/group/group_order/controller.dart';

class BeeGroupOrderView extends GetView<GroupOrderController> {
  const BeeGroupOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: AppText(
          str: '我的团单'.inte,
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
                str: '未签收'.inte,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppText(
                str: '已签收'.inte,
              ),
            ),
          ],
          labelColor: AppStyles.primary,
          indicatorColor: AppStyles.primary,
          onTap: (value) {
            controller.tabController.animateTo(value);

            controller.pageController.jumpToPage(value);
          },
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.tabController.animateTo(value);
        },
        itemBuilder: (context, index) {
          return RefreshView(
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
        GlobalPages.push(GlobalPages.groupOrderPorcess, arg: {'id': model.id});
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
                ImgItem(
                  'Group/group-buy',
                  width: 25.w,
                  height: 25.w,
                ),
                5.horizontalSpace,
                AppText(
                  str: model.orderSn,
                ),
                10.horizontalSpace,
                AppText(
                  str: '${'子订单'.inte}：${model.subOrdersCount}',
                  color: AppStyles.textGray,
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
                  AppText(
                    str: model.warehouse!.warehouseName!,
                  ),
                  ImgItem(
                    'Home/ship',
                    width: 80.w,
                    fit: BoxFit.fitWidth,
                  ),
                  AppText(
                    str: model.address?.countryName ?? '',
                  ),
                ],
              ),
            ),
            AppGaps.line,
            15.verticalSpaceFromWidth,
            AppText(
              str:
                  '${model.address?.receiverName} ${model.address?.timezone} ${model.address?.phone}',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              lines: 2,
            ),
            5.verticalSpaceFromWidth,
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
                          ? '送货上门'.inte
                          : '${'自提收货'.inte}-${model.station!.name}',
                    ),
                  ],
                ),
                10.horizontalSpace,
                model.status == 1
                    ? Column(
                        children: [
                          AppText(
                            str: '打包进度'.inte,
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
                            str: '支付进度'.inte,
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
                            str: '签收进度'.inte,
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
                  str: '${'提交时间'.inte}：${model.createdAt}',
                  color: AppStyles.textGray,
                ),
              ],
            ),
            (model.status == 2 || model.status == 12) && model.mode == 1
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: BeeButton(
                      text: '团长代付',
                      onPressed: () {
                        GlobalPages.push(GlobalPages.transportPay, arg: {
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
