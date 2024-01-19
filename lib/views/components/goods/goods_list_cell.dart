import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/models/shop/goods_model.dart';
import 'package:huanting_shop/models/shop/platform_goods_model.dart';
import 'package:huanting_shop/views/components/goods/goods_item.dart';
import 'package:huanting_shop/views/components/goods/platform_goods_item.dart';

class BeeShopGoodsList extends StatelessWidget {
  const BeeShopGoodsList({
    Key? key,
    this.color = Colors.white,
    this.goodsList,
    this.platformGoodsList,
    this.isPlatformGoods = false,
  }) : super(key: key);
  final Color color;
  final List<GoodsModel>? goodsList;
  final List<PlatformGoodsModel>? platformGoodsList;
  final bool isPlatformGoods;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          isPlatformGoods ? platformGoodsList?.length ?? 0 : goodsList?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 7 / 11,
      ),
      itemBuilder: (context, index) {
        if (isPlatformGoods) {
          return PlatformGoodsCell(
            goods: platformGoodsList![index],
          );
        } else {
          return BeeShopGoods(
            bgColor: color,
            goods: goodsList![index],
          );
        }
      },
    );
  }
}
