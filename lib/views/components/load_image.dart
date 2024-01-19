import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/common/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/config/color_config.dart';

class ImgItem extends StatelessWidget {
  const ImgItem(this.image,
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.placeholderWidget,
      this.format = "png",
      this.holderImg})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String format;
  final String? holderImg;
  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image == "null") {
      return LoadAssetImage(holderImg ?? 'none',
          height: height, width: width, fit: fit, format: format);
    } else {
      if (image.startsWith("http")) {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => holderImg != null
              ? LoadAssetImage(
                  holderImg!,
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  color: AppColors.textGrayC,
                  child: LoadAssetImage(
                    'Center/logo-w',
                    width: 50.w,
                    height: 50.w,
                  ),
                ),
          errorWidget: (context, url, error) => holderImg != null
              ? LoadAssetImage(
                  holderImg!,
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  color: AppColors.textGrayC,
                  child: LoadAssetImage(
                    'Center/logo-w',
                    width: 50.w,
                    height: 50.w,
                  ),
                ),
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return LoadAssetImage(image,
            height: height, width: width, fit: fit, format: format);
      }
    }
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.format = 'png',
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String format;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageUtil.getImgPath(image, format: format),
      height: height,
      width: width,
      fit: fit,
    );
  }
}
