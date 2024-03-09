import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/instance_manager.dart';
// import 'package:fluwx/fluwx.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/config/wechat_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/pay_type_model.dart';
import 'package:shop_app_client/models/shop/problem_order_model.dart';
import 'package:shop_app_client/models/shop/shop_order_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/balance_service.dart';
import 'package:shop_app_client/services/shop_service.dart';
import 'package:shop_app_client/services/user_service.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';

class ShopOrderPayController extends GlobalController {
  final orderList = <ShopOrderModel>[].obs;
  final payTypeList = <PayTypeModel>[].obs;
  final selectedPayType = Rxn<PayTypeModel?>();
  final RxNum myBalance = RxNum(0);
  final problemOrder = Rxn<ProblemOrderModel?>();
  // StreamSubscription<BaseWeChatResponse>? wechatResponse;
  final endUtil = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments['order'] != null) {
      getPayInfo();
    } else if (arguments['problemOrder'] != null) {
      problemOrder.value = arguments['problemOrder'];
    }
    getBalance();
    getPayTypes();

    // 监听微信支付结果
    WechatConfig().onAddListener(onListenWechatResonse);
  }

  @override
  onClose() {
    WechatConfig().onRemoveListener(onListenWechatResonse);
  }

  onListenWechatResonse(respsonse) {
    if (respsonse is WeChatPaymentResponse) {
      if (respsonse.isSuccessful) {
        showSuccess('支付成功');
        onPaySuccess();
      } else {
        showError(respsonse.errStr ?? '支付失败');
      }
    }
  }

  // 获取支付信息
  void getPayInfo() async {
    var orders = Get.arguments['order'];
    Map<String, dynamic> params = {};
    for (var i = 0; i < orders.length; i++) {
      params['order_sns[$i]'] = orders[i];
    }
    var data = await ShopService.getOrderConfirm(params);
    if (data != null) {
      orderList.value = data;
      if (data.isNotEmpty) {
        String endAt = data.first.payEndAt!;
        endUtil.value = ((DateTime.parse(endAt).millisecondsSinceEpoch / 1000) -
                (DateTime.now().millisecondsSinceEpoch / 1000))
            .toInt();
      }
    }
  }

  // 支付方式列表
  void getPayTypes() async {
    showLoading();
    payTypeList.value = await BalanceService.getPayTypeList(
      noDelivery: true,
    );
    hideLoading();
  }

  // 支付
  onPay(BuildContext context) async {
    if (selectedPayType.value == null) {
      return showToast('请选择支付方式');
    }
    if (selectedPayType.value!.name == 'wechat') {
      onWechatPay();
    } else if (selectedPayType.value!.name == 'balance') {
      var result = await BaseDialog.confirmDialog(context, '您确认使用余额支付吗'.inte);
      if (result == true) {
        onBalancePay();
      }
    } else {
      // 转账支付
      GlobalPages.push(GlobalPages.paymentTransfer, arg: {
        'payModel': payTypeList
            .where((e) => e.name == selectedPayType.value?.name)
            .first,
        'ids': problemOrder.value != null
            ? [problemOrder.value!.oaf?.id]
            : orderList.map((e) => e.id).toList(),
        'transferType': problemOrder.value != null ? 4 : 3,
        'amount': problemOrder.value != null
            ? double.parse(problemOrder.value!.amount ?? '0')
            : totalAmount,
      });
    }
  }

  // 微信支付
  void onWechatPay() async {
    List<int> ids = orderList.map((e) => e.id).toList();
    Map<String, dynamic> map = {'type': 4, 'id': ids, 'version': 'v3'};
    var appconfig = await ShopService.payByWechat(map);
    if (appconfig != null) {
      WechatConfig().onPay(appconfig);
    }
  }

  // 余额支付
  void onBalancePay() async {
    Map result = {};
    if (problemOrder.value != null) {
      result = await ShopService.problemPayByBalance({
        'id': problemOrder.value?.oaf?.id,
      });
    } else {
      List<int> ids = orderList.map((e) => e.id).toList();
      Map<String, dynamic> map = {
        'id': ids,
      };
      result = await ShopService.payByBalance(map);
    }
    if (result['ok']) {
      onPaySuccess();
    }
  }

  void onPaySuccess() {
    Get.find<AppStore>().getBaseCountInfo();
    if (problemOrder.value != null || Get.arguments['fromOrderList'] == true) {
      GlobalPages.pop('success');
    } else {
      GlobalPages.redirect(GlobalPages.paySuccess, {
        'fromShop': true,
        'id': orderList.first.id,
      });
    }
  }

  // 余额
  void getBalance() async {
    var userOrderDataCount = await UserService.getOrderDataCount();
    myBalance.value = ((userOrderDataCount!.balance ?? 0) / 100);
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

  num get totalAmount {
    var value = orderList.fold<num>(0, (pre, cur) {
      return pre + (cur.amount ?? 0);
    });
    return value;
  }
}
