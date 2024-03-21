import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/views/code_scan/bindings.dart';
import 'package:shop_app_client/views/code_scan/view.dart';
import 'package:shop_app_client/views/common/comment/bindings.dart';
import 'package:shop_app_client/views/common/comment/view.dart';
import 'package:shop_app_client/views/common/country/country_binding.dart';
import 'package:shop_app_client/views/common/country/country_list_page.dart';
import 'package:shop_app_client/views/express/express_query_bind.dart';
import 'package:shop_app_client/views/express/express_query_page.dart';
import 'package:shop_app_client/views/group/group_center/bindings.dart';
import 'package:shop_app_client/views/group/group_center/view.dart';
import 'package:shop_app_client/views/group/group_choose_parcel/bindings.dart';
import 'package:shop_app_client/views/group/group_choose_parcel/view.dart';
import 'package:shop_app_client/views/group/group_create/bindings.dart';
import 'package:shop_app_client/views/group/group_create/view.dart';
import 'package:shop_app_client/views/group/group_detail/bindings.dart';
import 'package:shop_app_client/views/group/group_detail/view.dart';
import 'package:shop_app_client/views/group/group_member_detail/bindings.dart';
import 'package:shop_app_client/views/group/group_member_detail/view.dart';
import 'package:shop_app_client/views/group/group_order/bindings.dart';
import 'package:shop_app_client/views/group/group_order/view.dart';
import 'package:shop_app_client/views/group/group_order_process/bindings.dart';
import 'package:shop_app_client/views/group/group_order_process/view.dart';
import 'package:shop_app_client/views/help/customer/binding.dart';
import 'package:shop_app_client/views/help/customer/view.dart';
import 'package:shop_app_client/views/help/guide/guide_binding.dart';
import 'package:shop_app_client/views/help/guide/guide_view.dart';
import 'package:shop_app_client/views/help/help_center/bindings.dart';
import 'package:shop_app_client/views/help/help_center/view.dart';
import 'package:shop_app_client/views/help/question/bindings.dart';
import 'package:shop_app_client/views/help/question/view.dart';
import 'package:shop_app_client/views/line/detail/line_detail_binding.dart';
import 'package:shop_app_client/views/line/detail/line_detail_view.dart';
import 'package:shop_app_client/views/line/query/line_query_binding.dart';
import 'package:shop_app_client/views/line/query/line_query_view.dart';
import 'package:shop_app_client/views/line/query_result/line_query_result_binding.dart';
import 'package:shop_app_client/views/line/query_result/line_query_result_view.dart';
import 'package:shop_app_client/views/notice/notice_binding.dart';
import 'package:shop_app_client/views/notice/notice_page.dart';
import 'package:shop_app_client/views/order/center/order_center_binding.dart';
import 'package:shop_app_client/views/order/center/order_center_page.dart';
import 'package:shop_app_client/views/order/comment/binding.dart';
import 'package:shop_app_client/views/order/comment/view.dart';
import 'package:shop_app_client/views/order/detail/order_detail_binding.dart';
import 'package:shop_app_client/views/order/detail/order_detail_page.dart';
import 'package:shop_app_client/views/order/tracking/tracking_binding.dart';
import 'package:shop_app_client/views/order/tracking/tracking_detail_page.dart';
import 'package:shop_app_client/views/parcel/create_order/bindings.dart';
import 'package:shop_app_client/views/parcel/create_order/view.dart';
import 'package:shop_app_client/views/parcel/forecast/forecast_binding.dart';
import 'package:shop_app_client/views/parcel/forecast/forecast_parcel_page.dart';
import 'package:shop_app_client/views/parcel/no_owner/detail/no_owner_parcel_detail_binding.dart';
import 'package:shop_app_client/views/parcel/no_owner/detail/no_owner_parcel_detail_view.dart';
import 'package:shop_app_client/views/parcel/no_owner/list/no_owner_parcel_binding.dart';
import 'package:shop_app_client/views/parcel/no_owner/list/no_owner_parcel_view.dart';
import 'package:shop_app_client/views/parcel/parcel_detail/parcel_detail_binding.dart';
import 'package:shop_app_client/views/parcel/parcel_detail/parcel_detail_page.dart';
import 'package:shop_app_client/views/parcel/parcel_edit/parcel_edit_binding.dart';
import 'package:shop_app_client/views/parcel/parcel_edit/parcel_edit_page.dart';
import 'package:shop_app_client/views/payment/pay_success/pay_success_binding.dart';
import 'package:shop_app_client/views/payment/pay_success/pay_success_view.dart';
import 'package:shop_app_client/views/payment/recharge/recharge_binding.dart';
import 'package:shop_app_client/views/payment/recharge/recharge_view.dart';
import 'package:shop_app_client/views/payment/recharge_history/bindings.dart';
import 'package:shop_app_client/views/payment/recharge_history/view.dart';
import 'package:shop_app_client/views/payment/shop_pay/shop_order_pay_binding.dart';
import 'package:shop_app_client/views/payment/shop_pay/shop_order_pay_view.dart';
import 'package:shop_app_client/views/payment/transfer_payment/bindings.dart';
import 'package:shop_app_client/views/payment/transfer_payment/view.dart';
import 'package:shop_app_client/views/payment/transport_pay/bindings.dart';
import 'package:shop_app_client/views/payment/transport_pay/view.dart';
import 'package:shop_app_client/views/shop/cart/cart_binding.dart';
import 'package:shop_app_client/views/shop/cart/cart_view.dart';
import 'package:shop_app_client/views/shop/category/binding.dart';
import 'package:shop_app_client/views/shop/category/view.dart';
import 'package:shop_app_client/views/shop/center/shop_center_binding.dart';
import 'package:shop_app_client/views/shop/center/shop_center_view.dart';
import 'package:shop_app_client/views/shop/chat_detail/order_chat_detail_binding.dart';
import 'package:shop_app_client/views/shop/chat_detail/order_chat_detail_view.dart';
import 'package:shop_app_client/views/shop/goods_list/goods_list_binding.dart';
import 'package:shop_app_client/views/shop/goods_list/goods_list_view.dart';
import 'package:shop_app_client/views/shop/image_search_goods/image_search_binding.dart';
import 'package:shop_app_client/views/shop/image_search_goods/image_search_view.dart';
import 'package:shop_app_client/views/shop/manual_order/binding.dart';
import 'package:shop_app_client/views/shop/manual_order/view.dart';
import 'package:shop_app_client/views/shop/order/shop_order_binding.dart';
import 'package:shop_app_client/views/shop/order/shop_order_view.dart';
import 'package:shop_app_client/views/shop/order_chat/shop_order_chat_binding.dart';
import 'package:shop_app_client/views/shop/order_chat/shop_order_chat_view.dart';
import 'package:shop_app_client/views/shop/order_detail/order_detail_binding.dart';
import 'package:shop_app_client/views/shop/order_detail/order_detail_view.dart';
import 'package:shop_app_client/views/shop/order_preview/order_preview_binding.dart';
import 'package:shop_app_client/views/shop/order_preview/order_preview_view.dart';
import 'package:shop_app_client/views/shop/problem_order/problem_order_binding.dart';
import 'package:shop_app_client/views/shop/problem_order/problem_order_view.dart';
import 'package:shop_app_client/views/user/abount/about_me_binding.dart';
import 'package:shop_app_client/views/user/abount/about_me_page.dart';
import 'package:shop_app_client/views/user/address/add/address_add_edit_binding.dart';
import 'package:shop_app_client/views/user/address/add/address_add_edit_view.dart';
import 'package:shop_app_client/views/user/address/list/address_list_binding.dart';
import 'package:shop_app_client/views/user/address/list/address_list_view.dart';
import 'package:shop_app_client/views/user/agent/agent_apply/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_apply/view.dart';
import 'package:shop_app_client/views/user/agent/agent_apply_instruction/binding.dart';
import 'package:shop_app_client/views/user/agent/agent_apply_instruction/view.dart';
import 'package:shop_app_client/views/user/agent/agent_center/binding.dart';
import 'package:shop_app_client/views/user/agent/agent_center/view.dart';
import 'package:shop_app_client/views/user/agent/agent_commission/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_commission/view.dart';
import 'package:shop_app_client/views/user/agent/agent_commission_apply/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_commission_apply/view.dart';
import 'package:shop_app_client/views/user/agent/agent_commission_history/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_commission_history/view.dart';
import 'package:shop_app_client/views/user/agent/agent_member/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_member/view.dart';
import 'package:shop_app_client/views/user/agent/agent_withdraw_detail/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_withdraw_detail/view.dart';
import 'package:shop_app_client/views/user/agent/agent_withdraw_record/bindings.dart';
import 'package:shop_app_client/views/user/agent/agent_withdraw_record/view.dart';
import 'package:shop_app_client/views/user/bind_info/bind_info_binding.dart';
import 'package:shop_app_client/views/user/bind_info/bind_info_view.dart';
import 'package:shop_app_client/views/user/info_change/info_change_binding.dart';
import 'package:shop_app_client/views/user/info_change/info_change_view.dart';
import 'package:shop_app_client/views/user/coupon/bindings.dart';
import 'package:shop_app_client/views/user/coupon/view.dart';
import 'package:shop_app_client/views/user/forget_password/forget_password_binding.dart';
import 'package:shop_app_client/views/user/forget_password/forget_password_page.dart';
import 'package:shop_app_client/views/user/logged_guide/binding.dart';
import 'package:shop_app_client/views/user/logged_guide/view.dart';
import 'package:shop_app_client/views/user/profile/profile_binding.dart';
import 'package:shop_app_client/views/user/profile/profile_view.dart';
import 'package:shop_app_client/views/user/register/register_binding.dart';
import 'package:shop_app_client/views/user/register/register_page.dart';
import 'package:shop_app_client/views/user/setting_locale/binding.dart';
import 'package:shop_app_client/views/user/setting_locale/view.dart';
import 'package:shop_app_client/views/user/setting_password/setting_password_binding.dart';
import 'package:shop_app_client/views/user/setting_password/setting_password_view.dart';
import 'package:shop_app_client/views/user/station/station_binding.dart';
import 'package:shop_app_client/views/user/station/station_view.dart';
import 'package:shop_app_client/views/user/station_select/station_select_binding.dart';
import 'package:shop_app_client/views/user/station_select/station_select_view.dart';
import 'package:shop_app_client/views/user/transaction/transaction_binding.dart';
import 'package:shop_app_client/views/user/transaction/transaction_page.dart';
import 'package:shop_app_client/views/user/vip/center/vip_center_binding.dart';
import 'package:shop_app_client/views/user/vip/center/vip_center_view.dart';
import 'package:shop_app_client/views/user/vip/growth_value/growth_value_binding.dart';
import 'package:shop_app_client/views/user/vip/growth_value/growth_value_view.dart';
import 'package:shop_app_client/views/user/vip/point/point_binding.dart';
import 'package:shop_app_client/views/user/vip/point/point_view.dart';
import 'package:shop_app_client/views/warehouse/warehouse_binding.dart';
import 'package:shop_app_client/views/warehouse/warehouse_page.dart';
import 'package:shop_app_client/views/tabbar/tabbar_binding.dart';
import 'package:shop_app_client/views/tabbar/tabbar_view.dart';
import 'package:shop_app_client/views/user/login/login_binding.dart';
import 'package:shop_app_client/views/user/login/login_page.dart';
import 'package:shop_app_client/views/webview/webview_binding.dart';
import 'package:shop_app_client/views/webview/webview_page.dart';
import 'package:shop_app_client/views/banner_webview/webview_binding.dart';
import 'package:shop_app_client/views/banner_webview/webview_page.dart';

