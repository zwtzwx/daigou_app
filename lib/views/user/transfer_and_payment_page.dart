/*
  支付转账
  主要为线下支付
*/

import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/models/payment_setting_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_vip_price_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TransferAndPaymentPage extends StatefulWidget {
  final Map arguments;

  const TransferAndPaymentPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  TransferAndPaymentPageState createState() => TransferAndPaymentPageState();
}

class TransferAndPaymentPageState extends State<TransferAndPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = '';
  List<String> selectImg = [''];

  UserModel? userModel;
  LocalizationModel? localizationInfo;

  bool isLoading = false;

  // 验证码
  TextEditingController transferAccountController = TextEditingController();
  final FocusNode transferAccountNode = FocusNode();
  FocusNode blankNode = FocusNode();

  // 支付方式数据模型
  PayTypeModel? payModel;

  // 会员充值数据模型
  UserVipPriceModel? vipPriceModel;

  // 余额充值数据
  double? amount;

  // 订单付款数据
  OrderModel? orderModel;

  // 'transferType': 0,
  //                           'modelType': 0,
  int modelType = 0; // 数据类型  0转账购买会员  1转账充值余额 2转账订单付款

  @override
  void initState() {
    super.initState();
    pageTitle = '转账支付';

    // contentModel
    payModel = widget.arguments['payModel'];
    modelType = widget.arguments['transferType'];
    if (modelType == 0) {
      vipPriceModel = widget.arguments['contentModel'];
    } else if (modelType == 1) {
      amount = widget.arguments['amount'];
    } else if (modelType == 2) {
      orderModel = widget.arguments['contentModel'];
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});

    created();
  }

  created() async {
    var data = await UserService.getProfile();
    setState(() {
      userModel = data;
      isLoading = true;
    });
  }

  // 提交
  onSubmit() async {
    List<String> listImg = [];
    for (var item in selectImg) {
      if (item != '') {
        listImg.add(item);
      }
    }
    EasyLoading.show();
    Map result = {};
    if (modelType == 0) {
      // 0会员充值转账
      Map<String, dynamic> upData = {
        'transfer_account': transferAccountController.text,
        'tran_amount': vipPriceModel!.price,
        'images': listImg,
        'price_type': vipPriceModel!.type,
        'price_id': vipPriceModel!.id,
        'payment_id': payModel!.id,
      };
      result = await BalanceService.buyVipTransfer(upData);
    } else if (modelType == 1) {
      //  1余额充值转账
      Map<String, dynamic> upData = {
        'transfer_account': transferAccountController.text,
        'tran_amount': amount! * 100,
        'images': listImg,
        'payment_type_id': payModel!.id,
      };
      result = await BalanceService.rechargeTransfer(upData);
    } else if (modelType == 2) {
      // 2 订单付款转账
      Map<String, dynamic> upData = {
        'order_number': orderModel!.orderSn,
        'transfer_account': transferAccountController.text,
        'images': listImg,
        'remark': '',
        'payment_id': payModel!.id,
      };
      result = await BalanceService.orderPayTransfer(upData);
    }
    EasyLoading.dismiss();
    if (result['ok']) {
      // Routers.push('/PaySuccessPage', context, {
      //   'model': orderModel,
      //   'type': modelType == 2 ? 1 : 3,
      // });
      Navigator.of(context)
        ..pop()
        ..pop('succeed');
    } else {
      EasyLoading.showError(result['msg'] ?? '提交失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().screenWidth,
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              decoration: const BoxDecoration(
                color: ColorConfig.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: ScreenUtil().screenWidth - 60,
                      child: Column(children: buildListView())),
                ],
              ),
            ),
            Container(
              height: payModel != null && payModel!.fullPath.isNotEmpty
                  ? ScreenUtil().screenWidth - 60 + 180
                  : 180,
              width: ScreenUtil().screenWidth,
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              decoration: const BoxDecoration(
                color: ColorConfig.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  payModel != null && payModel!.fullPath.isNotEmpty
                      ? SizedBox(
                          height: ScreenUtil().screenWidth - 60,
                          width: ScreenUtil().screenWidth - 60,
                          child: LoadImage(
                            payModel!.fullPath,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),
                  Container(
                    height: 50,
                    width: ScreenUtil().screenWidth - 60,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: 100,
                          child: const Caption(
                            str: '转账账号',
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          color: ColorConfig.bgGray,
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: ScreenUtil().screenWidth - 60 - 100,
                          child: NormalInput(
                            hintText: "请输入您的转账账号",
                            textAlign: TextAlign.left,
                            contentPadding: const EdgeInsets.only(top: 15),
                            controller: transferAccountController,
                            focusNode: transferAccountNode,
                            autoFocus: false,
                            keyboardType: TextInputType.text,
                            onSubmitted: (res) {
                              FocusScope.of(context).requestFocus(blankNode);
                            },
                            onChanged: (res) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.line,
                  Gaps.line,
                  uploadPhoto(),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 50, right: 15, left: 15),
                width: double.infinity,
                child: MainButton(
                  text: '确认提交',
                  onPressed: onSubmit,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  // 上传图片
  Widget uploadPhoto() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        height: (ScreenUtil().screenWidth - 60) / 4,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //设置列数
              crossAxisCount: 4,
              //设置横向间距
              crossAxisSpacing: 5,
              //设置主轴间距
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            shrinkWrap: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: selectImg.isEmpty ? 1 : selectImg.length,
            itemBuilder: _buildGrideBtnView()));
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      return _buildImageItem(
          context, selectImg.isEmpty ? '' : selectImg[index], index);
    };
  }

  Widget _buildImageItem(context, String url, int index) {
    return GestureDetector(
      child: Stack(children: <Widget>[
        url.isNotEmpty
            ? Container(
                color: ColorConfig.bgGray,
                height: (ScreenUtil().screenWidth - 60 - 15) / 4,
                width: (ScreenUtil().screenWidth - 60 - 15) / 4,
                child: LoadImage(
                  url,
                  fit: BoxFit.cover,
                  holderImg: "PackageAndOrder/defalutIMG@3x",
                  format: "png",
                ),
              )
            : Container(
                alignment: Alignment.center,
                color: ColorConfig.bgGray,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.add,
                      size: 30,
                      color: ColorConfig.textGray,
                    ),
                    Caption(
                      str: '添加图片',
                      fontSize: 10,
                    )
                  ],
                ),
              ),
        Positioned(
            top: 0,
            right: 0,
            child: url != ''
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!selectImg.contains('')) {
                          selectImg.add('');
                        }
                        selectImg.remove(url);
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: ColorConfig.textGrayC,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: const Icon(
                        Icons.close,
                        color: ColorConfig.white,
                        size: 18,
                      ),
                    ))
                : Container()),
      ]),
      onTap: () {
        UploadUtil.imagePicker(
          onSuccessCallback: (image) async {
            String imageUrl = image;
            setState(() {
              if (selectImg.length == 3) {
                if (index == 2) {
                  selectImg.removeLast();
                  selectImg.add(imageUrl);
                } else {
                  selectImg.replaceRange(index, index + 1, [imageUrl]);
                }
              } else {
                selectImg.insert(index, imageUrl);
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
      },
    );
  }

  buildListView() {
    List<Widget> listView = [];

    double warmHeight = calculateTextHeight(payModel!.remark, 14.0,
        FontWeight.w300, ScreenUtil().screenWidth - 60 - 80 - 20, 99);
    for (var i = 0; i < payModel!.paymentSettingConnection.length; i++) {
      PaymentSettingModel model = payModel!.paymentSettingConnection[i];

      var subView = Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 100,
                    child: Caption(
                      str: model.name,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 160,
                    child: Caption(
                      str: model.content,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: model.content));
                Util.showToast('复制成功');
              },
              child: Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: const BoxDecoration(
                    color: ColorConfig.warningText,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: const Caption(
                  str: '复制',
                  fontSize: 13,
                ),
              ),
            )
          ],
        ),
      );
      listView.add(subView);
    }
    List<String> listTitle = [
      '用户ID',
      '应付款',
    ];

    List<String> listContent = [
      isLoading ? userModel!.id.toString() : '',
      isLoading
          ? modelType == 0
              ? localizationInfo!.currencySymbol +
                  (vipPriceModel!.price / 100).toStringAsFixed(2)
              : modelType == 1
                  ? localizationInfo!.currencySymbol +
                      (amount!).toStringAsFixed(2)
                  : modelType == 2
                      ? localizationInfo!.currencySymbol +
                          (orderModel!.discountPaymentFee / 100)
                              .toStringAsFixed(2)
                      : '0'
          : '0',
    ];

    for (var i = 0; i < listTitle.length; i++) {
      var subView = Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 100,
                    child: Caption(
                      str: listTitle[i],
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 160,
                    child: Caption(
                      str: listContent[i],
                      color:
                          i == 1 ? ColorConfig.textRed : ColorConfig.textBlack,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            i == 0
                ? GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: listContent[i]));
                      Util.showToast('复制成功');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 10, left: 10),
                      decoration: const BoxDecoration(
                          color: ColorConfig.warningText,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: const Caption(
                        str: '复制',
                        fontSize: 13,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      );
      listView.add(subView);
    }
    var subView = Container(
      height: warmHeight + 28,
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: 100,
                  child: const Caption(
                    str: '温馨提示',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: warmHeight + 28,
            width: ScreenUtil().screenWidth - 60 - 80 - 20,
            child: Caption(
              lines: 99,
              str: payModel!.remark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
    listView.add(subView);
    return listView;
  }

  double calculateTextHeight(String value, fontSize, FontWeight fontWeight,
      double maxWidth, int maxLines) {
    // value = filterText(value);
    TextPainter painter = TextPainter(
        // ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        // locale: Localizations.localeOf(GlobalStatic.context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }
}
