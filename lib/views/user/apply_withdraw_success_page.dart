/*
  提现成功
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplyWithDrawSuccessPage extends StatefulWidget {
  final Map arguments;

  const ApplyWithDrawSuccessPage(this.arguments, {Key? key}) : super(key: key);

  @override
  ApplyWithDrawSuccessPageState createState() =>
      ApplyWithDrawSuccessPageState();
}

class ApplyWithDrawSuccessPageState extends State<ApplyWithDrawSuccessPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    pageTitle = '提现成功';
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
        body: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: ScreenUtil().screenWidth,
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                      width: 150,
                      child: Image.asset(
                        'assets/images/AboutMe/WithdrawalSuccess@3x.png',
                      )),
                  const Caption(
                    alignment: TextAlign.center,
                    lines: 2,
                    str: '申请成功',
                    color: ColorConfig.textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Routers.pop(context);
                    // Navigator.pushNamed(context, '/TabOrderInfo');
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    // decoration: new BoxDecoration(
                    //     color: ColorConfig.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    //     border:
                    //         Border.all(width: 1, color: ColorConfig.textGrayC)),
                    alignment: Alignment.center,
                    height: 30,
                    width: ScreenUtil().screenWidth - 30,
                    child: const Caption(
                      alignment: TextAlign.center,
                      lines: 2,
                      str: '我们将在五个工作日内审核通过后进行转账，请您注意查收！',
                      color: ColorConfig.textGray,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
