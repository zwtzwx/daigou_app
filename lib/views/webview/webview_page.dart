import 'dart:core';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/common/hex_to_color.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/webview/webview_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

//浏览器

class BeeWebView extends GetView<BeeWebviewLogic> {
  const BeeWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        child: Container(
          height: ScreenUtil().screenHeight,
          // decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       colors: [Color(0xFFFDCFCF), Color(0xFFF5FAFF)],
          //       stops: [0.0, 0.5],
          //     )
          // ),
          child: Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.transparent,
              flexibleSpace:Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF5EF), Color(0xFFCBE3FF)],
                      stops: [0.0, 2.0],
                    )
                ),
              ),
              // elevation: 0.5,
              centerTitle: true,
            ),
            body: controller.url.value != null &&
                controller.url.value!.startsWith('http') &&
                controller.webController != null
                ? SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              child: WebViewWidget(controller: controller.webController!),
            )
                : SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF5EF), Color(0xFFCBE3FF)],
                        stops: [0.0, 2.0],
                      )
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
                    padding: EdgeInsets.only(top: 30,bottom: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white
                    ),
                    child: Column(
                      children: <Widget>[
                        AppText(
                          str: controller.title.value ?? '',
                          fontSize: 17,
                          color: Color(0xff222222),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          alignment: Alignment.center,
                          height: 60,
                          child: AppText(
                            str: controller.time.value ?? '',
                            color: Color(0xff999999),
                            fontSize: 12,
                          ),
                        ),
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
                      ],
                    ),
                  ),
                )),
            backgroundColor: controller.bgColor.value != null
                ? HexToColor(controller.bgColor.value!)
                : Colors.white,
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
