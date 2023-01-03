import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/tracking_model.dart';
import 'package:jiyun_app_client/services/tracking_service.dart';
import 'package:jiyun_app_client/views/components/banner.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/empty_box.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:timeline_tile/timeline_tile.dart';

/*
  物流跟踪
 */
class ExpressQueryPage extends StatefulWidget {
  const ExpressQueryPage({Key? key}) : super(key: key);

  @override
  State<ExpressQueryPage> createState() => _ExpressQueryPageState();
}

class _ExpressQueryPageState extends State<ExpressQueryPage> {
  final TextEditingController _expressNumController = TextEditingController();
  final FocusNode _expressNumNode = FocusNode();
  // 物流信息列表
  bool isSearch = false;
  List<TrackingModel> trackingList = [];

  @override
  void dispose() {
    _expressNumController.dispose();
    _expressNumNode.dispose();
    super.dispose();
  }

  // 物流查询
  onQuery() async {
    if (_expressNumController.text.isEmpty) {
      Util.showToast(Translation.t(context, '请输入快递单号'));
      return;
    }
    EasyLoading.show();
    var data = await TrackingService.getList({
      'track_no': _expressNumController.text,
    });
    EasyLoading.dismiss();
    setState(() {
      trackingList = data;
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: ColorConfig.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().setHeight(190),
              child: const BannerBox(imgType: 'track_image'),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSearchView(),
                  Gaps.vGap10,
                  isSearch ? buildResultView() : Gaps.empty,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 快递单号
  Widget buildSearchView() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: ZHTextLine(
              str: Translation.t(context, '物流跟踪'),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Gaps.line,
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 45,
              decoration: BoxDecoration(
                color: ColorConfig.line,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: BaseInput(
                        board: true,
                        controller: _expressNumController,
                        focusNode: _expressNumNode,
                        autoShowRemove: false,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        hintText: Translation.t(context, '请输入快递单号'),
                        onSubmitted: (data) {
                          onQuery();
                        },
                      ),
                    ),
                    MainButton(
                      text: '查询',
                      borderRadis: 0,
                      onPressed: onQuery,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // 物流结果
  Widget buildResultView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: trackingList.isEmpty
          ? emptyBox(context, '暂无物流信息')
          : ListView.builder(
              itemCount: trackingList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                TrackingModel model = trackingList[index];
                return TimelineTile(
                  isFirst: index == 0,
                  isLast: index == trackingList.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 17,
                    height: 17,
                    padding: const EdgeInsets.only(right: 10),
                    drawGap: true,
                    indicatorXY: 0,
                    indicator: Icon(
                      index == 0 ? Icons.check_circle : Icons.circle,
                      size: 17,
                      color: index == 0 ? ColorConfig.green : Colors.grey[300],
                    ),
                    iconStyle: index == 0
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
                    color: (index == 0 || index == 1)
                        ? ColorConfig.green
                        : Colors.grey[300]!,
                  ),
                  afterLineStyle: index > 0
                      ? LineStyle(
                          thickness: 2,
                          color: Colors.grey[300]!,
                        )
                      : null,
                );
              }),
    );
  }
}
