import 'package:jiyun_app_client/config/color_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiyun_app_client/models/self_pickup_station_order_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Util {
  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    }
    return 'time error';
  }

  // 数组分组
  static List listToSort({required List toSort, required int chunk}) {
    var newList = [];
    for (var i = 0; i < toSort.length; i += chunk) {
      var end = i + chunk > toSort.length ? toSort.length : i + chunk;
      newList.add(toSort.sublist(i, end));
    }
    return newList;
  }

  /// 调起拨号页
  static void launchTelURL(String phone) async {
    Uri url = Uri.parse('tel:' + phone);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {}
  }

  static void showSnackBar(BuildContext context, String msg,
      [GlobalKey<ScaffoldState>? _scaffoldKey]) {
    if (_scaffoldKey != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Widget buildLoadingWithWiget(
      BuildContext context, Widget widget, isLoading) {
    return Stack(
      children: <Widget>[
        // 显示app
        Offstage(
          child: widget,
          offstage: false,
        ),
        // 显示广告
        Offstage(
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.5,
                child: Container(color: Colors.black),
              ),
              const SpinKitFoldingCube(
                color: Color(WidgetColor.themeColor),
                size: 50.0,
              )
            ],
          ),
          offstage: !isLoading,
        ),
      ],
    );
  }

  // 支付方式名称
  static String getPayTypeName(String type) {
    String name;
    switch (type) {
      case 'wechat':
        name = '微信支付';
        break;
      case 'balance':
        name = '余额支付';
        break;
      case 'alipay':
        name = '支付宝支付';
        break;
      case 'on_delivery':
        name = '货到付款';
        break;
      default:
        name = type;
        break;
    }
    return name;
  }

  // 订单状态
  static String getOrderStatusName(
      int status, SelfPickupStationOrderModel? stationOrder) {
    String statusStr = '';
    //1 待处理 2待付款 3待发货 4已发货5已签收11审核中12审核失败
    switch (status) {
      case 1:
        statusStr = '待处理';
        break;
      case 2:
        statusStr = '待支付';
        break;
      case 3:
        statusStr = '待发货';
        break;
      case 4:
        if (stationOrder == null) {
          statusStr = '已发货';
        } else {
          if (stationOrder.status == 1) {
            statusStr = '已到自提点';
          } else if (stationOrder.status == 3) {
            statusStr = '自提点出库';
          } else if (stationOrder.status == 4) {
            statusStr = '自提签收';
          }
        }
        break;
      case 5:
        if (stationOrder == null) {
          statusStr = '已签收';
        } else {
          if (stationOrder.status == 1) {
            statusStr = '已到自提点';
          } else if (stationOrder.status == 3) {
            statusStr = '自提点出库';
          } else if (stationOrder.status == 4) {
            statusStr = '自提签收';
          }
        }
        break;
      case 11:
        statusStr = '审核中';
        break;
      case 12:
        statusStr = '审核失败';
        break;
      default:
    }
    return statusStr;
  }
}
