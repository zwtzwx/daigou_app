/*
  登录页面
*/

import 'dart:async';

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/token_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/logined_event.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String result = "无";
  String pageTitle = '';
  int loginType = 2; // 1、手机号验证码 2: 邮箱验证码 3: 帐号密码  1 手机号密码 2 手机号验证码 3邮箱密码 4邮箱验证码
  String selectTypeName = '';
  List<String> listTitle = ['手机号', '邮箱号'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String sent = '';
  String code = '';
  bool isButtonEnable = true;
  Timer? timer;
  int count = 60;
  Color codeColor = ColorConfig.textBlack;
  // 新号码
  final TextEditingController _mobileNumberController = TextEditingController();
  // final FocusNode _mobileNumber = FocusNode();
  // 新号码
  final TextEditingController _emailController = TextEditingController();
  // final FocusNode _emailNumber = FocusNode();
  // 验证码
  final TextEditingController _validationController = TextEditingController();
  final FocusNode _validation = FocusNode();
  // 电话区号
  String areaNumber = "0086";
  // 电话号码
  String mobileNumber = "";
  // 验证码
  String verifyCode = "";

  bool protocolChecked = false;

  @override
  void initState() {
    super.initState();
    pageTitle = '登录注册';
    sent = Translation.t(context, '获取验证码');
    selectTypeName = listTitle.first;
  }

  /*
    微信登录
  */
  loginWithWechat() async {
    return loginWith('wechat', {'code': code});
  }

  /*
    登录方式
  */
  loginWith(String type, Map<String, dynamic> map) async {
    try {
      TokenModel? tokenModel;
      switch (type) {
        case 'wechat':
          tokenModel = await UserService.loginWithWechat(map);
          break;
        case 'emailCode':
        case 'mobileCode':
          tokenModel = await UserService.loginBy(map);
          break;
        default:
          tokenModel = await UserService.login(map);
      }

      EasyLoading.showSuccess(Translation.t(context, '登录成功'));
      //发送登录事件
      ApplicationEvent.getInstance().event.fire(LoginedEvent);
      //更新状态管理器
      var provider = Provider.of<Model>(context, listen: false);
      provider.setToken(tokenModel!.tokenType + ' ' + tokenModel.accessToken);
      provider.setUserInfo(tokenModel.user!);
      Routers.pop(context);
    } catch (e) {
      Util.showToast(e.toString());
    } finally {}
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _emailController.dispose();
    _validationController.dispose();
    if (timer != null) {
      timer!.cancel(); //销毁计时器
      timer = null;
    }

    // timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, pageTitle),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.white,
      body: SingleChildScrollView(
        child: SizedBox(
          // color: Colors.red,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight -
              ScreenUtil().statusBarHeight -
              ScreenUtil().bottomBarHeight,
          child: Stack(
            children: [
              Column(
                children: [
                  buildCustomViews(context),
                  buildExampleCell(context),
                ],
              ),
              // buildProtol(),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget buildProtol() {
    return Positioned(
      child: SizedBox(
          width: ScreenUtil().screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: protocolChecked,
                side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                      width: 1.0, color: ColorConfig.textGrayC),
                ),
                checkColor: Colors.green,
                fillColor: MaterialStateProperty.all(Colors.white),
                onChanged: (bool? value) {
                  setState(() {
                    protocolChecked = value!;
                  });
                },
              ),
              Caption(
                str: '登录代表您已同意',
                color: ColorConfig.textGrayC9,
                fontSize: ScreenUtil().setSp(12),
              ),
              GestureDetector(
                onTap: () {
                  Routers.push('/UserProtocolPage', context);
                },
                child: Caption(
                  str: '《集运用户协议》',
                  color: ColorConfig.warningTextDark,
                  fontSize: ScreenUtil().setSp(12),
                ),
              ),
              Caption(
                str: '和',
                color: ColorConfig.textGrayC9,
                fontSize: ScreenUtil().setSp(12),
              ),
              GestureDetector(
                onTap: () {
                  Routers.push('/UserPrivacyPage', context);
                },
                child: Caption(
                  str: '《隐私协议》',
                  color: ColorConfig.warningTextDark,
                  fontSize: ScreenUtil().setSp(12),
                ),
              ),
            ],
          )),
      bottom: 80,
    );
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
      height: 200,
      color: Colors.white,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          "assets/images/AboutMe/about-logo.png",
          height: 80,
          width: 80,
        ),
      ),
    );
    return headerView;
  }

  /*
  开始集运演示Cell
  */
  Widget buildExampleCell(BuildContext context) {
    return Container(
        color: ColorConfig.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: <Widget>[
            loginType == 1 ? inputPhoneView() : inPutEmailNumber(),
            inPutVeritfyNumber(),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: MainButton(
                text: '登录注册',
                borderRadis: 4,
                onPressed: () {
                  // if (!protocolChecked) {
                  //   Util.showToast('请先同意用户协议');
                  //   return;
                  // }
                  Map<String, dynamic> map;
                  //  1 手机号验证码 2 邮箱验证码 3 帐号密码
                  if (loginType == 3) {
                    //邮箱密码 1 手机密码
                    map = {
                      'account': _emailController.text,
                      'password': _validationController.text
                    };
                    return loginWith('password', map);
                    // await UserService.login(map);
                  } else if (loginType == 2) {
                    // 邮箱验证码
                    map = {
                      'email': _emailController.text,
                      'code': _validationController.text
                    };
                    // print(map);
                    return loginWith('emailCode', map);
                    // await UserService.loginBy(map);
                  } else if (loginType == 1) {
                    // 手机验证码
                    map = {
                      'phone': areaNumber + _mobileNumberController.text,
                      'code': _validationController.text
                    };
                    return loginWith('mobileCode', map);
                  }
                },
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        loginType = loginType == 3 ? 2 : 3;
                      });
                    },
                    child: Caption(
                      str: Translation.t(
                          context, loginType == 3 ? '验证码登录' : '密码登录'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }

  inPutEmailNumber() {
    var inputAccountView = Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5, color: ColorConfig.line, style: BorderStyle.solid)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 11,
              child: SizedBox(
                height: 40,
                child: TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: Translation.t(context, '请输入邮箱'),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConfig.line),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConfig.line),
                      )),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_validation);
                  },
                ),
              ))
        ],
      ),
    );
    return inputAccountView;
  }

  inPutVeritfyNumber() {
    var inputVerifyNumber = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5, color: ColorConfig.line, style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: TextField(
              obscureText: loginType == 3 ? true : false,
              style: const TextStyle(color: Colors.black87),
              controller: _validationController,
              decoration: InputDecoration(
                  hintText: Translation.t(
                      context, loginType == 3 ? '请输入密码' : '请输入验证码'),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConfig.line),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConfig.line),
                  )),
              onSubmitted: (res) {
                FocusScope.of(context).requestFocus(_validation);
              },
            ),
          ),
          loginType == 1 || loginType == 2
              ? SizedBox(
                  width: 130,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    child: Caption(str: sent, color: codeColor),
                    onPressed: () async {
                      if (isButtonEnable) {
                        //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
                        // int LoginType = 1; //  2 手机号验证码 4邮箱验证码
                        Map<String, dynamic> map = {
                          'receiver': loginType == 1
                              ? areaNumber + _mobileNumberController.text
                              : _emailController.text,
                          'action': loginType == 1
                              ? 5 // 手机登录验证码
                              : 4 // 邮箱登录验证码
                        };
                        EasyLoading.show();
                        UserService.getVerifyCode(map, (data) {
                          // Log.e(data);
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess(data.msg);
                          setState(() {
                            sent = Translation.t(context, '重新发送') +
                                '  ($count)'; //更新文本内容
                            _buttonClickListen();
                          });
                        }, (msg) {
                          EasyLoading.dismiss();
                          EasyLoading.showError(msg.toString());
                        });
                        return; //返回null按钮禁止点击
                      } else {
                        //当按钮不可点击时
                        return; //返回null按钮禁止点击
                      }
                    },
                  ),
                )
              : SizedBox(
                  width: 130,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    child: Caption(
                        str: Translation.t(context, '忘记密码') + '？',
                        color: ColorConfig.textBlack),
                    onPressed: () async {
                      Routers.push(
                          '/ForgetPasswordPage', context, {'type': loginType});
                    },
                  ),
                ),
        ],
      ),
    );
    return inputVerifyNumber;
  }

  clearContent() {
    _emailController.text = '';
    _mobileNumberController.text = '';
    _validationController.text = '';
  }

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();
        codeColor = ColorConfig.textGray;
        return; //返回null按钮禁止点击
      } else {
        //当按钮不可点击时
        return; //返回null按钮禁止点击
      }
    });
  }

  void _initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          codeColor = ColorConfig.textBlack;
          sent = Translation.t(context, '发送验证码'); //重置按钮文本
        } else {
          sent = Translation.t(context, '重新发送') + ' ($count)'; //更新文本内容
        }
      });
    });
  }

  inputPhoneView() {
    var inputAccountView = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: ColorConfig.line, style: BorderStyle.solid)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var s =
                        await Navigator.pushNamed(context, '/CountryListPage');
                    if (s != null) {
                      CountryModel a = s as CountryModel;
                      setState(() {
                        areaNumber = a.timezone!;
                      });
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 10),
                        child: Text('+' + areaNumber,
                            style: const TextStyle(
                              fontSize: 16.0, //textsize
                              color: ColorConfig.textNormal,
                            )),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: ColorConfig.textNormal,
                      ),
                    ],
                  ))),
          Expanded(
              flex: 11,
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(right: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: _mobileNumberController,
                  decoration: const InputDecoration(
                    hintText: '请输入手机号',
                    enabledBorder: UnderlineInputBorder(
                      // borderSide: BorderSide(color: ColorConfig.line),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      // borderSide: BorderSide(color: ColorConfig.line),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_validation);
                  },
                ),
              ))
        ],
      ),
    );
    return inputAccountView;
  }
}
