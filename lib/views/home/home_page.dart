import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:jiyun_app_client/views/home/widget/ads_cell.dart';
import 'package:jiyun_app_client/views/home/widget/announcement_cell.dart';
import 'package:jiyun_app_client/views/home/widget/module_cell.dart';
import 'package:jiyun_app_client/views/home/widget/quick_link_cell.dart';
import 'package:jiyun_app_client/views/home/widget/recommand_ship_lines_cell.dart';
import 'package:jiyun_app_client/views/home/widget/title_cell.dart';

/*
  首页
*/
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

/*
  首页
 */
class HomePageState extends State<HomePage> {
  // @override
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String fansUrl = ''; // 入群福利链接

  @override
  void initState() {
    super.initState();
    getIndexAnnoucement();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 最新公告
  getIndexAnnoucement() async {
    var data = await AnnouncementService.getLatest();
    String uniqueId = await AnnoucementStorage.getUniqueId();
    if (data != null && data.uniqueId != uniqueId) {
      await AnnoucementStorage.setUniqueId(data.uniqueId);
      onShowAnnoucement(data);
    }
  }

  // 显示公告弹窗
  onShowAnnoucement(AnnouncementModel data) async {
    bool detail = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AnnoucementDialog(
        model: data,
      ),
    );
    if (detail) {
      Routers.push('/webview', context, {
        'url': data.content,
        'title': data.title,
        'time': data.createdAt,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: 'BeeGoPlus集运',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      floatingActionButton: GestureDetector(
          onTap: () {
            fluwx.isWeChatInstalled.then((installed) {
              if (installed) {
                fluwx
                    .openWeChatCustomerServiceChat(
                        url:
                            'https://work.weixin.qq.com/kfid/kfcd1850645a45f5db4',
                        corpId: 'ww82affb1cf55e55e0')
                    .then((data) {});
              } else {
                Util.showToast("请先安装微信");
              }
            });
          },
          child: Container(
              height: 60,
              width: 80,
              decoration: const BoxDecoration(
                  color: ColorConfig.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                        blurRadius: 0.1, //阴影模糊程度
                        spreadRadius: 0.1 //阴影扩散程度
                        )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/TabbarIcon/在线客服@3x.png',
                    ),
                  ),
                  const Caption(
                    str: '联系客服',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ))),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endDocked, 20, -20),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: ColorConfig.themeRed,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: buildCellForFirstListView,
          controller: _scrollController,
          itemCount: 6,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    ApplicationEvent.getInstance().event.fire(HomeRefreshEvent());
  }

  void onFansUrl(String url) {
    setState(() {
      fansUrl = url;
    });
  }

  // 首页布局
  Widget buildCellForFirstListView(BuildContext context, int index) {
    Widget widget;
    switch (index) {
      case 1:
        widget = AnnouncementCell(context);
        break;
      case 2:
        widget = ModuleCell(context);
        break;
      case 3:
        widget = QuickLinkCell(context, fansUrl);
        break;
      case 4:
        widget = TitleCell(context);
        break;
      case 5:
        widget = const RecommandShipLinesCell();
        break;
      default:
        widget = AdsCell(
          onFansUrl: onFansUrl,
        );
    }
    return widget;
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
