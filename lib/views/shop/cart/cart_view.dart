import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/shop/cart_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/goods/cart_goods_item.dart';
import 'package:shop_app_client/views/components/goods/goods_list_cell.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/loading_cell.dart';
import 'package:shop_app_client/views/components/skeleton/skeleton.dart';
import 'package:shop_app_client/views/shop/cart/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgGray,
      bottomSheet: Obx(() => controller.showCartList.isNotEmpty
          ? Container(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 25.h),
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
                      child: Checkbox.adaptive(
                        value: controller.allChecked.value,
                        shape: const CircleBorder(),
                        activeColor: AppStyles.primary,
                        onChanged: (value) {
                          controller.onAllCheck(value!);
                        },
                      ),
                    ),
                    2.horizontalSpace,
                    Expanded(
                      child: Obx(
                        () => AppText(
                          str: '全选'.inte,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    controller.configState.value
                        ? SizedBox(
                            height: 30.h,
                            child: BeeButton(
                              backgroundColor: const Color(0xFFFFD8D8),
                              textColor: AppStyles.primary,
                              text: '删除',
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
                                      color: AppStyles.textDark,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller
                                                .currencyModel.value?.code ??
                                            '',
                                      ),
                                      TextSpan(
                                        text: ' ' +
                                            controller.totalCheckedPrice
                                                .priceConvert(
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
                                  text: '提交订单',
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
        color: AppStyles.primary,
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
                : cartCell(context)),
            recommendGoodsList(),
            30.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  Widget cartCell(BuildContext context) {
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
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: LoadAssetImage(
                              'Home/back',
                              width: 22.w,
                              height: 22.w,
                            )
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              cartTypeItem('代购商品', 1),
                              // 15.horizontalSpace,
                              // cartTypeItem('自营', 2),
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
                                ? '退出管理'.inte
                                : '管理'.inte,
                            fontSize: 14,
                            color: controller.configState.value
                                ? const Color(0xFFFFA441)
                                : AppStyles.textDark,
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
                                showDelete: controller.configState.value,
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
        str: label.inte +
            '(${type == 1 ? controller.platformCartSkuNum : controller.cartSkuNum})',
        fontSize: 16,
        color: AppStyles.textDark,
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
      child: Column(
        children: [
          ImgItem(
            'https://api-jiyun-v3.haiouoms.com/storage/admin/20230826-u0MsFIRRUF396f7D.png',
            width: 200.w,
            placeholderWidget: const SizedBox(),
          ),
          10.verticalSpace,
          Obx(
            () => AppText(
              str: '购物车空空如也'.inte + '~',
              fontSize: 12,
              color: AppStyles.textGrayC,
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
              str: '推荐'.inte,
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
