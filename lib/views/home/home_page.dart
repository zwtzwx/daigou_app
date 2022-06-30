import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/views/home/widget/ads_cell.dart';
import 'package:jiyun_app_client/views/home/widget/module_cell.dart';
import 'package:jiyun_app_client/views/home/widget/quick_link_cell.dart';
import 'package:jiyun_app_client/views/home/widget/recommand_ship_lines_cell.dart';

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
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: ColorConfig.themeRed,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: buildCellForFirstListView,
            controller: _scrollController,
            itemCount: 4,
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    ApplicationEvent.getInstance().event.fire(HomeRefreshEvent());
  }

  // 首页布局
  Widget buildCellForFirstListView(BuildContext context, int index) {
    Widget widget;
    switch (index) {
      case 1:
        widget = QuickLinkCell(context);
        break;
      case 2:
        widget = Container(
          padding: const EdgeInsets.only(left: 10, bottom: 15, top: 15),
          child: Caption(
            str: Translation.t(context, '超值路线'),
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case 3:
        widget = const RecommandShipLinesCell();
        break;
      default:
        widget = SizedBox(
          child: Stack(
            children: const [
              Positioned(
                child: AdsCell(),
              ),
              ModuleCell(),
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
