import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';

class CartCell extends StatefulWidget {
  const CartCell({Key? key}) : super(key: key);

  @override
  State<CartCell> createState() => _CartCellState();
}

class _CartCellState extends State<CartCell>
    with AutomaticKeepAliveClientMixin {
  late double topOffset;

  @override
  void initState() {
    super.initState();
    topOffset = 320.h;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Positioned(
      right: 12.w,
      top: topOffset,
      child: GestureDetector(
        onPanUpdate: (detail) {
          onDrag(detail.delta);
        },
        onTap: () {
          BeeNav.push(BeeNav.cart);
        },
        child: Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x140F3057),
                offset: Offset(0, 5.w),
                blurRadius: 19.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
          padding: EdgeInsets.all(11.w),
          child: Obx(() {
            var cartCount = Get.find<AppStore>().cartCount.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                const ImgItem(
                  'Center/ico_gwc',
                ),
                if (cartCount != 0)
                  Positioned(
                    right: -1.w,
                    top: -1.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                      child: AppText(
                        str: cartCount.toString(),
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void onDrag(Offset offset) {
    double dy = 0;
    // 垂直方向偏移量不能小于0不能大于屏幕最大高度
    var maxTopOffset = ScreenUtil().statusBarHeight + 50.h;
    if (topOffset + offset.dy <= maxTopOffset) {
      dy = maxTopOffset;
    } else if (topOffset + offset.dy >= (1.sh - 230.h)) {
      dy = 1.sh - 230.h;
    } else {
      dy = topOffset + offset.dy;
    }
    setState(() {
      topOffset = dy;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
