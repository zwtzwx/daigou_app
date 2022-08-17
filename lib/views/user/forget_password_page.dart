/*
  忘记密码
*/

import 'dart:async';

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/token_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  final Map arguments;
  const ForgetPasswordPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  ForgetPasswordPageState createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {
  String pageTitle = '';
  int loginType = 2; //  1 手机号 2 邮箱

  String selectTypeName = '';

  List<String> listTitle = ['手机号', '邮箱号'];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();

  String sent = '';

  bool isButtonEnable = true;

  Timer? timer;

  int count = 60;

  Color codeColor = ColorConfig.textBlack;

  // 新号码
  final TextEditingController _mobileNumberController = TextEditingController();
  // 新号码
  final TextEditingController _emailController = TextEditingController();
  // 验证码
  final TextEditingController _validationController = TextEditingController();
  final FocusNode _validation = FocusNode();

  // 电话区号
  String areaNumber = "0086";
  // 电话号码
  String mobileNumber = "";
  // 验证码
  String verifyCode = "";

  @override
  void initState() {
    super.initState();
    pageTitle = '忘记密码';
    sent = Translation.t(context, '发送验证码');
    // loginType = widget.arguments['type'];
    selectTypeName = listTitle.first;
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _emailController.dispose();
    _validationController.dispose();
    timer?.cancel(); //销毁计时器
    timer = null;
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
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, pageTitle),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.white,
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: buildCellForFirstListView,
          controller: _scrollController,
          itemCount: 3,
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget buildCellForFirstListView(BuildContext context, int index) {
    if (index == 1) {
      return loginSubmitCell(context);
    } else if (index == 2) {
      return Container();
    }
    return buildCustomViews(context);
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        height: 200,
        color: Colors.white,
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/AboutMe/about-logo.png",
          height: 80,
          width: 80,
        ));
    return headerView;
  }

  /*
  重置
  */
  Widget loginSubmitCell(BuildContext context) {
    return Container(
        color: ColorConfig.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: <Widget>[
            inputAccountView(),
            inPutVeritfyNumber(),
            inPutEmailNumber(),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: MainButton(
                text: '确认并登录',
                borderRadis: 4.0,
                onPressed: () async {
                  Map<String, dynamic> map = {
                    'account': loginType == 1
                        ? areaNumber + _mobileNumberController.text
                        : _mobileNumberController.text,
                    'verify_code': _validationController.text,
                    'password': _emailController.text,
                    'confirm_password': _emailController.text
                  };
                  EasyLoading.show();
                  TokenModel? tokenModel =
                      await UserService.resetPaswordAndLogin(map);
                  EasyLoading.dismiss();
                  if (tokenModel == null) {
                    Util.showToast(Translation.t(context, '操作失败'));
                    return;
                  }

                  EasyLoading.showSuccess(Translation.t(context, '登录成功'));

                  //发送登录事件
                  ApplicationEvent.getInstance()
                      .event
                      .fire(OrderCountRefreshEvent());
                  //更新状态管理器
                  var provider = Provider.of<Model>(context, listen: false);
                  provider.setToken(
                      tokenModel.tokenType + ' ' + tokenModel.accessToken);
                  provider.setUserInfo(tokenModel.user!);
                  String? dt = await UserStorage.getDeviceToken();
                  if (dt != null) {
                    await CommonService.saveDeviceToken({
                      'type': 1,
                      'token': dt,
                    });
                  }
                  Navigator.pushNamed(context, '/TabOrderInfo');
                },
              ),
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
                width: 1, color: ColorConfig.line, style: BorderStyle.solid)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 11,
              child: SizedBox(
                height: 40,
                child: TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: Translation.t(context, '请输入密码'),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
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
                width: 1, color: ColorConfig.line, style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: TextField(
              obscureText: false,
              style: const TextStyle(color: Colors.black87),
              controller: _validationController,
              decoration: InputDecoration(
                  hintText: Translation.t(context, '请输入验证码'),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
              onSubmitted: (res) {
                FocusScope.of(context).requestFocus(_validation);
              },
            ),
          ),
          SizedBox(
            width: 130,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
              ),
              child: Caption(str: sent, color: codeColor),
              onPressed: () async {
                if (isButtonEnable) {
                  if (_mobileNumberController.text.isEmpty) {
                    if (loginType == 1) {
                      Util.showToast(Translation.t(context, '请输入手机号'));
                    } else {
                      Util.showToast(Translation.t(context, '请输入邮箱号'));
                    }
                    return;
                  }
                  //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
                  Map<String, dynamic> map = {
                    'receiver': loginType == 1
                        ? areaNumber + _mobileNumberController.text
                        : _mobileNumberController.text,
                    'action': 6 // 重置密码 获取验证码
                  };
                  EasyLoading.show();
                  UserService.getVerifyCode(map, (data) {
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess(data.msg);
                    setState(() {
                      _buttonClickListen();
                    });
                  }, (message) {
                    EasyLoading.dismiss();
                    EasyLoading.showError(message);
                  });
                  return;
                } else {
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
    return inputVerifyNumber;
  }

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();
        codeColor = ColorConfig.textGray;
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
          sent = Translation.t(context, '重新发送') + '($count)'; //更新文本内容
        }
      });
    });
  }

  inputAccountView() {
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
          loginType == 1
              ? Expanded(
                  flex: 5,
                  child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        var s = await Navigator.pushNamed(
                            context, '/CountryListPage');

                        if (s == null) {
                          return;
                        }
                        setState(() {
                          areaNumber = (s as CountryModel).timezone!;
                        });
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
                      )))
              : const SizedBox(),
          Expanded(
              flex: 11,
              child: Container(
                height: 40,
                margin: loginType == 2
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.only(right: 10, left: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                      hintText: Translation.t(
                          context, loginType == 1 ? '请输入手机号' : '请输入邮箱'),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
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

  changeLoginType() async {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
            height:
                listTitle.length < 6 ? listTitle.length.toDouble() * 44 : 220,
            child: ListView.builder(
              itemCount: listTitle.length,
              itemExtent: 44,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  trailing: selectTypeName == listTitle[index]
                      ? const Icon(Icons.check)
                      : Container(
                          width: 10,
                        ),
                  title: SizedBox(
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(listTitle[index],
                            style:
                                const TextStyle(color: ColorConfig.textDark)),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectTypeName = listTitle[index];
                      loginType = index + 1;
                      _mobileNumberController.text = '';
                      _validationController.text = '';
                      _emailController.text = '';
                      Navigator.of(context).pop();
                    });
                  },
                );
              },
            ),
          );
        });
  }
}
