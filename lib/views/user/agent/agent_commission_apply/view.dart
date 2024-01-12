import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission_apply/controller.dart';

class AgentCommissionApplyPage extends GetView<AgentCommissionApplyController> {
  const AgentCommissionApplyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.1,
        centerTitle: true,
        title: AppText(
          str: '结算账号信息'.ts,
          fontSize: 17,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          height: 38.h,
          width: double.infinity,
          child: BeeButton(
            text: '确认',
            onPressed: controller.onSubmit,
          ),
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InputTextItem(
              rightFlex: 7,
              leftFlex: 3,
              isRequired: true,
              title: '收款方式'.ts,
              inputText: GestureDetector(
                onTap: () async {
                  controller.showApplyType(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Obx(
                          () => AppText(
                            str: controller.getWithdrawTypeName().ts,
                            color: controller.withdrawType.value == null
                                ? AppColors.textGray
                                : Colors.black,
                          ),
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
            Obx(
              () => Offstage(
                  offstage: controller.withdrawType.value == 1,
                  child: InputTextItem(
                      rightFlex: 7,
                      leftFlex: 3,
                      title: '账户名'.ts,
                      isRequired: true,
                      inputText: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: NormalInput(
                              hintText: '请输入账户名'.ts,
                              textAlign: TextAlign.left,
                              contentPadding: const EdgeInsets.all(0),
                              controller: controller.accountController,
                              focusNode: controller.accountNode,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(controller.remarkNoNode);
                              },
                            ))
                          ],
                        ),
                      ))),
            ),
            InputTextItem(
                rightFlex: 7,
                leftFlex: 3,
                title: '备注'.ts,
                inputText: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: NormalInput(
                        hintText: '请输入备注'.ts,
                        textAlign: TextAlign.left,
                        contentPadding: const EdgeInsets.all(0),
                        controller: controller.remarkController,
                        focusNode: controller.remarkNoNode,
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
