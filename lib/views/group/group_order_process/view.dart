import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/group/group_order_process/controller.dart';
import 'package:jiyun_app_client/views/group/widget/member_avatar_widget.dart';

import '../../../models/order_model.dart';

class GroupOrderProcessView extends GetView<GroupOrderProcessController> {
  const GroupOrderProcessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: ZHTextLine(
          str: '团单进度'.ts,
          fontSize: 17,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: Obx(
        () => ((controller.orderModel.value?.status == 2 ||
                    controller.orderModel.value?.status == 12) &&
                controller.orderModel.value?.mode == 1)
            ? Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: SafeArea(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MainButton(
                      text: controller.orderModel.value?.status == 2
                          ? '立即支付'
                          : '重新支付',
                      onPressed: () {},
                    ),
                  ],
                )),
              )
            : Sized.empty,
      ),
      body: Obx(() => controller.orderModel.value != null
          ? SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZHTextLine(
                          str: controller.orderModel.value!.orderSn,
                        ),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              color: BaseStylesConfig.textBlack,
                            ),
                            children: [
                              TextSpan(
                                text: controller
                                    .getOrderStatus(
                                        controller.orderModel.value!.status!,
                                        controller.orderModel.value!.mode!)
                                    .ts,
                              ),
                              TextSpan(
                                text: (controller.orderModel.value!.status ==
                                            1 ||
                                        (controller.orderModel.value!.status ==
                                                2 &&
                                            controller.orderModel.value!.mode ==
                                                0))
                                    ? ' ${controller.orderModel.value!.finished ?? 0}'
                                    : '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: (controller.orderModel.value!.status ==
                                            1 ||
                                        (controller.orderModel.value!.status ==
                                                2 &&
                                            controller.orderModel.value!.mode ==
                                                0))
                                    ? '/${controller.orderModel.value!.all ?? 0}'
                                    : '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Sized.vGap15,
                    Sized.line,
                    ...controller.orderModel.value!.subOrders!
                        .map((e) => orderItemCell(e))
                        .toList(),
                    Sized.vGap10,
                    controller.orderModel.value!.status == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoItemCell(
                                '全团已入库包裹数量',
                                '${controller.orderModel.value!.packagesCount!}${'个'.ts}',
                                isWeight: false,
                              ),
                              infoItemCell(
                                  '全团已入库包裹重量',
                                  (controller.orderModel.value!
                                              .packagesWeight! /
                                          1000)
                                      .toStringAsFixed(2)),
                              infoItemCell(
                                  '全团已入库包裹体积重量',
                                  (controller.orderModel.value!
                                              .packagesVolumeWeight! /
                                          1000)
                                      .toStringAsFixed(2)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoItemCell(
                                '团员数',
                                (controller.orderModel.value!.all ?? 0)
                                    .toString(),
                                isWeight: false,
                              ),
                              infoItemCell(
                                  '全团合计出库箱数',
                                  (controller.orderModel.value!.packagesCount ??
                                          0)
                                      .toString()),
                              infoItemCell(
                                  '全团计费重量',
                                  (controller.orderModel.value!
                                              .packagesWeight! /
                                          1000)
                                      .toStringAsFixed(2)),
                              Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                  children: [
                                    TextSpan(text: '合计应付'.ts + '：'),
                                    TextSpan(
                                      text: (controller.orderModel.value!
                                                  .actualPaymentFee ??
                                              0)
                                          .rate(),
                                      style: const TextStyle(
                                        color: BaseStylesConfig.textRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            )
          : Sized.empty),
    );
  }

  Widget infoItemCell(String label, String content, {bool isWeight = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: label.ts + '*：',
            style: const TextStyle(
              color: BaseStylesConfig.textGray,
            ),
          ),
          TextSpan(
            text: content +
                (isWeight ? (controller.localModel?.weightSymbol ?? '') : ''),
            style: const TextStyle(
              color: BaseStylesConfig.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }

  Widget orderItemCell(OrderModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BaseStylesConfig.line),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MemberAvatarWidget(
            member: model.user!,
            right: -30,
            leaderFirst: true,
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ZHTextLine(
                      str: model.user?.name ?? '',
                    ),
                    controller.orderModel.value!.status == 1 ||
                            (controller.orderModel.value!.status == 2 &&
                                controller.orderModel.value!.mode == 0) ||
                            controller.orderModel.value!.status == 4
                        ? getSubOrderStatusName(
                            model.status, model.groupBuyingStatus)
                        : Sized.empty,
                  ],
                ),
                Sized.vGap10,
                ...model.packages
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: ZHTextLine(
                          str: e.expressNum ?? '',
                        ),
                      ),
                    )
                    .toList(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ZHTextLine(
                    str: '拼团订单号'.ts + '：' + model.orderSn,
                    lines: 2,
                    color: BaseStylesConfig.textGray,
                  ),
                ),
                controller.orderModel.value!.status == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ZHTextLine(
                              str: '入库重量'.ts +
                                  '：' +
                                  ((model.exceptWeight ?? 0) / 1000)
                                      .toStringAsFixed(2) +
                                  (controller.localModel?.weightSymbol ?? ''),
                              lines: 2,
                              color: BaseStylesConfig.textGray,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ZHTextLine(
                              str: '入库体积重量'.ts +
                                  '：' +
                                  ((model.exceptVolumeWeight ?? 0) / 1000)
                                      .toStringAsFixed(2) +
                                  (controller.localModel?.weightSymbol ?? ''),
                              lines: 2,
                              color: BaseStylesConfig.textGray,
                            ),
                          ),
                        ],
                      )
                    : Sized.empty,
                controller.orderModel.value!.status! > 1 &&
                        model.groupBuyingStatus == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ZHTextLine(
                              str: '出库箱数'.ts +
                                  '：' +
                                  (model.boxesCount ?? 0).toString(),
                              lines: 2,
                              color: BaseStylesConfig.textGray,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ZHTextLine(
                              str: '计费重量'.ts +
                                  '：' +
                                  (model.paymentWeight / 1000)
                                      .toStringAsFixed(2) +
                                  (controller.localModel?.weightSymbol ?? ''),
                              lines: 2,
                              color: BaseStylesConfig.textGray,
                            ),
                          ),
                        ],
                      )
                    : Sized.empty,
                controller.orderModel.value!.status! > 1
                    ? Row(
                        children: [
                          ZHTextLine(
                            str: '应付'.ts + '：',
                          ),
                          ZHTextLine(
                            str: model.actualPaymentFee.rate(),
                            color: BaseStylesConfig.textRed,
                            fontWeight: FontWeight.bold,
                          ),
                          // Sized.hGap5,
                          // GestureDetector(
                          //   child: const Icon(
                          //     Icons.info_outline,
                          //     color: BaseStylesConfig.green,
                          //     size: 20,
                          //   ),
                          // ),
                        ],
                      )
                    : Sized.empty,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSubOrderStatusName(int status, [int? groupBuyingStatus]) {
    Widget widget;
    if (controller.orderModel.value!.status == 1) {
      widget = groupBuyingStatus == 1
          ? ZHTextLine(
              str: '已打包'.ts,
            )
          : ZHTextLine(
              str: '未打包'.ts,
              color: BaseStylesConfig.textRed,
            );
    } else if (controller.orderModel.value!.status == 2) {
      widget = Text.rich(TextSpan(children: [
        TextSpan(
          text: (status == 2 ? '待支付' : '已支付').ts,
          style: TextStyle(
            color: status == 2
                ? BaseStylesConfig.textRed
                : BaseStylesConfig.textGray,
          ),
        ),
        TextSpan(
          text: (status == 11 || status == 12)
              ? (status == 11 ? '待审核' : '审核拒绝').ts
              : '',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ]));
    } else {
      widget = ZHTextLine(
        str: (status == 4 ? '未签收' : '已签收').ts,
        color: status == 4 ? BaseStylesConfig.textGray : Colors.black,
      );
    }
    return widget;
  }
}
