import 'package:flutter/material.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

/*
  顶部 banner 图
 */
class BannerBox extends StatefulWidget {
  final String imgType;
  const BannerBox({
    Key? key,
    required this.imgType,
  }) : super(key: key);

  @override
  State<BannerBox> createState() => _BannerBoxState();
}

class _BannerBoxState extends State<BannerBox>
    with AutomaticKeepAliveClientMixin {
  BannersModel allimagesModel = BannersModel();

  @override
  void initState() {
    super.initState();
    getBanner();
  }

  @override
  bool get wantKeepAlive => true;

  // 获取顶部 banner 图
  void getBanner() async {
    var imageList = await CommonService.getAllBannersInfo();
    setState(() {
      allimagesModel = imageList!;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadImage(
      allimagesModel.toJson()[widget.imgType] ?? '',
      fit: BoxFit.fitWidth,
    );
  }
}
