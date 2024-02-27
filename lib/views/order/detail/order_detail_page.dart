/*
  订单详细
 */
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/common/fade_route.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/parcel_box_model.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/button/plain_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/order/detail/order_detail_controller.dart';

class BeeOrderPage extends GetView<BeeOrderLogic> {
  const BeeOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: AppText(
            str: '订单详情'.ts,
            fontSize: 17,
            color: Colors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: AppColors.bgGray,
        bottomNavigationBar: Obx(() => bottomButton(context)),
        body: SingleChildScrollView(
          child: Obx(
            () => controller.isLoading.value
                ? Column(
                    children: [
                      firstView(),
                      10.verticalSpaceFromWidth,
                      addressView(),
                      10.verticalSpaceFromWidth,
                      controller.model.value!.remark.isNotEmpty
                          ? remarkView()
                          : AppGaps.empty,
                      baseInfoView(),
                      10.verticalSpaceFromWidth,
                      valueInfoView(context),
                      20.verticalSpaceFromWidth,
                      controller.model.value!.status > 2
                          ? payInfoView()
                          : AppGaps.empty,
                    ],
                    // children: returnSubView(),
                  )
                : AppGaps.empty,
          ),
        ));
  }

  // 地址信息
  Widget addressView() {
    var address = controller.model.value!.address;
    String reciverStr =
        '${address.receiverName} ${address.timezone}${address.phone}';
    String addressStr = (address.address != null && address.address!.isNotEmpty)
        ? address.address!
        : ((address.area?.name ?? '') +
            (address.subArea != null ? ' ${address.subArea!.name}' : '') +
            (address.street.isNotEmpty ? ' ${address.street}' : '') +
            (address.doorNo.isNotEmpty ? ' ${address.doorNo}' : '') +
            (address.postcode.isNotEmpty ? ' ${address.postcode}' : '') +
            (address.city.isNotEmpty ? ' ${address.city}' : ''));
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: UnconstrainedBox(
              child: Container(
                height: 26.h,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: AppColors.primary,
                child: AppText(
                  str: address.countryName,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          12.verticalSpaceFromWidth,
          AppGaps.line,
          12.verticalSpaceFromWidth,
          AppText(
            str: '收货地址'.ts,
            fontSize: 13,
            color: AppColors.textGray,
          ),
          AppGaps.vGap5,
          AppText(
            str: reciverStr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          AppGaps.vGap5,
          AppText(
            str: addressStr,
            lines: 4,
          ),
          5.verticalSpaceFromWidth,
          AppText(
            str: controller.model.value!.station != null
                ? '${'自提收货'.ts}-${controller.model.value!.station!.name}'
                : '送货上门'.ts,
          ),
        ],
      ),
    );
  }

  // 客服备注
  Widget remarkView() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '客服备注'.ts,
            color: AppColors.textGray,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: AppText(
              str: controller.model.value!.remark,
              lines: 10,
            ),
          ),
        ],
      ),
    );
  }

  // 基础订单信息
  Widget baseInfoView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          baseInfoItem('提交时间', text: controller.model.value!.createdAt),
          baseInfoItem('快递类型', text: controller.model.value!.expressName),
          controller.model.value!.status > 2
              ? baseInfoItem('物流单号', text: controller.model.value!.logisticsSn)
              : AppGaps.empty,
          controller.model.value!.status > 1 ? packInfoView() : AppGaps.empty,
        ],
      ),
    );
  }

  // 打包信息
  Widget packInfoView() {
    String actualWeight =
        (controller.model.value!.actualWeight / 1000).toStringAsFixed(2) +
            controller.localModel!.weightSymbol;
    String paymentWeight =
        (controller.model.value!.paymentWeight / 1000).toStringAsFixed(2) +
            controller.localModel!.weightSymbol;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        controller.model.value!.boxes.isNotEmpty
            ? SizedBox(
                height: controller.model.value!.boxes.length * 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.model.value!.boxes.length,
                  itemBuilder: boxItem,
                ))
            : AppGaps.empty,
        baseInfoItem('称重重量', text: actualWeight),
        baseInfoItem('计费重量', text: paymentWeight),
        baseInfoItem('留仓物品', text: controller.model.value!.inWarehouseItem),
        // controller.packVideoManager.isNotEmpty
        //     ? Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           AppText(
        //             str: '打包视频'.ts,
        //             color: AppColors.textGray,
        //           ),
        //           AppGaps.vGap10,
        //           ...controller.packVideoManager.map((e) {
        //             return Padding(
        //               padding: const EdgeInsets.only(bottom: 10),
        //               child: FlickVideoPlayer(
        //                 flickManager: e,
        //               ),
        //             );
        //           }).toList(),
        //         ],
        //       )
        //     : AppGaps.empty,
        AppGaps.line,
        AppGaps.vGap10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  AppText(
                    str: '打包照片'.ts,
                    color: AppColors.textGray,
                  ),
                  AppGaps.vGap10,
                  controller.model.value!.packPictures.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.5,
                          ),
                          itemCount:
                              controller.model.value!.packPictures.length,
                          itemBuilder: (context, index) {
                            return _buildImageItem(
                                context,
                                controller.model.value!.packPictures[index],
                                index);
                          })
                      : AppGaps.empty,
                ],
              ),
            ),
            AppGaps.hGap15,
            Expanded(
              child: Column(
                children: [
                  AppText(
                    str: '物品照片'.ts,
                    color: AppColors.textGray,
                  ),
                  AppGaps.vGap10,
                  controller.model.value!.inWarehousePictures.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.5,
                          ),
                          itemCount:
                              controller.model.value!.packPictures.length,
                          itemBuilder: (context, index) {
                            return _buildImageItem(
                                context,
                                controller
                                    .model.value!.inWarehousePictures[index],
                                index);
                          })
                      : AppGaps.empty,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 多箱称重
  Widget boxItem(context, int index) {
    ParcelBoxModel boxModel = controller.model.value!.boxes[index];
    String volumnSum = ((boxModel.length ?? 0) / 100).toString() +
        '*' +
        ((boxModel.width ?? 0) / 100).toString() +
        '*' +
        ((boxModel.height ?? 0) / 100).toString() +
        '/' +
        (controller.model.value!.factor ?? 0).toString() +
        '=' +
        ((boxModel.volumeWeight ?? 0) / 1000).toStringAsFixed(2) +
        controller.localModel!.weightSymbol;
    return baseInfoItem(
      '${'包裹'.ts} ${index + 1}',
      labelColor: Colors.black,
      leftFlex: 0,
      // bottom: index == model!.boxes.length - 1 ? 0 : 15,
      content: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: AppText(
                    str: '实重'.ts,
                  ),
                ),
                AppText(
                  str: ((boxModel.weight ?? 0) / 1000).toStringAsFixed(2) +
                      controller.localModel!.weightSymbol,
                ),
              ],
            ),
            AppGaps.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: AppText(
                    str: '体积重'.ts,
                  ),
                ),
                AppText(
                  str: volumnSum,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 订单价格
  Widget valueInfoView(BuildContext context) {
    // 订单增值服务列表
    num valueAddAmount =
        num.parse(controller.model.value!.valueAddedAmount ?? '0');
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          controller.model.value!.status != 1
              ? baseInfoItem(
                  '合计运费',
                  content: Row(
                    children: [
                      controller.model.value!.price != null &&
                              num.parse(controller
                                      .model.value!.price!.discount) !=
                                  1
                          ? AppText(
                              str: controller.getPriceStr(
                                  controller.model.value!.price!.originPrice),
                              color: AppColors.textGray,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                            )
                          : AppGaps.empty,
                      AppGaps.hGap10,
                      AppText(
                        str: controller
                            .getPriceStr(controller.model.value!.allFreightFee),
                      ),
                    ],
                  ),
                )
              : AppGaps.empty,
          controller.model.value!.status != 1
              ? baseInfoItem('帮您运费节省',
                  text: controller
                      .getPriceStr(controller.model.value!.thriftFreightFee))
              : AppGaps.empty,
          controller.model.value!.insuranceFee > 0
              ? baseInfoItem('保险费',
                  text:
                      '+${controller.getPriceStr(controller.model.value!.insuranceFee)}')
              : AppGaps.empty,
          controller.model.value!.tariffFee > 0
              ? baseInfoItem('关税',
                  text:
                      '+${controller.getPriceStr(controller.model.value!.tariffFee)}')
              : AppGaps.empty,
          baseInfoItem(
            '订单增值服务',
            crossAxisAlignment: CrossAxisAlignment.start,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  str: controller.model.value!.valueAddedService.isNotEmpty
                      ? '+${controller.getPriceStr(valueAddAmount)}'
                      : '无'.ts,
                ),
                ...controller.model.value!.valueAddedService.map((e) {
                  return AppText(
                    str: e.name! + '(${controller.getPriceStr(e.price)})',
                  );
                }).toList(),
              ],
            ),
          ),
          controller.model.value!.lineRuleFee > 0
              ? baseInfoItem('渠道规则费',
                  text:
                      '+${controller.getPriceStr(controller.model.value!.lineRuleFee)}')
              : AppGaps.empty,
          controller.model.value!.lineServices.isNotEmpty
              ? baseInfoItem(
                  '渠道增值服务',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      controller.model.value!.status != 1
                          ? AppText(
                              str:
                                  '+${controller.getPriceStr(controller.model.value!.lineServiceFee)}',
                            )
                          : AppGaps.empty,
                      ...controller.model.value!.lineServices.map((e) {
                        return Row(
                          children: [
                            e.remark.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      BaseDialog.normalDialog(
                                        context,
                                        title: e.name,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 20),
                                          child: Text(e.remark),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: AppColors.green,
                                      size: 18,
                                    ),
                                  )
                                : AppGaps.empty,
                            AppGaps.hGap10,
                            AppText(
                              str: e.name +
                                  (controller.model.value!.status != 1
                                      ? '(${controller.getPriceStr(e.price)})'
                                      : ''),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                )
              : AppGaps.empty,
          controller.model.value!.status > 2 &&
                  controller.model.value!.couponDiscountFee > 0
              ? baseInfoItem(
                  '优惠券',
                  text: '-' +
                      controller.getPriceStr(
                          controller.model.value!.couponDiscountFee),
                )
              : AppGaps.empty,
          (controller.model.value!.status > 2 &&
                  controller.model.value!.transaction.isNotEmpty &&
                  controller.model.value!.transaction[0].isUsePoint == 1)
              ? baseInfoItem(
                  '积分',
                  text: '-' +
                      controller.getPriceStr(
                          controller.model.value!.transaction[0].pointAmount),
                )
              : AppGaps.empty,
          controller.model.value!.status != 1
              ? baseInfoItem(
                  '订单总价',
                  text: controller
                      .getPriceStr(controller.model.value!.actualPaymentFee),
                )
              : AppGaps.empty,
        ],
      ),
    );
  }

  // 支付信息
  Widget payInfoView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          baseInfoItem('实际支付',
              text: controller
                      .getPriceStr(controller.model.value!.discountPaymentFee) +
                  ((controller.model.value!.transaction.isNotEmpty &&
                          (controller.model.value!.transaction[0].showTrans ??
                              false))
                      ? '/${controller.model.value!.transaction[0].currency}${controller.model.value!.transaction[0].currencySymbol}' +
                          controller.getPriceStr(
                              controller.model.value!.discountPaymentFee *
                                  num.parse(controller
                                      .model.value!.transaction[0].transRate))
                      : ''),
              redText: true),
          baseInfoItem(
            '支付方式',
            text: controller.model.value!.transaction.isNotEmpty
                ? controller.model.value!.transaction[0].payName
                : '',
          ),
          baseInfoItem(
            '支付状态',
            text: controller.model.value!.transaction.isNotEmpty
                ? (controller.model.value!.transaction[0].type == 1
                    ? '支付成功'.ts
                    : (controller.model.value!.transaction[0].type == 2
                        ? '退款成功'.ts
                        : ''))
                : '',
          ),
          baseInfoItem(
            '支付单号',
            text: controller.model.value!.transaction.isNotEmpty
                ? controller.model.value!.transaction[0].serialNo
                : '',
          ),
          baseInfoItem(
            '支付时间',
            text: controller.model.value!.transaction.isNotEmpty
                ? controller.model.value!.transaction[0].createdAt
                : '',
          ),
          controller.model.value!.status == 5
              ? baseInfoItem(
                  '签收时间',
                  text: controller.model.value!.updatedAt,
                )
              : AppGaps.empty,
        ],
      ),
    );
  }

  Widget baseInfoItem(
    String label, {
    double? bottom,
    String? text,
    Widget? content,
    Color? labelColor,
    int? leftFlex,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool redText = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Flexible(
            flex: leftFlex ?? 1,
            child: AppText(
              str: label.ts,
              color: labelColor ?? AppColors.textGray,
              lines: 2,
            ),
          ),
          content ??
              AppText(
                str: text ?? '无'.ts,
                color: redText ? AppColors.textRed : AppColors.textBlack,
              ),
        ],
      ),
    );
  }

  // 底部按钮
  bottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.line),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: SizedBox(
                height: 30.h,
                child: HollowButton(
                  text: '联系客服',
                  onPressed: () async {
                    CommonMethods.onCustomerContact();
                  },
                  textColor: AppColors.textDark,
                  borderColor: AppColors.textGrayC,
                ),
              ),
            ),
            if ([2, 12].contains(controller.model.value?.status) ||
                controller.model.value?.paymentStatus == 1)
              Container(
                margin: EdgeInsets.only(left: 10.w),
                height: 30.h,
                child: BeeButton(
                  text: controller.model.value?.status == 12 ? '重新支付' : '去付款',
                  onPressed: () async {
                    var s = await BeeNav.push(BeeNav.transportPay, arg: {
                      'id': controller.model.value?.id,
                      'payModel': 1,
                      'deliveryStatus':
                          controller.model.value?.onDeliveryStatus,
                    });
                    if (s != null) {
                      controller.onRefresh();
                    }
                  },
                ),
              ),
            if (controller.model.value?.status == 4)
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
                  height: 30.h,
                  child: BeeButton(
                    text: '确认收货',
                    onPressed: () async {
                      var data = await BaseDialog.confirmDialog(
                          context, '请确认您已收到货'.ts);
                      if (data != null) {
                        controller.onSign();
                      }
                    },
                  ),
                ),
              ),
            if (controller.model.value?.status == 5 &&
                controller.model.value?.evaluated == 0)
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
                  height: 30.h,
                  child: BeeButton(
                    text: '我要评价',
                    onPressed: controller.onComment,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(context, Map<String, dynamic> picMap, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: controller.model.value!.packPictures, //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
          // NinePictureAllScreenShow(model.images, index);
        },
        child: Container(
          alignment: Alignment.center,
          child: ImgItem(
            picMap['full_path'],
            fit: BoxFit.fitWidth,
          ),
        ));
  }

  // 订单号、包裹列表
  Widget secondView() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 25),
      width: ScreenUtil().screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        // border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '转运订单号'.ts,
            fontSize: 13,
            color: AppColors.textGray,
          ),
          10.verticalSpaceFromWidth,
          Row(
            children: [
              AppText(
                str: controller.model.value?.orderSn ?? '',
              ),
              AppGaps.hGap15,
              GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                            text: controller.model.value?.orderSn ?? ''))
                        .then((value) => {controller.showSuccess('复制成功')});
                  },
                  child: Icon(
                    Icons.copy,
                    size: 20.sp,
                  )),
            ],
          ),
          10.verticalSpaceFromWidth,
          AppText(
            str: '包含的包裹'.ts,
            fontSize: 13,
            color: AppColors.textGray,
          ),
          10.verticalSpaceFromWidth,
          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: controller.model.value!.packages.map((e) {
              return GestureDetector(
                onTap: () {
                  BeeNav.push(BeeNav.parcelDetail, arg: {
                    "edit": false,
                    'id': e.id,
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImgItem(
                      'Home/parcel',
                      width: 20.w,
                      height: 20.w,
                    ),
                    AppGaps.hGap10,
                    AppText(
                      str: e.expressNum ?? '',
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget firstView() {
    return Container(
      color: AppColors.primary,
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            padding: const EdgeInsets.only(top: 30, left: 15),
            width: ScreenUtil().screenWidth,
            child: AppText(
              str: controller.statusStr.value.ts,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          secondView(),
        ],
      ),
    );
  }
}
