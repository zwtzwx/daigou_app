import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/services/agent_service.dart';
import 'package:shop_app_client/views/components/caption.dart';

class AgentCommissionApplyController extends GlobalController {
// 收款方式
  final withdrawType = Rxn<int?>();
  // 账号
  final TextEditingController accountController = TextEditingController();
  final FocusNode accountNode = FocusNode();
  // 备注
  final TextEditingController remarkController = TextEditingController();
  final FocusNode remarkNoNode = FocusNode();

  // 提交提现信息
  onSubmit() async {
    if (withdrawType.value == null) {
      return showToast('请选择收款方式');
    } else if (withdrawType.value != 1 && accountController.text.isEmpty) {
      return showToast('请输入账户名');
    }
    Map<String, dynamic> updataMap = {
      'commission_ids': Get.arguments?['ids'],
      'withdraw_type': withdrawType.value,
      'withdraw_account': accountController.text,
      'remark': remarkController.text,
    };
    var result = await AgentService.applyWithDraw(updataMap);
    if (result['ok']) {
      Get
        ..back()
        ..back();
    }
  }

  // 选择收款方式
  void showApplyType(BuildContext context) async {
    var data = await showCupertinoModalPopup<int>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: AppText(str: '余额提现'.inte),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 2);
              },
              child: AppText(str: '微信提现'.inte),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 3);
              },
              child: AppText(str: '支付宝提现'.inte),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: AppText(str: '取消'.inte),
          ),
        );
      },
    );
    if (data != null) {
      withdrawType.value = data;
    }
  }

  String getWithdrawTypeName() {
    String str = '请选择收款方式';
    switch (withdrawType.value) {
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

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
