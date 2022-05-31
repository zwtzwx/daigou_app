// 超值线路组件
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/localization_service.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:jiyun_app_client/views/home/widget/ship_line_item.dart';

class RecommandShipLinesCell extends StatefulWidget {
  const RecommandShipLinesCell({Key? key}) : super(key: key);

  @override
  _RecommandShipLinesState createState() => _RecommandShipLinesState();
}

class _RecommandShipLinesState extends State<RecommandShipLinesCell>
    with AutomaticKeepAliveClientMixin {
  List<ShipLineModel> lineList = [];
  LocalizationModel? localModel;
  bool _isLoading = false;
  final bool _isLoadingLocal = true;

  @override
  void initState() {
    super.initState();
    loadData();
    ApplicationEvent.getInstance().event.on<HomeRefreshEvent>().listen((event) {
      setState(() {
        _isLoading = false;
        loadData();
      });
    });
  }

  loadData() async {
    List<ShipLineModel> result =
        await ShipLineService.getList(const {'is_great_value': 1});

    var localiztion = await LocalizationService.getInfo();
    setState(() {
      lineList = result;
      localModel = localiztion;
      _isLoading = true;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading && _isLoadingLocal
        ? SizedBox(
            height: 330,
            child: Swiper(
              itemHeight: 300,
              itemCount: lineList.length % 3 == 0
                  ? lineList.length ~/ 3
                  : lineList.length ~/ 3 + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return layoutSubViews(index);
              },
              autoplay: lineList.length > 3,
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
          )
        : Container();
  }

  Widget layoutSubViews(int index) {
    List<ShipLineModel> indexList = [];
    int totalIndex =
        lineList.length % 3 == 0 ? lineList.length ~/ 3 : lineList.length ~/ 3;
    if (index != totalIndex) {
      for (var i = 0; i < 3; i++) {
        indexList.add(lineList[index * 3 + i]);
      }
    } else {
      if (lineList.length % 3 == 0) {
        for (var i = 0; i < 3; i++) {
          indexList.add(lineList[index * 3 + i]);
        }
      } else {
        for (var i = 0; i < lineList.length - index * 3; i++) {
          indexList.add(lineList[index * 3 + i]);
        }
      }
    }
    var swiperView = SizedBox(
      height: 440,
      width: ScreenUtil().screenWidth,
      child: Column(children: _buildGrideForRoute(indexList)),
    );
    return swiperView;
  }

  _buildGrideForRoute(List<ShipLineModel> lineList) {
    List<Widget> lineCell = [];

    for (ShipLineModel lineItem in lineList) {
      String propStr = '';
      if (lineItem.props != null) {
        for (var item in lineItem.props!) {
          if (propStr.isEmpty) {
            propStr = item.name!;
          } else {
            propStr = propStr + ',' + item.name!;
          }
        }
      }
      var view = buildLineItem(context, lineItem, propStr, localModel);
      lineCell.add(view);
    }
    return lineCell;
  }

  buildPlugin() {
    return SwiperPagination(
      builder: DotSwiperPaginationBuilder(
        color: Colors.grey[300],
        activeColor: const Color(0xFF888888),
        size: 8,
        activeSize: 8,
      ),
    );
  }
}
