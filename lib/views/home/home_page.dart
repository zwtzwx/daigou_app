import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/storage/annoucement_storage.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/home/widget/annoucement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/views/home/widget/ads_cell.dart';
import 'package:jiyun_app_client/views/home/widget/module_cell.dart';
import 'package:jiyun_app_client/views/home/widget/quick_link_cell.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
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
  late double leftOffset;
  late double topOffset;

  @override
  void initState() {
    super.initState();
    getIndexAnnoucement();
    leftOffset = ScreenUtil().screenWidth - 55;
    topOffset = ScreenUtil().screenHeight - 200;
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
        'id': data.id,
        'title': data.title,
        'time': data.createdAt,
        'type': 'notice',
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
        body: Stack(
          children: [
            RefreshIndicator(
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
            buildContactView(),
          ],
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

  // 客服
  Widget buildContactView() {
    return Positioned(
      left: leftOffset,
      top: topOffset,
      child: GestureDetector(
        onTap: () async {
          var showWechat = await fluwx.isWeChatInstalled;
          BaseDialog.customerDialog(context, showWechat);
        },
        onPanUpdate: (detail) {
          _calcOffset(detail.delta);
        },
        onPanEnd: (detail) {},
        child: Container(
          decoration: BoxDecoration(
            color: ColorConfig.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          width: 50,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/Home/customer.svg',
                width: 25,
                height: 25,
              ),
              Caption(
                str: Translation.t(context, '客服'),
                color: Colors.white,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcOffset(Offset offset) {
    var screenWidth = ScreenUtil().screenWidth;
    var screentHeight = ScreenUtil().screenHeight;
    double dx = 0;
    double dy = 0;
    // 水平方向偏移量不能小于0不能大于屏幕最大宽度
    if (leftOffset + offset.dx <= 0) {
      dx = 0;
    } else if (leftOffset + offset.dx >= (screenWidth - 50)) {
      dx = screenWidth - 50;
    } else {
      dx = leftOffset + offset.dx;
    }
    // 垂直方向偏移量不能小于0不能大于屏幕最大高度
    if (topOffset + offset.dy <= ScreenUtil().statusBarHeight) {
      dy = ScreenUtil().statusBarHeight;
    } else if (topOffset + offset.dy >= (screentHeight - 150)) {
      dy = screentHeight - 150;
    } else {
      dy = topOffset + offset.dy;
    }
    setState(() {
      leftOffset = dx;
      topOffset = dy;
    });
  }
}
