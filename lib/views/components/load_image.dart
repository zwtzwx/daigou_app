import 'package:jiyun_app_client/common/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImgItem extends StatelessWidget {
  const ImgItem(this.image,
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.format = "png",
      this.holderImg = "none"})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String format;
  final String holderImg;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image == "null") {
      return LoadAssetImage(holderImg,
          height: height, width: width, fit: fit, format: format);
    } else {
      if (image.startsWith("http")) {
        return CachedNetworkImage(
          memCacheWidth: 100,
          imageUrl: image,
          placeholder: (context, url) =>
              LoadAssetImage(holderImg, height: height, width: width, fit: fit),
          errorWidget: (context, url, error) =>
              LoadAssetImage(holderImg, height: height, width: width, fit: fit),
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
