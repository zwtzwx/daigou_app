/*
  购买会员界面
 */

import 'dart:async';

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_vip_price_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

class OrderPayPage extends StatefulWidget {
  final Map arguments;

  const OrderPayPage({Key? key, required this.arguments}) : super(key: key);

  @override
  OrderPayPageState createState() => OrderPayPageState();
}

class OrderPayPageState extends State<OrderPayPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();

  UserModel? userModel;

  LocalizationModel? localizationInfo;

  int payModel = 0; // 0 冲会员 1 订单付款

  // 会员充值数据模型
  UserVipPriceModel? vipPriceModel;

  // 订单付款数据模型
  OrderModel? orderModel;

  int isloading = 0;
  num myBalance = 0;
  String pageTitle = '';

  List<PayTypeModel> payTypeList = [];
  List<PayTypeModel> selectedPayType = [];

  bool isLoading = false;

  StreamSubscription<BaseWeChatResponse>? wechatResponse;

  @override
  void initState() {
    super.initState();
    pageTitle = '支付订单';
    payModel = widget.arguments['payModel'];

    if (payModel == 0) {
      vipPriceModel = widget.arguments['model'] as UserVipPriceModel;
    } else if (payModel == 1) {
      orderModel = widget.arguments['model'] as OrderModel;
    }

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    created();

    wechatResponse =
        weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is WeChatPaymentResponse) {
        if (res.isSuccessful) {
          if (payModel == 0) {
            // 充值会员付款成功
            Routers.push('/PaySuccessPage', context, {'type': 6});
          } else {
            // 订单付款成功
            Routers.push(
                '/PaySuccessPage', context, {'model': orderModel, 'type': 2});
          }
        } else {
          Util.showToast('支付失败');
        }
      }
    });
  }

  @override
  void dispose() {
    wechatResponse?.cancel();
    super.dispose();
  }

  created() async {
    /*
    得到支付类型
    */
    bool noDelivery = payModel == 0 || orderModel!.onDeliveryStatus == 1;
    EasyLoading.show();
    payTypeList = await BalanceService.getPayTypeList(noDelivery: noDelivery);
    var userOrderDataCount = await UserService.getOrderDataCount();
    EasyLoading.dismiss();
    setState(() {
      myBalance = ((userOrderDataCount!.balance ?? 0) / 100);
      isloading++;
    });
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: pageTitle,
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isloading == 1
            ? SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: ScreenUtil().screenWidth,
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                height: 150,
                                width: 250,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height: 40,
                                          child: Caption(
                                            str: localizationInfo!
                                                .currencySymbol,
                                            fontSize: 20,
                                            color: ColorConfig.textRed,
                                          ),
                                        ),
                                        Container(
                                            alignment: Alignment.bottomCenter,
                                            height: 40,
                                            child: Caption(
                                              str: payModel == 0
                                                  ? (vipPriceModel!.price / 100)
                                                      .toStringAsFixed(2)
                                                  : (orderModel!
                                                              .discountPaymentFee /
                                                          100)
                                                      .toStringAsFixed(2),
                                              fontSize: 35,
                                              color: ColorConfig.textRed,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          height: 25,
                                          child: Caption(
                                            str: payModel == 0
                                                ? vipPriceModel!.basePrice == 0
                                                    ? ''
                                                    : '已省' +
                                                        localizationInfo!
                                                            .currencySymbol +
                                                        ((vipPriceModel!.basePrice -
                                                                    vipPriceModel!
                                                                        .price) /
                                                                100)
                                                            .toStringAsFixed(2)
                                                : '已省' +
                                                    localizationInfo!
                                                        .currencySymbol +
                                                    ((orderModel!.actualPaymentFee -
                                                                orderModel!
                                                                    .discountPaymentFee) /
                                                            100)
                                                        .toStringAsFixed(2),
                                            fontSize: 14,
                                            color: ColorConfig.textRed,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Caption(
                                    str: '余额：' + myBalance.toStringAsFixed(2),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Routers.push('/RechargePage', context);
                                      },
                                      child: Row(
                                        children: const <Widget>[
                                          Caption(
                                            str: '充值',
                                          ),
                                          Icon(Icons.keyboard_arrow_right)
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: (payTypeList.length * 50).toDouble(),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        margin:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                        child: showPayTypeView(),
                      ),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(
                          top: 50,
                          right: 15,
                          left: 15,
                          bottom: 40,
                        ),
                        width: double.infinity,
                        child: MainButton(
                          text: '确认支付',
                          onPressed: onPay,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }

  // 支付
  onPay() {
    if (selectedPayType.isEmpty) {
      Util.showToast('请选择支付方式');
      return;
    }
    PayTypeModel model = selectedPayType.first;
    if (model.name == 'wechat') {
      // 微信付款
      weChatPayMethod();
    } else if (model.name == 'balance') {
      // 余额付款订单
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('您确认使用余额支付吗'),
              actions: <Widget>[
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('确定'),
                  onPressed: () async {
                    Navigator.of(context).pop(payByBalance());
                  },
                )
              ],
            );
          });
    } else {
      if (payModel == 0) {
        // 充值会员转账
        Routers.push('/TransferAndPaymentPage', context, {
          'transferType': 0,
          'contentModel': vipPriceModel!,
          'payModel': model,
        });
      } else if (payModel == 1) {
        // 订单付款转账
        Routers.push('/TransferAndPaymentPage', context, {
          'transferType': 2,
          'contentModel': orderModel,
          'payModel': model,
        });
      }
    }
  }

  payByBalance() async {
    // 余额付款
    Map result = {};
    EasyLoading.show();
    if (payModel == 0) {
      // 余额付款会员充值
      Map<String, dynamic> map = {
        'price_id': vipPriceModel!.id,
        'price_type': vipPriceModel!.type
      };
      result = await BalanceService.buyVipBalance(map);
    } else if (payModel == 1) {
      // 余额付款订单
      Map<String, dynamic> map = {
        'point': orderModel!.point,
        'is_use_point': orderModel!.isusepoint,
        'type': '4', // app支付
        'point_amount': orderModel!.pointamount,
        'order_id': orderModel!.id
      };
      result = await BalanceService.orderBalancePay(map);
    }
    EasyLoading.dismiss();
    if (result['ok']) {
      EasyLoading.showSuccess("操作成功");
      if (payModel == 0) {
        Navigator.pop(context, 'succeed');
      } else {
        Routers.push(
            '/PaySuccessPage', context, {'model': orderModel, 'type': 7});
      }
    } else {
      EasyLoading.showError(result['msg'] ?? '支付失败');
    }
  }

  // 支付方式列表
  Widget showPayTypeView() {
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
    bool show = false;
    //如果是余额支付
    if (typeMap.name == 'balance') {
      if (payModel == 0) {
        if (myBalance * 100 < vipPriceModel!.price) {
          show = true;
        }
      } else if (payModel == 1) {
        if (myBalance * 100 < orderModel!.discountPaymentFee) {
          show = true;
        }
      }
    }
    return GestureDetector(
        onTap: () {
          if (typeMap.name == 'balance' && show) {
            return;
          }
          if (selectedPayType.contains(typeMap)) {
            return;
          } else {
            selectedPayType.clear();
            setState(() {
              selectedPayType.add(typeMap);
            });
          }
        },
        child: Container(
          color: ColorConfig.white,
          padding: const EdgeInsets.only(right: 15, left: 15),
          height: 50,
          width: ScreenUtil().screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 30,
                    width: 30,
                    child: typeMap.name.contains('支付宝')
                        ? Image.asset(
                            'assets/images/AboutMe/支付宝支付@3x.png',
                          )
                        : typeMap.name.contains('wechat')
                            ? Image.asset(
                                'assets/images/AboutMe/微信支付@3x.png',
                              )
                            : Image.asset(
                                'assets/images/AboutMe/银行卡转账@3x.png',
                              ),
                  ),
                  Caption(
                    str: Util.getPayTypeName(typeMap.name),
                  ),
                  show
                      ? const Caption(
                          str: '（余额不足）',
                        )
                      : Container(),
                ],
              ),
              show
                  ? const Icon(
                      Icons.brightness_1,
                      color: ColorConfig.textGrayC,
                    )
                  : selectedPayType.contains(typeMap)
                      ? const Icon(
                          Icons.check_circle,
                          color: ColorConfig.warningText,
                        )
                      : const Icon(Icons.radio_button_unchecked,
                          color: ColorConfig.textGray),
            ],
          ),
        ));
  }

  /*
    微信支付
   */
  weChatPayMethod() async {
    // payModel = 0; // 0 冲会员 1 订单付款
    if (payModel == 0) {
      // 微信支付充值会员
      Map<String, dynamic> map = {
        'price_type': vipPriceModel!.type,
        'price_id': vipPriceModel!.id,
        'type': '4', // 微信支付
        'version': 'v3',
      };

      BalanceService.buyVipWechatPay(map, (data) {
        Map appconfig = data.data;
        isWeChatInstalled.then((installed) {
          if (installed) {
            payWithWeChat(
              appId: appconfig['appid'].toString(),
              partnerId: appconfig['partnerid'].toString(),
              prepayId: appconfig['prepayid'].toString(),
              packageValue: appconfig['package'].toString(),
              nonceStr: appconfig['noncestr'].toString(),
              timeStamp: appconfig['timestamp'],
              sign: appconfig['sign'].toString(),
            ).then((data) {
              print("---》$data");
            });
          } else {
            Util.showToast("请先安装微信");
          }
        });
      }, (err) => {});
    } else {
      // 微信支付订单付款
      Map<String, dynamic> map = {
        'point': orderModel?.point,
        'is_use_point': orderModel?.isusepoint,
        'type': '4', // 微信支付
        'point_amount': orderModel?.pointamount,
        'version': 'v3',
      };
      BalanceService.orderWechatPay(orderModel!.id, map, (data) {
        if (data.ret) {
          Map appconfig = data.data;
          isWeChatInstalled.then((installed) {
            if (installed) {
              payWithWeChat(
                appId: appconfig['appid'].toString(),
                partnerId: appconfig['partnerid'].toString(),
                prepayId: appconfig['prepayid'].toString(),
                packageValue: appconfig['package'].toString(),
                nonceStr: appconfig['noncestr'].toString(),
                timeStamp: appconfig['timestamp'],
                sign: appconfig['sign'].toString(),
              ).then((data) {
                print("---》$data");
              });
            } else {
              Util.showToast("请先安装微信");
            }
          });
        }
      }, (message) => null);
    }
  }
}
