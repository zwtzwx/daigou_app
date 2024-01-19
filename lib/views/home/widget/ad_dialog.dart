import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/models/ads_pic_model.dart';
import 'package:huanting_shop/views/components/load_image.dart';

class AdDialog extends StatelessWidget {
  const AdDialog({
    Key? key,
    required this.adItem,
  }) : super(key: key);
  final BannerModel adItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            CommonMethods.onAdLink(adItem);
          },
          child: ImgItem(
            adItem.fullPath,
            width: 300.w,
          ),
        ),
        20.verticalSpaceFromWidth,
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.cancel_outlined,
            color: Colors.white,
            size: 30.sp,
          ),
        ),
      ],
    );
  }
}
