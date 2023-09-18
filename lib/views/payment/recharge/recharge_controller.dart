import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/default_amount_model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';

class RechargeController extends BaseController {
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
  }

  @override
  onClose() {
    otherPriceController.dispose();
    otherPriceNode.dispose();
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

    /*
      获取微信支付配置
     */
    BalanceService.rechargePayByWeChat(map, (data) {
      if (data.ok) {
        Map appconfig = data.data;
        // isWeChatInstalled.then((installed) {
        //   if (installed) {
        //     payWithWeChat(
        //       appId: appconfig['appid'].toString(),
        //       partnerId: appconfig['partnerid'].toString(),
        //       prepayId: appconfig['prepayid'].toString(),
        //       packageValue: appconfig['package'].toString(),
        //       nonceStr: appconfig['noncestr'].toString(),
        //       timeStamp: appconfig['timestamp'],
        //       sign: appconfig['sign'].toString(),
        //     ).then((data) {
        //       if (kDebugMode) {
        //         print("---》$data");
        //       }
        //     });
        //   } else {
        //     Util.showToast("请先安装微信");
        //   }
        // });
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
      Routers.push(Routers.paymentTransfer, {
        'transferType': 1,
        'amount': amount.value,
        'payModel': selectType.first,
      });
    }
  }
}
