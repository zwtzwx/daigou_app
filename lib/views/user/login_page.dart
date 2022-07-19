/*
  登录页面
*/

import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/firebase/auth.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/token_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
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
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String pageTitle = '';
  int loginType = 2; // 1、手机号验证码 2: 邮箱验证码 3: 帐号密码  1 手机号密码 2 手机号验证码 3邮箱密码 4邮箱验证码
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
  late StreamSubscription<fluwx.BaseWeChatResponse> lis;

  // google、facebook 第三方登录
  late GoogleAndFacebookAuth _auth;
  bool showThridLogin = false;

  @override
  void initState() {
    super.initState();
    pageTitle = '登录注册';
    sent = Translation.t(context, '获取验证码');
    getThirdLoginStatus();
    //微信登录响应事件
    lis = fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) {
      if (res is fluwx.WeChatAuthResponse) {
        if (res.isSuccessful) {
          code = res.code!;
          loginWith('wechat', {'code': code});
        } else {
          Util.showToast('登录失败');
        }
      }
    });
  }

  getThirdLoginStatus() async {
    var result = await UserService.getThirdLoginStatus();
    if (result) {
      setState(() {
        showThridLogin = true;
        _auth = GoogleAndFacebookAuth();
      });
    }
  }

  /*
    登录方式
  */
  loginWith(String type, Map<String, dynamic> map) async {
    try {
      TokenModel? tokenModel;
      EasyLoading.show();
      switch (type) {
        case 'wechat':
          tokenModel = await UserService.loginWithWechat(map);
          break;
        case 'social':
          tokenModel = await UserService.loginWithFirebase(map);
          break;
        case 'emailCode':
        case 'mobileCode':
          tokenModel = await UserService.loginBy(map);
          break;
        default:
          tokenModel = await UserService.login(map);
      }
      EasyLoading.dismiss();
      EasyLoading.showSuccess(Translation.t(context, '登录成功'));
      //发送登录事件
      ApplicationEvent.getInstance().event.fire(LoginedEvent);
      ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent);
      //更新状态管理器
      var provider = Provider.of<Model>(context, listen: false);
      provider.setToken(tokenModel!.tokenType + ' ' + tokenModel.accessToken);
      provider.setUserInfo(tokenModel.user!);
      // 保存 device token
      String? dt = await UserStorage.getDeviceToken();
      if (dt != null) {
        await CommonService.saveDeviceToken({
          'type': 1,
          'token': dt,
        });
      }
      Routers.pop(context);
    } catch (e) {
      EasyLoading.dismiss();
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
    lis.cancel();
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
      bottomNavigationBar:
          showThridLogin ? buildOtherSignIn() : const SizedBox(),
      body: SingleChildScrollView(
        child: SizedBox(
          // color: Colors.red,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight -
              ScreenUtil().statusBarHeight -
              ScreenUtil().bottomBarHeight,
          child: Column(
            children: [
              buildCustomViews(context),
              buildExampleCell(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtherSignIn() {
    return SafeArea(
      child: SizedBox(
        height: 120,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: ColorConfig.textGray,
                    ),
                  ),
                  Gaps.hGap5,
                  Caption(
                    str: Translation.t(context, '其它登录方式'),
                    color: ColorConfig.textGray,
                  ),
                  Gaps.hGap5,
                  Expanded(
                    child: Container(
                      height: 1,
                      color: ColorConfig.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.vGap15,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    String? idToken = await _auth.signInGoogle();
                    if (idToken != null) {
                      loginWith('social', {'token': idToken});
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorConfig.textGray),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(7),
                          child: SvgPicture.asset(
                            'assets/images/Home/google.svg',
                            width: 25,
                            height: 25,
                          ),
                        ),
                        Gaps.vGap4,
                        const Caption(
                          str: 'Google',
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String? idToken = await _auth.signInFacebook();
                    if (idToken != null) {
                      loginWith('social', {'token': idToken});
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorConfig.textGray),
                            shape: BoxShape.circle,
                          ),
                          // padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.facebook,
                            color: Color(0xFF1877F2),
                            size: 39,
                          ),
                        ),
                        Gaps.vGap4,
                        const Caption(
                          str: 'Facebook',
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var _isInstalled = await fluwx.isWeChatInstalled;
                    if (_isInstalled) {
                      fluwx.sendWeChatAuth(
                        scope: "snsapi_userinfo",
                        state: "wechat_sdk_demo_test",
                      );
                    } else {
                      Util.showToast(Translation.t(context, '请先安装微信'));
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorConfig.textGray),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.wechat,
                            color: Color(0xFF51C332),
                            size: 35,
                          ),
                        ),
                        Gaps.vGap4,
                        const Caption(
                          str: 'Wechat',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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
