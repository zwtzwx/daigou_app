/*
  充值页面
 */

import 'dart:async';

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/default_amount_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:provider/provider.dart';

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

  StreamSubscription<BaseWeChatResponse>? wechatResponse;

  @override
  void initState() {
    super.initState();
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    EasyLoading.show();
    created();

    /*
      支付回调
     */
    wechatResponse =
        weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is WeChatPaymentResponse) {
        if (res.isSuccessful) {
          Routers.push('/PaySuccessPage', context, {'type': 3});
        } else {
          Util.showToast('支付失败');
        }
      }
    });
    EasyLoading.dismiss();
  }

  created() async {
    /*
    得到支付类型
    */
    EasyLoading.show();
    payTypeList = await BalanceService.getPayTypeList(noBalanceType: true);
    var userOrderDataCount = await UserService.getOrderDataCount();
    EasyLoading.dismiss();
    setState(() {
      myBalance = ((userOrderDataCount!.balance ?? 0) / 100).toStringAsFixed(2);
      isloading++;
    });

    //拉取默认的充值金额选项
    List<DefaultAmountModel>? _defaultAmountList =
        await BalanceService.getDefaultAmountList();

    setState(() {
      defaultAmountList = _defaultAmountList;
      isloading++;
    });
  }

  @override
  void dispose() {
    wechatResponse?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: ColorConfig.warningText,
        elevation: 0,
        centerTitle: true,
        title: const Caption(
          str: '余额',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
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
                  const Caption(
                    str: '充值：',
                    fontSize: 14,
                  ),
                  Caption(
                    str: localizationInfo?.currencySymbol ?? '',
                    fontSize: 14,
                    color: ColorConfig.textRed,
                  ),
                  Caption(
                    str: amount.toStringAsFixed(2),
                    color: ColorConfig.textRed,
                  ),
                ],
              ),
              Gaps.hGap10,
              MainButton(
                text: '确认支付',
                onPressed: () {
                  if (selectButton == -1) {
                    Util.showToast('请选择充值金额');
                    return;
                  } else if (selectButton == defaultAmountList.length &&
                      (amount * 100).toInt() == 0) {
                    Util.showToast('请输入充值金额');
                    return;
                  } else if (selectType.isEmpty) {
                    Util.showToast('请选择充值方式');
                    return;
                  }
                  if (selectType.first.name == 'wechat') {
                    weChatPayMethod();
                  } else {
                    Routers.push('/TransferAndPaymentPage', context, {
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
      body: isloading == 2
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildCustomViews(context),
                  Container(
                    decoration: const BoxDecoration(
                        color: ColorConfig.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: const EdgeInsets.only(
                        top: 20, left: 15, right: 15, bottom: 10),
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 40,
                          child: Caption(str: '余额充值'),
                        ),
                        buildMoreSupportType(context),
                        selectButton == defaultAmountList.length
                            ? buildCustomPrice()
                            : Gaps.empty,
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: ColorConfig.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: const EdgeInsets.only(
                        top: 20, left: 15, right: 15, bottom: 10),
                    padding: const EdgeInsets.only(
                        top: 0, left: 15, right: 15, bottom: 0),
                    child: buildListView(context),
                  ),
                  buildTipsView(),
                ],
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
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: Caption(str: '其它任意金额'),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConfig.warningText,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BaseInput(
            controller: _otherPriceController,
            focusNode: _otherPriceNode,
            hintText: '其它任意金额',
            isCollapsed: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            autoShowRemove: false,
            onChanged: (value) {
              setState(() {
                amount = double.parse(value);
              });
            },
          ),
        ),
        Gaps.vGap5,
        const Caption(
          str: '其它金额充值无赠送哦！',
          fontSize: 12,
          color: ColorConfig.textNormal,
        ),
      ],
    );
  }

  // 充值说明
  Widget buildTipsView() {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 15,
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Caption(
            str: '充值说明：',
            fontSize: 14,
          ),
          Gaps.vGap10,
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '1、充值金额仅能在BEEGOPLUS集运平台内进行运费抵扣；\n2、充值费用长期有效，剩余金额不予以退还\n3、充值金额无法与微信支付或支付宝搭配支付，请合理选择金额充值',
              style: TextStyle(
                fontSize: 12,
                color: ColorConfig.textNormal,
              ),
            ),
          )
        ],
      ),
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
                color: ColorConfig.warningBg,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 0.5,
                    color: selectButton == index
                        ? ColorConfig.warningText
                        : Colors.transparent)),
            alignment: Alignment.center,
            child: model != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Caption(
                        str: model.amount.toString() + '元',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorConfig.textBlack,
                      ),
                      model.complimentaryAmount != 0
                          ? Caption(
                              str: '送' +
                                  model.complimentaryAmount.toString() +
                                  '元',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorConfig.textBlack,
                            )
                          : Container(),
                    ],
                  )
                : const Caption(
                    str: '其它金额',
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
                ],
              ),
              selectType.contains(typeMap)
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

  // 支付方式

  Widget buildCustomViews(BuildContext context) {
    var headerView = SizedBox(
      height: 180,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 70, right: 15),
            color: ColorConfig.warningText,
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
                  color: ColorConfig.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Caption(
                              str: '账户余额',
                            ),
                            GestureDetector(
                              onTap: () {
                                Routers.push('/BalanceHistoryPage', context);
                              },
                              child: const Caption(
                                str: '充值记录',
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
                                    text: localizationInfo?.currencySymbol,
                                    style: const TextStyle(
                                        color: ColorConfig.textRed,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  TextSpan(
                                    text: myBalance.split('.').first,
                                    style: const TextStyle(
                                        color: ColorConfig.textRed,
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: ColorConfig.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: myBalance.split('.').last,
                                    style: const TextStyle(
                                      color: ColorConfig.textRed,
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
    // 微信支付充值余额
    Map<String, dynamic> map = {
      'amount': amount * 100,
      'type': '4', // 微信支付
      'version': 'v3',
    };

    /*
      获取微信支付配置
     */
    BalanceService.rechargePayByWeChat(map, (data) {
      if (data.ok) {
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
              if (kDebugMode) {
                print("---》$data");
              }
            });
          } else {
            Util.showToast("请先安装微信");
          }
        });
      }
    }, (message) => null);
  }
}
