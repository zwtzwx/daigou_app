import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

// ignore: non_constant_identifier_names
Widget ShipLineItem(BuildContext context, ShipLineModel lineItem,
    String propStr, LocalizationModel? localModel) {
  return GestureDetector(
    onTap: () {
      Routers.push('/LineDetailPage', context, {'id': lineItem.id, 'type': 1});
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
                color: ColorConfig.primary,
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
                Container(
                  alignment: Alignment.centerLeft,
                  height: 34,
                  padding: const EdgeInsets.only(left: 10.0, top: 6, right: 5),
                  child: Caption(
                    str: lineItem.name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.vGap4,
                Container(
                  width: ScreenUtil().screenWidth - 60,
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Caption(
                        str: lineItem.region!.referenceTime,
                        color: ColorConfig.textGray,
                      ),
                      Container(
                        child:
                            getSecondLineDetail(context, lineItem, localModel),
                      ),
                    ],
                  ),
                ),
                Gaps.vGap4,
                Container(
                  width: ScreenUtil().screenWidth - 60,
                  margin: const EdgeInsets.only(left: 10),
                  child: Caption(
                    str: Translation.t(context, '接受', listen: true) +
                        '：' +
                        propStr,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ],
        )),
  );
}

Widget getSecondLineDetail(
    context, ShipLineModel linedata, LocalizationModel? localModel) {
  // String strDetail = '';
  List<String> datalist = [];
  String contentSymbol =
      linedata.baseMode == 0 ? localModel!.weightSymbol : 'm³';
  num price = 0;
  num basePrice = 0;
  num weight = 0;
  for (var item in linedata.region!.prices!) {
    if (item.type == 8) {
      basePrice = item.price;
    } else if ([0, 2, 3].contains(item.type)) {
      price = item.price;
      if (item.type == 0) {
        weight = item.start;
      }
    }
  }
  if (linedata.mode == 1 || linedata.mode == 4) {
    // 1 首重续重
    datalist = [
      Translation.t(context, '首费', listen: true) +
          '(' +
          (weight / 1000).toStringAsFixed(2) +
          '$contentSymbol)：',
      localModel!.currencySymbol + (price / 100).toStringAsFixed(2),
    ];
  } else if (linedata.mode == 2) {
    // 2 阶梯价格
    if (price == 0) {
      datalist = [
        Translation.t(context, '价格', listen: true) + '：',
        localModel!.currencySymbol + (basePrice / 100).toStringAsFixed(2),
      ];
    } else {
      datalist = [
        Translation.t(context, '单价', listen: true) + '(' + contentSymbol + ')：',
        localModel!.currencySymbol + (price / 100).toStringAsFixed(2),
      ];
    }
  } else if (linedata.mode == 3) {
    // 3 单位价格加阶梯附加费
    datalist = [
      Translation.t(context, '单价', listen: true) + '(' + contentSymbol + ')：',
      localModel!.currencySymbol + (price / 100).toStringAsFixed(2),
    ];
  } else if (linedata.mode == 5) {
    // 5 阶梯首重续重
    num? firstWeight = linedata.region!.prices!.first.firstWeight ??
        linedata.region!.prices!.first.start;
    double price = linedata.region!.prices!.first.price.isNaN
        ? 0
        : (linedata.region!.prices!.first.price / 100);
    datalist = [
      Translation.t(context, '首费', listen: true) +
          '(' +
          (firstWeight / 1000).toStringAsFixed(2) +
          contentSymbol +
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
