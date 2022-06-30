/*
  申请代理
 */
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/profile_updated_event.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterAgentPage extends StatefulWidget {
  const RegisterAgentPage({Key? key}) : super(key: key);

  @override
  RegisterAgentPageState createState() => RegisterAgentPageState();
}

class RegisterAgentPageState extends State<RegisterAgentPage>
    with AutomaticKeepAliveClientMixin {
  final textEditingController = TextEditingController();

// 联系人
  String recipientName = "";

// 联系电话
  String mobileNumber = "";
// 邮箱
  String email = "";

  // 旧号码
  final TextEditingController _oldNumberController = TextEditingController();
  final FocusNode _oldNumber = FocusNode();
  // 新号码
  final TextEditingController _mobileNumberController = TextEditingController();
  final FocusNode _mobileNumber = FocusNode();
  // 验证码
  final TextEditingController _validationController = TextEditingController();
  final FocusNode _validation = FocusNode();

  FocusNode blankNode = FocusNode();

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
            str: Translation.t(context, '申请代理'),
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(right: 15, left: 15),
            child: MainButton(
              text: '申请成为代理',
              onPressed: () async {
                if (recipientName.isEmpty ||
                    mobileNumber.isEmpty ||
                    email.isEmpty) {
                  Util.showToast(Translation.t(context, '请填写完整信息'));
                  return;
                }
                Map<String, dynamic> dic = {
                  'name': recipientName,
                  'phone': mobileNumber,
                  'email': email,
                };
                EasyLoading.show();
                var resulst = await AgentService.applyAgent(dic);
                EasyLoading.dismiss();
                if (resulst['ok']) {
                  EasyLoading.showSuccess(Translation.t(context, '信息提交成功'));
                  ApplicationEvent.getInstance()
                      .event
                      .fire(ProfileUpdateEvent());
                  Navigator.of(context).pop('refresh');
                } else {
                  EasyLoading.showError(resulst['msg']);
                }
              },
            ),
            // child: TextButton(
            //   style: ButtonStyle(
            //     overlayColor: MaterialStateColor.resolveWith(
            //         (states) => Colors.transparent),
            //   ),
            //   onPressed: () async {
            //     if (recipientName.isEmpty ||
            //         mobileNumber.isEmpty ||
            //         email.isEmpty) {
            //       Util.showToast('请填写完整信息');
            //       return;
            //     }
            //     Map<String, dynamic> dic = {
            //       'name': recipientName,
            //       'wechat_id': mobileNumber,
            //       'email': email,
            //     };

            //     if (await AgentService.applyAgent(dic)) {
            //       EasyLoading.showSuccess("信息提交成功");
            //       ApplicationEvent.getInstance()
            //           .event
            //           .fire(ProfileUpdateEvent());
            //       Navigator.of(context).pop('refresh');
            //     }
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: ColorConfig.warningText,
            //         borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            //         border:
            //             Border.all(width: 1, color: ColorConfig.warningText)),
            //     alignment: Alignment.center,
            //     height: 40,
            //     child: const Caption(
            //       str: '确认申请',
            //     ),
            //   ),
            // ),
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // buildCustomViews(context),
                SizedBox(
                    child: Column(
                  children: <Widget>[
                    InputTextItem(
                        title: Translation.t(context, '姓名'),
                        isRequired: true,
                        inputText: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: BaseInput(
                                hintText: Translation.t(context, '请输入您的姓名'),
                                textAlign: TextAlign.left,
                                controller: _mobileNumberController,
                                focusNode: _mobileNumber,
                                autoFocus: false,
                                autoShowRemove: false,
                                maxLength: 50,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(_validation);
                                },
                                onChanged: (res) {
                                  recipientName = res;
                                },
                              ))
                            ],
                          ),
                        )),
                    InputTextItem(
                        title: Translation.t(context, '联系电话'),
                        isRequired: true,
                        inputText: BaseInput(
                          hintText: Translation.t(context, '请输入联系电话'),
                          textAlign: TextAlign.left,
                          controller: _oldNumberController,
                          focusNode: _oldNumber,
                          autoFocus: false,
                          autoShowRemove: false,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          onSubmitted: (res) {
                            FocusScope.of(context).requestFocus(_mobileNumber);
                          },
                          onChanged: (res) {
                            mobileNumber = res;
                          },
                        )),
                    InputTextItem(
                        title: Translation.t(context, '联系邮箱'),
                        isRequired: true,
                        inputText: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: BaseInput(
                                hintText: Translation.t(context, '请输入邮箱号'),
                                textAlign: TextAlign.left,
                                controller: _validationController,
                                focusNode: _validation,
                                autoFocus: false,
                                maxLength: 50,
                                autoShowRemove: false,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(blankNode);
                                },
                                onChanged: (res) {
                                  email = res;
                                },
                              )),
                            ],
                          ),
                        )),
                    Gaps.line,
                  ],
                )),
                Gaps.vGap15,
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        height: 150,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().screenWidth,
              child: const TrackingBanner(),
            ),
          ],
        ));
    return headerView;
  }
}

class TrackingBanner extends StatefulWidget {
  const TrackingBanner({Key? key}) : super(key: key);

  @override
  _TrackingBannerState createState() => _TrackingBannerState();
}

class _TrackingBannerState extends State<TrackingBanner>
    with AutomaticKeepAliveClientMixin {
  String? banner;

  BannersModel allimagesModel = BannersModel();

  @override
  void initState() {
    super.initState();
    banner = '';

    getBanner();
  }

  @override
  bool get wantKeepAlive => true;

  // 获取顶部 banner 图
  void getBanner() async {
    var imagesData = await CommonService.getAllBannersInfo();
    setState(() {
      allimagesModel = imagesData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadImage(
      allimagesModel.backupImg1 ?? "",
      fit: BoxFit.fitWidth,
    );
  }
}
