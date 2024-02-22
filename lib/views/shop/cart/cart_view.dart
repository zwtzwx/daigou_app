import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/shop/cart_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/cart_goods_item.dart';
import 'package:huanting_shop/views/components/goods/goods_list_cell.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/loading_cell.dart';
import 'package:huanting_shop/views/components/skeleton/skeleton.dart';
import 'package:huanting_shop/views/shop/cart/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: AppText(
          str: '购物车'.ts,
          fontSize: 17,
        ),
      ),
      backgroundColor: Colors.white,
      bottomSheet: Obx(() => controller.showCartList.isNotEmpty
          ? Container(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -1.h),
                    blurRadius: 20.r,
                    color: const Color(0x0D000000),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Checkbox(
                        value: controller.allChecked.value,
                        shape: const CircleBorder(),
                        activeColor: AppColors.primary,
                        checkColor: Colors.black,
                        onChanged: (value) {
                          controller.onAllCheck(value!);
                        },
                      ),
                    ),
                    2.horizontalSpace,
                    Expanded(
                      child: Obx(
                        () => AppText(
                          str: '全选'.ts,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    controller.configState.value
                        ? SizedBox(
                            height: 30.h,
                            child: BeeButton(
                              backgroundColor: const Color(0xFFFF4949),
                              img: ImgItem(
                                'Shop/ico_sc',
                                width: 18.w,
                              ),
                              onPressed: () {
                                controller.onCartDelete(context);
                              },
                            ),
                          )
                        : Row(
                            children: [
                              Obx(
                                () => Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      color: const Color(0xFFFF6868),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller
                                                .currencyModel.value?.symbol ??
                                            '',
                                      ),
                                      TextSpan(
                                        text: controller.totalCheckedPrice.rate(
                                            needFormat: false,
                                            showPriceSymbol: false),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              15.horizontalSpace,
                              SizedBox(
                                height: 30.h,
                                child: BeeButton(
                                  text: '提交',
                                  borderRadis: 999,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  onPressed: controller.onSubmit,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            )
          : AppGaps.empty),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.handleRefresh,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.loadingUtil.value.scrollController,
          children: [
            Obx(() => controller.cartLoading.value
                ? SizedBox(
                    height: 270.h,
                    child: Skeleton(
                      type: SkeletonType.listSkeleton,
                      itemCount: 3,
                      showImg: true,
                      height: 80.h,
                      lineCount: 4,
                    ),
                  )
                : cartCell()),
            recommendGoodsList(),
            30.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  Widget cartCell() {
    return controller.allCartList.isEmpty
        ? emptyCell()
        : Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              children: [
                SizedBox(
                    height: 30.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              cartTypeItem('代购', 1),
                              15.horizontalSpace,
                              cartTypeItem('自营', 2),
                            ],
                          ),
                        ),
                        10.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            controller.configState.value =
                                !controller.configState.value;
                          },
                          child: AppText(
                            str: controller.configState.value
                                ? '退出'.ts
                                : '管理'.ts,
                            fontSize: 14,
                            color: controller.configState.value
                                ? const Color(0xFFFFA441)
                                : AppColors.textDark,
                          ),
                        ),
                      ],
                    )),
                controller.showCartList.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.showCartList
                            .map(
                              (cart) => BeeShopOrderGoodsItem(
                                cartModel: cart,
                                checkedIds: controller.checkedList,
                                onStep: controller.onSkuQty,
                                onChecked: controller.onChecked,
                                onChangeQty: (CartSkuModel value) {
                                  controller.onChangeQty(value);
                                },
                              ),
                            )
                            .toList())
                    : emptyCell(),
              ],
            ),
          );
  }

  Widget cartTypeItem(String label, int type) {
    return GestureDetector(
      onTap: () {
        controller.checkedList.clear();
        controller.cartType.value = type;
        controller.allChecked.value = false;
        controller.getShowCartList();
      },
      child: AppText(
        str: label.ts +
            '(${type == 1 ? controller.platformCartSkuNum : controller.cartSkuNum})',
        fontSize: 16,
        color: AppColors.textDark,
        fontWeight: controller.cartType.value == type
            ? FontWeight.bold
            : FontWeight.w500,
      ),
    );
  }

  Widget emptyCell() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          ImgItem(
            'https://api-jiyun-v3.haiouoms.com/storage/admin/20230826-u0MsFIRRUF396f7D.png',
            width: 200.w,
          ),
          10.verticalSpace,
          Obx(
            () => AppText(
              str: '购物车空空如也'.ts + '~',
              fontSize: 12,
              color: AppColors.textGrayC,
            ),
          ),
        ],
      ),
    );
  }

  // 推荐商品（代购商品）
  Widget recommendGoodsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
          child: Obx(
            () => AppText(
              str: '推荐'.ts,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: BeeShopGoodsList(
                isPlatformGoods: true,
                platformGoodsList: controller.loadingUtil.value.list,
              ),
            ),
          ),
        ),
        Obx(
          () => LoadingCell(
            util: controller.loadingUtil.value,
          ),
        ),
      ],
    );
  }
}
