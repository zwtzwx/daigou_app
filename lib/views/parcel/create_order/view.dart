import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/insurance_item_model.dart';
import 'package:huanting_shop/models/parcel_model.dart';
import 'package:huanting_shop/models/ship_line_service_model.dart';
import 'package:huanting_shop/models/tariff_item_model.dart';
import 'package:huanting_shop/models/value_added_service_model.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/parcel/create_order/controller.dart';

class BeePackingView extends GetView<BeePackingLogic> {
  const BeePackingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Obx(
            () => AppText(
              str: controller.pageTitle.value,
              fontSize: 17,
            ),
          ),
        ),
        backgroundColor: AppColors.bgGray,
        body: Obx(() => controller.isLoading.value
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: buildSubViews(context),
                  ),
                ))
            : AppGaps.empty));
  }

  Widget buildSubViews(BuildContext context) {
    var content = Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 20, bottom: 10, left: 15),
          child: AppText(
            str: '您本次选择{count}个包裹'
                .tsArgs({'count': controller.packageList.length}),
          ),
        ),
        Obx(() => getAllPackageList()),
        buildMiddleView(context),
        buildBottomView(context),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 0, bottom: 10, left: 30),
          child: AppText(
            fontSize: 14,
            str: '提示合并打包后无法更改哦'.ts,
            color: AppColors.textGrayC9,
          ),
        ),
        // Obx(
        //   () => controller.shipLineModel.value != null
        //       ? buildRulesView()
        //       : Container(),
        // ),
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  str: '备注'.ts,
                  fontWeight: FontWeight.bold,
                ),
                10.verticalSpaceFromWidth,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgGray,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: BaseInput(
                    controller: controller.evaluateController,
                    focusNode: null,
                    board: true,
                    maxLines: 5,
                    minLines: 4,
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                    hintText: '请输入打包备注'.ts,
                    contentPadding: EdgeInsets.all(10.w),
                  ),
                ),
              ],
            )),
        Container(
          margin:
              const EdgeInsets.only(right: 15, left: 15, top: 30, bottom: 10),
          height: 38.h,
          width: double.infinity,
          child: BeeButton(
            text: '提交',
            onPressed: controller.onSubmit,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: AppText(
            str: '在仓库打包完成之后才会需要进行支付'.ts,
            color: AppColors.textNormal,
            fontSize: 14,
          ),
        ),
        20.verticalSpaceFromWidth,
      ],
    );
    return content;
  }

  // 包裹列表
  Widget getAllPackageList() {
    List<Widget> viewList = [];
    for (var i = 0; i < controller.packageList.length; i++) {
      ParcelModel model = controller.packageList[i];
      var view = Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 1, color: Colors.white),
            ),
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        child: AppText(
                          fontSize: 14,
                          str: model.expressNum ?? '',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppText(
                        fontSize: 14,
                        str: model.country?.name ?? '',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AppText(
                        str: model.prop?.map((e) => e.name).join(' ') ?? '',
                        fontSize: 14,
                      ),
                      Row(
                        children: <Widget>[
                          AppText(
                            str: (model.packageValue ?? 0).rate(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          AppGaps.hGap10,
                          AppText(
                            str: ((model.packageWeight ?? 0) / 1000)
                                    .toStringAsFixed(2) +
                                controller.localModel!.weightSymbol,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );
      viewList.add(view);
    }
    return Column(
      children: viewList,
    );
  }

  // 地址信息
  Widget buildMiddleView(BuildContext context) {
    var midView = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      // padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          // GestureDetector(
          //   onTap: () {
          //     controller.onDeliveryType(context);
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(
          //       vertical: 10,
          //       horizontal: 15,
          //     ),
          //     color: Colors.white,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Container(
          //           alignment: Alignment.centerLeft,
          //           width: 80,
          //           child: AppText(str: '收货形式'.ts),
          //         ),
          //         Expanded(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             children: <Widget>[
          //               AppText(
          //                 str: controller.tempDelivery.value == null
          //                     ? '请选择'.ts
          //                     : controller.tempDelivery.value == 0
          //                         ? '送货上门'.ts
          //                         : '自提点收货'.ts,
          //                 color: controller.tempDelivery.value == null
          //                     ? AppColors.textGray
          //                     : AppColors.textDark,
          //               ),
          //               !controller.isGroup.value
          //                   ? const Icon(
          //                       Icons.keyboard_arrow_right,
          //                       color: AppColors.textGray,
          //                     )
          //                   : AppGaps.empty,
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // AppGaps.line,
          GestureDetector(
            onTap: controller.onAddress,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 80,
                    child: AppText(
                      str: '收货地址'.ts,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          controller.selectedAddressModel.value == null
                              ? AppText(
                                  str: '请选择'.ts,
                                  color: AppColors.textGray,
                                )
                              : Expanded(
                                  // height: 90,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        // height: 40,
                                        width: double.infinity,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          controller
                                                  .selectedAddressModel.value!.receiverName +
                                              ' ' +
                                              controller.selectedAddressModel
                                                  .value!.timezone +
                                              '-' +
                                              controller.selectedAddressModel
                                                  .value!.phone,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.textDark),
                                        ),
                                      ),
                                      controller.selectedAddressModel.value!
                                                  .addressType ==
                                              2
                                          ? Container(
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: AppText(
                                                str: controller
                                                        .selectedAddressModel
                                                        .value!
                                                        .station
                                                        ?.name ??
                                                    '',
                                                fontSize: 14,
                                              ),
                                            )
                                          : AppGaps.empty,
                                      Container(
                                        // height: 40,
                                        width: double.infinity,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          controller.selectedAddressModel.value!
                                              .getContent(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              height: 1.5,
                                              color: AppColors.textDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  !controller.isGroup.value
                      ? const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.textGray,
                        )
                      : AppGaps.empty,
                ],
              ),
            ),
          ),
          AppGaps.line,
          GestureDetector(
            onTap: controller.onLine,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 80,
                    child: AppText(str: '快递方式'.ts),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          AppText(
                            str: controller.shipLineModel.value == null
                                ? '请选择'.ts
                                : controller.shipLineModel.value!.name,
                            color: controller.shipLineModel.value == null
                                ? AppColors.textGray
                                : AppColors.textDark,
                          ),
                          !controller.isGroup.value
                              ? const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColors.textGray,
                                )
                              : AppGaps.empty,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: 80,
                  child: AppText(str: '收货形式'.ts),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      AppText(
                        str: controller.selectedAddressModel.value == null
                            ? ''
                            : controller.selectedAddressModel.value!
                                        .addressType ==
                                    1
                                ? '送货上门'.ts
                                : '自提收货'.ts,
                        color: AppColors.textDark,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    return midView;
  }

  // 增值服务
  Widget buildBottomView(BuildContext context) {
    if (controller.insuranceModel.value?.enabled == 1) {
      for (InsuranceItemModel item in controller.insuranceModel.value!.items) {
        if (item.start < controller.totalValue.value) {
          // print(item.start.toString());
          controller.firstMust.value = (item.isForce == 1);
          if (item.insuranceType == 1) {
            var tempValue = (controller.totalValue.value / 100) *
                (item.insuranceProportion / 100);
            var maxValue = (item.max ?? 0) / 100;
            controller.firstStr.value =
                (tempValue > maxValue && maxValue != 0 ? maxValue : tempValue)
                    .toStringAsFixed(2);
          } else {
            controller.firstStr.value =
                item.insuranceProportion.toStringAsFixed(2);
          }
        }
      }
    }
    if (controller.tariffModel.value?.enabled == 1) {
      for (TariffItemModel item in controller.tariffModel.value!.items) {
        if (item.amount < controller.totalValue.value) {
          controller.secondMust.value = (item.enforce == 1);
          if (item.type == 1) {
            controller.secondStr.value =
                ((controller.totalValue.value / 100) * (item.amount / 10000))
                    .toStringAsFixed(2);
          } else {
            controller.secondStr.value = item.amount.toStringAsFixed(2);
          }
        }
      }
    }

    var bottomView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1, color: AppColors.white),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: (controller.insuranceModel.value?.enabled == 1 &&
                    controller.insuranceModel.value!.enabledLineIds
                        .contains(controller.shipLineModel.value?.id))
                ? 50
                : 0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          AppText(str: '保险服务'.ts),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: IconButton(
                                icon: const Icon(
                                  Icons.error,
                                  color: Color(0xFFffae00),
                                  size: 25,
                                ),
                                onPressed: () {
                                  showRemark(
                                      context,
                                      '保险服务'.ts,
                                      controller
                                          .insuranceModel.value!.explanation);
                                }),
                          ),
                          AppGaps.hGap10,
                          AppText(
                            str: num.parse(controller.firstStr.value)
                                .rate(needFormat: false),
                            color: AppColors.textRed,
                          )
                        ],
                      ),
                      Switch.adaptive(
                        value: controller.firstMust.value
                            ? controller.firstMust.value
                            : controller.insuranceServices.value,
                        activeColor: AppColors.green,
                        onChanged: (value) {
                          controller.insuranceServices.value = value;
                        },
                      ),
                    ],
                  ),
                ),
                AppGaps.line,
              ],
            ),
          ),
          SizedBox(
            height: (controller.tariffModel.value?.enabled == 1 &&
                    controller.tariffModel.value!.enabledLineIds
                        .contains(controller.shipLineModel.value?.id))
                ? 50
                : 0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          AppText(str: '关税服务'.ts),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: IconButton(
                                icon: const Icon(
                                  Icons.error,
                                  color: Color(0xFFffae00),
                                  size: 25,
                                ),
                                onPressed: () {
                                  showRemark(
                                      context,
                                      '关税服务'.ts,
                                      controller
                                          .tariffModel.value!.explanation);
                                }),
                          ),
                          AppText(
                              str: num.parse(controller.secondStr.value)
                                  .rate(needFormat: false),
                              color: AppColors.textRed),
                        ],
                      ),
                      Switch.adaptive(
                        value: controller.secondMust.value
                            ? controller.secondMust.value
                            : controller.customsService.value,
                        activeColor: AppColors.green,
                        onChanged: (value) {
                          controller.customsService.value = value;
                        },
                      ),
                    ],
                  ),
                ),
                AppGaps.line,
              ],
            ),
          ),
          Obx(
            () => controller.shipLineModel.value != null ||
                    controller.serviceList.isNotEmpty
                ? Column(children: getServiceList(context))
                : Container(),
          ),
        ],
      ),
    );
    return bottomView;
  }

  getServiceList(BuildContext context) {
    List<Widget> viewList = [];
    if (controller.serviceList.isNotEmpty) {
      for (ValueAddedServiceModel item in controller.serviceList) {
        String first = '';
        String second = item.price!.rate();
        String third = '';
        var view = SizedBox(
          height: 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AppText(str: item.name!),
                        Container(
                          height: 49,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: first,
                                  style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 10.0,
                                  ),
                                ),
                                TextSpan(
                                  text: second,
                                  style: const TextStyle(
                                    color: AppColors.textRed,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: third,
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        item.remark.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.error_outline_outlined,
                                    color: AppColors.green,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    showRemark(
                                        context, item.name!, item.remark);
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Obx(
                      () => Switch.adaptive(
                        value: controller.orderServiceId.contains(item.id),
                        activeColor: AppColors.green,
                        onChanged: (value) {
                          print('434');
                          if (value) {
                            controller.orderServiceId.add(item.id);
                          } else {
                            controller.orderServiceId.remove(item.id);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.line,
            ],
          ),
        );
        viewList.add(view);
      }
    }
    if (controller.shipLineModel.value == null) {
      return viewList;
    }
    if (controller.shipLineModel.value?.region?.services != null) {
      for (ShipLineServiceModel item
          in controller.shipLineModel.value!.region!.services!) {
        String first = '';
        String second = '';
        String third = '';
        // 1 运费比例 2固定费用 3单箱固定费用 4单位计费重量固定费用 5单位实际重量固定费用 6申报价值比列
        switch (item.type) {
          case 1:
            first = '实际运费'.ts;
            second = (item.value / 100).toStringAsFixed(2) + '%';
            break;
          case 2:
            second = item.value.rate();
            break;
          case 3:
            second = item.value.rate() + '/${'箱'.ts}';
            break;
          case 4:
            second =
                item.value.rate() + '/' + controller.localModel!.weightSymbol;
            third = '(${'计费重'.ts})';
            break;
          case 5:
            second =
                item.value.rate() + '/' + controller.localModel!.weightSymbol;
            third = '(${'实重'.ts})';
            break;
          case 6:
            second =
                ((item.value / 10000) * (controller.totalValue.value / 100))
                    .rate(needFormat: false);
            break;
          default:
        }
        var view = SizedBox(
          height: 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AppText(str: item.name),
                        Container(
                          height: 49,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: first,
                                  style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 10.0,
                                  ),
                                ),
                                TextSpan(
                                  text: second,
                                  style: const TextStyle(
                                    color: AppColors.textRed,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: third,
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        item.remark.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.error_outline_outlined,
                                    color: AppColors.green,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    showRemark(context, item.name, item.remark);
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Obx(
                      () => Switch.adaptive(
                        value: controller.lineServiceId.contains(item.id),
                        activeColor: AppColors.green,
                        onChanged: (value) {
                          if (item.isForced == 1) return;
                          if (value) {
                            controller.lineServiceId.add(item.id);
                          } else {
                            controller.lineServiceId.remove(item.id);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.line
            ],
          ),
        );
        viewList.add(view);
      }
    }
    return viewList;
  }

  // 订单增值服务、渠道增值服务、关税、保险说明
  showRemark(BuildContext context, String title, String content) {
    BaseDialog.normalDialog(
      context,
      title: title,
      titleFontSize: 18,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          content,
        ),
      ),
    );
  }
}
