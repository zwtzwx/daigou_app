import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/shop/goods_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';

class BeeShopGoods extends StatelessWidget {
  const BeeShopGoods({
    Key? key,
    this.bgColor = Colors.white,
    required this.goods,
    this.width,
    this.margin,
  }) : super(key: key);
  final Color bgColor;
  final GoodsModel goods;
  final double? width;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BeeNav.push(BeeNav.goodsDetail, {'id': goods.id});
      },
      child: Container(
        width: width,
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: ImgItem(
                  goods.images.isNotEmpty ? goods.images[0] : '',
                  holderImg: 'Shop/goods_none',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 35.h,
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.4,
                          color: AppColors.textDark,
                        ),
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: ImgItem(
                                'Shop/zy',
                                width: 16.w,
                                height: 16.w,
                              ),
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(text: goods.name.wordBreak),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  5.verticalSpace,
                  Obx(
                    () => AppText(
                      str: num.parse(goods.goodsLowestPrice ?? '0.00')
                          .rate(needFormat: false),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // Obx(
                  //   () => AppText(
                  //     str: '已卖{count}件'.tsArgs({'count': goods.saleCount}),
                  //     fontSize: 10,
                  //     color: AppColors.textGrayC9,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
