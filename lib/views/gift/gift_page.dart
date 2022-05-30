/*
  福利页
*/

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/ads_pic_model.dart';
import 'package:jiyun_app_client/services/ads_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

/*
  福利页面
 */
class GiftPage extends StatefulWidget {
  const GiftPage({Key? key}) : super(key: key);

  @override
  GiftPageState createState() => GiftPageState();
}

class GiftPageState extends State<GiftPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  List<AdsPicModel> adList = [];
  List<AdsPicModel> coupons = [];
  List<AdsPicModel> activity = [];

  @override
  void initState() {
    super.initState();
    getAds();
  }

  // 获取顶部 banner 图
  getAds() async {
    EasyLoading.show();
    adList = await AdsService.getList(const {"source": 4, 'position': 3});
    setState(() {
      EasyLoading.dismiss();
      for (var item in adList) {
        //3是领券专区
        if (item.type == 3) {
          coupons.add(item);
        } else {
          activity.add(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '福利活动',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        body: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 40,
                color: ColorConfig.white,
                alignment: Alignment.centerLeft,
                child: const Caption(
                  str: '领券专区',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                color: ColorConfig.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: buildCouponsCell,
                  controller: _scrollController,
                  itemCount: coupons.length,
                  // availableList.length,
                ),
              ),
              Container(
                color: ColorConfig.white,
                height: 15,
              ),
              Container(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 40,
                color: ColorConfig.white,
                alignment: Alignment.centerLeft,
                child: const Caption(
                  str: '更多活动',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                color: ColorConfig.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: buildActivityCell,
                  controller: _scrollController,
                  itemCount: activity.length,
                  // unAvailableList.length,
                ),
              ),
              Container(
                color: ColorConfig.white,
                height: 15,
              ),
            ]));
  }

  //领券专区
  Widget buildCouponsCell(BuildContext context, int index) {
    AdsPicModel model = coupons[index];
    return GestureDetector(
        onTap: () {
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
            Routers.push('/webview', context,
                {'url': model.linkPath, 'title': 'BeeGoplus集运'});
          }
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
          ),
          child: LoadImage(
            model.fullPath,
            fit: BoxFit.contain,
          ),
        ));
  }

  // 其他活动
  Widget buildActivityCell(BuildContext context, int index) {
    AdsPicModel model = activity[index];
    return GestureDetector(
        onTap: () {
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
            Routers.push('/webview', context,
                {'url': model.linkPath, 'title': 'BeeGoplus集运'});
          }
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
          ),
          child: LoadImage(
            model.fullPath,
            fit: BoxFit.contain,
          ),
        ));
  }
}
