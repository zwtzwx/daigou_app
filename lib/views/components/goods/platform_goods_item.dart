import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/shop/platform_goods_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/utils/fetch_loading.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_binding.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_view.dart';

class PlatformGoodsCell extends StatelessWidget {
  const PlatformGoodsCell({
    Key? key,
    required this.goods,
    this.width,
    this.margin,
  }) : super(key: key);
  final PlatformGoodsModel goods;
  final double? width;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final currency = Get.find<AppStore>().currencyModel.value;
    return GestureDetector(
      onTap: () {
        // 提前获取接口
        // fetchLoading fetchloading = fetchLoading(type: 'goods_details');
        // fetchloading.fetchData({
        //   'goodsId':goods.id,
        //   'arguments': {'url': goods.detailUrl},
        // });
        // origin
        GlobalPages.toPage(
          GoodsDetailView(goodsId: goods.id.toString()),
          arguments: {'url': goods.detailUrl},
          binding: GoodsDetailBinding(tag: goods.id.toString()),
          authCheck: true,
        );
      },
      child: Container(
        width: width,
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: ImgItem(
                  goods.picUrl ?? '',
                  holderImg: 'Shop/goods_none',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35.h,
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 13.sp,
                              height: 1.2,
                            ),
                            children: [
                              // WidgetSpan(
                              //   child: Padding(
                              //     padding: EdgeInsets.only(right: 5.w),
                              //     child: ImgItem(
                              //       BaseUtils.getPlatformIcon(
                              //           goods.platform),
                              //       width: 16.w,
                              //       height: 16.w,
                              //     ),
                              //   ),
                              //   alignment: PlaceholderAlignment.middle,
                              // ),
                              TextSpan(text: goods.title.wordBreak),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                      children: [
                        TextSpan(
                          text: (currency?.code ?? '') + ' ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        TextSpan(
                          text: (goods.price ?? 0).priceConvert(
                              needFormat: false, showPriceSymbol: false),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Obx(
                  //       () => AppText(
                  //         str: (goods.price ?? 0).priceConvert(needFormat: false),
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     5.horizontalSpace,
                  //     Expanded(
                  //       child: Obx(
                  //         () => AppText(
                  //           str: '{count}人付款'.inArgs(
                  //             {'count': goods.sales},
                  //           ),
                  //           color: AppStyles.textGrayC9,
                  //           fontSize: 10,
                  //           alignment: TextAlign.right,
                  //           lines: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
