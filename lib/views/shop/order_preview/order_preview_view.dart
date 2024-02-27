import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/cart_goods_item.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/shop/order_preview/order_preview_controller.dart';

class OrderPreviewView extends GetView<OrderPreviewController> {
  const OrderPreviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '确认订单'.ts,
          fontSize: 17,
        ),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: AppColors.bgGray,
      ),
      backgroundColor: AppColors.bgGray,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCFE),
                boxShadow: [
                  BoxShadow(blurRadius: 7.r, color: const Color(0x0D000000)),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: Obx(
                      () => Checkbox.adaptive(
                        shape: const CircleBorder(),
                        activeColor: AppColors.primary,
                        value: controller.agreeProtocol.value,
                        onChanged: (value) {
                          if (value == null) return;
                          controller.agreeProtocol.value = value;
                        },
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textNormal,
                        ),
                        children: [
                          TextSpan(
                            text: '我已阅读与同意'.ts,
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () {
                                BeeNav.push(BeeNav.webview,
                                    arg: {'type': 'article', 'id': 4179});
                              },
                              child: AppText(
                                str: '《${'禁购商品声明'.ts}》',
                                fontSize: 12,
                                color: const Color(0xFF5CADF6),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () {
                                BeeNav.push(BeeNav.webview,
                                    arg: {'type': 'article', 'id': 4180});
                              },
                              child: AppText(
                                str: '《${'免责声明'.ts}》',
                                fontSize: 12,
                                color: const Color(0xFF5CADF6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(
                          () => Text.rich(
                            TextSpan(
                              style: TextStyle(
                                color: AppColors.textRed,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      controller.currencyModel.value?.symbol ??
                                          '',
                                ),
                                TextSpan(
                                  text: controller.shopOrderValue.rate(
                                      needFormat: false,
                                      showPriceSymbol: false),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppText(
                          str: '待支付总价(国际运费需另计)'.ts,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  14.horizontalSpace,
                  Container(
                    height: 35.h,
                    constraints: BoxConstraints(minWidth: 85.w),
                    child: BeeButton(
                      text: '提交',
                      fontWeight: FontWeight.bold,
                      onPressed: controller.onSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // shipModelCell(),
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
                        AppText(
                          str: '注：以上预估集运费用，会在仓库打包后支付'.ts + '。',
                          fontSize: 12,
                          color: AppColors.textRed,
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
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: AppText(
                            str: types[index].ts,
                            fontSize: 14,
                            color: controller.shipModel.value == index
                                ? AppColors.textDark
                                : AppColors.textGrayC9,
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
                      border: Border(bottom: BorderSide(color: AppColors.line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str: '收货地址'.ts,
                          fontSize: 14,
                        ),
                        AppText(
                          str: controller.address.value!.addressType == 1
                              ? '送货上门'.ts
                              : '自提点提货'.ts,
                          fontSize: 12,
                          color: AppColors.textNormal,
                        ),
                      ],
                    ),
                  )
                : AppGaps.empty),
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
                      child: Container(
                        color: Colors.transparent,
                        child: controller.address.value == null
                            ? AppText(
                                str: '请选择地址'.ts,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    str:
                                        controller.address.value!.receiverName +
                                            ' ' +
                                            controller.address.value!.timezone +
                                            '-' +
                                            controller.address.value!.phone,
                                    lines: 4,
                                  ),
                                  controller.address.value!.addressType == 2
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: AppText(
                                            str: controller.address.value!
                                                    .station?.name ??
                                                '',
                                          ),
                                        )
                                      : AppGaps.empty,
                                  2.verticalSpace,
                                  AppText(
                                    str: controller.address.value!.getContent(),
                                    lines: 10,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textNormal,
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
                  Expanded(
                    child: AppText(
                      str: '物流方案'.ts,
                      fontSize: 14,
                      lines: 3,
                    ),
                  ),
                  10.horizontalSpace,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textNormal,
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
                    AppGaps.line,
                    10.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            str: controller.lineModel.value!.name,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str:
                              controller.lineModel.value!.region!.referenceTime,
                          color: AppColors.textGrayC9,
                          fontSize: 14,
                        ),
                        AppText(
                          str: CommonMethods.getLineModelName(
                                  controller.lineModel.value!.mode)
                              .ts,
                          fontSize: 14,
                          color: AppColors.textGrayC9,
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    GestureDetector(
                      onTap: () {
                        BeeNav.push(BeeNav.lineDetail, arg: {
                          'line': controller.lineModel.value,
                          'type': 2
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(
                            str: '查看详情'.ts,
                            color: AppColors.textGrayC9,
                            fontSize: 14,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textGrayC9,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : AppGaps.empty,
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
            AppText(
              str: '增值服务'.ts,
              fontSize: 14,
            ),
            5.verticalSpace,
            AppGaps.line,
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
            //               AppText(
            //                 str: '保险服务'.ts,
            //                 fontSize: 14,
            //               ),
            //               Switch.adaptive(
            //                 activeColor: AppColors.primary,
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
            //                 color: AppColors.bgGray,
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
            //                         color: AppColors.textGrayC9,
            //                       ),
            //                       children: [
            //                       TextSpan(text: '保险费用'.ts + '：'),
            //                       TextSpan(
            //                         text: controller.insuranceFee.value
            //                             .toStringAsFixed(2),
            //                         style: const TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           color: AppColors.textRed,
            //                         ),
            //                       ),
            //                     ]))
            //               : AppText(
            //                   str: '未选择保险'.ts,
            //                   fontSize: 12,
            //                   color: AppColors.textGrayC9,
            //                 ),
            //           8.verticalSpace,
            //           AppGaps.line,
            //         ],
            //       )
            //     : AppGaps.empty,
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
            //               AppText(
            //                 str: '关税服务'.ts,
            //                 fontSize: 14,
            //               ),
            //               Switch.adaptive(
            //                 activeColor: AppColors.primary,
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
            //                         color: AppColors.textGrayC9,
            //                       ),
            //                       children: [
            //                       TextSpan(text: '关税费用'.ts + '：'),
            //                       TextSpan(
            //                         text: controller.tariffValue,
            //                         style: const TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           color: AppColors.textRed,
            //                         ),
            //                       ),
            //                     ]))
            //               : AppText(
            //                   str: '未选择关税'.ts,
            //                   fontSize: 12,
            //                   color: AppColors.textGrayC9,
            //                 ),
            //           8.verticalSpace,
            //           AppGaps.line,
            //         ],
            //       )
            //     : AppGaps.empty,
            ...controller.orderAddService.map(
              (service) => Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    AppText(
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
                              color: AppColors.textGrayC9,
                            ),
                          )
                        : AppGaps.empty,
                    Expanded(
                      child: AppText(
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
                        activeColor: AppColors.primary,
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
            //         AppText(
            //           str: service.name,
            //           fontSize: 14,
            //         ),
            //         5.horizontalSpace,
            //         Expanded(
            //           child: AppText(
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
            //             activeColor: AppColors.primary,
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
                    BeeShopOrderGoodsItem(
                      cartModel: shop,
                      previewMode: true,
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str: '国内运费'.ts,
                          fontSize: 14,
                        ),
                        AppText(
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
                                  AppText(
                                    str: '代购服务费'.ts,
                                    fontSize: 14,
                                  ),
                                  AppText(
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
                                    color: AppColors.textGrayC9,
                                    size: 16.sp,
                                  ),
                                  5.horizontalSpace,
                                  Expanded(
                                    child: AppText(
                                      str: '代购服务费'.ts +
                                          '：' +
                                          (shop.service?.remark ?? '') +
                                          ' ' +
                                          controller.getServiceStr(
                                              shop.service!.feeType!,
                                              shop.service!.fee!),
                                      fontSize: 10,
                                      color: AppColors.textGrayC9,
                                      lines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : AppGaps.empty,
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
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
                              AppGaps.line,
                              10.verticalSpace,
                              AppText(
                                str: '增值服务'.ts,
                                fontSize: 14,
                              ),
                              ...controller.parcelAddService.map(
                                (service) => Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AppText(
                                          str: service.content,
                                          fontSize: 12,
                                        ),
                                      ),
                                      AppText(
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
                                          activeColor: AppColors.primary,
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
                        : AppGaps.empty,
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
                  color: AppColors.textGrayC9,
                ),
                2.horizontalSpace,
                AppText(
                  str: '不含国际运费'.ts,
                  fontSize: 10,
                  color: AppColors.textGrayC9,
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
