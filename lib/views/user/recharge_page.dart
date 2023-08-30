/*
  充值页面
 */

import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/default_amount_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({Key? key}) : super(key: key);

  @override
  RechargePageState createState() => RechargePageState();
}

class RechargePageState extends State<RechargePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _otherPriceController = TextEditingController();
  final FocusNode _otherPriceNode = FocusNode();

  int isloading = 0;
  //我的余额
  String myBalance = '0.00';

  // 选择的金额
  int selectButton = -1;
  double amount = 0;
  // 选择的充值方式

  List<DefaultAmountModel> defaultAmountList = [];
  List<PayTypeModel> payTypeList = [];
  List<PayTypeModel> selectType = [];
  LocalizationModel? localizationInfo;

  // StreamSubscription<BaseWeChatResponse>? wechatResponse;

  @override
  void initState() {
    super.initState();
    localizationInfo = Get.find<LocalizationModel?>();
    // 微信支付回调
    // wechatResponse =
    //     weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
    //   if (res is WeChatPaymentResponse) {
    //     if (res.isSuccessful) {
    //     } else {
    //       Util.showToast(Translation.t(context, '支付失败'));
    //     }
    //   }
    // });
    created();
    getBalance();
  }

  created() async {
    /*
    得到支付类型
    */
    EasyLoading.show();
    payTypeList = await BalanceService.getPayTypeList(noBalanceType: true);
    //拉取默认的充值金额选项
    List<DefaultAmountModel>? _defaultAmountList =
        await BalanceService.getDefaultAmountList();
    EasyLoading.dismiss();
    setState(() {
      defaultAmountList = _defaultAmountList;
      isloading++;
    });
  }

  void getBalance() async {
    var userOrderDataCount = await UserService.getOrderDataCount();
    setState(() {
      myBalance = ((userOrderDataCount!.balance ?? 0) / 100).toStringAsFixed(2);
      isloading++;
    });
  }

  @override
  void dispose() {
    // wechatResponse?.cancel();
    _otherPriceNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: BaseStylesConfig.primary,
        elevation: 0,
        centerTitle: true,
        title: ZHTextLine(
          str: '余额'.ts,
          color: BaseStylesConfig.white,
          fontSize: 18,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        color: Colors.white,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  ZHTextLine(
                    str: '充值'.ts + '：',
                    fontSize: 14,
                  ),
                  ZHTextLine(
                    str: amount.rate(needFormat: false),
                    color: BaseStylesConfig.textRed,
                  ),
                ],
              ),
              10.horizontalSpace,
              MainButton(
                text: '确认支付',
                onPressed: () {
                  if (selectButton == -1) {
                    EasyLoading.showToast('请选择充值金额'.ts);
                    return;
                  } else if (selectButton == defaultAmountList.length &&
                      (amount * 100).toInt() == 0) {
                    EasyLoading.showToast('请输入充值金额'.ts);
                    return;
                  } else if (selectType.isEmpty) {
                    EasyLoading.showToast('请选择充值方式'.ts);
                    return;
                  }
                  if (selectType.first.name == 'wechat') {
                    weChatPayMethod();
                  } else {
                    Routers.pushNormalPage('/TransferAndPaymentPage', context, {
                      'transferType': 1,
                      'amount': amount,
                      'payModel': selectType.first,
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: isloading >= 2
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    buildCustomViews(context),
                    Container(
                      decoration: const BoxDecoration(
                          color: BaseStylesConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                            child: ZHTextLine(str: '余额充值'.ts),
                          ),
                          buildMoreSupportType(context),
                          Offstage(
                            offstage: selectButton != defaultAmountList.length,
                            child: buildCustomPrice(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: BaseStylesConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 0),
                      child: buildListView(context),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  // 其它任意金额
  Widget buildCustomPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: ZHTextLine(str: '其它任意金额'.ts),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: BaseStylesConfig.primary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BaseInput(
            controller: _otherPriceController,
            focusNode: _otherPriceNode,
            hintText: '其它任意金额'.ts,
            isCollapsed: true,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            autoShowRemove: false,
            onChanged: (value) {
              var rate =
                  Get.find<UserInfoModel>().currencyModel.value?.rate ?? 1;
              setState(() {
                if (double.tryParse(value) != null) {
                  amount = double.parse(value) / rate;
                } else if (value.isEmpty) {
                  amount = 0;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildMoreSupportType(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10.0, //水平子Widget之间间距
        mainAxisSpacing: 5.0, //垂直子Widget之间间距
        crossAxisCount: 3, //一行的Widget数量
        childAspectRatio: 3 / 2,
      ), // 宽高比例
      itemCount: defaultAmountList.length + 1,
      itemBuilder: _buildGrideBtnView(),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      DefaultAmountModel? model;
      if (index != defaultAmountList.length) {
        model = defaultAmountList[index];
      }
      return GestureDetector(
        onTap: () {
          setState(() {
            selectButton = index;
            if (model == null) {
              amount = 0;
            } else {
              amount = (model.amount).toDouble();
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(
                color: HexToColor('#eceeff'),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 0.5,
                    color: selectButton == index
                        ? BaseStylesConfig.primary
                        : Colors.transparent)),
            alignment: Alignment.center,
            child: model != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZHTextLine(
                        str: '{count}元'.tsArgs({
                          'count': model.amount.rate(
                            showPriceSymbol: false,
                            needFormat: false,
                            showInt: true,
                          )
                        }),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: BaseStylesConfig.textBlack,
                      ),
                      model.complimentaryAmount != 0
                          ? ZHTextLine(
                              str: '送{count}元'.tsArgs({
                                'count': model.complimentaryAmount.rate(
                                  showPriceSymbol: false,
                                  needFormat: false,
                                  showInt: true,
                                )
                              }),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: BaseStylesConfig.textBlack,
                            )
                          : Container(),
                    ],
                  )
                : ZHTextLine(
                    str: '其它金额'.ts,
                    fontWeight: FontWeight.w500,
                  )),
      );
    };
  }

  Widget buildListView(BuildContext context) {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: payTypeCell,
      controller: _scrollController,
      itemCount: payTypeList.length,
    );
    return listView;
  }

  Widget payTypeCell(BuildContext context, int index) {
    PayTypeModel typeMap = payTypeList[index];
    return GestureDetector(
        onTap: () {
          if (selectType.contains(typeMap)) {
            return;
          } else {
            selectType.clear();
            setState(() {
              selectType.add(typeMap);
            });
          }
        },
        child: Container(
          color: BaseStylesConfig.white,
          padding: const EdgeInsets.only(right: 15, left: 15),
          height: 50,
          width: ScreenUtil().screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(right: 15),
                      child: typeMap.name.contains('alipay')
                          ? Image.asset(
                              'assets/images/AboutMe/alipay.png',
                            )
                          : typeMap.name.contains('wechat')
                              ? Image.asset(
                                  'assets/images/AboutMe/wechat_pay.png',
                                )
                              : typeMap.name.contains('balance')
                                  ? Image.asset(
                                      'assets/images/Home/balance_pay.png',
                                    )
                                  : Image.asset(
                                      'assets/images/AboutMe/transfer.png',
                                    ),
                    ),
                    Expanded(
                      child: ZHTextLine(
                        str: Util.getPayTypeName(typeMap.name),
                        lines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              selectType.contains(typeMap)
                  ? const Icon(
                      Icons.check_circle,
                      color: BaseStylesConfig.green,
                    )
                  : const Icon(Icons.radio_button_unchecked,
                      color: BaseStylesConfig.textGray),
            ],
          ),
        ));
  }

  // 支付方式

  Widget buildCustomViews(BuildContext context) {
    var headerView = SizedBox(
      height: 180,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 70, right: 15),
            color: BaseStylesConfig.primary,
            constraints: const BoxConstraints.expand(
              height: 130.0,
            ),
          ),
          Positioned(
              top: 10,
              left: 15,
              right: 15,
              bottom: 0,
              child: Container(
                  padding: const EdgeInsets.only(right: 15, top: 15, left: 15),
                  width: ScreenUtil().screenWidth - 30,
                  color: BaseStylesConfig.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ZHTextLine(
                              str: '账户余额'.ts,
                            ),
                            GestureDetector(
                              onTap: () {
                                Routers.pushNormalPage(
                                    '/BalanceHistoryPage', context);
                              },
                              child: ZHTextLine(
                                str: '充值记录'.ts,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: Get.find<UserInfoModel>()
                                            .currencyModel
                                            .value
                                            ?.symbol ??
                                        '',
                                    style: const TextStyle(
                                      color: BaseStylesConfig.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: num.parse(myBalance)
                                        .rate(
                                          needFormat: false,
                                          showPriceSymbol: false,
                                        )
                                        .split('.')
                                        .first,
                                    style: const TextStyle(
                                        color: BaseStylesConfig.textRed,
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: BaseStylesConfig.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: num.parse(myBalance)
                                        .rate(
                                          needFormat: false,
                                          showPriceSymbol: false,
                                        )
                                        .split('.')
                                        .last,
                                    style: const TextStyle(
                                      color: BaseStylesConfig.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
    return headerView;
  }

  /*
    微信在线支付
   */
  weChatPayMethod() async {
    var currencyModel = Get.find<UserInfoModel>().currencyModel.value;
    // 微信支付充值余额
    Map<String, dynamic> map = {
      'amount': amount * 100,
      'type': '4', // 微信支付
      'version': 'v3',
      'trans_currency': currencyModel?.code ?? '',
      'trans_rate': currencyModel?.rate ?? 1,
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
}
