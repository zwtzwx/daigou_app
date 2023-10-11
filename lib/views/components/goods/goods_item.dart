import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/goods_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    str: goods.name,
                    fontSize: 13,
                    color: AppColors.textDark,
                    lines: 2,
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => AppText(
                          str: num.parse(goods.goodsLowestPrice ?? '0.00')
                              .rate(needFormat: false),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Obx(
                        () => AppText(
                          str: '已卖{count}件'.tsArgs({'count': goods.saleCount}),
                          fontSize: 10,
                          color: AppColors.textGrayC9,
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
    );
  }
}
