import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
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
    return GestureDetector(
      onTap: () {
        BeeNav.push(BeeNav.goodsDetail, {'url': goods.detailUrl});
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
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: ImgItem(
                                    CommonMethods.getPlatformIcon(
                                        goods.platform),
                                    width: 16.w,
                                    height: 16.w,
                                  ),
                                ),
                                alignment: PlaceholderAlignment.middle,
                              ),
                              TextSpan(text: goods.title.wordBreak),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => AppText(
                          str: (goods.price ?? 0).rate(needFormat: false),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      5.horizontalSpace,
                      Expanded(
                        child: Obx(
                          () => AppText(
                            str: '{count}人付款'.tsArgs(
                              {'count': goods.sales},
                            ),
                            color: AppColors.textGrayC9,
                            fontSize: 10,
                            alignment: TextAlign.right,
                            lines: 2,
                          ),
                        ),
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
