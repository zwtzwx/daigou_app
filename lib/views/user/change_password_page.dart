import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final FocusNode _newPaddwordNode = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _confirmPaddwordNode = FocusNode();

  void onSubmit() async {
    EasyLoading.show();
    var res = await UserService.onChangePassword({
      'password': _newPasswordController.text,
      'password_confirmation': _confirmPasswordController.text,
    });
    EasyLoading.dismiss();
    if (res['ok']) {
      EasyLoading.showSuccess(res['msg']).then((value) async {
        await UserStorage.clearToken();
        //清除TOKEN
        Provider.of<Model>(context, listen: false).loginOut();
        Routers.redirect('/LoginPage', context);
      });
    } else {
      EasyLoading.showError(res['msg']);
    }
  }

  @override
  void dispose() {
    _newPaddwordNode.dispose();
    _confirmPaddwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        elevation: 0.5,
        title: ZHTextLine(
          str: Translation.t(context, '修改密码'),
          fontSize: 18,
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
            child: MainButton(
          text: '提交',
          onPressed: onSubmit,
        )),
      ),
      body: Column(
        children: [
          InputTextItem(
            title: Translation.t(context, '新密码'),
            isRequired: true,
            inputText: NormalInput(
              hintText: Translation.t(context, '请输入新密码'),
              contentPadding: const EdgeInsets.only(right: 15),
              controller: _newPasswordController,
              focusNode: _newPaddwordNode,
              autoFocus: false,
              isScureText: true,
              maxLines: 1,
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(_confirmPaddwordNode);
              },
              keyboardType: TextInputType.text,
            ),
          ),
          InputTextItem(
            title: Translation.t(context, '确认密码'),
            isRequired: true,
            inputText: NormalInput(
              hintText: Translation.t(context, '请确认密码'),
              contentPadding: const EdgeInsets.only(right: 15),
              controller: _confirmPasswordController,
              focusNode: _confirmPaddwordNode,
              autoFocus: false,
              isScureText: true,
              maxLines: 1,
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}
