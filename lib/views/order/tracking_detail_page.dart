/*
  快递跟踪
*/
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/tracking_model.dart';
import 'package:jiyun_app_client/services/tracking_service.dart';
import 'package:jiyun_app_client/views/components/banner.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackingDetailPage extends StatefulWidget {
  final Map arguments;
  const TrackingDetailPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  TrackingDetailPageState createState() => TrackingDetailPageState();
}

class TrackingDetailPageState extends State<TrackingDetailPage> {
  bool isLoading = false;
  List<TrackingModel> dataList = [];

  late String orderSn;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    orderSn = widget.arguments['order_sn'];
    getTrackingList();
  }

  getTrackingList() async {
    var _dataList = await TrackingService.getList({'track_no': orderSn});
    setState(() {
      isLoading = true;

      dataList = _dataList;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const EmptyAppBar(),
        primary: false,
        backgroundColor: ColorConfig.bgGray,
        body: isLoading
            ? SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  buildCustomViews(),
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: _buildTrackListView(),
                    ),
                  ),
                ],
              ))
            : Container());
  }

  Widget buildCustomViews() {
    var headerView = Container(
        color: ColorConfig.bgGray,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().setHeight(190),
              child: const BannerBox(imgType: 'track_image'),
            ),
            Positioned(
                top: ScreenUtil().statusBarHeight,
                left: 10,
                child: const BackButton(
                  color: Colors.white,
                )),
          ],
        ));
    return headerView;
  }

  // 物流消息列表
  List<Widget> _buildTrackListView() {
    List<Widget> listView = [];
    for (var i = 0; i <= dataList.length - 1; i++) {
      TrackingModel model = dataList[i];
      var cell = TimelineTile(
        isFirst: i == 0,
        isLast: i == dataList.length - 1,
        indicatorStyle: IndicatorStyle(
          width: 17,
          height: 17,
          padding: const EdgeInsets.only(right: 10),
          drawGap: true,
          indicatorXY: 0,
          indicator: Icon(
            i == 0 ? Icons.check_circle : Icons.circle,
            size: 17,
            color: i == 0 ? ColorConfig.green : Colors.grey[300],
          ),
          iconStyle: i == 0
              ? IconStyle(
                  iconData: Icons.check,
                  fontSize: 15,
                  color: Colors.white,
                )
              : null,
        ),
        endChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ZHTextLine(
              str: model.ftime,
              fontSize: 14,
              color: ColorConfig.textGray,
            ),
            Gaps.vGap10,
            ZHTextLine(
              str: model.context,
              lines: 10,
            ),
            Gaps.vGap15,
          ],
        ),
        beforeLineStyle: LineStyle(
          thickness: 2,
          color: (i == 0 || i == 1) ? ColorConfig.green : Colors.grey[300]!,
        ),
        afterLineStyle: i > 0
            ? LineStyle(
                thickness: 2,
                color: Colors.grey[300]!,
              )
            : null,
      );
      listView.add(cell);
    }

    return listView;
  }
}

Widget line = const SizedBox(
  height: 60,
  width: 0.5,
  child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFE5E5E5))),
);
