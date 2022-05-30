/*
  待处理订单  打包中订单
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InPackParcelListPage extends StatefulWidget {
  const InPackParcelListPage({Key? key}) : super(key: key);

  @override
  InPackParcelListPageState createState() => InPackParcelListPageState();
}

class InPackParcelListPageState extends State<InPackParcelListPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LocalizationModel? localizationInfo;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    loadList();
  }

  @override
  bool get wantKeepAlive => true;

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    return await OrderService.getList({
      'status': OrderStatus.packIng.id, // 待处理订单
      'page': (++pageIndex),
      'size': '10',
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Caption(
          str: '打包中',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    return Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: renderItem,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget renderItem(index, OrderModel model) {
    OrderStatus orderStatus =
        OrderStatus.values.firstWhere((e) => e.id == model.status);

    String contentStr = '';
    if (model.address.id != null) {
      if (model.address.area != null) {
        if (model.address.area != null) {
          contentStr =
              model.address.countryName + ' ' + model.address.area!.name;
        }
        if (model.address.subArea != null) {
          contentStr += ' ' + model.address.subArea!.name;
        }
        if (model.address.address != null) {
          contentStr += ' ' + model.address.address!;
        }
      } else {
        contentStr = model.address.countryName +
            ' ' +
            model.address.province +
            ' ' +
            model.address.city;

        if (model.address.address != null) {
          contentStr += ' ' + model.address.address!;
        }
      }
    }
    double addressH = calculateTextHeight(
        contentStr, 16.0, FontWeight.w400, ScreenUtil().screenWidth - 60, 2);
    // 申报价格 所有包裹价值总和
    num totalValue = 0.0;
    for (ParcelModel item in model.packages) {
      totalValue += item.packageValue!;
    }
    return GestureDetector(
        onTap: () {
          Routers.push('/OrderDetailPage', context, {'id': model.id});
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: Colors.white),
          ),
          height: 125 + addressH,
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  margin: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Caption(
                            fontSize: 16,
                            str: '订单号：' + model.orderSn,
                          )
                        ],
                      ),
                      Caption(
                        str: orderStatus.name,
                        color: ColorConfig.warningTextDark,
                        fontSize: 14,
                      )
                    ],
                  )),
              Gaps.line,
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Caption(
                            str: model.address.receiverName,
                            fontSize: 20,
                          ),
                          Gaps.hGap15,
                          Caption(
                            str: model.address.timezone +
                                '-' +
                                model.address.phone,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    Gaps.vGap5,
                    Container(
                      height: addressH,
                      alignment: Alignment.centerLeft,
                      child: Caption(
                        str: contentStr,
                        lines: 2,
                      ),
                    ),
                    Gaps.vGap5,
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Caption(
                              fontSize: 16,
                              str: '申报价格：' +
                                  localizationInfo!.currencySymbol +
                                  (totalValue / 100).toStringAsFixed(2),
                              color: ColorConfig.textGray,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  double calculateTextHeight(String value, fontSize, FontWeight fontWeight,
      double maxWidth, int maxLines) {
    // value = filterText(value);
    TextPainter painter = TextPainter(
        // ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        // locale: Localizations.localeOf(GlobalStatic.context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }
}
