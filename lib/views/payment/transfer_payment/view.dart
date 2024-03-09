import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/common/upload_util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/payment_setting_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/payment/transfer_payment/controller.dart';

class TransferPaymentPage extends GetView<TransferPaymentController> {
  const TransferPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '转账支付'.inte,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(controller.blankNode);
        },
        child: SingleChildScrollView(
            child: Column(
          children: [
            15.verticalSpaceFromWidth,
            Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppStyles.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildListView(),
                  ),
                )),
            10.verticalSpaceFromWidth,
            Obx(
              () => Container(
                width: ScreenUtil().screenWidth,
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppStyles.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.payModel.value != null &&
                            controller.payModel.value!.fullPath.isNotEmpty
                        ? SizedBox(
                            child: ImgItem(
                              controller.payModel.value!.fullPath,
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                            ),
                          )
                        : Container(),
                    10.verticalSpaceFromWidth,
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 100.w,
                          child: AppText(
                            str: '转账账号'.inte,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: BaseInput(
                            hintText: '请输入您的转账账号'.inte,
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
                    AppGaps.line,
                    uploadPhoto(),
                  ],
                ),
              ),
            ),
            20.verticalSpaceFromWidth,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              width: double.infinity,
              height: 38.h,
              child: BeeButton(
                text: '确认提交',
                onPressed: controller.onSubmit,
              ),
            ),
            30.verticalSpaceFromWidth,
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
                color: AppStyles.bgGray,
                height: (ScreenUtil().screenWidth - 60 - 15) / 4,
                width: (ScreenUtil().screenWidth - 60 - 15) / 4,
                child: ImgItem(
                  url,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                alignment: Alignment.center,
                color: AppStyles.bgGray,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.add,
                      size: 30,
                      color: AppStyles.textGray,
                    ),
                    AppText(
                      str: '添加图片'.inte,
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
                          color: AppStyles.textGrayC,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: const Icon(
                        Icons.close,
                        color: AppStyles.white,
                        size: 18,
                      ),
                    ))
                : Container()),
      ]),
      onTap: () {
        ImagePickers.imagePicker(
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
            title: Text('请选择上传方式'.inte),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('相册'.inte),
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              CupertinoActionSheetAction(
                child: Text('照相机'.inte),
                onPressed: () {
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'.inte),
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

    for (var i = 0;
        i < controller.payModel.value!.paymentSettingConnection.length;
        i++) {
      PaymentSettingModel model =
          controller.payModel.value!.paymentSettingConnection[i];

      var subView = Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            SizedBox(
              width: 100.w,
              child: AppText(
                str: model.name,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: AppText(
                str: model.content,
                fontSize: 14,
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
                    color: AppStyles.primary,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: AppText(
                  str: '复制'.inte,
                  fontSize: 12,
                  color: Colors.white,
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
              : controller.modelType.value == 2
                  ? (controller.orderModel.value!.discountPaymentFee / 100)
                  : (controller.amount.value ?? 0))
          .priceConvert(needFormat: false)
    ];

    for (var i = 0; i < listTitle.length; i++) {
      var subView = Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 90.w,
              child: AppText(
                str: listTitle[i].inte,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: AppText(
                str: listContent[i],
                color: i == 1 ? AppStyles.textRed : AppStyles.textBlack,
                fontSize: 14,
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
                          color: AppStyles.primary,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: AppText(
                        str: '复制'.inte,
                        fontSize: 12,
                        color: Colors.white,
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
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 90.w,
            child: AppText(
              str: '温馨提示'.inte,
              fontSize: 14,
              lines: 2,
            ),
          ),
          AppText(
            lines: 99,
            str: controller.payModel.value!.remark,
            fontSize: 14,
          ),
        ],
      ),
    );
    listView.add(subView);
    return listView;
  }
}
