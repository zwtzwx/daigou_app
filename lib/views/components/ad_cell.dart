// 轮播图组件
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/home_refresh_event.dart';
import 'package:shop_app_client/models/ads_pic_model.dart';
import 'package:shop_app_client/services/ads_service.dart';
import 'package:shop_app_client/views/components/load_image.dart';

class AdsCell extends StatefulWidget {
  const AdsCell({
    Key? key,
    this.onFansUrl,
    required this.type,
    this.padding,
  }) : super(key: key);
  final Function? onFansUrl;
  final int type;
  final double? padding;

  @override
  HomeAdsState createState() => HomeAdsState();
}

class HomeAdsState extends State<AdsCell> with AutomaticKeepAliveClientMixin {
  List<BannerModel> adList = [];

  @override
  void initState() {
    super.initState();
    getAds();
    ApplicationEvent.getInstance().event.on<PageRefreshEvent>().listen((event) {
      getAds();
    });
  }

  @override
  bool get wantKeepAlive => true;

  // 获取轮播图
  getAds() async {
    List<BannerModel> result = await AdsService.getList({"source": 4});
    List<BannerModel> filterAdList = [];
    for (var item in result) {
      if (item.type == widget.type) {
        filterAdList.add(item);
      }
    }

    setState(() {
      adList = filterAdList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.padding ?? 12.w),
      height: 130.h,
      child: Swiper(
        onTap: (index) {
          BannerModel model = adList[index];
          BaseUtils.onAdLink(model);
        },
        itemCount: adList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: ImgItem(
              adList[index].fullPath,
              fit: BoxFit.cover,
            ),
          );
        },
        autoplay: adList.length > 1,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          builder: SwiperCustomPagination(builder: (context, config) {
            return customPagination(config.activeIndex, config.itemCount);
          }),
        ),
        // 无线轮播
        loop: adList.length > 1,
      ),
    );
  }

  Widget customPagination(int activeIndex, int itemCount) {
    List<Widget> list = [];
    for (var i = 0; i < itemCount; i++) {
      if (i == activeIndex) {
        list.add(
          Container(
            width: 12.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      } else {
        list.add(
          ClipOval(
            child: Container(
              width: 6.w,
              height: 6.w,
              color: const Color(0x8FFFFFFF),
            ),
          ),
        );
      }
      list.add(5.horizontalSpace);
    }
    return Row(
      children: list,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
