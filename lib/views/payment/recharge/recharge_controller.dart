import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/config/wechat_config.dart';
import 'package:huanting_shop/models/default_amount_model.dart';
import 'package:huanting_shop/models/pay_type_model.dart';
import 'package:huanting_shop/services/balance_service.dart';
import 'package:huanting_shop/services/user_service.dart';

class RechargeController extends GlobalLogic {
  final TextEditingController otherPriceController = TextEditingController();
  final FocusNode otherPriceNode = FocusNode();

  final isloading = 0.obs;
  //我的余额
  final myBalance = RxNum(0);

  // 选择的金额
  final selectButton = RxInt(-1);
  final amount = 0.0.obs;
  // 选择的充值方式

  final defaultAmountList = <DefaultAmountModel>[].obs;
  final payTypeList = <PayTypeModel>[].obs;
  final selectType = <PayTypeModel>[].obs;

  @override
  onInit() {
    super.onInit();
    created();
    getBalance();
    // 监听微信支付结果
    WechatConfig().onAddListener(onListenWechatResonse);
  }

  @override
  onClose() {
    otherPriceController.dispose();
    otherPriceNode.dispose();
    WechatConfig().onRemoveListener(onListenWechatResonse);
  }

  onListenWechatResonse(respsonse) {
    if (respsonse is WeChatPaymentResponse) {
      if (respsonse.isSuccessful) {
        showSuccess('支付成功');
        getBalance();
      } else {
        showError(respsonse.errStr ?? '支付失败');
      }
    }
  }

  created() async {
    showLoading();
    payTypeList.value =
        await BalanceService.getPayTypeList(noBalanceType: true);
    //拉取默认的充值金额选项
    List<DefaultAmountModel>? _defaultAmountList =
        await BalanceService.getDefaultAmountList();
    hideLoading();
    defaultAmountList.value = _defaultAmountList;
    isloading.value++;
  }

  void getBalance() async {
    var userOrderDataCount = await UserService.getOrderDataCount();
    myBalance.value = userOrderDataCount!.balance ?? 0;
    isloading.value++;
  }

  /*
    微信在线支付
   */
  weChatPayMethod() async {
    var currency = currencyModel.value;
    // 微信支付充值余额
    Map<String, dynamic> map = {
      'amount': amount * 100,
      'type': '4', // 微信支付
      'version': 'v3',
      'trans_currency': currency?.code ?? '',
      'trans_rate': currency?.rate ?? 1,
    };

    BalanceService.rechargePayByWeChat(map, (data) {
      if (data.ok) {
        Map appconfig = data.data;
        WechatConfig().onPay(appconfig);
      }
    }, (message) => null);
  }

  void onPay() async {
    if (selectButton.value == -1) {
      showToast('请选择充值金额');
      return;
    } else if (selectButton.value == defaultAmountList.length &&
        (amount.value * 100).toInt() <= 0) {
      showToast('请输入正确的充值金额');
      return;
    } else if (selectType.isEmpty) {
      showToast('请选择充值方式');
      return;
    }
    if (selectType.first.name == 'wechat') {
      weChatPayMethod();
    } else {
      BeeNav.push(BeeNav.paymentTransfer, arg: {
        'transferType': 1,
        'amount': amount.value,
        'payModel': selectType.first,
      });
    }
  }
}
