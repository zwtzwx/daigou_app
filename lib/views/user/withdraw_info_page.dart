import 'package:flutter/cupertino.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
/*
  结算账号信息
*/

class WithdrawlInfoPage extends StatefulWidget {
  const WithdrawlInfoPage({Key? key, this.arguments}) : super(key: key);
  final Map? arguments;
  @override
  WithdrawlInfoPageState createState() => WithdrawlInfoPageState();
}

class WithdrawlInfoPageState extends State<WithdrawlInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 收款方式
  int? withdrawType;
  // 账号
  final TextEditingController _accountController = TextEditingController();
  final FocusNode _accountNode = FocusNode();
  // 备注
  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkNoNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 提交提现信息
  onSubmit() async {
    if (withdrawType == null) {
      return Util.showToast(Translation.t(context, '请选择收款方式'));
    } else if (withdrawType != 1 && _accountController.text.isEmpty) {
      return Util.showToast(Translation.t(context, '请输入账户名'));
    }
    Map<String, dynamic> updataMap = {
      'commission_ids': widget.arguments?['ids'],
      'withdraw_type': withdrawType,
      'withdraw_account': _accountController.text,
      'remark': _remarkController.text,
    };
    EasyLoading.show();
    var result = await AgentService.applyWithDraw(updataMap);
    EasyLoading.dismiss();
    if (result['ok']) {
      EasyLoading.showSuccess(result['msg']).then((value) => {
            Navigator.of(context)
              ..pop()
              ..pop()
          });
    } else {
      EasyLoading.showError(result['msg']);
    }
  }

  // 选择收款方式
  Future<int?> showApplyType() {
    return showCupertinoModalPopup<int>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Caption(str: Translation.t(context, '余额提现')),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 2);
              },
              child: Caption(str: Translation.t(context, '微信提现')),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 3);
              },
              child: Caption(str: Translation.t(context, '支付宝提现')),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Caption(str: Translation.t(context, '取消')),
          ),
        );
      },
    );
  }

  String getWithdrawTypeName() {
    String str = '请选择收款方式';
    switch (withdrawType) {
      case 1:
        str = '余额提现';
        break;
      case 2:
        str = '微信提现';
        break;
      case 3:
        str = '支付宝提现';
        break;
    }
    return str;
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
          str: Translation.t(context, '结算账号信息'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin:
              const EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
          height: 40,
          width: double.infinity,
          child: MainButton(
            text: '确认',
            onPressed: onSubmit,
          ),
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InputTextItem(
              rightFlex: 7,
              leftFlex: 3,
              isRequired: true,
              title: Translation.t(context, '收款方式'),
              inputText: GestureDetector(
                onTap: () async {
                  var data = await showApplyType();
                  if (data != null) {
                    setState(() {
                      withdrawType = data;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Caption(
                          str: Translation.t(context, getWithdrawTypeName()),
                          color: withdrawType == null
                              ? ColorConfig.textGray
                              : Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
            ),
            withdrawType != 1
                ? InputTextItem(
                    rightFlex: 7,
                    leftFlex: 3,
                    title: Translation.t(context, '账户名'),
                    isRequired: true,
                    inputText: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: NormalInput(
                            hintText: Translation.t(context, '请输入账户名'),
                            textAlign: TextAlign.left,
                            contentPadding: const EdgeInsets.only(top: 17),
                            controller: _accountController,
                            focusNode: _accountNode,
                            autoFocus: false,
                            keyboardType: TextInputType.text,
                            onSubmitted: (res) {
                              FocusScope.of(context)
                                  .requestFocus(_remarkNoNode);
                            },
                          ))
                        ],
                      ),
                    ))
                : Gaps.empty,
            InputTextItem(
                rightFlex: 7,
                leftFlex: 3,
                title: Translation.t(context, '备注'),
                inputText: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: NormalInput(
                        hintText: Translation.t(context, '请输入备注'),
                        textAlign: TextAlign.left,
                        contentPadding: const EdgeInsets.only(top: 17),
                        controller: _remarkController,
                        focusNode: _remarkNoNode,
                        autoFocus: false,
                        keyboardType: TextInputType.text,
                      ))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
