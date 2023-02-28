/*
  订单详细
 */
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/order/detail/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: ZHTextLine(
            str: '订单详情'.ts,
            color: BaseStylesConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: BaseStylesConfig.bgGray,
        bottomNavigationBar: bottomButton(context),
        body: SingleChildScrollView(
          child: Obx(
            () => controller.isLoading.value
                ? Column(
                    children: [
                      firstView(),
                      Sized.vGap10,
                      addressView(),
                      Sized.vGap10,
                      controller.model.value!.remark.isNotEmpty
                          ? remarkView()
                          : Sized.empty,
                      baseInfoView(),
                      Sized.vGap10,
                      valueInfoView(context),
                      Sized.vGap10,
                      // controller.model.value!.status > 2
                      //     ? payInfoView()
                      //     : Sized.empty,
                    ],
                    // children: returnSubView(),
                  )
                : Sized.empty,
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
          Row(
            children: [
              const LoadImage(
                'PackageAndOrder/address-icon',
                width: 24,
                height: 24,
              ),
              Sized.hGap10,
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: HexToColor('#eceeff'),
                  child: ZHTextLine(
                    str: address.countryName,
                    color: BaseStylesConfig.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Sized.vGap15,
          Sized.line,
          Sized.vGap15,
          ZHTextLine(
            str: '收货地址'.ts,
            fontSize: 13,
            color: BaseStylesConfig.textGray,
          ),
          Sized.vGap5,
          ZHTextLine(
            str: reciverStr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          Sized.vGap5,
          ZHTextLine(
            str: addressStr,
            lines: 4,
          ),
          Sized.vGap5,
          ZHTextLine(
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
          ZHTextLine(
            str: '客服备注'.ts,
            color: BaseStylesConfig.textGray,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ZHTextLine(
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
              : Sized.empty,
          controller.model.value!.status > 1 ? packInfoView() : Sized.empty,
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
            : Sized.empty,
        baseInfoItem('称重重量', text: actualWeight),
        baseInfoItem('计费重量', text: paymentWeight),
        baseInfoItem('留仓物品', text: controller.model.value!.inWarehouseItem),
        controller.packVideoManager.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ZHTextLine(
                    str: '打包视频'.ts,
                    color: BaseStylesConfig.textGray,
                  ),
                  Sized.vGap10,
                  ...controller.packVideoManager.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FlickVideoPlayer(
                        flickManager: e,
                      ),
                    );
                  }).toList(),
                ],
              )
            : Sized.empty,
        Sized.line,
        Sized.vGap10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  ZHTextLine(
                    str: '打包照片'.ts,
                    color: BaseStylesConfig.textGray,
                  ),
                  Sized.vGap10,
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
                      : Sized.empty,
                ],
              ),
            ),
            Sized.hGap15,
            Expanded(
              child: Column(
                children: [
                  ZHTextLine(
                    str: '物品照片'.ts,
                    color: BaseStylesConfig.textGray,
                  ),
                  Sized.vGap10,
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
                      : Sized.empty,
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
                  child: ZHTextLine(
                    str: '实重'.ts,
                  ),
                ),
                ZHTextLine(
                  str: ((boxModel.weight ?? 0) / 1000).toStringAsFixed(2) +
                      controller.localModel!.weightSymbol,
                ),
              ],
            ),
            Sized.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ZHTextLine(
                    str: '体积重'.ts,
                  ),
                ),
                ZHTextLine(
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
          // controller.model.value!.status != 1
          //     ? baseInfoItem(
          //         '合计运费',
          //         content: Row(
          //           children: [
          //             controller.model.value!.price != null &&
          //                     num.parse(controller
          //                             .model.value!.price!.discount) !=
          //                         1
          //                 ? ZHTextLine(
          //                     str: controller.getPriceStr(
          //                         controller.model.value!.price!.originPrice),
          //                     color: BaseStylesConfig.textGray,
          //                     fontSize: 13,
          //                     decoration: TextDecoration.lineThrough,
          //                   )
          //                 : Sized.empty,
          //             Sized.hGap10,
          //             ZHTextLine(
          //               str: controller
          //                   .getPriceStr(controller.model.value!.allFreightFee),
          //             ),
          //           ],
          //         ),
          //       )
          //     : Sized.empty,
          // controller.model.value!.status != 1
          //     ? baseInfoItem('帮您运费节省',
          //         text: controller
          //             .getPriceStr(controller.model.value!.thriftFreightFee))
          //     : Sized.empty,
          controller.model.value!.insuranceFee > 0
              ? baseInfoItem('保险费',
                  text:
                      '+${controller.getPriceStr(controller.model.value!.insuranceFee)}')
              : Sized.empty,
          controller.model.value!.tariffFee > 0
              ? baseInfoItem('关税',
                  text:
                      '+${controller.getPriceStr(controller.model.value!.tariffFee)}')
              : Sized.empty,
          baseInfoItem(
            '订单增值服务',
            crossAxisAlignment: CrossAxisAlignment.start,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ZHTextLine(
                  str: controller.model.value!.valueAddedService.isNotEmpty
                      ? '+${controller.getPriceStr(valueAddAmount)}'
                      : '无'.ts,
                ),
                ...controller.model.value!.valueAddedService.map((e) {
                  return ZHTextLine(
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
              : Sized.empty,
          controller.model.value!.lineServices.isNotEmpty
              ? baseInfoItem(
                  '渠道增值服务',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      controller.model.value!.status != 1
                          ? ZHTextLine(
                              str:
                                  '+${controller.getPriceStr(controller.model.value!.lineServiceFee)}',
                            )
                          : Sized.empty,
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
                                      color: BaseStylesConfig.green,
                                      size: 18,
                                    ),
                                  )
                                : Sized.empty,
                            Sized.hGap10,
                            ZHTextLine(
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
              : Sized.empty,
          controller.model.value!.status > 2 &&
                  controller.model.value!.couponDiscountFee > 0
              ? baseInfoItem(
                  '优惠券',
                  text: '-' +
                      controller.getPriceStr(
                          controller.model.value!.couponDiscountFee),
                )
              : Sized.empty,
          (controller.model.value!.status > 2 &&
                  controller.model.value!.transaction.isNotEmpty &&
                  controller.model.value!.transaction[0].isUsePoint == 1)
              ? baseInfoItem(
                  '积分',
                  text: '-' +
                      controller.getPriceStr(
                          controller.model.value!.transaction[0].pointAmount),
                )
              : Sized.empty,
          // controller.model.value!.status != 1
          //     ? baseInfoItem(
          //         '订单总价',
          //         text: controller
          //             .getPriceStr(controller.model.value!.actualPaymentFee),
          //       )
          //     : Sized.empty,
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
              : Sized.empty,
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
            child: ZHTextLine(
              str: label.ts,
              color: labelColor ?? BaseStylesConfig.textGray,
              lines: 2,
            ),
          ),
          content ??
              ZHTextLine(
                str: text ?? '无'.ts,
                color: redText
                    ? BaseStylesConfig.textRed
                    : BaseStylesConfig.textBlack,
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
          top: BorderSide(color: BaseStylesConfig.line),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: PlainButton(
                text: '联系客服',
                onPressed: () async {
                  Routers.push(Routers.contact);
                },
              ),
            ),
            Sized.hGap10,
            [4, 5].contains(controller.model.value?.status)
                ? PlainButton(
                    text: '查看物流',
                    onPressed: () {
                      if (controller.model.value!.boxes.isNotEmpty) {
                        BaseDialog.showBoxsTracking(
                            context, controller.model.value!);
                      } else {
                        Routers.push(Routers.orderTracking,
                            {"order_sn": controller.model.value!.orderSn});
                      }
                    },
                  )
                : Sized.empty,
            Sized.hGap10,
            controller.model.value?.status == 4
                ? Flexible(
                    child: MainButton(
                      text: '确认收货',
                      onPressed: () async {
                        var data = await BaseDialog.confirmDialog(
                            context, '请确认您已收到货'.ts);
                        if (data != null) {
                          controller.onSign();
                        }
                      },
                    ),
                  )
                : Sized.empty,
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
          child: LoadImage(
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
          ZHTextLine(
            str: '转运订单号'.ts,
            fontSize: 13,
            color: BaseStylesConfig.textGray,
          ),
          Sized.vGap10,
          Row(
            children: [
              ZHTextLine(
                str: controller.model.value?.orderSn ?? '',
              ),
              Sized.hGap15,
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                          ClipboardData(text: controller.model.value?.orderSn))
                      .then((value) => {controller.showSuccess('复制成功')});
                },
                child: const LoadImage(
                  'PackageAndOrder/copy-icon',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          Sized.vGap10,
          ZHTextLine(
            str: '包含的包裹'.ts,
            fontSize: 13,
            color: BaseStylesConfig.textGray,
          ),
          Sized.vGap10,
          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: controller.model.value!.packages.map((e) {
              return GestureDetector(
                onTap: () {
                  Routers.push(Routers.parcelDetail, {
                    "edit": false,
                    'id': e.id,
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LoadImage(
                      'PackageAndOrder/package',
                      width: 24,
                      height: 24,
                    ),
                    Sized.hGap10,
                    ZHTextLine(
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
        color: BaseStylesConfig.primary,
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              padding: const EdgeInsets.only(top: 30, left: 15),
              width: ScreenUtil().screenWidth,
              child: ZHTextLine(
                str: controller.statusStr.value.ts,
                color: BaseStylesConfig.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            secondView(),
          ],
        ));
  }
}
