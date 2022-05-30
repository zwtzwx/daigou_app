/*
  确认收货成功页面
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignSuccessPage extends StatefulWidget {
  final Map arguments;
  const SignSuccessPage({Key? key, required this.arguments}) : super(key: key);

  @override
  SignSuccessPageState createState() => SignSuccessPageState();
}

class SignSuccessPageState extends State<SignSuccessPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = '';
  OrderModel orderModel = OrderModel();

  @override
  void initState() {
    super.initState();
    pageTitle = '交易成功';
    orderModel = widget.arguments['model'];
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
        padding: const EdgeInsets.only(top: 60),
        decoration: const BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  'assets/images/PackageAndOrder/交易成功图标@3x.png',
                )),
            Container(
              margin: const EdgeInsets.only(right: 30, left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  GestureDetector(
                    onTap: () {
                      Routers.push(
                          '/OrderCommentPage', context, {'order': orderModel});
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      decoration: BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                              width: 1, color: ColorConfig.warningText)),
                      alignment: Alignment.center,
                      height: 40,
                      child: const Caption(
                          str: '评价有奖', color: ColorConfig.textDark),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
