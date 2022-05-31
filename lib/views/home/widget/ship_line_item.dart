import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/ship_line_price_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

Widget buildLineItem(BuildContext context, ShipLineModel lineItem,
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
                        child: getSecondLineDetail(lineItem, localModel),
                      ),
                    ],
                  ),
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
}

Widget getSecondLineDetail(
    ShipLineModel linedata, LocalizationModel? localModel) {
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
      localModel.currencySymbol + price.toStringAsFixed(2),
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
      '单价(' + localModel.weightSymbol + ')：',
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
      localModel.currencySymbol + price.toStringAsFixed(2),
    ];
  } else if (linedata.mode == 4) {
    // 4 多级续重
    double weithgt =
        linedata.firstWeight!.isNaN ? 0 : linedata.firstWeight! / 1000;
    double price = linedata.firstMoney!.isNaN ? 0 : linedata.firstMoney! / 100;
    datalist = [
      '首费(' + weithgt.toStringAsFixed(2) + localModel!.weightSymbol + ')：',
      localModel.currencySymbol + price.toStringAsFixed(2),
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
      localModel.currencySymbol + price.toStringAsFixed(2),
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
