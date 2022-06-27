// 轮播图组件
import 'package:flutter/cupertino.dart';
import 'package:jiyun_app_client/common/translation.dart';
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
import 'package:jiyun_app_client/models/language_model.dart';
import 'package:jiyun_app_client/provider/language_provider.dart';
import 'package:jiyun_app_client/services/ads_service.dart';
import 'package:jiyun_app_client/services/language_service.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

class AdsCell extends StatefulWidget {
  const AdsCell({Key? key, this.onFansUrl}) : super(key: key);
  final Function? onFansUrl;

  @override
  HomeAdsState createState() => HomeAdsState();
}

class HomeAdsState extends State<AdsCell> with AutomaticKeepAliveClientMixin {
  List<AdsPicModel> adList = [];
  List<LanguageModel> langList = [];

  @override
  void initState() {
    super.initState();
    getAds();
    getLanguages();
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
      }
    }
    if (kDebugMode) {
      print(filterAdList.length);
    }
    setState(() {
      adList = filterAdList;
    });
  }

  // 获取语言列表
  getLanguages() async {
    var data = await LanguageService.getLanguage();
    setState(() {
      langList = data;
    });
  }

  showLanguage() async {
    var code = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: langList.map((e) {
            return CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, e.languageCode);
                },
                child: Text(
                  e.name,
                ));
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              Translation.t(context, '取消'),
            ),
          ),
        );
      },
    );
    if (code != null) {
      String languge =
          Provider.of<LanguageProvider>(context, listen: false).languge;
      if (code == languge) return;
      await LanguageStore.setLanguage(code);
      ApplicationEvent.getInstance().event.fire(HomeRefreshEvent());
      Provider.of<LanguageProvider>(context, listen: false).setLanguage(code);
      Provider.of<LanguageProvider>(context, listen: false).loadTranslations();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        SizedBox(
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
                    Util.showToast(Translation.t(context, '请先安装微信'));
                  }
                });
              } else {
                if (model.linkType == 1) {
                  // 应用内
                  Routers.push(
                      '/HelpSecondListPage', context, {'type': model.linkType});
                } else if (model.linkType == 2) {
                  // 外部URL

                  Routers.push('/webview', context, {
                    'url': model.linkPath,
                    'title': 'BeeGoplus集运',
                    'time': ''
                  });
                } else if (model.linkType == 3) {
                  // 公众号 URL
                  Routers.push('/webview', context, {
                    'url': model.linkPath,
                    'title': 'BeeGoplus集运',
                    'time': ''
                  });
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
        ),
        buildLanguageView(),
      ],
    );
  }

  buildPlugin() {
    return const SwiperPagination(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
        builder: DotSwiperPaginationBuilder(
            color: Colors.grey,
            activeColor: Colors.white,
            size: 8,
            activeSize: 8));
  }

  // 支持语言
  Widget buildLanguageView() {
    String language = Provider.of<LanguageProvider>(context).languge;
    var codeList = language.split('_');
    String codeStr = codeList.length > 1 ? codeList[1] : codeList[0];
    return Positioned(
      left: 10,
      top: ScreenUtil().statusBarHeight + 10,
      child: GestureDetector(
        onTap: showLanguage,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0x33000000),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4DFFFFFF)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Caption(
                  str: codeStr,
                ),
              ),
              Gaps.hGap15,
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
