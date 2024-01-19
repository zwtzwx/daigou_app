import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/pay_type_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/payment/transport_pay/controller.dart';

class TransportPayPage extends GetView<TransportPayController> {
  const TransportPayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: AppText(
            str: '支付订单'.ts,
            fontSize: 17,
          ),
        ),
        backgroundColor: AppColors.bgGray,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  width: ScreenUtil().screenWidth,
                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  padding: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 150,
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 40,
                                    child: AppText(
                                      str: (controller
                                              .currencyModel.value?.symbol ??
                                          ''),
                                      fontSize: 20,
                                      color: AppColors.textRed,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 40,
                                    child: Obx(
                                      () => AppText(
                                        str: (controller.payModel.value == 0
                                                ? (controller.vipPriceModel
                                                        .value?.price ??
                                                    0)
                                                : (controller.orderModel.value
                                                        ?.discountPaymentFee ??
                                                    0))
                                            .rate(showPriceSymbol: false),
                                        fontSize: 35,
                                        color: AppColors.textRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 25,
                                    child: Obx(
                                      () => AppText(
                                        str: controller.payModel.value == 0
                                            ? controller.vipPriceModel.value
                                                        ?.basePrice ==
                                                    0
                                                ? ''
                                                : '已省'.ts +
                                                    (controller
                                                                .vipPriceModel
                                                                .value!
                                                                .basePrice -
                                                            controller
                                                                .vipPriceModel
                                                                .value!
                                                                .price)
                                                        .rate()
                                            : '已省'.ts +
                                                ((controller.orderModel.value
                                                                ?.couponDiscountFee ??
                                                            0) +
                                                        (controller.isUsePoint
                                                                .value
                                                            ? (controller
                                                                    .orderModel
                                                                    .value
                                                                    ?.pointamount ??
                                                                0)
                                                            : 0))
                                                    .rate(),
                                        fontSize: 14,
                                        color: AppColors.textRed,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Obx(
                              () => AppText(
                                str: '${'余额'.ts}：' +
                                    (controller.myBalance.value).rate(),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  BeeNav.push(BeeNav.recharge, context);
                                },
                                child: Row(
                                  children: <Widget>[
                                    AppText(
                                      str: '充值'.ts,
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Obx(
                        () => (controller.pointShow.value &&
                                controller.payModel.value == 1 &&
                                (controller.orderModel.value?.point ?? 0) > 0)
                            ? Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AppText(
                                      str: '积分'.ts,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          buildPointView(context);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Obx(
                                              () => AppText(
                                                str: controller.isUsePoint.value
                                                    ? '-${(controller.orderModel.value!.pointamount).rate()}'
                                                    : '不使用'.ts,
                                                color:
                                                    controller.isUsePoint.value
                                                        ? AppColors.textRed
                                                        : AppColors.textBlack,
                                              ),
                                            ),
                                            const Icon(
                                                Icons.keyboard_arrow_right)
                                          ],
                                        ))
                                  ],
                                ),
                              )
                            : AppGaps.empty,
                      ),
                      Obx(
                        () => controller.payModel.value == 1
                            ? Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AppText(
                                      str: '优惠券'.ts,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        var s =
                                            await BeeNav.push(BeeNav.coupon, {
                                          'select': true,
                                          'lineid': controller
                                              .orderModel.value!.expressLineId,
                                          'amount': controller.orderModel.value!
                                              .actualPaymentFee,
                                          'model': controller.selectCoupon.value
                                        });
                                        if (s == null) {
                                          return;
                                        }

                                        controller.selectCoupon.value =
                                            (s as Map)['selectCoupon'];
                                        if (controller.isGroupOrder) {
                                          controller.previewGroupOrder();
                                        } else {
                                          controller.previewOrder();
                                        }
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          controller.selectCoupon.value != null
                                              ? Row(
                                                  children: [
                                                    AppText(
                                                      str: controller
                                                          .selectCoupon
                                                          .value!
                                                          .coupon!
                                                          .name,
                                                    ),
                                                    AppText(
                                                      str: '(-' +
                                                          (controller
                                                                  .orderModel
                                                                  .value!
                                                                  .couponDiscountFee)
                                                              .rate() +
                                                          ')',
                                                      color: AppColors.textRed,
                                                    ),
                                                  ],
                                                )
                                              : AppText(
                                                  str: '不使用'.ts,
                                                ),
                                          const Icon(Icons.keyboard_arrow_right)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : AppGaps.empty,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Container(
                    height: (controller.payTypeList.length * 50).toDouble(),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                    child: showPayTypeView(),
                  ),
                ),
                Container(
                  height: 38.h,
                  margin: const EdgeInsets.only(
                    top: 50,
                    right: 15,
                    left: 15,
                    bottom: 40,
                  ),
                  width: double.infinity,
                  child: BeeButton(
                    text: '确认支付',
                    onPressed: () {
                      controller.onPay(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // 支付方式列表
  Widget showPayTypeView() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: payTypeCell,
        itemCount: controller.payTypeList.length,
      ),
    );
  }

  Widget payTypeCell(BuildContext context, int index) {
    PayTypeModel typeMap = controller.payTypeList[index];
    // bool show = false;
    // //如果是余额支付
    // if (typeMap.name == 'balance') {
    //   if (controller.payModel.value == 0) {
    //     if (controller.myBalance.value <
    //         controller.vipPriceModel.value!.price) {
    //       show = true;
    //     }
    //   } else if (controller.payModel.value == 1) {
    //     if (controller.myBalance.value <
    //         controller.orderModel.value!.discountPaymentFee) {
    //       show = true;
    //     }
    //   }
    // }
    return GestureDetector(
        onTap: () {
          // if (typeMap.name == 'balance' && show) {
          //   return;
          // }
          if (controller.selectedPayType.value == typeMap) {
            return;
          } else {
            controller.selectedPayType.value = typeMap;
          }
        },
        child: Container(
          color: AppColors.white,
          padding: const EdgeInsets.only(right: 15, left: 15),
          height: 50,
          width: 1.sw,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  height: 30.w,
                  width: 30.w,
                  child: ImgItem(controller.getPayTypeIcon(typeMap.name)),
                ),
                Expanded(
                  child: AppText(
                    str: CommonMethods.getPayTypeName(typeMap.name).ts,
                  ),
                ),
                controller.selectedPayType.value == typeMap
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.green,
                      )
                    : const Icon(Icons.radio_button_unchecked,
                        color: AppColors.textGray)
              ],
            ),
          ),
        ));
  }

  // 积分抵扣
  buildPointView(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (BuildContext context) {
          bool select = controller.isUsePoint.value;
          return StatefulBuilder(builder: (context1, setBottomSheetState) {
            return Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().screenWidth,
                          height: 40,
                          child: AppText(
                            str: '积分抵扣'.ts,
                            fontSize: 20,
                            color: AppColors.textBlack,
                          ),
                        ),
                        AppText(
                          str: '${'账户剩余积分'.ts}：' +
                              controller.orderModel.value!.userPoint.toString(),
                          fontSize: 14,
                        ),
                        AppGaps.vGap10,
                        AppGaps.line,
                      ],
                    ),
                    AppGaps.vGap16,
                    GestureDetector(
                        onTap: () {
                          if (select) {
                            return;
                          }
                          setBottomSheetState(() {
                            select = true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                AppText(
                                  str: '使用{point}积分抵扣'.tsArgs({
                                    'point': controller.orderModel.value!.point
                                  }),
                                  fontSize: 14,
                                ),
                                AppText(
                                  str:
                                      (controller.orderModel.value!.pointamount)
                                          .rate(),
                                  fontSize: 14,
                                  color: AppColors.textRed,
                                ),
                              ],
                            ),
                            select
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                : const Icon(
                                    Icons.radio_button_unchecked,
                                    color: AppColors.textGrayC,
                                  ),
                          ],
                        )),
                    AppGaps.vGap16,
                    GestureDetector(
                        onTap: () {
                          if (!select) {
                            return;
                          }
                          setBottomSheetState(() {
                            select = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                AppText(
                                  str: '不使用积分抵扣'.ts,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            !select
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                : const Icon(
                                    Icons.radio_button_unchecked,
                                    color: AppColors.textGrayC,
                                  ),
                          ],
                        )),
                    Container(
                      height: 100,
                    ),
                    SafeArea(
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: BeeButton(
                          text: '确认',
                          borderRadis: 20.0,
                          onPressed: () {
                            controller.isUsePoint.value = select;
                            if (controller.isGroupOrder) {
                              controller.previewGroupOrder();
                            } else {
                              controller.previewOrder();
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
  }
}
