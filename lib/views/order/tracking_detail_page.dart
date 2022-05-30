/*
  快递跟踪
*/
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/tracking_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/tracking_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';

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
  late String bannerImage;

  late String orderSn;

  @override
  void initState() {
    super.initState();
    orderSn = widget.arguments['order_sn'];

    getTrackingList();
    getBanner();
  }

  // 获取顶部 banner 图
  getBanner() async {
    var _tmp = await CommonService.getAllBannersInfo();
    setState(() {
      bannerImage = _tmp!.trackImage!;
    });
  }

  getTrackingList() async {
    var _dataList = await TrackingService.getList({'order_sn': orderSn});
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
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '物流详情',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isLoading
            ? SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  Column(
                    children: _buildTrackListView(context),
                  ),
                ],
              ))
            : Container());
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        color: ColorConfig.bgGray,
        child: Stack(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  isWeChatInstalled.then((installed) {
                    if (installed) {
                      openWeChatCustomerServiceChat(
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
                  margin: const EdgeInsets.only(top: 0, left: 15, right: 15),
                  width: ScreenUtil().screenWidth,
                  height: 150,
                  child: LoadImage(
                    bannerImage,
                    fit: BoxFit.contain,
                  ),
                )),
          ],
        ));
    return headerView;
  }

  // 物流消息列表
  List<Widget> _buildTrackListView(BuildContext context) {
    List<Widget> listView = [];
    listView.add(buildCustomViews(context));
    listView.add(const SizedBox(height: 10));
    for (var i = 0; i < dataList.length - 1; i++) {
      TrackingModel data = dataList[i];
      var cell = Container(
        color: ColorConfig.white,
        margin: const EdgeInsets.only(top: 0, left: 15, right: 15),
        height: 80,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 25, left: 25, top: 0),
              width: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  i != 0
                      ? Expanded(child: line)
                      : const SizedBox(
                          width: 0.5,
                          height: 30,
                        ),
                  Icon(
                      i == 0
                          ? Icons.check_circle_outline
                          : Icons.panorama_fish_eye,
                      color: i == 0 ? ColorConfig.green : ColorConfig.main),
                  Expanded(child: line),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().screenWidth - 120,
                    child: Caption(
                      fontSize: 17,
                      lines: 2,
                      str: data.context,
                      color: ColorConfig.textBlack,
                    ),
                  ),
                  Caption(
                    color: ColorConfig.textGray,
                    str: data.ftime,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      listView.add(cell);
    }

    TrackingModel lastModel = dataList.last;
    var cell = Container(
        color: ColorConfig.white,
        margin: const EdgeInsets.only(top: 0, left: 15, right: 15),
        height: 80,
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              margin: const EdgeInsets.only(right: 25, left: 25, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: line),
                  const Icon(
                    Icons.panorama_fish_eye,
                    color: ColorConfig.main,
                  ),
                  const SizedBox(
                    width: 0.5,
                    height: 30,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil().screenWidth - 120,
                  child: Caption(
                    fontSize: 17,
                    lines: 2,
                    str: lastModel.context,
                  ),
                ),
                Caption(
                  color: ColorConfig.textGray,
                  str: lastModel.ftime,
                ),
              ],
            )
          ],
        ));
    listView.add(cell);
    return listView;
  }
}

Widget line = const SizedBox(
  height: 60,
  width: 0.5,
  child: DecoratedBox(decoration: BoxDecoration(color: ColorConfig.green)),
);
