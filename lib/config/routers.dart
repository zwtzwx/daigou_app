import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/views/common/country_list_page.dart';
import 'package:jiyun_app_client/views/express/express_query_page.dart';
import 'package:jiyun_app_client/views/home/contact_page.dart';
import 'package:jiyun_app_client/views/home/station_page.dart';
import 'package:jiyun_app_client/views/home/warehouse_page.dart';
import 'package:jiyun_app_client/views/order/order_comment_page.dart';
import 'package:jiyun_app_client/views/order/order_detail_page.dart';
import 'package:jiyun_app_client/views/order/order_list_page.dart';
import 'package:jiyun_app_client/views/order/tracking_detail_page.dart';
import 'package:jiyun_app_client/views/parcel/edit_parcel_page.dart';
import 'package:jiyun_app_client/views/parcel/forecast_parcel_list_page.dart';
import 'package:jiyun_app_client/views/parcel/forecast_parcel_page.dart';
import 'package:jiyun_app_client/views/parcel/in_warehouse_parcel_list.dart';
import 'package:jiyun_app_client/views/parcel/parcel_detail_page.dart';
import 'package:jiyun_app_client/views/user/about_me_page.dart';
import 'package:jiyun_app_client/views/user/change_mobile_email_page.dart';
import 'package:jiyun_app_client/views/user/change_password_page.dart';
import 'package:jiyun_app_client/views/user/forget_password_page.dart';
import 'package:jiyun_app_client/views/user/login_page.dart';
import 'package:jiyun_app_client/views/user/my_growth_value_page.dart';
import 'package:jiyun_app_client/views/user/my_profile_page.dart';
import 'package:jiyun_app_client/views/user/receiver_address_edit_page.dart';
import 'package:jiyun_app_client/views/user/receiver_address_list_part.dart';
import 'package:jiyun_app_client/views/user/transaction_page.dart';
import 'package:jiyun_app_client/views/user/my_point_page.dart';
import 'package:jiyun_app_client/views/user/vip_center_page.dart';
import 'package:jiyun_app_client/views/webview/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/views/main_controller.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Routers {
  static List filterList = [
    '/webview',
    '/ForgetPasswordPage',
    '/ExpressQueryPage',
    '/StationPage',
    '/CountryListPage',
    '/AboutMePage',
    '/TabOrderInfo',
    '/contactPage'
  ];

  // 路由声明
  static Map<String, Function> routes = {
    '/TabOrderInfo': (context) => const MainController(),
    '/ForcastParcelListPage': (context) => const ForcastParcelListPage(),
    '/InWarehouseParcelListPage': (context) =>
        const InWarehouseParcelListPage(),
    '/EditParcelPage': (context, {arguments}) =>
        EditParcelPage(arguments: arguments),
    '/PackageDetailPage': (context, {arguments}) =>
        PackageDetailPage(arguments: arguments),
    '/ReceiverAddressListPage': (context, {arguments}) =>
        ReceiverAddressListPage(arguments: arguments),
    '/ReceiverAddressEditPage': (context, {arguments}) =>
        ReceiverAddressEditPage(arguments: arguments),
    '/OrderDetailPage': (context, {arguments}) =>
        OrderDetailPage(arguments: arguments),
    '/OrderCommentPage': (context, {arguments}) =>
        OrderCommentPage(arguments: arguments),
    '/TrackingDetailPage': (context, {arguments}) =>
        TrackingDetailPage(arguments: arguments),
    '/WarehousePage': (context) => const WarehousePage(),
    '/webview': (context, {arguments}) => WebViewPage(arguments: arguments),
    '/TransactionPage': (context) => const TransactionPage(),
    '/MyProfilePage': (context, {arguments}) => const MyProfilePage(),
    '/ChangeMobileEmailPage': (context, {arguments}) =>
        ChangeMobileEmailPage(arguments: arguments),
    '/CountryListPage': (context, {arguments}) =>
        CountryListPage(arguments: arguments),
    '/LoginPage': (context) => const LoginPage(),
    '/ChangePasswordPage': (context) => const ChangePasswordPage(),
    '/StationPage': (context) => const StationPage(),
    '/OrderListPage': (context, {arguments}) =>
        OrderListPage(arguments: arguments),
    '/ExpressQueryPage': (context) => const ExpressQueryPage(),
    '/AboutMePage': (context) => const AboutMePage(),
    '/MyPointPage': (context, {arguments}) => MyPointPage(arguments: arguments),
    '/VipCenterPage': (context, {arguments}) =>
        VipCenterPage(arguments: arguments),
    '/MyGrowthValuePage': (context) => const MyGrowthValuePage(),
    '/ForgetPasswordPage': (context, {arguments}) =>
        ForgetPasswordPage(arguments: arguments),
    '/contactPage': (context) => const ContactPage(),
    '/forecastPage': (context) => const ForcastParcelPage(),
  };

  static String currentRouteName = "";

  // 路由初始化
  static run(RouteSettings settings) {
    final Function? pageContentBuilder = Routers.routes[settings.name];

    if (pageContentBuilder != null) {
      currentRouteName = settings.name!;
      if (settings.arguments != null) {
        // 传参路由
        return CupertinoPageRoute(
            fullscreenDialog: false,
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
      } else {
        // 无参数路由
        return CupertinoPageRoute(
            builder: (context) => pageContentBuilder(context));
      }
    } else {
      // 404页
      // return CupertinoPageRoute(builder: (context) => NotFoundPage());
    }
  }

  // 组件跳转
  static link(Widget child, String routeName, BuildContext context,
      [Map? parmas]) {
    return GestureDetector(
      onTap: () {
        if (parmas != null) {
          Navigator.pushNamed(context, routeName, arguments: parmas);
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: child,
    );
  }

  // 方法跳转
  static push(String routeName, BuildContext context, [Map? parmas]) async {
    if (filterList.contains(routeName)) {
      if (parmas != null) {
        Navigator.pushNamed(context, routeName, arguments: parmas);
      } else {
        Navigator.pushNamed(context, routeName);
      }
      return;
    }
    // 如果状态管理器中的Token是空的
    if (Provider.of<Model>(context, listen: false).token.isEmpty) {
      Navigator.pushNamed(
        context,
        '/LoginPage',
      );
      return;
    }

    if (parmas != null) {
      return Navigator.pushNamed(context, routeName, arguments: parmas)
          .then((value) {
        EasyLoading.dismiss();
        return value;
      });
    } else {
      return Navigator.pushNamed(
        context,
        routeName,
      ).then((value) {
        EasyLoading.dismiss();
        return value;
      });
    }
  }

  // 方法跳转,无返回
  static redirect(String routeName, BuildContext context, [Map? parmas]) {
    if (parmas != null) {
      return Navigator.pushReplacementNamed(context, routeName,
          arguments: parmas);
    } else {
      Navigator.pushReplacementNamed(context, routeName); //pushReplacementNamed
    }
  }

  //modal弹出
  static Future popup(String routeName, BuildContext context, [Map? parmas]) {
    return Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return Routers.routes[routeName]!.call();
        }));
  }

  static pop(BuildContext context, [Map? params]) {
    return Navigator.pop(context, params);
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}
