import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/payment_setting_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/payment/transfer_payment/controller.dart';

class TransferPaymentPage extends GetView<TransferPaymentController> {
  const TransferPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '转账支付'.ts,
          color: AppColors.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(controller.blankNode);
        },
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              width: 1.sw,
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: ScreenUtil().screenWidth - 60,
                      child: Obx(() => Column(children: buildListView()))),
                ],
              ),
            ),
            Obx(
              () => Container(
                height: controller.payModel.value != null &&
                        controller.payModel.value!.fullPath.isNotEmpty
                    ? ScreenUtil().screenWidth - 60 + 180
                    : 180,
                width: ScreenUtil().screenWidth,
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    controller.payModel.value != null &&
                            controller.payModel.value!.fullPath.isNotEmpty
                        ? SizedBox(
                            height: ScreenUtil().screenWidth - 60,
                            width: ScreenUtil().screenWidth - 60,
                            child: ImgItem(
                              controller.payModel.value!.fullPath,
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
                            child: AppText(
                              str: '转账账号'.ts,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            color: AppColors.bgGray,
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: ScreenUtil().screenWidth - 60 - 100,
                            child: BaseInput(
                              hintText: '请输入您的转账账号'.ts,
                              textAlign: TextAlign.left,
                              controller: controller.transferAccountController,
                              focusNode: controller.transferAccountNode,
                              autoFocus: false,
                              keyboardType: TextInputType.text,
                              autoShowRemove: false,
                              onSubmitted: (res) {
                                FocusScope.of(context)
                                    .requestFocus(controller.blankNode);
                              },
                              onChanged: (res) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppGaps.line,
                    uploadPhoto(),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 50, right: 15, left: 15),
                width: double.infinity,
                child: BeeButton(
                  text: '确认提交',
                  onPressed: controller.onSubmit,
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
      child: Obx(
        () => GridView.builder(
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
          itemCount:
              controller.selectImg.isEmpty ? 1 : controller.selectImg.length,
          itemBuilder: _buildGrideBtnView(),
        ),
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      return _buildImageItem(
          context,
          controller.selectImg.isEmpty ? '' : controller.selectImg[index],
          index);
    };
  }

  Widget _buildImageItem(context, String url, int index) {
    return GestureDetector(
      child: Stack(children: <Widget>[
        url.isNotEmpty
            ? Container(
                color: AppColors.bgGray,
                height: (ScreenUtil().screenWidth - 60 - 15) / 4,
                width: (ScreenUtil().screenWidth - 60 - 15) / 4,
                child: ImgItem(
                  url,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                alignment: Alignment.center,
                color: AppColors.bgGray,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.textGray,
                    ),
                    AppText(
                      str: '添加图片'.ts,
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
                      if (!controller.selectImg.contains('')) {
                        controller.selectImg.add('');
                      }
                      controller.selectImg.remove(url);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.textGrayC,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ))
                : Container()),
      ]),
      onTap: () {
        ImageUpload.imagePicker(
          onSuccessCallback: (image) async {
            String imageUrl = image;
            if (controller.selectImg.length == 3) {
              if (index == 2) {
                controller.selectImg.removeLast();
                controller.selectImg.add(imageUrl);
              } else {
                controller.selectImg.replaceRange(index, index + 1, [imageUrl]);
              }
            } else {
              controller.selectImg.insert(index, imageUrl);
            }
          },
          context: context,
          child: CupertinoActionSheet(
            title: Text('请选择上传方式'.ts),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('相册'.ts),
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              CupertinoActionSheetAction(
                child: Text('照相机'.ts),
                onPressed: () {
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'.ts),
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

    double warmHeight = calculateTextHeight(controller.payModel.value!.remark,
        14.0, FontWeight.w300, ScreenUtil().screenWidth - 60 - 80 - 20, 99);
    for (var i = 0;
        i < controller.payModel.value!.paymentSettingConnection.length;
        i++) {
      PaymentSettingModel model =
          controller.payModel.value!.paymentSettingConnection[i];

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
                    child: AppText(
                      str: model.name,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 160,
                    child: AppText(
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
                controller.showToast('复制成功');
              },
              child: Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: AppText(
                  str: '复制'.ts,
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
      controller.userModel?.id.toString() ?? '',
      (controller.modelType.value == 0
              ? ((controller.vipPriceModel.value?.price ?? 0) / 100)
              : controller.modelType.value == 1
                  ? controller.amount.value!
                  : controller.modelType.value == 2
                      ? (controller.orderModel.value!.discountPaymentFee / 100)
                      : 0)
          .rate(needFormat: false)
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
                    child: AppText(
                      str: listTitle[i].ts,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 160,
                    child: AppText(
                      str: listContent[i],
                      color: i == 1 ? AppColors.textRed : AppColors.textBlack,
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
                      controller.showToast('复制成功');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 10, left: 10),
                      decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: AppText(
                        str: '复制'.ts,
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
          Container(
            alignment: Alignment.centerLeft,
            width: 100,
            child: AppText(
              str: '温馨提示'.ts,
              fontSize: 14,
              lines: 2,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: AppText(
              lines: 99,
              str: controller.payModel.value!.remark,
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
