/*
  快递跟踪
*/
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/models/tracking_model.dart';
import 'package:shop_app_client/views/components/banner.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/order/tracking/tracking_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BeeOrderTrackPage extends GetView<BeeOrderTrackLogic> {
  const BeeOrderTrackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      primary: false,
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            bannerCell(),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Obx(
                () => Column(
                  children: trackingListCell(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bannerCell() {
    var headerView = Container(
        color: AppStyles.bgGray,
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
  List<Widget> trackingListCell() {
    List<Widget> listView = [];
    for (var i = 0; i <= controller.dataList.length - 1; i++) {
      TrackingModel model = controller.dataList[i];
      var cell = TimelineTile(
        isFirst: i == 0,
        isLast: i == controller.dataList.length - 1,
        indicatorStyle: IndicatorStyle(
          width: 17,
          height: 17,
          padding: const EdgeInsets.only(right: 10),
          drawGap: true,
          indicatorXY: 0,
          indicator: Icon(
            i == 0 ? Icons.check_circle : Icons.circle,
            size: 17,
            color: i == 0 ? AppStyles.green : Colors.grey[300],
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
            AppText(
              str: model.ftime,
              fontSize: 14,
              color: AppStyles.textGray,
            ),
            AppGaps.vGap10,
            AppText(
              str: model.context,
              lines: 10,
            ),
            AppGaps.vGap15,
          ],
        ),
        beforeLineStyle: LineStyle(
          thickness: 2,
          color: (i == 0 || i == 1) ? AppStyles.green : Colors.grey[300]!,
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
