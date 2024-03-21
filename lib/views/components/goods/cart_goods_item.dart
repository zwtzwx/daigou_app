import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/models/shop/cart_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/shop/cart/cart_controller.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_binding.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_view.dart';

class BeeShopOrderGoodsItem extends StatelessWidget {
  const BeeShopOrderGoodsItem({
    Key? key,
    this.previewMode = false,
    required this.cartModel,
    this.checkedIds,
    this.onChecked,
    this.onStep,
    this.onChangeQty,
    this.orderStatusName,
    this.showDelete = false,
    this.otherWiget,
    this.goodsToDetail = true,
  }) : super(key: key);
  final bool previewMode;
  final CartModel cartModel;
  final List<int>? checkedIds;
  final Function(List<int> id)? onChecked;
  final Function? onStep;
  final Function? onChangeQty;
  final String? orderStatusName;
  final Widget? otherWiget;
  final bool goodsToDetail;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    var currencyModel = Get.find<AppStore>().currencyModel;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.only(bottom: previewMode ? 0 : 10.h),
      padding: previewMode
          ? null
          : EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
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
                          activeColor: AppStyles.primary,
                          onChanged: (value) {
                            if (onChecked != null) {
                              onChecked!(
                                  cartModel.skus.map((e) => e.id).toList());
                            }
                          },
                            side: MaterialStateBorderSide.resolveWith(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.selected))//修改勾选时边框颜色为红色
                                      return const BorderSide(width: 0.5, color: Colors.white);
                                  //修改默认时边框颜色为绿色
                                  return const BorderSide(
                                      width: 1, color: Color(0xff999999));
                                }
                              // 调整视觉密度
                            )
                        ),
                      ),
                    )
                  : AppGaps.empty,
              ImgItem(
                'Shop/shop',
                width: 20.w,
              ),
              5.horizontalSpace,
              Expanded(
                child: AppText(
                  str: cartModel.shopName ?? '',
                  fontSize: 14,
                ),
              ),
              (orderStatusName ?? '').isNotEmpty
                  ? AppText(
                      str: orderStatusName!,
                      fontSize: 14,
                      color: AppStyles.textGrayC9,
                      alignment: TextAlign.right,
                    )
                  : AppGaps.empty,
              otherWiget ?? AppGaps.empty,
            ],
          ),
          ...cartModel.skus.map(
            (sku) => GestureDetector(
              onTap: goodsToDetail
                  ? () {
                      if (cartModel.shopId.toString() == '-1') {
                        GlobalPages.toPage(
                          GoodsDetailView(goodsId: sku.goodsId.toString()),
                          arguments: {'id': sku.goodsId},
                          binding:
                              GoodsDetailBinding(tag: sku.goodsId.toString()),
                          authCheck: true,
                        );
                      } else {
                        GlobalPages.toPage(
                          GoodsDetailView(goodsId: sku.id.toString()),
                          arguments: {'url': sku.platformUrl},
                          binding: GoodsDetailBinding(tag: sku.id.toString()),
                          authCheck: true,
                        );
                      }
                    }
                  : null,
              child: Container(
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
                                  activeColor: AppStyles.primary,
                                  onChanged: (value) {
                                    if (onChecked != null) {
                                      onChecked!([sku.id]);
                                    }
                                  },
                                  side: MaterialStateBorderSide.resolveWith(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.selected))//修改勾选时边框颜色为红色
                                          return const BorderSide(width: 0.5, color: Colors.white);
                                    //修改默认时边框颜色为绿色
                                    return const BorderSide(
                                        width: 1, color: Color(0xff999999));
                                  }
                                      // 调整视觉密度
                                      )),
                            ))
                        : AppGaps.empty,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ImgItem(
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
                          AppText(
                            str: sku.name,
                            fontSize: 14,
                          ),
                          ...(sku.skuInfo?.attributes ?? []).map(
                            (info) => Container(
                              margin: EdgeInsets.only(top: 3.h),
                              child: AppText(
                                str: '${info['label']}：${info['value']}',
                                fontSize: 12,
                                color: AppStyles.textGrayC9,
                                lines: 2,
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
                                        color: AppStyles.textDark,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: currencyModel.value?.code ?? '',
                                        ),
                                        TextSpan(
                                          text: ' ' +
                                              (sku.price).priceConvert(
                                                needFormat: false,
                                                showPriceSymbol: false,
                                                showInt: true,
                                              ),
                                          // text: previewMode
                                          //     ? (sku.price).priceConvert(
                                          //         needFormat: false,
                                          //         showPriceSymbol: false)
                                          //     : (sku.price).priceConvert(
                                          //         needFormat: false,
                                          //         showPriceSymbol: false),
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                              if (showDelete)
                                GestureDetector(
                                  onTap: () {
                                    Get.find<CartController>()
                                        .onCartDelete(context, sku.id);
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: AppStyles.primary,
                                    size: 20.sp,
                                  ),
                                )
                              else
                                previewMode
                                    ? AppText(
                                        str: '×${sku.quantity}',
                                        fontSize: 12,
                                      )
                                    : sku.changeQty
                                        ? Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (sku.quantity <=
                                                      (sku.skuInfo
                                                              ?.minOrderQuantity ??
                                                          1)) return;
                                                  onStep!(
                                                      -(sku.skuInfo
                                                              ?.batchNumber ??
                                                          1),
                                                      sku);
                                                },
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 24.w,
                                                    height: 24.w,
                                                    alignment: Alignment.center,
                                                    color: sku.quantity <=
                                                            (sku.skuInfo
                                                                    ?.minOrderQuantity ??
                                                                1)
                                                        ? const Color(
                                                            0xFFF0F0F0)
                                                        : AppStyles.primary,
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 14.sp,
                                                      color: sku.quantity <=
                                                              (sku.skuInfo
                                                                      ?.minOrderQuantity ??
                                                                  1)
                                                          ? const Color(
                                                              0xFFBBBBBB)
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 20.h,
                                                alignment: Alignment.center,
                                                width: 40.w,
                                                child: AppText(
                                                  str: sku.quantity.toString(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  onStep!(
                                                      sku.skuInfo
                                                              ?.batchNumber ??
                                                          1,
                                                      sku);
                                                },
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 24.w,
                                                    height: 24.w,
                                                    alignment: Alignment.center,
                                                    color: AppStyles.primary,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 14.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                                                  color:
                                                      const Color(0xFFEEEEEE),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(text: 'x'),
                                                    TextSpan(
                                                      text: sku.quantity
                                                          .toString(),
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
          ),
        ],
      ),
    );
  }
}
