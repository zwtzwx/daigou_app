import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/goods_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/goods_item.dart';
import 'package:jiyun_app_client/views/components/goods/platform_goods_item.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class GoodsListCell extends StatelessWidget {
  const GoodsListCell({
    Key? key,
    this.color = Colors.white,
    this.goodsList,
    this.platformGoodsList,
    this.isPlatformGoods = false,
    this.firstPlaceholder = false,
  }) : super(key: key);
  final Color color;
  final List<GoodsModel>? goodsList;
  final List<PlatformGoodsModel>? platformGoodsList;
  final bool isPlatformGoods;
  final bool firstPlaceholder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: isPlatformGoods
          ? ((platformGoodsList?.length ?? 0) + (firstPlaceholder ? 1 : 0))
          : goodsList?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 7 / 11,
      ),
      itemBuilder: (context, index) {
        if (isPlatformGoods) {
          if (firstPlaceholder) {
            if (index == 0) {
              return buildShopEnterCell();
            } else {
              return PlatformGoodsCell(
                goods: platformGoodsList![index - 1],
              );
            }
          } else {
            return PlatformGoodsCell(
              goods: platformGoodsList![index],
            );
          }
        } else {
          return GoodsItem(
            bgColor: color,
            goods: goodsList![index],
          );
        }
      },
    );
  }

  Widget buildShopEnterCell() {
    return Stack(
      fit: StackFit.expand,
      children: [
        const LoadImage(
          'https://api-jiyun-v3.haiouoms.com/storage/admin/20230817-q1npSlv5DECuAVcq.png',
          fit: BoxFit.fill,
        ),
        Positioned(
          bottom: 30.h,
          left: 30.w,
          right: 30.w,
          child: GestureDetector(
            onTap: () {
              Routers.push(Routers.shopCenter);
            },
            child: Container(
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xA6757E83),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(blurRadius: 5.r, color: const Color(0x63FFFFFF)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZHTextLine(
                    str: '更多商品'.ts,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  3.horizontalSpace,
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
