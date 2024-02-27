import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/order_model.dart';
import 'package:huanting_shop/models/pay_type_model.dart';
import 'package:huanting_shop/models/user_coupon_model.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_vip_price_model.dart';
import 'package:huanting_shop/services/balance_service.dart';
import 'package:huanting_shop/services/order_service.dart';
import 'package:huanting_shop/services/user_service.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';

class TransportPayController extends GlobalLogic {
  final payTypeList = <PayTypeModel>[].obs;
  final selectedPayType = Rxn<PayTypeModel?>();
  final RxNum myBalance = RxNum(0);
  final vipPriceModel = Rxn<UserVipPriceModel?>();
  final orderModel = Rxn<OrderModel?>();
  final orderId = Rxn<int?>();
  final selectCoupon = Rxn<UserCouponModel?>();
  final pointShow = false.obs;
  final isUsePoint = false.obs;
  final payModel = 0.obs; // 0 冲会员 1 订单付款
  bool isGroupOrder = false; // 是否是拼团订单

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    payModel.value = arguments['payModel'];

    if (payModel.value == 0) {
      vipPriceModel.value = arguments['model'] as UserVipPriceModel;
    } else if (payModel.value == 1) {
      orderId.value = arguments['id'];
      if (Get.arguments['isLeader'] != null) {
        isGroupOrder = true;
        previewGroupOrder();
      } else {
        previewOrder();
      }
      previewOrder();
    }
    created();
  }

  created() async {
    bool noDelivery =
        payModel.value == 0 || Get.arguments['deliveryStatus'] == 1;
    payTypeList.value =
        await BalanceService.getPayTypeList(noDelivery: noDelivery);
    var userOrderDataCount = await UserService.getOrderDataCount();
    var vipInfo = await UserService.getVipMemberData();
    myBalance.value = (userOrderDataCount!.balance ?? 0);
    if (vipInfo != null &&
        vipInfo.pointStatus == 1 &&
        vipInfo.ruleStatus.pointDecrease) {
      pointShow.value = true;
    }
  }

  String getPayTypeIcon(String type) {
    String icon = 'Center/transfer';
    switch (type) {
      case 'alipay':
        icon = 'Center/alipay';
        break;
      case 'wechat':
        icon = 'Center/wechat_pay';
        break;
      case 'balance':
        icon = 'Center/balance_pay';
        break;
    }
    return icon;
  }

  // 预览订单
  void previewOrder() async {
    Map<String, dynamic> map = {
      'order_id': orderId.value,
      'coupon_id': selectCoupon.value?.id ?? '',
      'is_use_point': isUsePoint.value ? 1 : 0,
    };
    OrderService.updateReadyPay(map, (data) {
      orderModel.value = OrderModel.fromJson(data.data);
      if (orderModel.value!.coupon != null) {
        selectCoupon.value = orderModel.value!.coupon;
      }
    }, (message) => null);
  }

  // 预览拼团订单
  void previewGroupOrder() async {
    var data = await OrderService.onPreviewGroupOrder(orderId.value!, {
      'coupon_id': selectCoupon.value?.id ?? '',
      'is_use_point': isUsePoint.value ? 1 : 0,
    });
    if (data != null) {
      orderModel.value = data;
      if (orderModel.value!.coupon != null) {
        selectCoupon.value = orderModel.value!.coupon;
      }
    }
  }

  // 支付
  onPay(BuildContext context) async {
    if (selectedPayType.value == null) {
      showToast('请选择支付方式');
      return;
    }
    PayTypeModel model = selectedPayType.value!;
    if (model.name == 'wechat') {
      // 微信付款
      // weChatPayMethod();
    } else if (model.name == 'alipay') {
      // 支付宝付款
      // onAliPay();
    } else if (model.name == 'paypal') {
      // paypal 支付
    } else if (model.name == 'on_delivery') {
      // 货到付款
      Map<String, dynamic> map = {
        'point': orderModel.value!.point,
        'is_use_point': orderModel.value!.isusepoint,
        'type': '4', // app支付
        'point_amount': orderModel.value!.pointamount,
        'order_id': orderModel.value!.id
      };
      Map result = await BalanceService.orderOnDelivery(map);
      onPayResult(result);
    } else if (model.name == 'balance') {
      // 余额付款订单
      var result = await BaseDialog.confirmDialog(
        context,
        '您确认使用余额支付吗'.ts,
      );
      if (result != null) {
        payByBalance();
      }
    } else {
      if (payModel.value == 0) {
        // 充值会员转账
        BeeNav.push(BeeNav.paymentTransfer, arg: {
          'transferType': 0,
          'contentModel': vipPriceModel.value!,
          'payModel': model,
        });
      } else if (payModel.value == 1) {
        // 订单付款转账
        BeeNav.push(BeeNav.paymentTransfer, arg: {
          'transferType': 2,
          'contentModel': orderModel.value,
          'payModel': model,
        });
      }
    }
  }

  // 余额付款
  payByBalance() async {
    Map result = {};
    if (payModel.value == 0) {
      // 余额付款会员充值
      Map<String, dynamic> map = {
        'price_id': vipPriceModel.value!.id,
        'price_type': vipPriceModel.value!.type
      };
      result = await BalanceService.buyVipBalance(map);
    } else if (payModel.value == 1) {
      // 余额付款订单
      Map<String, dynamic> map = {
        'point': orderModel.value!.point,
        'is_use_point': orderModel.value!.isusepoint,
        'type': '4', // app支付
        'point_amount': orderModel.value!.pointamount,
        'order_id': orderModel.value!.id
      };
      result = await BalanceService.orderBalancePay(map);
    }
    onPayResult(result);
  }

  // 支付结果
  onPayResult(Map result) {
    if (result['ok']) {
      Get.find<AppStore>().getBaseCountInfo();
      BeeNav.pop('succeed');
    }
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
