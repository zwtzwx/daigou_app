import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/views/common/comment_list_page.dart';
import 'package:jiyun_app_client/views/common/country_list_page.dart';
import 'package:jiyun_app_client/views/help/help_support_page.dart';
import 'package:jiyun_app_client/views/help/question_page.dart';
import 'package:jiyun_app_client/views/home/share_page.dart';
import 'package:jiyun_app_client/views/home/station_page.dart';
import 'package:jiyun_app_client/views/home/warehouse_page.dart';
import 'package:jiyun_app_client/views/line/line_all_page.dart';
import 'package:jiyun_app_client/views/line/line_detail_page.dart';
import 'package:jiyun_app_client/views/line/line_query_page.dart';
import 'package:jiyun_app_client/views/line/lines_page.dart';
import 'package:jiyun_app_client/views/order/create_order_page.dart';
import 'package:jiyun_app_client/views/order/invoice_page.dart';
import 'package:jiyun_app_client/views/order/no_owner_parcel_detail_page.dart';
import 'package:jiyun_app_client/views/order/no_owner_parcel_page.dart';
import 'package:jiyun_app_client/views/order/order_comment_page.dart';
import 'package:jiyun_app_client/views/order/order_detail_page.dart';
import 'package:jiyun_app_client/views/order/order_list_page.dart';
import 'package:jiyun_app_client/views/order/order_pay_page.dart';
import 'package:jiyun_app_client/views/order/pay_success_page.dart';
import 'package:jiyun_app_client/views/user/select_bank_page.dart';
import 'package:jiyun_app_client/views/order/select_self_pickup_page.dart';
import 'package:jiyun_app_client/views/order/sign_success_page.dart';
import 'package:jiyun_app_client/views/order/tracking_detail_page.dart';
import 'package:jiyun_app_client/views/parcel/category_page.dart';
import 'package:jiyun_app_client/views/parcel/edit_parcel_page.dart';
import 'package:jiyun_app_client/views/parcel/forecast_parcel_list_page.dart';
import 'package:jiyun_app_client/views/parcel/in_pack_parcel_list_page.dart';
import 'package:jiyun_app_client/views/parcel/in_warehouse_parcel_list.dart';
import 'package:jiyun_app_client/views/parcel/parcel_detail_page.dart';
import 'package:jiyun_app_client/views/user/about_me_page.dart';
import 'package:jiyun_app_client/views/user/agent_member_page.dart';
import 'package:jiyun_app_client/views/user/agent_page.dart';
import 'package:jiyun_app_client/views/user/apply_withdraw_success_page.dart';
import 'package:jiyun_app_client/views/user/balance_history_page.dart';
import 'package:jiyun_app_client/views/user/change_mobile_email_page.dart';
import 'package:jiyun_app_client/views/user/forget_password_page.dart';
import 'package:jiyun_app_client/views/user/login_page.dart';
import 'package:jiyun_app_client/views/user/my_coupon_page.dart';
import 'package:jiyun_app_client/views/user/my_growth_value_page.dart';
import 'package:jiyun_app_client/views/user/my_profile_page.dart';
import 'package:jiyun_app_client/views/user/receiver_address_edit_page.dart';
import 'package:jiyun_app_client/views/user/receiver_address_list_part.dart';
import 'package:jiyun_app_client/views/user/register_agent_page.dart';
import 'package:jiyun_app_client/views/user/suggest/suggest_page.dart';
import 'package:jiyun_app_client/views/user/suggest/suggest_type_page.dart';
import 'package:jiyun_app_client/views/user/transaction_page.dart';
import 'package:jiyun_app_client/views/user/transfer_and_payment_page.dart';
import 'package:jiyun_app_client/views/user/user_privacy_page.dart';
import 'package:jiyun_app_client/views/user/user_protocol_page.dart';
import 'package:jiyun_app_client/views/user/withdraw_commission_page.dart';
import 'package:jiyun_app_client/views/user/withdraw_history_detail_page.dart';
import 'package:jiyun_app_client/views/user/withdraw_history_page.dart';
import 'package:jiyun_app_client/views/user/apply_withdraw_page.dart';
import 'package:jiyun_app_client/views/user/my_point_page.dart';
import 'package:jiyun_app_client/views/user/recharge_page.dart';
import 'package:jiyun_app_client/views/user/vip_center_page.dart';
import 'package:jiyun_app_client/views/user/withdraw_info_page.dart';
import 'package:jiyun_app_client/views/webview/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/views/main_controller.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Routers {
  static List filterList = [
    'WefarePage',
    '/webview',
    '/HelpSupportPage',
    '/QuestionPage',
    '/LinesDetailPage',
    '/LineQueryPage',
    '/UserPrivacyPage',
    '/UserProtocolPage',
    '/ForgetPasswordPage',
    '/CommentListPage',
    '/LineAllPage',
    '/StationPage'
  ];

  // 路由声明
  static Map<String, Function> routes = {
    '/TabOrderInfo': (context) => const MainController(),
    // '/LineDetail': (context, {arguments}) =>
    // LineDetailInfo(arguments: arguments),
    // '/LineDetailSecondType': (context, {arguments}) =>
    // LineDetailSecondType(arguments: arguments),
    '/NoOwnerParcelPage': (context) => const NoOwnerParcelPage(),
    '/NoOwnerParcelDetailPage': (context, {arguments}) =>
        NoOwnerParcelDetailPage(arguments: arguments),
    '/ForcastParcelListPage': (context) => const ForcastParcelListPage(),
    '/InWarehouseParcelListPage': (context) =>
        const InWarehouseParcelListPage(),
    '/EditParcelPage': (context, {arguments}) =>
        EditParcelPage(arguments: arguments),
    '/PackageDetailPage': (context, {arguments}) =>
        PackageDetailPage(arguments: arguments),
    '/CreateOrderPage': (context, {arguments}) =>
        CreateOrderPage(arguments: arguments),
    // '/AddressForSelfGet': (context, {arguments}) =>
    //     AddressForSelfGet(arguments: arguments),
    '/ReceiverAddressListPage': (context, {arguments}) =>
        ReceiverAddressListPage(arguments: arguments),
    '/ReceiverAddressEditPage': (context, {arguments}) =>
        ReceiverAddressEditPage(arguments: arguments),
    '/InPackParcelListPage': (context) => const InPackParcelListPage(),
    '/OrderDetailPage': (context, {arguments}) =>
        OrderDetailPage(arguments: arguments),
    '/OrderPayPage': (context, {arguments}) =>
        OrderPayPage(arguments: arguments),
    '/OrderCommentPage': (context, {arguments}) =>
        OrderCommentPage(arguments: arguments),
    '/TrackingDetailPage': (context, {arguments}) =>
        TrackingDetailPage(arguments: arguments),
    // '/BePaiedList': (context) => BePaiedList(),
    // '/BeSendList': (context) => BeSendList(),
    // '/HasShipped': (context) => HasShipped(),
    // '/HasSign': (context) => HasSign(),
    '/WareHouseAddress': (context) => const WareHouseAddress(),
    '/HelpSupportPage': (context, {arguments}) =>
        HelpSupportPage(arguments: arguments),
    '/QuestionPage': (context, {arguments}) =>
        QuestionPage(arguments: arguments),
    '/webview': (context, {arguments}) => WebViewPage(arguments: arguments),
    // '/ComplaintsPage': (context, {arguments}) =>
    //     ComplaintsPage(arguments: arguments),
    '/CommentListPage': (context) => const CommentListPage(),
    // '/ShareCouponPage': (context) => ShareCouponPage(),
    '/RechargePage': (context) => const RechargePage(),
    '/ApplyWithDrawPage': (context) => const ApplyWithDrawPage(), //提现界面
    // '/BalanceTopUpPage': (context) => BalanceTopUpPage(),
    '/CouponPage': (context, {arguments}) => MyCouponPage(arguments: arguments),
    '/TransactionPage': (context) => const TransactionPage(),
    // '/MyPromotionPage': (context) => MyPromotionPage(),
    // '/CommissionDetailPage': (context, {arguments}) =>
    // CommissionDetailPage(arguments: arguments),
    '/WithdrawHistoryPage': (context) => const WithdrawHistoryPage(),
    '/WithdrawHistoryDetailPage': (context, {arguments}) =>
        WithdrawHistoryDetailPage(arguments: arguments),
    '/WithdrawCommissionPage': (context) => const WithdrawCommissionPage(),
    '/WithdrawlInfoPage': (context, {arguments}) =>
        WithdrawlInfoPage(arguments: arguments),
    // '/DealRecordPage': (context) => DealRecordPage(),
    '/MyProfilePage': (context, {arguments}) => const MyProfilePage(),
    '/ChangeMobileEmailPage': (context, {arguments}) =>
        ChangeMobileEmailPage(arguments: arguments),
    // '/PrepaidRecord': (context) => PrepaidRecord(),
    '/RegisterAgentPage': (context) => const RegisterAgentPage(),
    '/CountryListPage': (context, {arguments}) =>
        CountryListPage(arguments: arguments),
    '/CategoriesPage': (context, {arguments}) =>
        CategoryPage(arguments: arguments),
    // '/WithdrawalInformation': (context, {arguments}) =>
    //     WithdrawalInformation(arguments: arguments),
    '/TransferAndPaymentPage': (context, {arguments}) =>
        TransferAndPaymentPage(arguments: arguments),
    '/LoginPage': (context) => const LoginPage(),
    '/UserPrivacyPage': (context) => const UserPrivacyPage(),
    '/UserProtocolPage': (context) => const UserProtocolPage(),
    // '/PackageOrOrder': (context) => PackageOrOrder(),
    // '/BeganToFreight': (context) => BeganToFreight(),
    '/LineAllPage': (context) => const LineAllPage(),
    '/StationPage': (context) => const StationPage(),
    '/LineQueryPage': (context, {arguments}) =>
        LineQueryPage(arguments: arguments),
    '/LinesPage': (context, {arguments}) => LinesPage(arguments: arguments),
    '/LineDetailPage': (context, {arguments}) =>
        LineDetailPage(arguments: arguments),
    '/OrderListPage': (context, {arguments}) =>
        OrderListPage(arguments: arguments),
    '/AboutMePage': (context) => const AboutMePage(),
    '/SignSuccessPage': (context, {arguments}) =>
        SignSuccessPage(arguments: arguments),
    '/MyPointPage': (context, {arguments}) => MyPointPage(arguments: arguments),
    '/AgentPage': (context) => const AgentPage(),
    '/AgentMemberPage': (context) => const AgentMemberPage(),
    '/VipCenterPage': (context, {arguments}) =>
        VipCenterPage(arguments: arguments),
    '/SelectBankPage': (context) => const SelectBankPage(),
    '/ApplyWithDrawSuccessPage': (context, {arguments}) =>
        ApplyWithDrawSuccessPage(arguments),
    '/BalanceHistoryPage': (context, {arguments}) => const BalanceHistoryPage(),
    '/MyGrowthValuePage': (context) => const MyGrowthValuePage(),
    '/SharePage': (context) => const SharePage(),
    '/SuggestTypePage': (context) => const SuggestTypePage(),
    '/SuggestPage': (context, {arguments}) => SuggestPage(arguments: arguments),
    // '/ForgetPsdPage': (context, {arguments}) =>
    //     ForgetPsdPage(arguments: arguments),
    '/ForgetPasswordPage': (context, {arguments}) =>
        ForgetPasswordPage(arguments: arguments),
    '/InvoicePage': (context, {arguments}) => InvoicePage(arguments: arguments),
    '/SelectSelfPickUpPage': (context, {arguments}) =>
        SelectSelfPickUpPage(arguments: arguments),
    '/PaySuccessPage': (context, {arguments}) =>
        PaySuccessPage(arguments: arguments),
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
