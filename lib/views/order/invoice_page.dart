import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/invoice_model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/services/invoice_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class InvoicePage extends StatefulWidget {
  final Map arguments;
  const InvoicePage({Key? key, required this.arguments}) : super(key: key);

  @override
  InvoicePageState createState() => InvoicePageState();
}

class InvoicePageState extends State<InvoicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int invoiceType = 2; //发票抬头类型 1 个人 2 企业
  int type = 1; //发票类型 1 纸质发票
  bool isDefault = false;

  // 发票抬头
  final TextEditingController _invoiceHeaderController =
      TextEditingController();
  final FocusNode _invoiceHeader = FocusNode();
  // 税号
  final TextEditingController _companyEinController = TextEditingController();
  final FocusNode _companyEin = FocusNode();
  // 开户银行
  final TextEditingController _bankController = TextEditingController();
  final FocusNode _bankName = FocusNode();
  // 银行账号
  final TextEditingController _bankAccountController = TextEditingController();
  final FocusNode _bankAccount = FocusNode();
  // 企业地址
  final TextEditingController _companyAddressController =
      TextEditingController();
  final FocusNode _companyAddress = FocusNode();
  // 企业电话
  final TextEditingController _companyPhoneController = TextEditingController();
  final FocusNode _companyPhone = FocusNode();

  FocusNode blankNode = FocusNode();

  // 发票数据模型
  InvoiceModel? invoiceModel;
  OrderModel? orderModel;

  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    pageTitle = '发票';
    orderModel = widget.arguments['orderModel'] as OrderModel;
    getDefaultInvoice();
  }

  // 默认发票信息
  getDefaultInvoice() async {
    var _invoiceModel = await InvoiceService.getDefault();
    if (_invoiceModel != null) {
      setState(() {
        invoiceModel = _invoiceModel;
        _invoiceHeaderController.text = invoiceModel!.title;
        _companyEinController.text = invoiceModel!.dutyParagraph;
        _bankController.text = invoiceModel!.bankName;
        _bankAccountController.text = invoiceModel!.bankAccount;
        _companyAddressController.text = invoiceModel!.companyAddress;
        _companyPhoneController.text = invoiceModel!.companyTel;
        invoiceType = invoiceModel!.invoiceType;
      });
    }
  }

  // 提交发票
  onSubmit() async {
    if (_invoiceHeaderController.text.isEmpty) {
      Util.showToast(invoiceType == 1 ? '请填写姓名' : '请填写企业名称');
      return;
    }
    Map<String, dynamic> map;
    if (invoiceType == 1) {
      // 个人发票
      map = {
        'type': type, // 发票类型 目前只有纸质发票
        'invoice_type': invoiceType, // 抬头类型
        'title': _invoiceHeaderController.text, //抬头
        'is_default': isDefault ? 1 : 0, // 是否默认  0不默认 1 默认
      };
    } else {
      if (_companyEinController.text.isEmpty) {
        Util.showToast('请填写纳税人识别号');
        return;
      }
      map = {
        'type': type, // 发票类型 目前只有纸质发票
        'invoice_type': invoiceType, // 抬头类型
        'title': _invoiceHeaderController.text, //抬头
        'duty_paragraph': _companyEinController.text, // 税号
        'bank_name': _bankController.text, // 银行名称
        'bank_account': _bankAccountController.text, // 银行账号
        'company_address': _companyAddressController.text, // 企业地址
        'company_tel': _companyPhoneController.text, // 企业电话
        'is_default': isDefault ? 1 : 0, // 是否默认  0不默认 1 默认
      };
    }
    EasyLoading.show();
    bool data = await InvoiceService.update(orderModel!.id, map);
    EasyLoading.dismiss();
    if (data) {
      EasyLoading.showSuccess('提交成功');
      Navigator.pop(context, 'confirm');
    } else {
      EasyLoading.showSuccess('提交失败');
    }
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
          str: pageTitle,
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: Container(
        margin: const EdgeInsets.only(top: 10, right: 15, left: 15),
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
          children: <Widget>[
            InputTextItem(
                title: "发票类型",
                inputText: Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  alignment: Alignment.centerRight,
                  height: 55,
                  child: const Caption(
                    str: '普通纸质发票',
                  ),
                )),
            InputTextItem(
                title: "抬头类型",
                inputText: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          invoiceType = 1;
                        });
                      },
                      child: SizedBox(
                        height: 55,
                        width: 80,
                        child: Row(
                          children: <Widget>[
                            invoiceType == 1
                                ? const Icon(
                                    Icons.check_circle,
                                    color: ColorConfig.warningText,
                                  )
                                : const Icon(
                                    Icons.radio_button_off_outlined,
                                    color: ColorConfig.textGray,
                                  ),
                            const Caption(
                              str: '个人',
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          invoiceType = 2;
                        });
                      },
                      child: SizedBox(
                        height: 55,
                        width: 80,
                        child: Row(
                          children: <Widget>[
                            invoiceType == 2
                                ? const Icon(
                                    Icons.check_circle,
                                    color: ColorConfig.warningText,
                                  )
                                : const Icon(
                                    Icons.radio_button_off_outlined,
                                    color: ColorConfig.textGray,
                                  ),
                            const Caption(
                              str: '公司',
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            InputTextItem(
                title: "发票抬头",
                inputText: NormalInput(
                  hintText: invoiceType == 1 ? '需要开具发票的姓名' : "需要开具发票的企业名称",
                  textAlign: TextAlign.right,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  controller: _invoiceHeaderController,
                  focusNode: _invoiceHeader,
                  maxLength: 40,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_companyEin);
                  },
                  onChanged: (res) {
                    // model.receiverName = res;
                  },
                )),
            InputTextItem(
                height: invoiceType == 1 ? 0 : 55,
                title: "税号",
                inputText: NormalInput(
                  hintText: "纳税人识别号",
                  textAlign: TextAlign.right,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  controller: _companyEinController,
                  focusNode: _companyEin,
                  maxLength: 40,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_bankName);
                  },
                  onChanged: (res) {},
                )),
            InputTextItem(
                height: invoiceType == 1 ? 0 : 55,
                title: "开户银行",
                inputText: NormalInput(
                  hintText: "选填",
                  textAlign: TextAlign.right,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  controller: _bankController,
                  focusNode: _bankName,
                  maxLength: 40,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_bankAccount);
                  },
                  onChanged: (res) {},
                )),
            InputTextItem(
                height: invoiceType == 1 ? 0 : 55,
                title: "银行账号",
                inputText: NormalInput(
                  hintText: "选填",
                  textAlign: TextAlign.right,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  controller: _bankAccountController,
                  focusNode: _bankAccount,
                  maxLength: 40,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_companyAddress);
                  },
                  onChanged: (res) {},
                )),
            InputTextItem(
                height: invoiceType == 1 ? 0 : 55,
                title: "企业地址",
                inputText: NormalInput(
                  hintText: "选填",
                  textAlign: TextAlign.right,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  controller: _companyAddressController,
                  focusNode: _companyAddress,
                  maxLength: 40,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_companyPhone);
                  },
                  onChanged: (res) {},
                )),
            InputTextItem(
                height: invoiceType == 1 ? 0 : 55,
                title: "企业电话",
                inputText: NormalInput(
                  hintText: "选填",
                  textAlign: TextAlign.right,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  controller: _companyPhoneController,
                  focusNode: _companyPhone,
                  maxLength: 40,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(blankNode);
                  },
                  onChanged: (res) {},
                )),
            const SizedBox(
              height: 15,
            ),
            InputTextItem(
                leftFlex: 6,
                rightFlex: 4,
                title: "设置为默认抬头",
                inputText: GestureDetector(
                    onTap: () {
                      setState(() {
                        isDefault = !isDefault;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      alignment: Alignment.centerRight,
                      height: 55,
                      child: isDefault
                          ? const Icon(
                              Icons.check_circle,
                              color: ColorConfig.warningText,
                            )
                          : const Icon(
                              Icons.radio_button_off_outlined,
                              color: ColorConfig.textGray,
                            ),
                    ))),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, left: 5),
              alignment: Alignment.centerLeft,
              height: 55,
              child: const Caption(
                lines: 2,
                str: '提示：如要发票随包裹一起寄出或其他要求请及时联系客服！',
                fontSize: 14,
                color: ColorConfig.textGray,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 110,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: MainButton(
                      text:
                          (orderModel!.status == 2 || orderModel!.status == 12)
                              ? '确认'
                              : '提交申请',
                      onPressed: onSubmit,
                    ),
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: MainButton(
                      text: '不开发票',
                      backgroundColor: Colors.white,
                      textColor: ColorConfig.textRed,
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
