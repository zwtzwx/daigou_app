import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/views/common/comment/bindings.dart';
import 'package:jiyun_app_client/views/common/comment/view.dart';
import 'package:jiyun_app_client/views/common/country/country_binding.dart';
import 'package:jiyun_app_client/views/common/country/country_list_page.dart';
import 'package:jiyun_app_client/views/contact/contact_binding.dart';
import 'package:jiyun_app_client/views/contact/contact_page.dart';
import 'package:jiyun_app_client/views/express/express_query_bind.dart';
import 'package:jiyun_app_client/views/express/express_query_page.dart';
import 'package:jiyun_app_client/views/group/group_center/bindings.dart';
import 'package:jiyun_app_client/views/group/group_center/view.dart';
import 'package:jiyun_app_client/views/help/help_center/bindings.dart';
import 'package:jiyun_app_client/views/help/help_center/view.dart';
import 'package:jiyun_app_client/views/help/question/bindings.dart';
import 'package:jiyun_app_client/views/help/question/view.dart';
import 'package:jiyun_app_client/views/line/detail/line_detail_binding.dart';
import 'package:jiyun_app_client/views/line/detail/line_detail_view.dart';
import 'package:jiyun_app_client/views/line/query/line_query_binding.dart';
import 'package:jiyun_app_client/views/line/query/line_query_view.dart';
import 'package:jiyun_app_client/views/line/query_result/line_query_result_binding.dart';
import 'package:jiyun_app_client/views/line/query_result/line_query_result_view.dart';
import 'package:jiyun_app_client/views/notice/notice_binding.dart';
import 'package:jiyun_app_client/views/notice/notice_page.dart';
import 'package:jiyun_app_client/views/order/center/order_center_binding.dart';
import 'package:jiyun_app_client/views/order/center/order_center_page.dart';
import 'package:jiyun_app_client/views/order/detail/order_detail_binding.dart';
import 'package:jiyun_app_client/views/order/detail/order_detail_page.dart';
import 'package:jiyun_app_client/views/order/list/order_list_binding.dart';
import 'package:jiyun_app_client/views/order/list/order_list_view.dart';
import 'package:jiyun_app_client/views/order/tracking/tracking_binding.dart';
import 'package:jiyun_app_client/views/order/tracking/tracking_detail_page.dart';
import 'package:jiyun_app_client/views/parcel/create_order/bindings.dart';
import 'package:jiyun_app_client/views/parcel/create_order/view.dart';
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
import 'package:jiyun_app_client/views/payment/pay_success/pay_success_binding.dart';
import 'package:jiyun_app_client/views/payment/pay_success/pay_success_view.dart';
import 'package:jiyun_app_client/views/payment/recharge/recharge_binding.dart';
import 'package:jiyun_app_client/views/payment/recharge/recharge_view.dart';
import 'package:jiyun_app_client/views/payment/recharge_history/bindings.dart';
import 'package:jiyun_app_client/views/payment/recharge_history/view.dart';
import 'package:jiyun_app_client/views/payment/shop_pay/shop_order_pay_binding.dart';
import 'package:jiyun_app_client/views/payment/shop_pay/shop_order_pay_view.dart';
import 'package:jiyun_app_client/views/payment/transfer_payment/bindings.dart';
import 'package:jiyun_app_client/views/payment/transfer_payment/view.dart';
import 'package:jiyun_app_client/views/payment/transport_pay/bindings.dart';
import 'package:jiyun_app_client/views/payment/transport_pay/view.dart';
import 'package:jiyun_app_client/views/shop/center/shop_center_binding.dart';
import 'package:jiyun_app_client/views/shop/center/shop_center_view.dart';
import 'package:jiyun_app_client/views/shop/chat_detail/order_chat_detail_binding.dart';
import 'package:jiyun_app_client/views/shop/chat_detail/order_chat_detail_view.dart';
import 'package:jiyun_app_client/views/shop/goods_detail/goods_detail_binding.dart';
import 'package:jiyun_app_client/views/shop/goods_detail/goods_detail_view.dart';
import 'package:jiyun_app_client/views/shop/goods_list/goods_list_binding.dart';
import 'package:jiyun_app_client/views/shop/goods_list/goods_list_view.dart';
import 'package:jiyun_app_client/views/shop/order/shop_order_binding.dart';
import 'package:jiyun_app_client/views/shop/order/shop_order_view.dart';
import 'package:jiyun_app_client/views/shop/order_chat/shop_order_chat_binding.dart';
import 'package:jiyun_app_client/views/shop/order_chat/shop_order_chat_view.dart';
import 'package:jiyun_app_client/views/shop/order_detail/order_detail_binding.dart';
import 'package:jiyun_app_client/views/shop/order_detail/order_detail_view.dart';
import 'package:jiyun_app_client/views/shop/order_preview/order_preview_binding.dart';
import 'package:jiyun_app_client/views/shop/order_preview/order_preview_view.dart';
import 'package:jiyun_app_client/views/shop/platform_goods/platform_goods_binding.dart';
import 'package:jiyun_app_client/views/shop/platform_goods/platform_goods_list_view.dart';
import 'package:jiyun_app_client/views/shop/problem_order/problem_order_binding.dart';
import 'package:jiyun_app_client/views/shop/problem_order/problem_order_view.dart';
import 'package:jiyun_app_client/views/user/abount/about_me_binding.dart';
import 'package:jiyun_app_client/views/user/abount/about_me_page.dart';
import 'package:jiyun_app_client/views/user/address/add/address_add_edit_binding.dart';
import 'package:jiyun_app_client/views/user/address/add/address_add_edit_view.dart';
import 'package:jiyun_app_client/views/user/address/list/address_list_binding.dart';
import 'package:jiyun_app_client/views/user/address/list/address_list_view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_apply/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_apply/view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission/view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission_apply/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission_apply/view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission_history/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission_history/view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_member/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_member/view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_withdraw_detail/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_withdraw_detail/view.dart';
import 'package:jiyun_app_client/views/user/agent/agent_withdraw_record/bindings.dart';
import 'package:jiyun_app_client/views/user/agent/agent_withdraw_record/view.dart';
import 'package:jiyun_app_client/views/user/bind_info/bind_info_binding.dart';
import 'package:jiyun_app_client/views/user/bind_info/bind_info_view.dart';
import 'package:jiyun_app_client/views/user/coupon/bindings.dart';
import 'package:jiyun_app_client/views/user/coupon/view.dart';
import 'package:jiyun_app_client/views/user/forget_password/forget_password_binding.dart';
import 'package:jiyun_app_client/views/user/forget_password/forget_password_page.dart';
import 'package:jiyun_app_client/views/user/profile/profile_binding.dart';
import 'package:jiyun_app_client/views/user/profile/profile_view.dart';
import 'package:jiyun_app_client/views/user/register/register_binding.dart';
import 'package:jiyun_app_client/views/user/register/register_page.dart';
import 'package:jiyun_app_client/views/user/setting_password/setting_password_binding.dart';
import 'package:jiyun_app_client/views/user/setting_password/setting_password_view.dart';
import 'package:jiyun_app_client/views/user/station/station_binding.dart';
import 'package:jiyun_app_client/views/user/station/station_view.dart';
import 'package:jiyun_app_client/views/user/station_select/station_select_binding.dart';
import 'package:jiyun_app_client/views/user/station_select/station_select_view.dart';
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
  static const String lineQuery = '/lineQuery'; // 运费估算
  static const String lineQueryResult = '/lineQueryResult'; // 运费估算
  static const String lineDetail = '/lineDetail'; // 运费估算
  static const String notice = '/notice'; // 消息通知
  static const String recharge = '/rechargePage'; // 充值
  static const String rechargeHistory = '/rechargeHistory'; // 充值
  static const String paymentTransfer = '/paymentTransfer'; // 充值
  static const String coupon = '/coupon'; // 优惠券
  static const String agentApply = '/agentApply'; // 代理申请
  static const String agentMember = '/agentMember'; // 代理推广好友
  static const String agentCommission = '/agentCommission'; // 佣金申请列表
  static const String agentWithdrawDetail = '/agentWithdrawDetail'; // 佣金申请记录详情
  static const String agentWithdrawRecord = '/agentWithdrawRecord'; // 佣金成交记录
  static const String agentCommissionList = '/agentCommissionList'; // 佣金列表
  static const String agentCommissionApply = '/agentCommissionApply'; // 佣金提现
  static const String comment = '/comment'; // 评论列表
  static const String help = '/help'; // 帮助中心
  static const String question = '/question'; // 问题
  static const String orderCenter = '/orderCenter'; // 包裹/订单中心
  static const String stationSelect = '/stationSelect'; // 自提点
  static const String transportPay = '/transportPay'; // 集运订单支付
  static const String createOrder = '/createOrder'; // 合箱

  static const String groupCenter = '/groupCenter'; // 拼团中心

  static const String shopCenter = '/shopCenter'; //自营商城中心
  static const String goodsList = '/goodsList'; // 自营商品列表
  static const String platformGoodsList = '/platformGoodsList'; // 代购商品列表
  static const String goodsDetail = '/goodsDetail'; // 商品详情
  static const String orderPreview = '/orderPreview'; // 商品订单确认
  static const String shopOrderPay = '/shopOrderPay'; // 商城订单支付
  static const String paySuccess = '/paySuccess'; // 支付成功
  static const String shopOrderList = '/shopOrderList'; // 商城订单列表
  static const String shopOrderDetail = '/shopOrderDetail'; // 商城订单详情
  static const String probleShopOrder = '/probleShopOrder'; // 问题商品列表
  static const String shopOrderChat = '/shopOrderChat'; // 我的咨询
  static const String shopOrderChatDetail = '/shopOrderChatDetail'; // 咨询详情

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
    track,
    shopCenter,
    goodsList,
    platformGoodsList,
    goodsDetail,
    lineQuery,
    lineDetail,
    lineQueryResult,
    help,
    question,
    comment,
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
    ),
    GetPage(
      name: shopCenter,
      page: () => const ShopCenterView(),
      binding: ShopCenterBinding(),
    ),
    GetPage(
      name: goodsList,
      page: () => const GoodsListView(),
      binding: GoodsListBinding(),
    ),
    GetPage(
      name: platformGoodsList,
      page: () => const PlatformGoodsListView(),
      binding: PlatformGoodsBinding(),
    ),
    GetPage(
      name: goodsDetail,
      page: () => const GoodsDetailView(),
      binding: GoodsDetailBinding(),
    ),
    GetPage(
      name: orderPreview,
      page: () => const OrderPreviewView(),
      binding: OrderPreviewBinding(),
    ),
    GetPage(
      name: lineQuery,
      page: () => const LineQueryView(),
      binding: LineQueryBinding(),
    ),
    GetPage(
      name: lineQueryResult,
      page: () => const LineQueryResultView(),
      binding: LineQueryResultBinding(),
    ),
    GetPage(
      name: lineDetail,
      page: () => const LineDetailView(),
      binding: LineDetailBinding(),
    ),
    GetPage(
      name: shopOrderPay,
      page: () => const ShopOrderPayView(),
      binding: ShopOrderPayBinding(),
    ),
    GetPage(
      name: paySuccess,
      page: () => const PaySuccessView(),
      binding: PaySuccessBinding(),
    ),
    GetPage(
      name: shopOrderList,
      page: () => const ShopOrderView(),
      binding: ShopOrderBinding(),
    ),
    GetPage(
      name: shopOrderDetail,
      page: () => const ShopOrderDetailView(),
      binding: ShopOrderDetailBinding(),
    ),
    GetPage(
      name: probleShopOrder,
      page: () => const ProblemOrderView(),
      binding: ProblemOrderBinding(),
    ),
    GetPage(
      name: shopOrderChat,
      page: () => const ShopOrderChatView(),
      binding: ShopOrderChatBinding(),
    ),
    GetPage(
      name: shopOrderChatDetail,
      page: () => const ShopChatDetailView(),
      binding: ShopOrderChatDetailBinding(),
    ),
    GetPage(
      name: notice,
      page: () => const NoticePage(),
      binding: NoticeBinding(),
    ),
    GetPage(
      name: recharge,
      page: () => const RechargeView(),
      binding: RechargeBinding(),
    ),
    GetPage(
      name: rechargeHistory,
      page: () => const RechargeHistoryPage(),
      binding: RechargeHistoryBinding(),
    ),
    GetPage(
      name: paymentTransfer,
      page: () => const TransferPaymentPage(),
      binding: TransferPaymentBinding(),
    ),
    GetPage(
      name: coupon,
      page: () => const CouponPage(),
      binding: CouponBinding(),
    ),
    GetPage(
      name: agentApply,
      page: () => const AgentApplyPage(),
      binding: AgentApplyBinding(),
    ),
    GetPage(
      name: agentMember,
      page: () => const AgentMemberPage(),
      binding: AgentMemberBinding(),
    ),
    GetPage(
      name: agentCommission,
      page: () => const AgentCommissionHistoryPage(),
      binding: AgentCommissionHistoryBinding(),
    ),
    GetPage(
      name: agentWithdrawDetail,
      page: () => const AgentWithdrawDetailPage(),
      binding: AgentWithdrawDetailBinding(),
    ),
    GetPage(
      name: agentWithdrawRecord,
      page: () => const AgentWithdrawRecordPage(),
      binding: AgentWithdrawRecordBinding(),
    ),
    GetPage(
      name: agentCommissionList,
      page: () => const AgentCommissionPage(),
      binding: AgentCommissionBinding(),
    ),
    GetPage(
      name: agentCommissionApply,
      page: () => const AgentCommissionApplyPage(),
      binding: AgentCommissionApplyBinding(),
    ),
    GetPage(
      name: comment,
      page: () => const CommentPage(),
      binding: CommentBinding(),
    ),
    GetPage(
      name: help,
      page: () => const HelpCenterPage(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: question,
      page: () => const QuestionPage(),
      binding: QuestionBinding(),
    ),
    GetPage(
      name: orderCenter,
      page: () => const OrderCenterView(),
      binding: OrderCenterBinding(),
    ),
    GetPage(
      name: station,
      page: () => const StationView(),
      binding: StationBinding(),
    ),
    GetPage(
      name: stationSelect,
      page: () => const StationSelectView(),
      binding: StationSelectBinding(),
    ),
    GetPage(
      name: transportPay,
      page: () => const TransportPayPage(),
      binding: TransportPayBinding(),
    ),
    GetPage(
      name: createOrder,
      page: () => const CreateOrderPage(),
      binding: CreateOrderBinding(),
    ),
    GetPage(
      name: groupCenter,
      page: () => const GroupCenterPage(),
      binding: GroupCenterBinding(),
    ),
  ];

  static String currentRouteName = "";

  // 跳转到下个页面
  static Future<dynamic>? push(String page, [dynamic arguments]) {
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

  // // // 路由初始化
  // static run(RouteSettings settings) {
  //   final Function? pageContentBuilder =
  //       Routers.excludeGetPageRoute[settings.name];

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

  // 方法跳转
  // static pushNormalPage(String routeName, BuildContext context,
  //     [Map? parmas]) async {
  //   if (filterList.contains(routeName)) {
  //     if (parmas != null) {
  //       Navigator.pushNamed(context, routeName, arguments: parmas);
  //     } else {
  //       Navigator.pushNamed(context, routeName);
  //     }
  //     return;
  //   }
  //   // 如果状态管理器中的Token是空的
  //   var token = Get.find<UserInfoModel>().token;
  //   if (token.value.isEmpty) {
  //     Routers.push(Routers.login);
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
