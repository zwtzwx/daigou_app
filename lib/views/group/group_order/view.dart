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
        title: ZHTextLine(
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
              child: ZHTextLine(
                str: '未签收'.ts,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ZHTextLine(
                str: '已签收'.ts,
              ),
            ),
          ],
          labelColor: BaseStylesConfig.primary,
          indicatorColor: BaseStylesConfig.primary,
          onTap: (value) {
            controller.tabController.animateTo(value);

            controller.pageController.jumpToPage(value);
          },
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
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
                Sized.hGap5,
                ZHTextLine(
                  str: model.orderSn,
                ),
                Sized.hGap10,
                ZHTextLine(
                  str: '${'子订单'.ts}：${model.subOrdersCount}',
                  color: BaseStylesConfig.textGray,
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
                      Sized.vGap20,
                      ZHTextLine(
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
                        Sized.vGap4,
                        ZHTextLine(
                          str: Util.getOrderStatusName(
                              model.status!, model.stationOrder),
                          color: BaseStylesConfig.primary,
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
                      Sized.vGap20,
                      ZHTextLine(
                        str: model.address?.countryName ?? '',
                      )
                    ],
                  ),
                ],
              ),
            ),
            Sized.line,
            Sized.vGap15,
            ZHTextLine(
              str:
                  '${model.address?.receiverName} ${model.address?.timezone} ${model.address?.phone}',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              lines: 2,
            ),
            Sized.vGap5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZHTextLine(
                      str:
                          '${model.address?.area != null ? '${model.address?.area?.name} ' : ''}${model.address?.subArea != null ? '${model.address?.subArea!.name} ' : ''}${model.address?.street} ${model.address?.doorNo} ${model.address?.city}',
                      lines: 2,
                    ),
                    ZHTextLine(
                      str: model.station == null
                          ? '送货上门'.ts
                          : '${'自提收货'.ts}-${model.station!.name}',
                    ),
                  ],
                ),
                Sized.hGap10,
                model.status == 1
                    ? Column(
                        children: [
                          ZHTextLine(
                            str: '打包进度'.ts,
                          ),
                          ZHTextLine(
                            str: '${model.finished}/${model.all}',
                          ),
                        ],
                      )
                    : Sized.empty,
                model.status == 2 && model.mode != 1
                    ? Column(
                        children: [
                          ZHTextLine(
                            str: '支付进度'.ts,
                          ),
                          ZHTextLine(
                            str: '${model.finished}/${model.all}',
                          ),
                        ],
                      )
                    : Sized.empty,
                model.status == 4
                    ? Column(
                        children: [
                          ZHTextLine(
                            str: '签收进度'.ts,
                          ),
                          ZHTextLine(
                            str: '${model.finished}/${model.all}',
                          ),
                        ],
                      )
                    : Sized.empty,
              ],
            ),
            Sized.vGap5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: '${'提交时间'.ts}：${model.createdAt}',
                  color: BaseStylesConfig.textGray,
                ),
              ],
            ),
            (model.status == 2 || model.status == 12) && model.mode == 1
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: MainButton(
                      text: '团长代付',
                      onPressed: () {},
                    ),
                  )
                : Sized.empty,
          ],
        ),
      ),
    );
  }
}