class GlobalPages {
  GlobalPages._();

  static const String home = '/';
  static const String editParcel = '/parcel/edit'; // 修改包裹
  static const String parcelDetail = '/parcel/detail'; // 包裹详情
  static const String addressList = '/address/list'; // 地址列表
  static const String addressAddEdit = '/address/addEdit'; // 添加、修改地址
  static const String orderDetail = '/order/detail'; // 订单详情
  static const String orderComment = '/order/comment'; // 订单评价
  static const String orderTracking = '/order/tracking'; // 订单物流
  static const String userInfo = '/user/info';
  static const String warehouse = '/warehouse'; // 仓库
  static const String webview = '/webview';
  static const String bannerWebview = '/bannerWebview';
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
  static const String agentApplyInstruct = '/agentApplyInstruct'; // 代理申请说明
  static const String agentCenter = '/agentCenter'; // 代理中心
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
  static const String chromeLogin = '/chromeLogin'; // chorme 插件扫码登录
  static const String guide = '/guide'; // 新手指引
  static const String localeSetting = '/localeSetting'; // 语言、货币设置
  static const String customer = '/customer'; // 客服
  static const String loggedGuide = '/loggedGuide'; // 登录后指引

  static const String groupCenter = '/groupCenter'; // 拼团中心
  static const String groupCreate = '/groupCreate'; // 创建拼团
  static const String groupOrder = '/groupOrder'; // 拼团订单
  static const String groupOrderPorcess = '/groupOrderProcess'; // 团单进度
  static const String groupDetail = '/groupDetail'; // 拼团详情
  static const String groupMemberDetail = '/groupMemberDetail'; // 参团人员详情
  static const String groupParcelSelect = '/groupParcelSelect'; // 选择参团包裹

