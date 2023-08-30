import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

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
    final textPainter = TextPainter(
      text: TextSpan(text: goods.title, style: TextStyle(fontSize: 13.sp)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (1.sw - 34.w) / 2 - 41.w);
    final maxChars = textPainter
        .getPositionForOffset(Offset((1.sw - 34.w) / 2 - 41.w, 0))
        .offset
        .toInt();
    return GestureDetector(
      onTap: () {
        Routers.push(Routers.goodsDetail, {'url': goods.detailUrl});
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
                child: LoadImage(
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
                        Row(
                          children: [
                            LoadImage(
                              'Home/tao',
                              width: 16.w,
                              height: 16.w,
                            ),
                            5.horizontalSpace,
                            ZHTextLine(
                              str: goods.title.length > maxChars
                                  ? goods.title.substring(0, maxChars)
                                  : goods.title,
                              fontSize: 13,
                              color: BaseStylesConfig.textDark,
                            ),
                          ],
                        ),
                        Container(
                          child: goods.title.length > maxChars
                              ? ZHTextLine(
                                  str: goods.title.substring(maxChars),
                                  fontSize: 13,
                                  color: BaseStylesConfig.textDark,
                                )
                              : Sized.empty,
                        ),
                      ],
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => ZHTextLine(
                          str: (goods.price ?? 0).rate(needFormat: false),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ZHTextLine(
                        str: '{count}人付款'.tsArgs(
                          {'count': (goods.sales ?? 0).toString()},
                        ),
                        color: BaseStylesConfig.textGrayC9,
                        fontSize: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
