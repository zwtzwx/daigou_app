import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/config/app_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/config/wechat_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/ads_pic_model.dart';
import 'package:shop_app_client/models/self_pickup_station_order_model.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseUtils {
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

  // 拼团状态
  static String getGroupStatusName(int status) {
    String str = '';
    switch (status) {
      case 0:
        str = '拼团中';
        break;
      case 1:
        str = '拼团结束';
        break;
      case 2:
        str = '拼团取消';
        break;
    }
    return str;
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
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
  static String getOrderStatusName(int status,
      [SelfPickupStationOrderModel? stationOrder]) {
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

  static String getLineModelName(num model) {
    String modeStr = '';
    switch (model) {
      case 1:
        modeStr = '首重续重模式';
        break;
      case 2:
        modeStr = '阶梯价格模式';
        break;
      case 3:
        modeStr = '单位价格+阶梯总价模式';
        break;
      case 4:
        modeStr = '多级续重模式';
        break;
      case 5:
        modeStr = '阶梯首重续重模式';
        break;
    }
    return modeStr;
  }

  // 客服
  static void onCustomerContact([String type = 'wx']) async {
    print(type);
    if (type == 'whatsapp') {
      const contact = '+8618163665594';
      String whatsappURlAndroid = 'whatsapp://send?phone=' + contact + '&text=';
      String whatappURLIos = "https://wa.me/$contact?text=";
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(whatappURLIos))) {
          await launchUrl(Uri.parse(whatappURLIos));
        }
      } else {
        if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
          await launchUrl(Uri.parse(whatsappURlAndroid));
        } else {
          await launchUrl(Uri.parse(whatappURLIos));
        }
      }
    } else {
      WechatConfig().onCustomer();
    }
  }

  // 第三方平台商品图标
  static String getPlatformIcon(String? platform) {
    String icon = 'Shop/tb';
    switch (platform) {
      case 'jd':
        icon = 'Shop/jd';
        break;
      case 'pinduoduo':
        icon = 'Shop/pdd';
        break;
      case '1688':
        icon = 'Shop/1688';
        break;
    }
    return icon;
  }

  // 语言占位符替换
  static List<String> parsePlaceholder(String str) {
    List<String> list = [];
    int position = 0;
    int strLength = str.length;
    while (position < strLength) {
      String char = str[position++];
      if (char == '{') {
        String sub = '';
        if (position < strLength) {
          char = str[position++];
        }
        while (position < strLength && char != '}') {
          sub += char;
          char = str[position++];
        }
        list.add(sub);
      }
    }
    return list;
  }

  // 轮播图跳转
  static void onAdLink(BannerModel model) {
    if (model.linkType == 1) {
      // 应用内
      if (model.linkPath.startsWith('/pages')) {
        WechatConfig().openMiniProgram(model.fullPath, model.linkPath);
      } else {
        var paths = model.linkPath.split('?');
        if (paths.first.startsWith('/lottery')) {
          // 抽奖页面
          String token = Get.find<AppStore>().token.value;
          if (token.isEmpty) {
            GlobalPages.push(GlobalPages.login);
          } else {
            String uuid = BaseUrls.getUUID();
            String api = BaseUrls.getBaseApi();
            var parsedQuery = Uri.splitQueryString(paths[1]);
            GlobalPages.push(GlobalPages.webview, arg: {
              'title': '抽奖'.inte,
              'url':
                  'https://yingxiao.haiousaas.com/pages/reward/index?token=$token&api_url=$api&env=App&&UUID=$uuid&reward_id=${parsedQuery['id']}'
            });
          }
        } else {
          if (paths.length > 1) {
            var parsedQuery = Uri.splitQueryString(paths[1]);
            GlobalPages.push(paths[0], arg: parsedQuery);
          } else {
            GlobalPages.push(model.linkPath);
          }
        }
      }
    } else if (model.linkType == 2 || model.linkType == 3) {
      // 外部URL、公众号 URL
      GlobalPages.push(GlobalPages.webview,
          arg: {'url': model.linkPath, 'title': 'Daigou', 'time': ''});
    }
  }
}