  static const String shopCenter = '/shopCenter'; //自营商城中心
  static const String goodsList = '/goodsList'; // 自营商品列表
  static const String orderPreview = '/orderPreview'; // 商品订单确认
  static const String shopOrderPay = '/shopOrderPay'; // 商城订单支付
  static const String paySuccess = '/paySuccess'; // 支付成功
  static const String shopOrderList = '/shopOrderList'; // 商城订单列表
  static const String shopOrderDetail = '/shopOrderDetail'; // 商城订单详情
  static const String probleShopOrder = '/probleShopOrder'; // 问题商品列表
  static const String shopOrderChat = '/shopOrderChat'; // 我的咨询
  static const String shopOrderChatDetail = '/shopOrderChatDetail'; // 咨询详情
  static const String imageSearch = '/imageSearch';
  static const String manualOrder = '/manualOrder';
  static const String cart = '/cart';
  static const String goodsCategory = '/goodsCategory';

  static List filterList = [
    webview,
    forgetPassword,
    station,
    country,
    abountMe,
    home,
    login,
    goodsCategory,
    register,
    loggedGuide,
    track,
    shopCenter,
    guide,
    goodsList,
    lineQuery,
    lineDetail,
    lineQueryResult,
    help,
    question,
    comment,
    customer,
    chromeLogin,
  ];

