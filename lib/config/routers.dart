import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/views/common/country/country_binding.dart';
import 'package:jiyun_app_client/views/common/country/country_list_page.dart';
import 'package:jiyun_app_client/views/contact/contact_binding.dart';
import 'package:jiyun_app_client/views/contact/contact_page.dart';
import 'package:jiyun_app_client/views/express/express_query_bind.dart';
import 'package:jiyun_app_client/views/express/express_query_page.dart';
import 'package:jiyun_app_client/views/order/detail/order_detail_binding.dart';
import 'package:jiyun_app_client/views/order/detail/order_detail_page.dart';
import 'package:jiyun_app_client/views/order/list/order_list_binding.dart';
import 'package:jiyun_app_client/views/order/list/order_list_view.dart';
import 'package:jiyun_app_client/views/order/tracking/tracking_binding.dart';
import 'package:jiyun_app_client/views/order/tracking/tracking_detail_page.dart';
import 'package:jiyun_app_client/views/parcel/forecast/forecast_binding.dart';
import 'package:jiyun_app_client/views/parcel/forecast/forecast_parcel_page.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/detail/no_owner_parcel_detail_binding.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/detail/no_owner_parcel_detail_view.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/list/no_owner_parcel_binding.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/list/no_owner_parcel_view.dart';
import 'package:jiyun_app_client/views/parcel/parcel_detail/parcel_detail_binding.dart';
import 'package:jiyun_app_client/views/parcel/parcel_detail/parcel_detail_page.dart';
import 'package:jiyun_app_client/views/parcel/parcel_edit/parcel_edit_binding.dart';
import 'package:jiyun_app_client/views/parcel/parcel_edit/parcel_edit_page.dart';
import 'package:jiyun_app_client/views/parcel/parcel_list/parcel_list_binding.dart';
import 'package:jiyun_app_client/views/parcel/parcel_list/parcel_list_page.dart';
import 'package:jiyun_app_client/views/user/abount/about_me_binding.dart';
import 'package:jiyun_app_client/views/user/abount/about_me_page.dart';
import 'package:jiyun_app_client/views/user/address/add/address_add_edit_binding.dart';
import 'package:jiyun_app_client/views/user/address/add/address_add_edit_view.dart';
import 'package:jiyun_app_client/views/user/address/list/address_list_binding.dart';
import 'package:jiyun_app_client/views/user/address/list/address_list_view.dart';
import 'package:jiyun_app_client/views/user/bind_info/bind_info_binding.dart';
import 'package:jiyun_app_client/views/user/bind_info/bind_info_view.dart';
import 'package:jiyun_app_client/views/user/forget_password/forget_password_binding.dart';
import 'package:jiyun_app_client/views/user/forget_password/forget_password_page.dart';
import 'package:jiyun_app_client/views/user/profile/profile_binding.dart';
import 'package:jiyun_app_client/views/user/profile/profile_view.dart';
import 'package:jiyun_app_client/views/user/register/register_binding.dart';
import 'package:jiyun_app_client/views/user/register/register_page.dart';
import 'package:jiyun_app_client/views/user/setting_password/setting_password_binding.dart';
import 'package:jiyun_app_client/views/user/setting_password/setting_password_view.dart';
import 'package:jiyun_app_client/views/user/transaction/transaction_binding.dart';
import 'package:jiyun_app_client/views/user/transaction/transaction_page.dart';
import 'package:jiyun_app_client/views/user/vip/center/vip_center_binding.dart';
import 'package:jiyun_app_client/views/user/vip/center/vip_center_view.dart';
import 'package:jiyun_app_client/views/user/vip/growth_value/growth_value_binding.dart';
import 'package:jiyun_app_client/views/user/vip/growth_value/growth_value_view.dart';
import 'package:jiyun_app_client/views/user/vip/point/point_binding.dart';
import 'package:jiyun_app_client/views/user/vip/point/point_view.dart';
import 'package:jiyun_app_client/views/warehouse/warehouse_binding.dart';
import 'package:jiyun_app_client/views/warehouse/warehouse_page.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_binding.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_view.dart';
import 'package:jiyun_app_client/views/user/login/login_binding.dart';
import 'package:jiyun_app_client/views/user/login/login_page.dart';
import 'package:jiyun_app_client/views/webview/webview_binding.dart';
import 'package:jiyun_app_client/views/webview/webview_page.dart';

