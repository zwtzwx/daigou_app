/*
  更改手机号或EMAIL
 */
import 'dart:async';

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangeMobileEmailPage extends StatefulWidget {
  final Map arguments;
  const ChangeMobileEmailPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  ChangeMobileEmailPageState createState() => ChangeMobileEmailPageState();
}

class ChangeMobileEmailPageState extends State<ChangeMobileEmailPage>
    with AutomaticKeepAliveClientMixin {
  final textEditingController = TextEditingController();

  bool isloading = false;

  UserModel? userModel;

  String sent = '获取验证码';
  bool isButtonEnable = true;

  //剩余时间
  Timer? resetTimer;

  int count = 60;
  String codeColor = '#8A8A8A';
  int flagBool = 0; // 1 改手机号  2 改邮箱号（绑定邮箱）
  bool emailFlag = false; // true 更换绑定邮箱  false 绑定邮箱
  bool phoneFlag = false; // true 更换手机号  false 绑定手机号

// 旧手机号
  String oldPhoneNumber = "";
// 电话区号
  String mobilArea = "0086";
// 新联系电话
  String mobileNumber = "";
// 验证码
  String verifyCode = "";

  // 新号码
  final TextEditingController _newNumberController = TextEditingController();
  final FocusNode _newNumber = FocusNode();
  // 验证码
  final TextEditingController _validationController = TextEditingController();
  final FocusNode _validation = FocusNode();

  FocusNode blankNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getLocalization();
  }

  @override
  bool get wantKeepAlive => true;

  getLocalization() async {
    userModel = await UserService.getProfile();
    flagBool = widget.arguments['type'];
    setState(() {
      if (flagBool == 1) {
        phoneFlag = userModel!.phone != null && userModel!.phone!.isNotEmpty;
      } else {
        emailFlag = userModel!.email != null && userModel!.email!.isNotEmpty;
      }
      isloading = true;
    });
  }

  @override
  void dispose() {
    resetTimer?.cancel(); //销毁计时器
    super.dispose();
  }

  // 发送验证码
  onGetCode() {
    if (isButtonEnable) {
      EasyLoading.show();
      //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
      UserService.getVerifyCode({
        'receiver': _newNumberController.text,
        'action': flagBool == 1
            ? 3 // 更改手机号
            : emailFlag
                ? 2 // 更改邮箱
                : 1 // 绑定邮箱
      }, (data) {
        EasyLoading.dismiss();
        if (data.ok) {
          EasyLoading.showSuccess(data.msg);
          setState(() {
            _buttonClickListen();
          });
        }
      }, (message) {
        EasyLoading.dismiss();
        EasyLoading.showError(message);
      });
    }
  }

  // 绑定
  onSubmit() async {
    EasyLoading.show();
    if (flagBool == 1) {
      Map<String, dynamic> params = {
        'phone': _newNumberController.text,
        'code': verifyCode,
      };
      await UserService.changePhone(params, (msg) {
        onResult(true, msg);
      }, (error) => onResult(false, error));
    } else {
      Map<String, dynamic> params = {
        'email': _newNumberController.text,
        'code': verifyCode,
      };
      if (emailFlag) {
        await UserService.changeEmail(params, (msg) {
          onResult(true, msg);
        }, (error) => onResult(false, error));
      } else {
        await UserService.bindEmail(params, (msg) {
          onResult(true, msg);
        }, (error) => onResult(false, error));
      }
    }
  }

  onResult(bool ok, String msg) {
    EasyLoading.dismiss();
    if (ok) {
      EasyLoading.showSuccess(msg).then((value) {
        Routers.pop(context);
      });
    } else {
      EasyLoading.showError(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: Translation.t(
                context,
                flagBool == 1
                    ? phoneFlag
                        ? '更改手机号'
                        : '绑定手机'
                    : emailFlag
                        ? '更换邮箱'
                        : '绑定邮箱'),
            color: ColorConfig.textBlack,
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: MainButton(
              text: '确定',
              onPressed: onSubmit,
            ),
          ),
        ),
        body: isloading
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      InputTextItem(
                        title: flagBool == 1
                            ? Translation.t(context, '联系电话')
                            : Translation.t(context, '现邮箱'),
                        inputText: Container(
                          height: 55,
                          alignment: Alignment.centerLeft,
                          child: Caption(
                            str: flagBool == 1
                                ? userModel == null || userModel!.phone != null
                                    ? Translation.t(context, '无')
                                    : userModel!.phone!
                                : userModel == null || userModel!.email!.isEmpty
                                    ? Translation.t(context, '无')
                                    : userModel!.email!,
                          ),
                        ),
                      ),
                      InputTextItem(
                        height: 55,
                        title: flagBool == 2
                            ? Translation.t(context, '新邮箱')
                            : Translation.t(context, '新号码'),
                        inputText: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: NormalInput(
                                hintText: flagBool == 2
                                    ? Translation.t(context, '请输入新邮箱')
                                    : Translation.t(context, '请输入新号码'),
                                textAlign: TextAlign.left,
                                contentPadding: const EdgeInsets.only(top: 15),
                                controller: _newNumberController,
                                focusNode: _newNumber,
                                autoFocus: false,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(_validation);
                                },
                                onChanged: (res) {
                                  mobileNumber = res;
                                },
                              ))
                            ],
                          ),
                        ),
                      ),
                      InputTextItem(
                        title: Translation.t(context, '验证码'),
                        isRequired: true,
                        inputText: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: NormalInput(
                                hintText: Translation.t(context, '请输入验证码'),
                                textAlign: TextAlign.left,
                                contentPadding: const EdgeInsets.only(top: 15),
                                controller: _validationController,
                                focusNode: _validation,
                                autoFocus: false,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(blankNode);
                                },
                                onChanged: (res) {
                                  verifyCode = res;
                                },
                              )),
                              Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0)),
                                  border: Border.all(
                                      width: 1.0, color: Colors.white),
                                  color: ColorConfig.bgGray,
                                ),
                                margin: const EdgeInsets.only(
                                    right: 15, top: 8, bottom: 8),
                                child: MainButton(
                                  text: sent,
                                  backgroundColor: Colors.transparent,
                                  textColor: HexToColor(codeColor),
                                  onPressed: onGetCode,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();
      }
    });
  }

  void _initTimer() {
    resetTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          codeColor = '#8A8A8A';
          sent = '获取验证码'; //重置按钮文本
        } else {
          sent = Translation.t(context, '重新发送') + '($count)'; //更新文本内容
        }
      });
    });
  }
}