  // 路由声明
  static final routes = [
    GetPage(
      name: home,
      page: () => const TabbarScrren(),
      binding: TabbarLinker(),
    ),
    GetPage(
      name: login,
      page: () => const BeeSignInPage(),
      binding: BeeSignInBinding(),
    ),
    GetPage(
      name: country,
      page: () => const CountryListView(),
      binding: CountryBinding(),
    ),
    GetPage(
      name: warehouse,
      page: () => const BeeCangKuPage(),
      binding: BeeCangKuBinding(),
    ),
    GetPage(
      name: forecast,
      page: () => const BeeParcelCreatePage(),
      binding: BeeParcelCreateBinding(),
    ),
    GetPage(
      name: parcelDetail,
      page: () => const BeePackageDetailPage(),
      binding: BeePackageDetailBinding(),
    ),
    GetPage(
      name: guide,
      page: () => const GuideView(),
      binding: GuideBinding(),
    ),
    GetPage(
      name: userInfo,
      page: () => const InfoPage(),
      binding: BeeInfoBinding(),
    ),
    GetPage(
      name: loggedGuide,
      page: () => const LoggedGuideView(),
      binding: LoggedGuideBinding(),
    ),
    GetPage(
      name: customer,
      page: () => const CustomerView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: editParcel,
      page: () => const BeePackageUpdatePage(),
      binding: BeePackageUpdateBinding(),
    ),
    GetPage(
      name: orderTracking,
      page: () => const BeeOrderTrackPage(),
      binding: BeeOrderTrackBinding(),
    ),
    GetPage(
      name: abountMe,
      page: () => const BeePage(),
      binding: BeeBinding(),
    ),
    GetPage(
      name: webview,
      page: () => const BeeWebView(),
      binding: BeeWebviewBinding(),
    ),
    GetPage(
      name: bannerWebview,
      page: () => const BeeBannerWebView(),
      binding: BeeBannerWebviewBinding(),
    ),
    GetPage(
      name: localeSetting,
      page: () => const SettingLocaleView(),
      binding: SettingLocaleBinding(),
    ),
    GetPage(
      name: password,
      page: () => const BeeNewPwdPage(),
      binding: BeeNewPwdBinding(),
    ),
    GetPage(
      name: transaction,
      page: () => const BeeTradePage(),
      binding: BeeTradeBinding(),
    ),
    GetPage(
      name: profile,
      page: () => const BeeUserInfoPage(),
      binding: BeeUserInfoBinding(),
    ),
    GetPage(
      name: changeMobileAndEmail,
      page: () => const BeePhonePage(),
      binding: BeePhoneBinding(),
    ),
    GetPage(
      name: addressList,
      page: () => const BeeShippingPage(),
      binding: BeeShippingBinding(),
    ),
    GetPage(
      name: addressAddEdit,
      page: () => const BeeAddressInfoPage(),
      binding: BeeAddressInfoBinding(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => const BeeResetPwdPage(),
      binding: BeeResetPwdBinding(),
    ),
    GetPage(
      name: orderDetail,
      page: () => const BeeOrderPage(),
      binding: BeeOrderBinding(),
    ),
    GetPage(
      name: noOwnerList,
      page: () => const AbnomalParcelPage(),
      binding: AbnomalParcelBinding(),
    ),
    GetPage(
      name: noOwnerDetail,
      page: () => const BeeParcelClaimPage(),
      binding: BeeParcelClaimBinding(),
    ),
    GetPage(
      name: vip,
      page: () => const BeeSuperUserView(),
      binding: BeeSuperUserBinding(),
    ),
    GetPage(
      name: point,
      page: () => const IntergralPage(),
      binding: IntergralBinding(),
    ),
    GetPage(
      name: growthValue,
      page: () => const BeeValuesPage(),
      binding: BeeValuesBinding(),
    ),
    GetPage(
      name: register,
      page: () => const BeeSignUpPage(),
      binding: BeeSignUpBinding(),
    ),
    GetPage(
      name: track,
      page: () => const BeeTrackingView(),
      binding: BeeTrackingBinding(),
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
      name: orderPreview,
      page: () => const OrderPreviewView(),
      binding: OrderPreviewBinding(),
    ),
    GetPage(
      name: orderComment,
      page: () => const OrderCommentView(),
      binding: OrderCommentBinding(),
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
      name: chromeLogin,
      page: () => const CodeScanPage(),
      binding: CodeScanBinding(),
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
      name: goodsCategory,
      page: () => const GoodsCategoryView(),
      binding: GoodsCategoryBinding(),
    ),
    GetPage(
      name: notice,
      page: () => const InformationView(),
      binding: InformationBinding(),
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
      name: agentCenter,
      page: () => const AgentCenterView(),
      binding: AgentCenterBinding(),
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
      name: agentApplyInstruct,
      page: () => const AgentApplyInstructionView(),
      binding: AgentApplyInstructionBinding(),
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
      page: () => const BeeSupportView(),
      binding: BeeSupportBinding(),
    ),
    GetPage(
      name: question,
      page: () => const BeeQusView(),
      binding: BeeQusBinding(),
    ),
    GetPage(
      name: orderCenter,
      page: () => const BeeOrderIndexPage(),
      binding: BeeOrderIndexBinding(),
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
      page: () => const BeePackingView(),
      binding: BeePackingBinding(),
    ),
    GetPage(
      name: groupCenter,
      page: () => const BeeGroupView(),
      binding: BeeGroupBinding(),
    ),
    GetPage(
      name: groupCreate,
      page: () => const BeeGroupCreateView(),
      binding: BeeGroupCreateBinding(),
    ),
    GetPage(
      name: groupOrder,
      page: () => const BeeGroupOrderView(),
      binding: GroupOrderBinding(),
    ),
    GetPage(
      name: groupOrderPorcess,
      page: () => const BeeGroupOrderDetailView(),
      binding: BeeGroupOrderDetailBinding(),
    ),
    GetPage(
      name: groupDetail,
      page: () => const BeeGroupDetailView(),
      binding: BeeGroupDetailBinding(),
    ),
    GetPage(
      name: groupMemberDetail,
      page: () => const BeeGroupUsersView(),
      binding: BeeGroupUsersBinding(),
    ),
    GetPage(
      name: groupParcelSelect,
      page: () => const BeeGroupParcelSelectView(),
      binding: BeeGroupParcelSelectBinding(),
    ),
    GetPage(
      name: imageSearch,
      page: () => const GoodsImageSearchPage(),
      binding: GoodsImageSearchBinding(),
    ),
    GetPage(
      name: manualOrder,
      page: () => const ManualOrderView(),
      binding: ManualOrderBinding(),
    ),
    GetPage(
      name: cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ];

  static String currentRouteName = "";

  // 跳转到下个页面
  static Future<dynamic>? push(
    String page, {
    dynamic arg,
    Map<String, String>? parameters,
  }) {
    AppStore userInfo = Get.find<AppStore>();
    if (filterList.contains(page) || userInfo.token.value.isNotEmpty) {
      return Get.toNamed(page, arguments: arg, parameters: parameters);
    } else {
      return Get.toNamed(login);
    }
  }

  static Future<dynamic>? toPage(
    dynamic page, {
    dynamic arguments,
    Bindings? binding,
    bool authCheck = false,
  }) {
    AppStore userInfo = Get.find<AppStore>();
    if (!authCheck || userInfo.token.value.isNotEmpty) {
      return Get.to(page, arguments: arguments, binding: binding);
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
  //       GlobalPages.excludeGetPageRoute[settings.name];

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
  //   var token = Get.find<AppStore>().token;
  //   if (token.value.isEmpty) {
  //     GlobalPages.push(GlobalPages.login);
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
  //         return GlobalPages.routes[routeName]!.call();
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
