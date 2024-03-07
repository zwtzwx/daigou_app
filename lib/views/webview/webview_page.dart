import 'dart:core';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/common/hex_to_color.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/webview/webview_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

//浏览器

class BeeWebView extends GetView<BeeWebviewLogic> {
  const BeeWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        child: Scaffold(
          body: controller.url.value != null &&
                  controller.url.value!.startsWith('http') &&
                  controller.webController != null
              ? SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight,
                  child: WebViewWidget(controller: controller.webController!),
                )
              : SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().screenWidth,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Html(
                          style: {
                            "*": Style(
                              fontSize: FontSize.large,
                              lineHeight: LineHeight.number(1.2),
                            ),
                            'img': Style(
                              width: Width(375.w, Unit.auto),
                            ),
                          },

                          data: controller.url.value ?? '',
                          // onLinkTap: (linkUrl) {},
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      height: 60,
                      child: AppText(
                        str: controller.time.value ?? '',
                      ),
                    )
                  ],
                )),
          backgroundColor: controller.bgColor.value != null
              ? HexToColor(controller.bgColor.value!)
              : Colors.white,
          appBar: AppBar(
            backgroundColor: controller.bgColor.value != null
                ? HexToColor(controller.bgColor.value!)
                : Colors.white,
            //设置为白色字体
            title: AppText(
              str: controller.title.value ?? '',
              fontSize: 17,
            ),
          ),
        ),
        onWillPop: () async {
          Get.delete<BeeWebviewLogic>();
          return true;
        },
      );
    });
  }
}
