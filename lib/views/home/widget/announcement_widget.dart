// 公告轮播组件
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class AnnouncementWidget extends StatefulWidget {
  const AnnouncementWidget({Key? key}) : super(key: key);

  @override
  AnnouncementState createState() => AnnouncementState();
}

class AnnouncementState extends State<AnnouncementWidget>
    with AutomaticKeepAliveClientMixin {
  List<AnnouncementModel> adList = [];
  @override
  void initState() {
    super.initState();
    getAds();
    ApplicationEvent.getInstance().event.on<HomeRefreshEvent>().listen((event) {
      getAds();
    });
  }

  @override
  bool get wantKeepAlive => true;

  // 获取轮播图
  getAds() async {
    // 获取公告列表
    var data = await AnnouncementService.getList();
    setState(() {
      if (data['dataList'] != null) {
        adList = data['dataList'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: ColorConfig.white,
      padding: const EdgeInsets.only(right: 0, top: 0, bottom: 0, left: 0),
      height: 40,
      child: Swiper(
        onTap: (index) {
          // Routers.push('/LineDetail', context);
          // 公告
          AnnouncementModel model = adList[index];
          if (model.content.startsWith('/pages')) {
            fluwx.isWeChatInstalled.then((installed) {
              if (installed) {
                fluwx
                    .launchWeChatMiniProgram(
                        username: 'gh_e9afa1eee63a', path: model.content)
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
            Routers.push('/webview', context, {
              'url': model.content,
              'title': model.title,
              'time': model.createdAt
            });
          }
        },
        itemCount: adList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          AnnouncementModel model = adList[index];
          return Container(
            alignment: Alignment.centerLeft,
            color: ColorConfig.white,
            child: Caption(
              str: '公告: ' + model.title,
              color: ColorConfig.warningTextDark,
            ),
          );
        },
        autoplay: adList.length > 1,
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
}