class Routers {
  Routers._();

  static const String home = '/';
  static const String parcelList = '/parcel/forcast/list'; // 未入库包裹列表
  static const String inWarehouseList = '/parcel/inWarehouse/list'; // 已入库包裹列表
  static const String editParcel = '/parcel/edit'; // 修改包裹
  static const String parcelDetail = '/parcel/detail'; // 包裹详情
  static const String addressList = '/address/list'; // 地址列表
  static const String addressAddEdit = '/address/addEdit'; // 添加、修改地址
  static const String orderList = '/order/list'; // 订单列表
  static const String orderDetail = '/order/detail'; // 订单详情
  static const String orderComment = '/order/comment'; // 订单评价
  static const String orderTracking = '/order/tracking'; // 订单物流
  static const String warehouse = '/warehouse'; // 仓库
  static const String webview = '/webview';
  static const String transaction = '/transaction'; // 交易记录
  static const String profile = '/profile'; // 个人信息
  static const String changeMobileAndEmail =
      '/changeMobileAndEmail'; // 修改手机号、邮箱
  static const String country = '/country'; // 国家列表
  static const String login = '/login'; // 登录
  static const String register = '/register'; // 注册
  static const String password = '/password'; // 修改密码
  static const String station = '/station'; // 自提点列表
  static const String abountMe = '/aboutMe'; // 关于我们
  static const String point = '/vip/point'; // 我的积分
  static const String vip = '/vip'; // 我的会员
  static const String growthValue = '/vip/growthValue'; // 我的成长值
  static const String forgetPassword = '/forgetPassword'; // 忘记密码
  static const String contact = '/contact'; // 联系我们
  static const String forecast = '/forecast'; // 包裹预报
  static const String noOwnerList = '/noOwner/list'; // 异常件列表
  static const String noOwnerDetail = '/noOwner/detail'; // 异常件认领
  static const String track = '/track'; // 快递跟踪

  static List filterList = [
    webview,
    forgetPassword,
    station,
    country,
    abountMe,
    contact,
    home,
    login,
    register,
    track
  ];

