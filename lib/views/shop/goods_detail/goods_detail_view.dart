import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/utils/dotted_painting.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/views/components/base_search.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/error_box.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/skeleton/skeleton.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_controller.dart';

class GoodsDetailView extends GetView<GoodsDetailController> {
  const GoodsDetailView({Key? key, required this.goodsId}) : super(key: key);
  final String goodsId;

  @override
  String? get tag => goodsId;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        child: Scaffold(
          primary: false,
          appBar: const EmptyAppBar(),
          backgroundColor: AppStyles.bgGray,
          bottomNavigationBar: Obx(() => controller.goodsModel.value != null
              ? Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30.h,
                            child: BeeButton(
                              borderRadis: 12,
                              text: '购买',
                              backgroundColor: const Color(0xFFFFE1E2),
                              textColor: AppStyles.primary,
                              onPressed: () {
                                controller.showSkuModal('buy');
                              },
                            ),
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: SizedBox(
                            height: 30.h,
                            child: BeeButton(
                              borderRadis: 12,
                              text: '加入购物车',
                              backgroundColor: AppStyles.primary,
                              textColor: const Color(0xFFFFE1E2),
                              onPressed: () {
                                controller.showSkuModal('cart');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : AppGaps.empty),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: AppStyles.primary,
                  strokeWidth: 5,
                ),
              );
            } else if (controller.goodsModel.value != null) {
              return buildContentList(context);
            }

            return Stack(
              children: [
                Center(
                  child: ErrorBox(
                    onRefresh: controller.getGoodsDetail,
                  ),
                ),
                Positioned(
                  left: 15.w,
                  top: ScreenUtil().statusBarHeight + 5,
                  child: const BackButton(color: Colors.black),
                ),
              ],
            );
          }),
        ),
        value: SystemUiOverlayStyle.dark);
  }

  Widget buildContentList(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: controller.scrollController,
          children: [
            baseInfoCell(),
            // optionCell(context),
            processCell(),
            shopCell(),
            10.verticalSpaceFromWidth,
            Obx(() => commentsCell()),
            remarkCell(),
          ],
        ),
        Positioned(
          child: Obx(
            () => Container(
              padding: EdgeInsets.fromLTRB(
                  10.w, ScreenUtil().statusBarHeight + 5.h, 14.w, 10.h),
              decoration: BoxDecoration(
                  color: controller.prcent.value != 0
                      ? Colors.white.withOpacity(controller.prcent.value)
                      : Colors.transparent,
                  boxShadow: controller.prcent.value > 0.5
                      ? [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 10.r,
                            color: Colors.black.withOpacity(0.2),
                          )
                        ]
                      : null),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      child: Container(
                        margin: EdgeInsets.only(right: 3),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(150)),
                        child: LoadAssetImage(
                          'Guide/back-guide',
                          width: 22.w,
                          height: 22.w,
                        ),
                      ),
                    ),
                  ),
                  if (controller.prcent.value > 0)
                    const Expanded(child: BaseSearch()),
                  GestureDetector(
                    onTap: () {
                      GlobalPages.push(GlobalPages.cart);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 3),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(150)),
                      child: Obx(
                        () {
                          var cartCount = Get.find<AppStore>().cartCount.value;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  LoadAssetImage(
                                    'Home/ico_gwc',
                                    width: 22.w,
                                    height: 22.w,
                                  ),
                                  if (cartCount != 0)
                                    Positioned(
                                      right: -4.w,
                                      top: -4.w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppStyles.primary,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 1.w),
                                        child: AppText(
                                          str: cartCount.toString(),
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // AppText(
                              //   str: '购物车'.inte,
                              //   fontSize: 12,
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double getTextSpanWidth(String text, TextStyle style) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }
  int getTextSpanLines(String text, TextStyle style, double maxWidth) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 999, // 设置一个很大的值，确保可以计算出所有行数
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }

  Widget baseInfoCell() {
    TextStyle style = TextStyle(color: Color(0xff333333), fontSize: 16);
    double textWidth = ScreenUtil().screenWidth*2-14.w*14.5;
    print(textWidth);
    int lines = getTextSpanLines(controller
        .goodsModel.value!.title.wordBreak+'(测试-日本2月发售)', style, textWidth);
    print(lines);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SizedBox(
            height: 305.h,
            child: Swiper(
              autoplay: (controller.goodsModel.value?.images ?? []).length > 1,
              itemBuilder: (context, index) {
                return ImgItem(
                  controller.goodsModel.value!.images![index],
                  holderImg: 'Shop/goods_none',
                  fit: BoxFit.cover,
                );
              },
              loop: (controller.goodsModel.value?.images ?? []).length > 1,
              itemCount: controller.goodsModel.value?.images!.length ?? 0,
            ),
          ),
        ),
        Obx(
          () => defaultBoxItem(
            margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            // padding: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: controller.currencyModel.value?.code ?? '',
                            ),
                            WidgetSpan(child: 5.horizontalSpace),
                            TextSpan(
                              text: ((controller.sku.value?.price ??
                                          controller.goodsModel.value?.price ??
                                          0) *
                                      (controller.qty.value ?? 1))
                                  .priceConvert(
                                      showPriceSymbol: false,
                                      needFormat: false),
                              style: TextStyle(
                                fontSize: 26.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onPhotoSearch,
                      child: LoadAssetImage(
                        'Transport/ico_zxs',
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                    16.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        var data =
                            '${controller.goodsModel.value?.detailUrl} ${controller.goodsModel.value?.title}';
                        controller.onCopyData(data);
                      },
                      child: LoadAssetImage(
                        'Transport/ico_share',
                        width: 22.w,
                        height: 22.w,
                      ),
                    ),
                  ],
                ),
                6.verticalSpaceFromWidth,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 10,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 16.sp,
                              // height: 1.5,
                            ),
                            children: [
                              WidgetSpan(
                                child: controller.isPlatformGoods.value
                                    ? Container(
                                  margin: EdgeInsets.only(right: 5.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9A3E),
                                    borderRadius:
                                    BorderRadius.circular(2.r),
                                  ),
                                  padding: EdgeInsets.all(2.w),
                                  child: AppText(
                                    str: controller.platformName.inte,
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                )
                                    : AppGaps.empty,
                                alignment: PlaceholderAlignment.middle,
                              ),
                              TextSpan(
                                  text: controller
                                      .goodsModel.value!.title.wordBreak,
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 16
                                )),
                              TextSpan(
                                  text: '(测试-日本2月发售)',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 16
                                  )),


                            ],
                          ),
                          maxLines:controller.isExpand.value?100:controller.maxLines,
                          overflow: TextOverflow.ellipsis,
                        ),),
                    if(lines>1)Expanded(child:
                        GestureDetector(
                          onTap: (){
                            controller.isExpand.value = !controller.isExpand.value;
                            controller.isExpand.refresh();
                          },
                          child: Text(
                            controller.isExpand.value ? '收起' : '展开',
                            style: TextStyle(color: AppStyles.primary),
                          ),
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget optionCell(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -20.h),
      child: defaultBoxItem(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            optionItem(type: 'sku'),
            controller.isPlatformGoods.value
                ? Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          str: '国内运费'.inte,
                          fontSize: 12,
                          color: AppStyles.textGrayC9,
                        ),
                        10.verticalSpaceFromWidth,
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFD7D7D7)),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              width: 80.w,
                              height: 30.h,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(
                                    str: controller.currencyModel.value?.code ??
                                        '',
                                    fontSize: 14,
                                  ),
                                  3.horizontalSpace,
                                ],
                              ),
                            ),
                            20.horizontalSpace,
                            AppText(
                              str: '将寄往'.inte,
                              fontSize: 14,
                              color: AppStyles.textGrayC9,
                            ),
                            10.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                controller.showWarehousePicker(context);
                              },
                              child: AppText(
                                str: controller.selectedWarehouse.value
                                        ?.warehouseName ??
                                    '选择仓库'.inte,
                                fontSize: 14,
                              ),
                            ),
                            5.horizontalSpace,
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppStyles.textNormal,
                              size: 14.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : AppGaps.empty,
            // controller.isPlatformGoods.value
            //     ? optionItem(type: 'country')
            //     : AppGaps.empty,
          ],
        ),
      ),
    );
  }

  Widget optionItem({
    required String type,
    String? value,
  }) {
    return GestureDetector(
      onTap: () {
        if (type == 'sku') {
          controller.showSkuModal('select');
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    str: type == 'sku' ? '选择'.inte : '目的地'.inte,
                    fontSize: 12,
                    color: AppStyles.textGrayC9,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppStyles.textNormal,
                  size: 15.sp,
                ),
              ],
            ),
            10.verticalSpaceFromWidth,
            AppText(
              str: value ??
                  (type == 'sku'
                      ? (controller.sku.value == null
                          ? '产品规格'.inte
                          : '${controller.sku.value!.propertiesName} x${controller.qty.value}')
                      : '根据地区进行计算'.inte),
              fontSize: 14,
              lines: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget processCell() {
    return defaultBoxItem(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                decoration: BoxDecoration(
                    color: Color(0xffFFE6E6),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: AppText(
                  str: '从商家到海鸥'.inte,
                  color: Color(0xffFF3A3E),
                  fontSize: 12,
                  lines: 5,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                decoration: BoxDecoration(
                    color: Color(0xffFFE6E6),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: AppText(
                  str: '从海鸥到您'.inte,
                  color: Color(0xffFF3A3E),
                  fontSize: 12,
                  lines: 5,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          9.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xffFF3A3E)),
                  ),
                ),
              ),
              // DottedBorder(
              //   dashPattern: [6, 2],
              //   color: Color(0xffFF8789),
              //   strokeWidth: 2,
              //     child:Container(
              //       width: 120.w,
              //     )
              // ),
              Container(
                width: 120.w,
                child: DottedLine(
                  direction: Axis.horizontal,
                  color: Color(0xffFF8789),
                  height: 2.w,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xffFF3A3E)),
                  ),
                ),
              ),
              // DottedBorder(
              //     dashPattern: [6, 2],
              //     color: Color(0xffFF8789),
              //     strokeWidth: 2,
              //     child:Container(
              //       width: 120.w,
              //     )
              // ),
              Container(
                width: 120.w,
                child: DottedLine(
                  direction: Axis.horizontal,
                  color: Color(0xffFF8789),
                  height: 2.w,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xffFF3A3E)),
                  ),
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                str: '商家发货'.inte,
                color: Color(0xff333333),
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
              AppText(
                str: '海鸥认证仓库'.inte,
                color: Color(0xff333333),
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
              AppText(
                str: '包裹交付'.inte,
                color: Color(0xff333333),
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget shopCell() {
    return defaultBoxItem(
      child: Row(
        children: [
          ImgItem(
            'Shop/shop',
            width: 30.w,
            height: 30.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: AppText(
              str: controller.isPlatformGoods.value
                  ? controller.goodsModel.value!.nick ?? ''
                  : '自营商城'.inte,
              lines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget commentsCell() {
    return controller.commentLoading.value
        ? Skeleton(
            type: SkeletonType.singleSkeleton,
            lineCount: 5,
            height: 100.h,
            borderRadius: 8,
            margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
          )
        : (controller.comments.isNotEmpty
            ? GestureDetector(
                onTap: controller.onShowCommentSheet,
                child: defaultBoxItem(
                  margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              str: '商品评价'.inte +
                                  '(${controller.commentsTotal.value})',
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14.sp,
                            color: AppStyles.textGrayC9,
                          ),
                        ],
                      ),
                      ...controller.comments.map(
                        (item) => Container(
                          margin: EdgeInsets.only(top: 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                str: item.displayUserNick ?? '',
                              ),
                              8.verticalSpaceFromWidth,
                              AppText(
                                str: item.rateContent ?? '',
                                color: const Color(0xff555555),
                                lines: 20,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AppGaps.empty);
  }

  Widget remarkCell() {
    return defaultBoxItem(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: AppText(
              str: '商品详情'.inte,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Obx(() => controller.goodsModel.value!.desc!.isNotEmpty
              ? Html(
                  data: controller.goodsModel.value!.desc,
                  style: {
                    'img': Style(
                      width: Width(330.w, Unit.px),
                    ),
                  },
                )
              : AppGaps.empty),
        ],
      ),
    );
  }

  Widget defaultBoxItem({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: child,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
