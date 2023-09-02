import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/cart_goods_item.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/shop/order_preview/order_preview_controller.dart';

class OrderPreviewView extends GetView<OrderPreviewController> {
  const OrderPreviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ZHTextLine(
          str: '订单确认'.ts,
          fontSize: 17,
        ),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: BaseStylesConfig.bgGray,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 5.r, color: const Color(0x0D000000)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: BaseStylesConfig.textDark,
                        fontSize: 12.sp,
                      ),
                      children: [
                        TextSpan(text: '总计'.ts + '：'),
                        TextSpan(
                          text: controller.currencyModel.value?.symbol ?? '',
                          style: const TextStyle(
                            color: BaseStylesConfig.textRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: controller.shopOrderValue
                              .rate(needFormat: false, showPriceSymbol: false),
                          style: const TextStyle(
                            fontSize: 16,
                            color: BaseStylesConfig.textRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              MainButton(
                text: '提交',
                borderRadis: 999,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                onPressed: controller.onSubmit,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shipModelCell(),
              addressCell(),
              Obx(() => Offstage(
                    offstage: controller.shipModel.value == 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shipLineCell(),
                        Offstage(
                          offstage: !controller.orderAddService.isNotEmpty,
                          // offstage: !((controller.insurance.value?.enabled ==
                          //             1 &&
                          //         (controller.insurance.value?.enabledLineIds ??
                          //                 [])
                          //             .contains(
                          //                 controller.lineModel.value?.id)) ||
                          //     controller.orderAddService.isNotEmpty ||
                          //     (controller.tariff.value?.enabled == 1 &&
                          //         (controller.tariff.value?.enabledLineIds ??
                          //                 [])
                          //             .contains(
                          //                 controller.lineModel.value?.id)) ||
                          //     (controller.lineModel.value?.region?.services ??
                          //             [])
                          //         .isNotEmpty),
                          child: serviceCell(context),
                        ),
                        ZHTextLine(
                          str: '注：以上预估集运费用，会在仓库打包后支付'.ts + '。',
                          fontSize: 12,
                          color: BaseStylesConfig.textRed,
                          lines: 2,
                        ),
                        15.verticalSpace,
                      ],
                    ),
                  )),
              shopCell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget shipModelCell() {
    List<String> types = ['集齐', '即发'];
    return Container(
      height: 28.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      child: UnconstrainedBox(
        child: Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: types
                .asMap()
                .keys
                .map((index) => GestureDetector(
                      onTap: () {
                        if (index == controller.shipModel.value) return;
                        controller.shipModel.value = index;
                      },
                      child: Obx(
                        () => Container(
                          height: 28.h,
                          padding: EdgeInsets.symmetric(horizontal: 35.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: controller.shipModel.value == index
                                ? BaseStylesConfig.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: ZHTextLine(
                            str: types[index].ts,
                            fontSize: 14,
                            color: controller.shipModel.value == index
                                ? BaseStylesConfig.textDark
                                : BaseStylesConfig.textGrayC9,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget addressCell() {
    return baseBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.address.value != null
                ? Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.only(bottom: 10.w),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: BaseStylesConfig.line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZHTextLine(
                          str: '收货地址'.ts,
                          fontSize: 14,
                        ),
                        ZHTextLine(
                          str: controller.address.value!.addressType == 1
                              ? '送货上门'.ts
                              : '自提点提货'.ts,
                          fontSize: 12,
                          color: BaseStylesConfig.textNormal,
                        ),
                      ],
                    ),
                  )
                : Sized.empty),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF9D9D9D),
                  size: 26,
                ),
                10.horizontalSpace,
                Obx(
                  () => Expanded(
                    child: GestureDetector(
                      onTap: controller.onAddress,
                      child: controller.address.value == null
                          ? ZHTextLine(
                              str: '请选择地址'.ts,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ZHTextLine(
                                  str: controller.address.value!.receiverName +
                                      ' ' +
                                      controller.address.value!.timezone +
                                      '-' +
                                      controller.address.value!.phone,
                                  lines: 4,
                                ),
                                ZHTextLine(
                                  str: controller.address.value!.getContent(),
                                  lines: 10,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: BaseStylesConfig.textNormal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 线路
  Widget shipLineCell() {
    return baseBox(
        child: Container(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.onLine,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ZHTextLine(
                    str: '物流方案'.ts,
                    fontSize: 14,
                  ),
                  10.horizontalSpace,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: BaseStylesConfig.textNormal,
                  ),
                ],
              ),
            ),
          ),
          controller.lineModel.value != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.verticalSpace,
                    Sized.line,
                    10.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: ZHTextLine(
                            str: controller.lineModel.value!.name,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.horizontalSpace,
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: BaseStylesConfig.textRed,
                              fontSize: 12.sp,
                            ),
                            children: [
                              TextSpan(
                                  text:
                                      (controller.localModel?.currencySymbol ??
                                          '')),
                              TextSpan(
                                text: ((controller.lineModel.value!.expireFee ??
                                            0) /
                                        100)
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZHTextLine(
                          str:
                              controller.lineModel.value!.region!.referenceTime,
                          color: BaseStylesConfig.textGrayC9,
                          fontSize: 14,
                        ),
                        ZHTextLine(
                          str: '预估运费'.ts,
                          fontSize: 14,
                          color: BaseStylesConfig.textNormal,
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: BaseStylesConfig.textDark,
                            ),
                            children: [
                              TextSpan(text: '计费重'.ts + '：'),
                              TextSpan(
                                text:
                                    ((controller.lineModel.value!.countWeight ??
                                                0) /
                                            1000)
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: controller.localModel?.weightSymbol ??
                                      ''),
                            ],
                          ),
                        ),
                        ZHTextLine(
                          str: Util.getLineModelName(
                                  controller.lineModel.value!.mode)
                              .ts,
                          fontSize: 14,
                          color: BaseStylesConfig.textGrayC9,
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    GestureDetector(
                      onTap: () {
                        Routers.push(Routers.lineDetail,
                            {'line': controller.lineModel.value});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ZHTextLine(
                            str: '查看详情'.ts,
                            color: BaseStylesConfig.textGrayC9,
                            fontSize: 14,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: BaseStylesConfig.textGrayC9,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Sized.empty,
        ],
      ),
    ));
  }

  // 增值服务
  Widget serviceCell(BuildContext context) {
    return baseBox(
      child: Container(
        padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ZHTextLine(
              str: '增值服务'.ts,
              fontSize: 14,
            ),
            5.verticalSpace,
            Sized.line,
            // (controller.insurance.value?.enabled == 1 &&
            //         (controller.insurance.value?.enabledLineIds ?? [])
            //             .contains(controller.lineModel.value?.id))
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           12.verticalSpace,
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               ZHTextLine(
            //                 str: '保险服务'.ts,
            //                 fontSize: 14,
            //               ),
            //               Switch.adaptive(
            //                 activeColor: BaseStylesConfig.primary,
            //                 value: controller.insuranceChecked.value,
            //                 onChanged: (value) {
            //                   controller.insuranceChecked.value = value;
            //                 },
            //               ),
            //             ],
            //           ),
            //           Offstage(
            //             offstage: !controller.insuranceChecked.value,
            //             child: Container(
            //               margin: EdgeInsets.only(bottom: 8.h),
            //               clipBehavior: Clip.none,
            //               padding: EdgeInsets.symmetric(horizontal: 10.w),
            //               decoration: BoxDecoration(
            //                 color: BaseStylesConfig.bgGray,
            //                 borderRadius: BorderRadius.circular(999),
            //               ),
            //               child: BaseInput(
            //                 board: true,
            //                 isCollapsed: true,
            //                 contentPadding: EdgeInsets.symmetric(vertical: 6.h),
            //                 controller: controller.insuranceController,
            //                 focusNode: controller.insuranceNode,
            //                 autoShowRemove: false,
            //                 autoRemoveController: false,
            //                 hintText: '请输入保价金额'.ts,
            //                 textInputAction: TextInputAction.done,
            //                 keyboardType: const TextInputType.numberWithOptions(
            //                     decimal: true),
            //               ),
            //             ),
            //           ),
            //           controller.insuranceChecked.value
            //               ? RichText(
            //                   text: TextSpan(
            //                       style: TextStyle(
            //                         fontSize: 12.sp,
            //                         color: BaseStylesConfig.textGrayC9,
            //                       ),
            //                       children: [
            //                       TextSpan(text: '保险费用'.ts + '：'),
            //                       TextSpan(
            //                         text: controller.insuranceFee.value
            //                             .toStringAsFixed(2),
            //                         style: const TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           color: BaseStylesConfig.textRed,
            //                         ),
            //                       ),
            //                     ]))
            //               : ZHTextLine(
            //                   str: '未选择保险'.ts,
            //                   fontSize: 12,
            //                   color: BaseStylesConfig.textGrayC9,
            //                 ),
            //           8.verticalSpace,
            //           Sized.line,
            //         ],
            //       )
            //     : Sized.empty,
            // (controller.tariff.value?.enabled == 1 &&
            //         (controller.tariff.value?.enabledLineIds ?? [])
            //             .contains(controller.lineModel.value?.id))
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           12.verticalSpace,
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               ZHTextLine(
            //                 str: '关税服务'.ts,
            //                 fontSize: 14,
            //               ),
            //               Switch.adaptive(
            //                 activeColor: BaseStylesConfig.primary,
            //                 value: controller.tariffChecked.value,
            //                 onChanged: (value) {
            //                   controller.tariffChecked.value = value;
            //                 },
            //               ),
            //             ],
            //           ),
            //           controller.tariffChecked.value
            //               ? RichText(
            //                   text: TextSpan(
            //                       style: TextStyle(
            //                         fontSize: 12.sp,
            //                         color: BaseStylesConfig.textGrayC9,
            //                       ),
            //                       children: [
            //                       TextSpan(text: '关税费用'.ts + '：'),
            //                       TextSpan(
            //                         text: controller.tariffValue,
            //                         style: const TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           color: BaseStylesConfig.textRed,
            //                         ),
            //                       ),
            //                     ]))
            //               : ZHTextLine(
            //                   str: '未选择关税'.ts,
            //                   fontSize: 12,
            //                   color: BaseStylesConfig.textGrayC9,
            //                 ),
            //           8.verticalSpace,
            //           Sized.line,
            //         ],
            //       )
            //     : Sized.empty,
            ...controller.orderAddService.map(
              (service) => Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    ZHTextLine(
                      str: service.name ?? '',
                      fontSize: 14,
                    ),
                    5.horizontalSpace,
                    service.remark.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              BaseDialog.normalDialog(context,
                                  title: service.name,
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 10.h),
                                      child: Text(service.remark)));
                            },
                            child: Icon(
                              Icons.info_outline,
                              size: 18.sp,
                              color: BaseStylesConfig.textGrayC9,
                            ),
                          )
                        : Sized.empty,
                    Expanded(
                      child: ZHTextLine(
                        str: (service.price ?? 0).rate(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        alignment: TextAlign.right,
                      ),
                    ),
                    10.horizontalSpace,
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Checkbox(
                        value: controller.orderServiceIds.contains(service.id),
                        shape: const CircleBorder(),
                        activeColor: BaseStylesConfig.primary,
                        checkColor: Colors.black,
                        onChanged: (value) {
                          if (value!) {
                            controller.orderServiceIds.add(service.id);
                          } else {
                            controller.orderServiceIds.remove(service.id);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ...(controller.lineModel.value?.region?.services ?? []).map(
            //   (service) => Padding(
            //     padding: EdgeInsets.only(top: 10.h),
            //     child: Row(
            //       children: [
            //         ZHTextLine(
            //           str: service.name,
            //           fontSize: 14,
            //         ),
            //         5.horizontalSpace,
            //         Expanded(
            //           child: ZHTextLine(
            //             str: controller.getLineServiceValue(
            //                 service.type, service.value),
            //             fontSize: 14,
            //             fontWeight: FontWeight.bold,
            //             alignment: TextAlign.right,
            //           ),
            //         ),
            //         10.horizontalSpace,
            //         SizedBox(
            //           width: 24.w,
            //           height: 24.w,
            //           child: Checkbox(
            //             value: controller.lineServiceIds.contains(service.id),
            //             shape: const CircleBorder(),
            //             activeColor: BaseStylesConfig.primary,
            //             checkColor: Colors.black,
            //             onChanged: (value) {
            //               if (service.isForced == 1) return;
            //               if (value!) {
            //                 controller.lineServiceIds.add(service.id);
            //               } else {
            //                 controller.lineServiceIds.remove(service.id);
            //               }
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget shopCell() {
    return Obx(
      () => Column(
        children: [
          ...controller.goodsList.map(
            (shop) => baseBox(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  children: [
                    CartGoodsItem(
                      cartModel: shop,
                      previewMode: true,
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZHTextLine(
                          str: '国内运费'.ts,
                          fontSize: 14,
                        ),
                        ZHTextLine(
                          str: (shop.freightFee ?? 0).rate(needFormat: false),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    shop.service != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ZHTextLine(
                                    str: '代购服务费'.ts,
                                    fontSize: 14,
                                  ),
                                  ZHTextLine(
                                    str: (shop.service?.serviceFee ?? 0)
                                        .rate(needFormat: false),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              5.verticalSpace,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: BaseStylesConfig.textGrayC9,
                                    size: 16.sp,
                                  ),
                                  5.horizontalSpace,
                                  Expanded(
                                    child: ZHTextLine(
                                      str: '代购服务费'.ts +
                                          '：' +
                                          (shop.service?.remark ?? '') +
                                          ' ' +
                                          controller.getServiceStr(
                                              shop.service!.feeType!,
                                              shop.service!.fee!),
                                      fontSize: 10,
                                      color: BaseStylesConfig.textGrayC9,
                                      lines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Sized.empty,
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZHTextLine(
                          str: '订单备注'.ts,
                          fontSize: 14,
                        ),
                        5.horizontalSpace,
                        Expanded(
                          child: BaseInput(
                            controller: shop.remarkController!,
                            focusNode: shop.remarkNode,
                            hintText: '选填'.ts,
                            autoShowRemove: false,
                            autoRemoveController: false,
                            maxLength: 300,
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    controller.parcelAddService.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Sized.line,
                              10.verticalSpace,
                              ZHTextLine(
                                str: '增值服务'.ts,
                                fontSize: 14,
                              ),
                              ...controller.parcelAddService.map(
                                (service) => Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ZHTextLine(
                                          str: service.content,
                                          fontSize: 12,
                                        ),
                                      ),
                                      ZHTextLine(
                                        str: (service.charge ?? 0).rate(),
                                        fontSize: 14,
                                      ),
                                      10.horizontalSpace,
                                      SizedBox(
                                        width: 24.w,
                                        height: 24.w,
                                        child: Checkbox(
                                          value: shop.addServiceIds!
                                              .contains(service.id),
                                          shape: const CircleBorder(),
                                          activeColor: BaseStylesConfig.primary,
                                          checkColor: Colors.black,
                                          onChanged: (value) {
                                            controller.onParcelServiceChecked(
                                                shop, service.id);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : Sized.empty,
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: BaseStylesConfig.textGrayC9,
                ),
                2.horizontalSpace,
                ZHTextLine(
                  str: '不含国际运费'.ts,
                  fontSize: 10,
                  color: BaseStylesConfig.textGrayC9,
                ),
              ],
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget baseBox({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      margin: EdgeInsets.only(bottom: 10.h),
      child: child,
    );
  }
}