  // 路由声明
  static final routes = [
    GetPage(
      name: home,
      page: () => const TabbarView(),
      binding: TabbarBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: country,
      page: () => const CountryListView(),
      binding: CountryBinding(),
    ),
    GetPage(
      name: warehouse,
      page: () => const WarehouseView(),
      binding: WarehouseBinding(),
    ),
    GetPage(
      name: contact,
      page: () => ContactView(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: forecast,
      page: () => const ForecastParcelView(),
      binding: ForecastBinding(),
    ),
    GetPage(
      name: parcelList,
      page: () => const ParcelListView(),
      binding: ParcelListBinding(),
    ),
    GetPage(
      name: parcelDetail,
      page: () => const ParcelDetailView(),
      binding: ParcelDetailBinding(),
    ),
    GetPage(
      name: editParcel,
      page: () => const ParcelEditView(),
      binding: ParcelEditBinding(),
    ),
    GetPage(
      name: orderTracking,
      page: () => const OrderTrackingView(),
      binding: TrackingBinding(),
    ),
    GetPage(
      name: abountMe,
      page: () => const AboutMeView(),
      binding: AbountMeBinding(),
    ),
    GetPage(
      name: webview,
      page: () => const H5View(),
      binding: WebviewBinding(),
    ),
    GetPage(
      name: password,
      page: () => const SettingPasswordView(),
      binding: SettingPasswordBinding(),
    ),
    GetPage(
      name: transaction,
      page: () => const TransactionView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: changeMobileAndEmail,
      page: () => const BindInfoView(),
      binding: BindInfoBinding(),
    ),
    GetPage(
      name: addressList,
      page: () => const AddressListView(),
      binding: AddressListBinding(),
    ),
    GetPage(
      name: addressAddEdit,
      page: () => const AddressAddEditView(),
      binding: AddressAddEditBinding(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: orderList,
      page: () => const OrderListView(),
      binding: OrderListBinding(),
    ),
    GetPage(
      name: orderDetail,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: noOwnerList,
      page: () => const NoOwnerParcelView(),
      binding: NoOwnerParcelBinding(),
    ),
    GetPage(
      name: noOwnerDetail,
      page: () => const NoOwnerParcelDetailView(),
      binding: NoOwnerParcelDetailBinding(),
    ),
    GetPage(
      name: vip,
      page: () => const VipCenterView(),
      binding: VipCenterBinding(),
    ),
    GetPage(
      name: point,
      page: () => const PointView(),
      binding: PointBinding(),
    ),
    GetPage(
      name: growthValue,
      page: () => const GrowthValueView(),
      binding: GrowthValueBinding(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      binding: RegisterBingding(),
    ),
    GetPage(
      name: track,
      page: () => const ExpressQueryView(),
      binding: ExpressQueryBind(),
    )
  ];

  static String currentRouteName = "";

  // 跳转到下个页面
  static push(String page, [dynamic arguments]) {
    UserInfoModel userInfo = Get.find<UserInfoModel>();
    if (filterList.contains(page) || userInfo.token.value.isNotEmpty) {
      return Get.toNamed(page, arguments: arguments);
    } else {
      return Get.toNamed(login);
    }
  }

  static void pop([dynamic arguments]) {
    Get.back(result: arguments);
  }

  static void redirect(String page, [dynamic arguments]) {
    Get.offNamed(page, arguments: arguments);
  }

  // // 路由初始化
  // static run(RouteSettings settings) {
  //   final Function? pageContentBuilder = Routers.routes[settings.name];

  //   if (pageContentBuilder != null) {
  //     currentRouteName = settings.name!;
  //     if (settings.arguments != null) {
  //       // 传参路由
  //       return CupertinoPageRoute(
  //           fullscreenDialog: false,
  //           builder: (context) =>
  //               pageContentBuilder(context, arguments: settings.arguments));
  //     } else {
  //       // 无参数路由
  //       return CupertinoPageRoute(
  //           builder: (context) => pageContentBuilder(context));
  //     }
  //   } else {
  //     // 404页
  //     // return CupertinoPageRoute(builder: (context) => NotFoundPage());
  //   }
  // }

  // 组件跳转
  // static link(Widget child, String routeName, BuildContext context,
  //     [Map? parmas]) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (parmas != null) {
  //         Navigator.pushNamed(context, routeName, arguments: parmas);
  //       } else {
  //         Navigator.pushNamed(context, routeName);
  //       }
  //     },
  //     child: child,
  //   );
  // }

  // // 方法跳转
  // static push(String routeName, BuildContext context, [Map? parmas]) async {
  //   if (filterList.contains(routeName)) {
  //     if (parmas != null) {
  //       Navigator.pushNamed(context, routeName, arguments: parmas);
  //     } else {
  //       Navigator.pushNamed(context, routeName);
  //     }
  //     return;
  //   }
  //   // 如果状态管理器中的Token是空的
  //   if (Provider.of<Model>(context, listen: false).token.isEmpty) {
  //     Navigator.pushNamed(
  //       context,
  //       '/LoginPage',
  //     );
  //     return;
  //   }

  //   if (parmas != null) {
  //     return Navigator.pushNamed(context, routeName, arguments: parmas)
  //         .then((value) {
  //       EasyLoading.dismiss();
  //       return value;
  //     });
  //   } else {
  //     return Navigator.pushNamed(
  //       context,
  //       routeName,
  //     ).then((value) {
  //       EasyLoading.dismiss();
  //       return value;
  //     });
  //   }
  // }

  // // 方法跳转,无返回
  // static redirect(String routeName, BuildContext context, [Map? parmas]) {
  //   if (parmas != null) {
  //     return Navigator.pushReplacementNamed(context, routeName,
  //         arguments: parmas);
  //   } else {
  //     Navigator.pushReplacementNamed(context, routeName); //pushReplacementNamed
  //   }
  // }

  // //modal弹出
  // static Future popup(String routeName, BuildContext context, [Map? parmas]) {
  //   return Navigator.of(context).push(MaterialPageRoute(
  //       fullscreenDialog: true,
  //       builder: (context) {
  //         return Routers.routes[routeName]!.call();
  //       }));
  // }

  // static pop(BuildContext context, [Map? params]) {
  //   return Navigator.pop(context, params);
  // }

  // /// 返回
  // static void goBack(BuildContext context) {
  //   FocusScope.of(context).unfocus();
  //   Navigator.pop(context);
  // }
}
