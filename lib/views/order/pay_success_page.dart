/*
  支付成功
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaySuccessPage extends StatefulWidget {
  final Map arguments;

  const PaySuccessPage({Key? key, required this.arguments}) : super(key: key);

  @override
  PaySuccessPageState createState() => PaySuccessPageState();
}

class PaySuccessPageState extends State<PaySuccessPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = '';

  OrderModel orderModel = OrderModel();
  int type = 0; // 1 订单转账 2 订单付款 3 余额充值转账 4 余额充值付款 5 会员充值转账 6 会员充值付款 7 订单余额付款

  @override
  void initState() {
    super.initState();
    pageTitle = '支付订单';
    type = widget.arguments['type'];
    if (type < 3 || type == 7) {
      orderModel = widget.arguments['model'];
      // getOrderModel();
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  getOrderModel() async {
    var data = await OrderService.getDetail(orderModel.id);
    setState(() {
      orderModel = data!;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        height: 300,
        width: ScreenUtil().screenWidth,
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 180,
                width: 180,
                child: type == 2 || type == 4 || type == 6 || type == 7
                    ? Image.asset(
                        'assets/images/PackageAndOrder/支付成功@3x.png',
                      )
                    : Image.asset(
                        'assets/images/PackageAndOrder/等待审核@3x.png',
                      )),
            SizedBox(
              height: 30,
              child: Caption(
                str: type == 2 || type == 4 || type == 6 || type == 7
                    ? '支付成功'
                    : '等待客服确认支付',
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 30, left: 30),
              child: Row(
                mainAxisAlignment: type == 1 || type == 2 || type == 7
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/TabOrderInfo');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      decoration: BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                              width: 1, color: ColorConfig.textGrayC)),
                      alignment: Alignment.center,
                      height: 40,
                      child: const Caption(
                          str: '返回首页', color: ColorConfig.textDark),
                    ),
                  ),
                  type < 3 || type == 7
                      ? GestureDetector(
                          onTap: () {
                            Routers.push('/OrderDetailPage', context,
                                {'id': orderModel.id});
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            decoration: BoxDecoration(
                                color: ColorConfig.warningText,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                border: Border.all(
                                    width: 1, color: ColorConfig.warningText)),
                            alignment: Alignment.center,
                            height: 40,
                            child: const Caption(
                                str: '查看订单', color: ColorConfig.textDark),
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
