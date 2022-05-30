// 超值线路组件
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/ship_line_price_model.dart';
import 'package:jiyun_app_client/services/localization_service.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

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
        ? Container(
            margin: const EdgeInsets.only(bottom: 30),
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
      var view = GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print(lineItem);
          }
          Routers.push(
              '/LineDetailPage', context, {'id': lineItem.id, 'type': 1});
        },
        child: Container(
            height: 90,
            width: ScreenUtil().screenWidth - 20,
            margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: ColorConfig.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: ColorConfig.warningText,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  height: 90,
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 34,
                          width: (ScreenUtil().screenWidth - 40) * 4 / 5 - 35,
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 6, right: 5),
                          child: Caption(
                            str: lineItem.name,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 34,
                          width: (ScreenUtil().screenWidth - 40) / 5 + 40,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10, right: 5),
                          child: Caption(
                            str: lineItem.region!.referenceTime,
                            color: ColorConfig.textGray,
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                    Gaps.vGap4,
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: getSecondLineDetail(lineItem),
                    ),
                    Gaps.vGap4,
                    Container(
                      width: ScreenUtil().screenWidth - 60,
                      margin: const EdgeInsets.only(left: 10),
                      child: Caption(
                        str: '接受：' + propStr,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ],
            )),
      );
      lineCell.add(view);
    }
    return lineCell;
  }

  Widget getSecondLineDetail(ShipLineModel linedata) {
    // String strDetail = '';
    List<String> datalist = [];
    if (linedata.mode == 1) {
      // 1 首重续重
      double weithgt = linedata.region!.prices == null
          ? 0
          : linedata.region!.prices!.first.start / 1000;
      double price = linedata.region!.prices == null
          ? 0
          : linedata.region!.prices!.first.price / 100;
      datalist = [
        '首费(' + weithgt.toStringAsFixed(2) + localModel!.weightSymbol + ')：',
        localModel!.currencySymbol + price.toStringAsFixed(2),
      ];
    } else if (linedata.mode == 2) {
      // 2 阶梯价格
      ShipLinePriceModel priceM = linedata.region!.prices!.last;
      String contentStr = '';
      if (priceM.price.isNaN) {
        contentStr = localModel!.currencySymbol + '0.00';
      } else {
        double price = priceM.price.isNaN ? 0 : priceM.price / 100;
        contentStr = localModel!.currencySymbol + price.toStringAsFixed(2);
      }
      datalist = [
        '单价(' + localModel!.weightSymbol + ')：',
        contentStr,
      ];
    } else if (linedata.mode == 3) {
      // 3 单位价格加阶梯附加费
      // String priceStr = '';
      if (linedata.region!.prices != null) {
        for (ShipLinePriceModel item in linedata.region!.prices!) {
          if (item.type == 3) {
            // double price = item.price == null ? 0 : item.price / 100;
            // priceStr = localModel.currencySymbol + price.toStringAsFixed(2);
          }
        }
      }
      double price = !linedata.region!.prices!.first.price.isNaN
          ? 0
          : linedata.region!.prices!.first.price / 100;
      datalist = [
        '单价(' + localModel!.weightSymbol + ')：',
        localModel!.currencySymbol + price.toStringAsFixed(2),
      ];
    } else if (linedata.mode == 4) {
      // 4 多级续重
      double weithgt =
          linedata.firstWeight!.isNaN ? 0 : linedata.firstWeight! / 1000;
      double price =
          linedata.firstMoney!.isNaN ? 0 : linedata.firstMoney! / 100;
      datalist = [
        '首费(' + weithgt.toStringAsFixed(2) + localModel!.weightSymbol + ')：',
        localModel!.currencySymbol + price.toStringAsFixed(2),
      ];
    } else if (linedata.mode == 5) {
      // 5 阶梯首重续重
      num? firstWeight = linedata.region!.prices!.first.firstWeight ??
          linedata.region!.prices!.first.start;
      double price = linedata.region!.prices!.first.price.isNaN
          ? 0
          : (linedata.region!.prices!.first.price / 100);
      datalist = [
        '首费(' +
            (firstWeight / 1000).toStringAsFixed(2) +
            localModel!.weightSymbol +
            ')：',
        localModel!.currencySymbol + price.toStringAsFixed(2),
      ];
    }
    var view1 = datalist.isNotEmpty
        ? RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: datalist[0],
                style: const TextStyle(
                  color: ColorConfig.textBlack,
                  fontSize: 15.0,
                ),
              ),
              TextSpan(
                text: datalist[1],
                style: const TextStyle(
                  color: ColorConfig.textRed,
                  fontSize: 15.0,
                ),
              ),
            ]))
        : Container();
    return view1;
  }

  String getAllPropName(ShipLineModel linedata) {
    String allPropsName = '';
    for (GoodsPropsModel prop in linedata.props!) {
      if (allPropsName.isEmpty) {
        allPropsName = prop.propName!;
      } else {
        allPropsName = allPropsName + '、' + prop.propName!;
      }
    }
    return allPropsName;
  }

  buildPlugin() {
    return SwiperPagination(
        builder: DotSwiperPaginationBuilder(
            color: Colors.grey[300],
            activeColor: const Color(0xFF888888),
            size: 8,
            activeSize: 8));
  }
}
