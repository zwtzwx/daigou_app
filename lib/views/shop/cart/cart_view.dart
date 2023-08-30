import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/cart_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/contact_cell.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/goods/cart_goods_item.dart';
import 'package:jiyun_app_client/views/components/goods/goods_list_cell.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/loading_cell.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/shop/cart/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomSheet: Obx(() => controller.showCartList.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5.r,
                    color: const Color(0x0D000000),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Checkbox(
                      value: controller.allChecked.value,
                      shape: const CircleBorder(),
                      activeColor: BaseStylesConfig.primary,
                      checkColor: Colors.black,
                      onChanged: (value) {
                        controller.onAllCheck(value!);
                      },
                    ),
                  ),
                  2.horizontalSpace,
                  Expanded(
                    child: ZHTextLine(
                      str: '全选'.ts,
                      fontSize: 14,
                    ),
                  ),
                  controller.configState.value
                      ? MainButton(
                          text: '删除',
                          backgroundColor: const Color(0xFFFF6868),
                          borderRadis: 999,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.white,
                          onPressed: () {
                            controller.onCartDelete(context);
                          },
                        )
                      : Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: const Color(0xFFFF6868),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '总计'.ts + '：',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: BaseStylesConfig.textDark,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.totalCheckedPrice
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            15.horizontalSpace,
                            MainButton(
                              text: '提交',
                              borderRadis: 999,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              onPressed: controller.onSubmit,
                            ),
                          ],
                        ),
                ],
              ),
            )
          : Sized.empty),
      body: Stack(
        children: [
          RefreshIndicator(
            color: BaseStylesConfig.primary,
            onRefresh: controller.handleRefresh,
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.loadingUtil.value.scrollController,
              children: [
                Container(
                  color: Colors.white,
                  child: const LanguageCell(),
                ),
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
          const ContactCell(),
        ],
      ),
    );
  }

  Widget cartCell() {
    return Obx(
      () => controller.allCartList.isEmpty
          ? emptyCell()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [Colors.white, BaseStylesConfig.bgGray],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [controller.showCartList.isNotEmpty ? 0.1 : 1, 0.3],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        cartTypeItem('代购', 1),
                        10.horizontalSpace,
                        Expanded(
                          child: cartTypeItem('自营', 2),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.configState.value =
                                !controller.configState.value;
                          },
                          child: ZHTextLine(
                            str: controller.configState.value
                                ? '退出管理'.ts
                                : '管理'.ts,
                            fontSize: 14,
                            color: controller.configState.value
                                ? const Color(0xFFFFA441)
                                : BaseStylesConfig.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.showCartList.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.showCartList
                              .map(
                                (cart) => CartGoodsItem(
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
      child: ZHTextLine(
        str: label.ts +
            '（${type == 1 ? controller.platformCartSkuNum : controller.cartSkuNum}）',
        fontSize: controller.cartType.value == type ? 16 : 14,
        color: controller.cartType.value == type
            ? BaseStylesConfig.textDark
            : BaseStylesConfig.textGrayC9,
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
          LoadImage(
            'https://api-jiyun-v3.haiouoms.com/storage/admin/20230826-u0MsFIRRUF396f7D.png',
            width: 200.w,
          ),
          10.verticalSpace,
          ZHTextLine(
            str: '购物车空空如也'.ts + '~',
            fontSize: 12,
            color: BaseStylesConfig.textGrayC,
          ),
        ],
      ),
    );
  }

  // 推荐商品（代购商品）
  Widget recommendGoodsList() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            alignment: Alignment.center,
            child: ZHTextLine(
              str: '推荐商品'.ts,
              fontWeight: FontWeight.bold,
            )),
        Obx(
          () => Visibility(
            visible: controller.loadingUtil.value.list.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GoodsListCell(
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
