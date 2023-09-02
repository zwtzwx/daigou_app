import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/models/shop/cart_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class CartGoodsItem extends StatelessWidget {
  const CartGoodsItem({
    Key? key,
    this.previewMode = false,
    required this.cartModel,
    this.checkedIds,
    this.onChecked,
    this.onStep,
    this.onChangeQty,
    this.orderStatusName,
    this.otherWiget,
  }) : super(key: key);
  final bool previewMode;
  final CartModel cartModel;
  final List<int>? checkedIds;
  final Function(List<int> id)? onChecked;
  final Function? onStep;
  final Function? onChangeQty;
  final String? orderStatusName;
  final Widget? otherWiget;

  @override
  Widget build(BuildContext context) {
    var currencyModel = Get.find<UserInfoModel>().currencyModel;
    return Container(
      margin: EdgeInsets.only(bottom: previewMode ? 0 : 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: previewMode
          ? null
          : EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              !previewMode
                  ? Container(
                      width: 24.w,
                      height: 24.w,
                      margin: EdgeInsets.only(right: 10.w),
                      child: Obx(
                        () => Checkbox(
                            value: cartModel.skus
                                .every((e) => checkedIds!.contains(e.id)),
                            shape: const CircleBorder(),
                            activeColor: BaseStylesConfig.primary,
                            checkColor: Colors.black,
                            onChanged: (value) {
                              if (onChecked != null) {
                                onChecked!(
                                    cartModel.skus.map((e) => e.id).toList());
                              }
                            }),
                      ),
                    )
                  : Sized.empty,
              LoadImage(
                'Shop/cart_shop',
                width: 20.w,
              ),
              5.horizontalSpace,
              Expanded(
                child: ZHTextLine(
                  str: cartModel.shopName ?? '',
                  fontSize: 14,
                ),
              ),
              (orderStatusName ?? '').isNotEmpty
                  ? ZHTextLine(
                      str: orderStatusName!,
                      fontSize: 14,
                      color: BaseStylesConfig.textGrayC9,
                      alignment: TextAlign.right,
                    )
                  : Sized.empty,
              otherWiget ?? Sized.empty,
            ],
          ),
          ...cartModel.skus.map(
            (sku) => Container(
              margin: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  !previewMode
                      ? Container(
                          width: 24.w,
                          height: 24.w,
                          margin: EdgeInsets.only(right: 10.w),
                          child: Obx(
                            () => Checkbox(
                                value: checkedIds!.contains(sku.id),
                                shape: const CircleBorder(),
                                activeColor: BaseStylesConfig.primary,
                                checkColor: Colors.black,
                                onChanged: (value) {
                                  if (onChecked != null) {
                                    onChecked!([sku.id]);
                                  }
                                }),
                          ),
                        )
                      : Sized.empty,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LoadImage(
                      sku.skuInfo?.picUrl ?? '',
                      holderImg: 'Shop/goods_none',
                      width: 95.w,
                      height: 95.w,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ZHTextLine(
                          str: sku.name,
                          fontSize: 14,
                        ),
                        ...(sku.skuInfo?.attributes ?? []).map(
                          (info) => Container(
                            margin: EdgeInsets.only(top: 3.h),
                            child: ZHTextLine(
                              str: '${info['label']}：${info['value']}',
                              fontSize: 12,
                              color: BaseStylesConfig.textGrayC9,
                            ),
                          ),
                        ),
                        8.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text.rich(
                                TextSpan(
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: currencyModel.value?.symbol ?? '',
                                      ),
                                      TextSpan(
                                        text: previewMode
                                            ? (sku.amount).rate(
                                                needFormat: false,
                                                showPriceSymbol: false)
                                            : (sku.quantity * sku.price).rate(
                                                needFormat: false,
                                                showPriceSymbol: false),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            previewMode
                                ? ZHTextLine(
                                    str: '×${sku.quantity}',
                                    fontSize: 12,
                                  )
                                : sku.changeQty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFEEEEEE),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (sku.quantity == 1) return;
                                                onStep!(-1, sku);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w),
                                                color: Colors.transparent,
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 14.sp,
                                                  color: sku.quantity == 1
                                                      ? BaseStylesConfig
                                                          .textGray
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 20.h,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                border: Border.symmetric(
                                                  vertical: BorderSide(
                                                    color: Color(0xFFEEEEEE),
                                                  ),
                                                ),
                                              ),
                                              width: 40.w,
                                              child: ZHTextLine(
                                                str: sku.quantity.toString(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                onStep!(1, sku);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w),
                                                color: Colors.transparent,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          onChangeQty!(sku);
                                        },
                                        child: Container(
                                          height: 20.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color(0xFFEEEEEE),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(text: 'x'),
                                                TextSpan(
                                                  text: sku.quantity.toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
