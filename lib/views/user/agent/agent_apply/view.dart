import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/user/agent/agent_apply/controller.dart';

class AgentApplyPage extends GetView<AgentApplyController> {
  const AgentApplyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: AppText(
            str: '申请代理'.ts,
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 15, left: 15),
              child: MainButton(
                text: '申请成为代理',
                onPressed: controller.onSubmit,
              )),
        ),
        backgroundColor: AppColors.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                    child: Column(
                  children: <Widget>[
                    InputTextItem(
                        title: '姓名'.ts,
                        isRequired: true,
                        inputText: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: BaseInput(
                                hintText: '请输入您的姓名'.ts,
                                textAlign: TextAlign.left,
                                controller: controller.mobileNumberController,
                                focusNode: controller.mobileNumber,
                                autoFocus: false,
                                autoShowRemove: false,
                                maxLength: 50,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(controller.oldNumber);
                                },
                              ))
                            ],
                          ),
                        )),
                    InputTextItem(
                        title: '联系电话'.ts,
                        isRequired: true,
                        inputText: BaseInput(
                          hintText: '请输入联系电话'.ts,
                          textAlign: TextAlign.left,
                          controller: controller.oldNumberController,
                          focusNode: controller.oldNumber,
                          autoFocus: false,
                          autoShowRemove: false,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          onSubmitted: (res) {
                            FocusScope.of(context)
                                .requestFocus(controller.validation);
                          },
                        )),
                    InputTextItem(
                        title: '联系邮箱'.ts,
                        isRequired: true,
                        inputText: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: BaseInput(
                                hintText: '请输入邮箱号'.ts,
                                textAlign: TextAlign.left,
                                controller: controller.validationController,
                                focusNode: controller.validation,
                                autoFocus: false,
                                maxLength: 50,
                                autoShowRemove: false,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(controller.blankNode);
                                },
                              )),
                            ],
                          ),
                        )),
                    AppGaps.line,
                  ],
                )),
                AppGaps.vGap15,
              ],
            ),
          ),
        ));
  }
}
