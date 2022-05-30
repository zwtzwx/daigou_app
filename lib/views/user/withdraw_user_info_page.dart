import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/agent_model.dart';
import 'package:jiyun_app_client/models/bank_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
/*
  确认提现信息
*/

class WithdrawlUserInfoPage extends StatefulWidget {
  const WithdrawlUserInfoPage({Key? key, this.arguments}) : super(key: key);
  final Map? arguments;
  @override
  WithdrawlUserInfoPageState createState() => WithdrawlUserInfoPageState();
}

class WithdrawlUserInfoPageState extends State<WithdrawlUserInfoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = '';
  AgentModel? agentData;
  BankModel? bankModel;
  final textEditingController = TextEditingController();
  FocusNode blankNode = FocusNode();
  // 真名
  final TextEditingController _realNameContraller = TextEditingController();
  final FocusNode _realNameNode = FocusNode();
  // 身份证
  final TextEditingController _idCardController = TextEditingController();
  final FocusNode _idCardNode = FocusNode();
  // 银行账号
  final TextEditingController _bankNoController = TextEditingController();
  final FocusNode _bankNoNode = FocusNode();
  // 手机号
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _mobileNode = FocusNode();
  // 电子邮箱
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailNode = FocusNode();

  String realName = '';
  String IDCard = '';
  String bankName = '';
  String bankNumber = '';
  String mobileNumber = '';
  String emailNumber = '';
  String idCardPhoto = '';

  // 正面照片
  String positivePhoto = '';
  // 背面照片
  String backPhoto = '';

  @override
  void initState() {
    super.initState();
    pageTitle = '确认提现信息';
    getBindInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 用户绑定的提现信息
  getBindInfo() async {
    EasyLoading.show();
    var data = await AgentService.getProfile();
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        agentData = data;
        if (data.fullname.isNotEmpty) {
          _realNameContraller.text = data.fullname;
          _idCardController.text = data.idcard;
          bankName = data.bankName;
          _bankNoController.text = data.bankNumber;
          _mobileController.text = data.phone;
          _emailController.text = data.email;
          positivePhoto = data.faceImg;
          backPhoto = data.backImg;
        }
      });
    }
  }

  // 提交提现信息
  onSubmit() async {
    Map<String, dynamic> updataMap = {
      'fullname': _realNameContraller.text,
      'idcard': _idCardController.text,
      'bank_code': bankModel?.code ?? agentData?.bankCode,
      'bank_name': bankName,
      'bank_number': _bankNoController.text,
      'email': _emailController.text,
      'face_img': positivePhoto,
      'back_img': backPhoto,
      'phone': _mobileController.text,
    };
    EasyLoading.show();
    await AgentService.agentBind(updataMap, (msg) {
      EasyLoading.dismiss();
      EasyLoading.showSuccess(msg).then((value) {
        Navigator.pop(context, true);
      });
    }, (err) {
      EasyLoading.dismiss();
      EasyLoading.showError(err);
    });
  }

  // 身份证照片上传

  onIdCardUpload(int index) {
    UploadUtil.imagePicker(
      onSuccessCallback: (imageUrl) async {
        setState(() {
          if (index == 0) {
            positivePhoto = imageUrl;
          } else {
            backPhoto = imageUrl;
          }
        });
      },
      context: context,
      child: CupertinoActionSheet(
        title: const Text('请选择上传方式'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('相册'),
            onPressed: () {
              Navigator.pop(context, 'gallery');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('照相机'),
            onPressed: () {
              Navigator.pop(context, 'camera');
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('取消'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: pageTitle,
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: ColorConfig.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      InputTextItem(
                          height: 55,
                          rightFlex: 7,
                          leftFlex: 3,
                          title: '真实姓名',
                          inputText: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: NormalInput(
                                  hintText: '请填写您的真实姓名',
                                  textAlign: TextAlign.left,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  controller: _realNameContraller,
                                  focusNode: _realNameNode,
                                  autoFocus: false,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(_idCardNode);
                                  },
                                  onChanged: (res) {},
                                ))
                              ],
                            ),
                          )),
                      InputTextItem(
                          height: 55,
                          rightFlex: 7,
                          leftFlex: 3,
                          title: '身份证号码',
                          inputText: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: NormalInput(
                                  hintText: '请填写您的身份证号码',
                                  textAlign: TextAlign.left,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  controller: _idCardController,
                                  focusNode: _idCardNode,
                                  autoFocus: false,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(_bankNoNode);
                                  },
                                  onChanged: (res) {},
                                ))
                              ],
                            ),
                          )),
                      InputTextItem(
                          height: 55,
                          rightFlex: 7,
                          leftFlex: 3,
                          title: '银行名称',
                          inputText: GestureDetector(
                              onTap: () async {
                                var s = await Navigator.pushNamed(
                                    context, '/SelectBankPage');
                                if (s == null) {
                                  return;
                                }
                                bankModel = (s as BankModel);
                                setState(() {
                                  bankName = bankModel!.name;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Caption(
                                      str: bankName.isNotEmpty
                                          ? bankName
                                          : '请选择银行卡种类',
                                      color: bankName.isNotEmpty
                                          ? ColorConfig.textDark
                                          : ColorConfig.textGray,
                                      fontSize: 14,
                                    )),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: ColorConfig.bgGray,
                                    )
                                  ],
                                ),
                              ))),
                      InputTextItem(
                          height: 55,
                          rightFlex: 7,
                          leftFlex: 3,
                          title: '银行卡号',
                          inputText: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: NormalInput(
                                  hintText: '请填写您的银行卡号',
                                  textAlign: TextAlign.left,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  controller: _bankNoController,
                                  focusNode: _bankNoNode,
                                  autoFocus: false,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(_mobileNode);
                                  },
                                  onChanged: (res) {},
                                ))
                              ],
                            ),
                          )),
                      InputTextItem(
                          height: 55,
                          rightFlex: 7,
                          leftFlex: 3,
                          title: '手机号',
                          inputText: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: NormalInput(
                                  hintText: '请填写您的手机号',
                                  textAlign: TextAlign.left,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  controller: _mobileController,
                                  focusNode: _mobileNode,
                                  autoFocus: false,
                                  keyboardType: TextInputType.phone,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(_emailNode);
                                  },
                                  onChanged: (res) {},
                                ))
                              ],
                            ),
                          )),
                      InputTextItem(
                          height: 55,
                          rightFlex: 7,
                          leftFlex: 3,
                          title: '电子邮箱',
                          inputText: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: NormalInput(
                                  hintText: '请填写您的电子邮箱',
                                  textAlign: TextAlign.left,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  controller: _emailController,
                                  focusNode: _emailNode,
                                  autoFocus: false,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (res) {
                                    FocusScope.of(context)
                                        .requestFocus(blankNode);
                                  },
                                  onChanged: (res) {},
                                ))
                              ],
                            ),
                          )),
                      SizedBox(
                        height: (ScreenUtil().screenWidth - 60) / 3 + 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 10, right: 10),
                              height: 55,
                              child: const Caption(
                                str: '身份证照片',
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: (ScreenUtil().screenWidth - 60) / 3,
                              width: ScreenUtil().screenWidth - 140,
                              margin: const EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                              ),
                              child: uploadPhoto(),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 15, left: 15, top: 10, bottom: 10),
                height: 40,
                width: double.infinity,
                child: MainButton(
                  text: '确认',
                  onPressed: onSubmit,
                ),
              ),
            ]),
          ),
        ));
  }

  // 上传图片
  Widget uploadPhoto() {
    return Container(
        height: (ScreenUtil().screenWidth - 60) / 3,
        width: ScreenUtil().screenWidth - 140,
        alignment: Alignment.center,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //设置列数
              crossAxisCount: 2,
              //设置横向间距
              crossAxisSpacing: 5,
              //设置主轴间距
              mainAxisSpacing: 0,
            ),
            shrinkWrap: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 2,
            itemBuilder: _buildGrideBtnView()));
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      return _buildImageItem(
          context, index == 0 ? positivePhoto : backPhoto, index);
    };
  }

  Widget _buildImageItem(context, String url, int index) {
    return GestureDetector(
      child: url.isNotEmpty
          ? Container(
              color: ColorConfig.bgGray,
              child: LoadImage(
                url,
                fit: BoxFit.contain,
                holderImg: "PackageAndOrder/defalutIMG@3x",
                format: "png",
              ),
            )
          : Container(
              alignment: Alignment.center,
              color: ColorConfig.bgGray,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.add,
                    size: 30,
                    color: ColorConfig.textGray,
                  ),
                  Caption(
                    str: index == 0 ? '正面照片' : '反面照片',
                    fontSize: 13,
                  )
                ],
              ),
            ),
      onTap: () {
        onIdCardUpload(index);
      },
    );
  }
}
