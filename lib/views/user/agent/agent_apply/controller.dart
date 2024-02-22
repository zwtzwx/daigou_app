import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/profile_updated_event.dart';
import 'package:huanting_shop/services/agent_service.dart';

class AgentApplyController extends GlobalLogic {
  final TextEditingController oldNumberController = TextEditingController();
  final FocusNode oldNumber = FocusNode();
  // 新号码
  final TextEditingController mobileNumberController = TextEditingController();
  final FocusNode mobileNumber = FocusNode();
  // 验证码
  final TextEditingController validationController = TextEditingController();
  final FocusNode validation = FocusNode();

  FocusNode blankNode = FocusNode();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  onSubmit() async {
    if (mobileNumberController.text.isEmpty ||
        oldNumberController.text.isEmpty ||
        validationController.text.isEmpty) {
      showToast('请填写完整信息');
      return;
    }
    Map<String, dynamic> dic = {
      'name': mobileNumberController.text,
      'phone': oldNumberController.text,
      'email': validationController.text,
    };
    var resulst = await AgentService.applyAgent(dic);
    if (resulst['ok']) {
      ApplicationEvent.getInstance().event.fire(ProfileUpdateEvent());
      Get
        ..back()
        ..back(result: 'refresh');
    }
  }
}
