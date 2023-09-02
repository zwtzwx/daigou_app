import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/cart_goods_item.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/shop/order_detail/order_detail_controller.dart';

class ShopOrderDetailView extends GetView<ShopOrderDetailController> {
  const ShopOrderDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ZHTextLine(
          str: '订单详情'.ts,
          fontSize: 17,
        ),
        backgroundColor: BaseStylesConfig.bgGray,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: Obx(
        () => controller.isLoading.value
            ? Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                    child: const Skeleton(
                      type: SkeletonType.singleSkeleton,
                      lineCount: 5,
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    height: ScreenUtil().setHeight(60),
                    child: const Skeleton(
                      type: SkeletonType.singleSkeleton,
                      lineCount: 3,
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    height: ScreenUtil().setHeight(150),
                    child: const Skeleton(
                      type: SkeletonType.singleSkeleton,
                      lineCount: 9,
                    ),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: controller.getDetail,
                color: BaseStylesConfig.primary,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    addressCell(),
                    shopCell(),
                    skusCell(),
                    15.verticalSpace,
                  ],
                ),
              ),
      ),
    );
  }

  Widget addressCell() {
    return baseBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: BaseStylesConfig.line)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: '收货地址'.ts,
                  fontSize: 14,
                ),
                ZHTextLine(
                  str: controller.orderModel.value!.address?.addressType == 1
                      ? '送货上门'.ts
                      : '自提点提货'.ts,
                  fontSize: 12,
                  color: BaseStylesConfig.textNormal,
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: const Color(0xFF9D9D9D),
                size: 30.sp,
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZHTextLine(
                      str: controller.orderModel.value!.address!.receiverName +
                          ' ' +
                          controller.orderModel.value!.address!.timezone +
                          '-' +
                          controller.orderModel.value!.address!.phone,
                      lines: 4,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    4.verticalSpace,
                    ZHTextLine(
                      str: controller.orderModel.value!.address!.getContent(),
                      lines: 10,
                      fontSize: 12,
                      color: BaseStylesConfig.textGrayC9,
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  Widget skusCell() {
    return baseBox(
        child: Column(
      children: [
        10.verticalSpace,
        ...controller.orderModel.value!.skus!.map(
          (e) => CartGoodsItem(
            previewMode: true,
            cartModel: e,
            orderStatusName: controller.orderModel.value?.statusName ?? '',
          ),
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZHTextLine(
                str: '国内运费'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: (controller.orderModel.value!.freightFee ?? 0)
                  .rate(needFormat: false),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZHTextLine(
              str: '订单备注'.ts,
              fontSize: 14,
            ),
            10.horizontalSpace,
            Expanded(
              child: ZHTextLine(
                str: (controller.orderModel.value!.remark ?? ''),
                fontSize: 14,
                alignment: TextAlign.right,
                lines: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        10.verticalSpace,
        Sized.line,
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZHTextLine(
                str: '商品总价'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: (controller.orderModel.value!.goodsAmount ?? 0)
                  .rate(needFormat: false),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZHTextLine(
                str: '国内运费'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: (controller.orderModel.value!.freightFee ?? 0)
                  .rate(needFormat: false),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZHTextLine(
                str: '增值服务费'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: (controller.orderModel.value!.packageServiceFee ?? 0)
                  .rate(needFormat: false),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        ![0, 10].contains(controller.orderModel.value?.status)
            ? Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ZHTextLine(
                        str: '支付金额'.ts,
                        fontSize: 14,
                        lines: 2,
                      ),
                    ),
                    5.horizontalSpace,
                    ZHTextLine(
                      str: (controller.orderModel.value!.amount ?? 0)
                          .rate(needFormat: false),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              )
            : Sized.empty,
        12.verticalSpace,
        Sized.line,
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZHTextLine(
                str: '订单编号'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: controller.orderModel.value!.orderSn,
              fontSize: 14,
              color: BaseStylesConfig.textGrayC9,
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ZHTextLine(
                str: '提交时间'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: controller.orderModel.value!.createdAt ?? '',
              fontSize: 14,
              color: BaseStylesConfig.textGrayC9,
            ),
          ],
        ),
        15.verticalSpace,
      ],
    ));
  }

  Widget shopCell() {
    return baseBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: ZHTextLine(
                str: '打包方式'.ts,
                fontSize: 14,
                lines: 2,
              ),
            ),
            5.horizontalSpace,
            ZHTextLine(
              str: controller.orderModel.value!.expressLine != null
                  ? '到件即发'.ts
                  : '集齐再发'.ts,
              fontSize: 14,
              color: BaseStylesConfig.textGrayC9,
            ),
          ],
        ),
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
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
      child: child,
    );
  }
}
