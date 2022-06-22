import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/views/home/widget/ads_cell.dart';
import 'package:jiyun_app_client/views/home/widget/comment_cell.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: _scaffoldKey,
        primary: false,
        appBar: const EmptyAppBar(),
        backgroundColor: ColorConfig.bgGray,
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
        widget = QuickLinkCell(context, fansUrl);
        break;
      case 2:
        widget = TitleCell(
            context, '渠道优选&推荐', () => {Routers.push('/LineAllPage', context)});
        break;
      case 3:
        widget = const RecommandShipLinesCell();
        break;
      case 4:
        widget = TitleCell(
            context, '用户晒单', () => {Routers.push('/CommentListPage', context)});
        break;
      case 5:
        widget = const CommentCell();
        break;
      default:
        widget = SizedBox(
          child: Stack(
            children: [
              Positioned(
                  child: AdsCell(
                onFansUrl: onFansUrl,
              )),
              const ModuleCell(),
            ],
          ),
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
