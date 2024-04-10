import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/models/shop/cart_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/shop/cart/cart_controller.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_binding.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_view.dart';

class BeeShopOrderGoodsItem extends StatefulWidget {
  BeeShopOrderGoodsItem({
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
  BeeShopOrderGoodsItemState createState() => BeeShopOrderGoodsItemState();
}

class BeeShopOrderGoodsItemState extends State<BeeShopOrderGoodsItem> {
  OverlayEntry? _overlayEntry;
  void _showBubble(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    OverlayState overlayState = Overlay.of(context);
    Get.find<AppStore>().saveBubble(false);
    _overlayEntry = OverlayEntry(
      builder: (context) => Obx((){
        return Positioned(
          // height: 18.h,
            left: offset.dx+200.w,
            top: offset.dy + renderBox.size.height-20.h,
            child: AnimatedOpacity(
              duration: Duration(seconds: 2),
              opacity: (!Get.find<AppStore>().bubbleDisappear.value&&_overlayEntry!=null)? 1.0 : 0.0,
              child: Material(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xffF9E9E8),
                  ),
                  child: Text('输入后回车即可保存'.inte,
                    style: TextStyle(
                        color: Color(0xff333333)
                    ),),
                ),
              ),
            )
        );
      }),
    );
    overlayState.insert(_overlayEntry!);
    // readyHide = true;
    // 2秒后自动移除气泡提示
    Future.delayed(Duration(seconds: 1), () {
      Get.find<AppStore>().saveBubble(true);
      _removeBubble();
    });
    // Future.delayed(Duration(seconds: 2), () {
    //   _removeBubble();
    // });
  }

  void _removeBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget inputQuantity(int num, CartSkuModel sku,BuildContext context) {
    final TextEditingController quantityController = TextEditingController();
    final FocusNode quantityNode = FocusNode();
    quantityController.text = num.toString();
    return // 支持手动输入
      Container(
        height: 20.h,
        alignment: Alignment.center,
        width: 40.w,
        child: BaseInput(
          controller: quantityController,
          focusNode: quantityNode,
          autoRemoveController: false,
          showDone: true,
          board: true,
          onChanged: (value){
            _showBubble(context);
          },
          hintText: '请填入'.inte,
          textAlign: TextAlign.center,
          onSubmitted: (value) {
            print(value);
            if (value == '') {
              widget.onStep!(0, sku, true);
            } else {
              int? number = int.tryParse(value);
              if (number == null) {
                EasyLoading.showError('请输入一个有效整数'.inte);
              } else
                widget.onStep!(int.parse(value), sku, true);
            }
          },
          autoShowRemove: false,
          style: TextStyle(fontSize: 14.sp),
          contentPadding: const EdgeInsets.only(bottom: 10),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var currencyModel = Get.find<AppStore>().currencyModel;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.only(bottom: widget.previewMode ? 0 : 10.h),
      padding: widget.previewMode
          ? null
          : EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              !widget.previewMode
                  ? Container(
                width: 24.w,
                height: 24.w,
                margin: EdgeInsets.only(right: 10.w),
                child: Obx(
                      () => Checkbox(
                      value: widget.cartModel.skus
                          .every((e) =>widget.checkedIds!.contains(e.id)),
                      shape: const CircleBorder(),
                      activeColor: AppStyles.primary,
                      onChanged: (value) {
                        if (widget.onChecked != null) {
                          widget.onChecked!(
                              widget.cartModel.skus.map((e) => e.id).toList());
                        }
                      },
                      side: MaterialStateBorderSide.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(
                                MaterialState.selected)) //修改勾选时边框颜色为红色
                              return const BorderSide(
                                  width: 0.5, color: Colors.white);
                            //修改默认时边框颜色为绿色
                            return const BorderSide(
                                width: 1, color: Color(0xff999999));
                          }
                        // 调整视觉密度
                      )),
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
                  str: widget.cartModel.shopName ?? '',
                  fontSize: 14,
                ),
              ),
              (widget.orderStatusName ?? '').isNotEmpty
                  ? AppText(
                str: widget.orderStatusName!,
                fontSize: 14,
                color: AppStyles.textGrayC9,
                alignment: TextAlign.right,
              )
                  : AppGaps.empty,
              widget.otherWiget ?? AppGaps.empty,
            ],
          ),
          ...widget.cartModel.skus.map(
                (sku) => GestureDetector(
              onTap: widget.goodsToDetail
                  ? () {
                if (widget.cartModel.shopId.toString() == '-1') {
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
                    !widget.previewMode
                        ? Container(
                        width: 24.w,
                        height: 24.w,
                        margin: EdgeInsets.only(right: 10.w),
                        child: Obx(
                              () => Checkbox(
                              value: widget.checkedIds!.contains(sku.id),
                              shape: const CircleBorder(),
                              activeColor: AppStyles.primary,
                              onChanged: (value) {
                                if (widget.onChecked != null) {
                                  widget.onChecked!([sku.id]);
                                }
                              },
                              side: MaterialStateBorderSide.resolveWith(
                                      (Set<MaterialState> states) {
                                    if (states.contains(
                                        MaterialState.selected)) //修改勾选时边框颜色为红色
                                      return const BorderSide(
                                          width: 0.5, color: Colors.white);
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
                                            text:
                                            currencyModel.value?.code ?? '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
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
                              if (widget.showDelete)
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
                                widget.previewMode
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
                                        widget.onStep!(
                                            -(sku.skuInfo
                                                ?.batchNumber ??
                                                1),
                                            sku,
                                            false);
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

                                    // 支持手动输入
                                    Container(
                                      height: 20.h,
                                      alignment: Alignment.center,
                                      width: 45.w,
                                      child: inputQuantity(
                                          sku.quantity, sku,context),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.onStep!(
                                            sku.skuInfo
                                                ?.batchNumber ??
                                                1,
                                            sku,
                                            false);
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
                                    widget.onChangeQty!(sku);
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
