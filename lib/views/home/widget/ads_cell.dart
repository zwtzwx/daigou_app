// 轮播图组件
import 'package:jiyun_app_client/common/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/models/ads_pic_model.dart';
import 'package:jiyun_app_client/services/ads_service.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class AdsCell extends StatefulWidget {
  const AdsCell({Key? key, this.onFansUrl}) : super(key: key);
  final Function? onFansUrl;

  @override
  HomeAdsState createState() => HomeAdsState();
}

class HomeAdsState extends State<AdsCell> with AutomaticKeepAliveClientMixin {
  List<AdsPicModel> adList = [];

  @override
  void initState() {
    super.initState();
    getAds();
    // Provider.of<BaseDataGetProvider>(context, listen: false).getUserData();
    ApplicationEvent.getInstance().event.on<HomeRefreshEvent>().listen((event) {
      getAds();
    });
  }

  @override
  bool get wantKeepAlive => true;

  // 获取轮播图
  getAds() async {
    List<AdsPicModel> result = await AdsService.getList(const {"source": 4});
    List<AdsPicModel> filterAdList = [];
    for (var item in result) {
      if (item.type == 1) {
        filterAdList.add(item);
      } else if (item.type == 2 &&
          item.position == 3 &&
          widget.onFansUrl != null) {
        widget.onFansUrl!(item.linkPath);
      }
    }
    if (kDebugMode) {
      print(filterAdList.length);
    }
    setState(() {
      adList = filterAdList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      // padding: const EdgeInsets.only(right: 10, top: 10, bottom: 20, left: 10),
      height: ScreenUtil().setHeight(160),
      child: Swiper(
        onTap: (index) {
          // Routers.push('/LineDetail', context);
          AdsPicModel model = adList[index];
          if (model.linkPath.startsWith('/pages')) {
            fluwx.isWeChatInstalled.then((installed) {
              if (installed) {
                fluwx
                    .launchWeChatMiniProgram(
                        username: 'gh_e9afa1eee63a', path: model.linkPath)
                    .then((data) {
                  if (kDebugMode) {
                    print("---》$data");
                  }
                });
              } else {
                Util.showToast("请先安装微信");
              }
            });
          } else {
            if (model.linkType == 1) {
              // 应用内
              Routers.push(
                  '/HelpSecondListPage', context, {'type': model.linkType});
            } else if (model.linkType == 2) {
              // 外部URL

              Routers.push('/webview', context,
                  {'url': model.linkPath, 'title': 'BeeGoplus集运', 'time': ''});
            } else if (model.linkType == 3) {
              // 公众号 URL
              Routers.push('/webview', context,
                  {'url': model.linkPath, 'title': 'BeeGoplus集运', 'time': ''});
            }
          }

          //  else if (model.type == 4) {
          //   Routers.push(
          //       '/HelpSecondListPage', context, {'type': model.linkType});
          // }
        },
        itemCount: adList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return LoadImage(
            adList[index].fullPath,
            fit: BoxFit.fitWidth,
          );
        },
        autoplay: adList.length > 1,
        pagination: buildPlugin(),
        // 相邻子条目视窗比例
        viewportFraction: 1,
        // 用户进行操作时停止自动翻页
        autoplayDisableOnInteraction: true,
        // 无线轮播
        loop: true,
        //当前条目的缩放比例
        scale: 1,
      ),
    );
  }

  buildPlugin() {
    return const SwiperPagination(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 55),
        builder: DotSwiperPaginationBuilder(
            color: Colors.grey,
            activeColor: Colors.white,
            size: 8,
            activeSize: 8));
  }
}
