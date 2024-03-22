import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/common/image_util.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/common/version_util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/config/text_config.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_app_client/views/components/caption.dart';

/*
  升级框
 */
class UpdateDialog extends StatefulWidget {
  const UpdateDialog({Key? key, required this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  // CancelToken _cancelToken = CancelToken();
  bool _isDownload = false;
  double _value = 0;

  @override
  void dispose() {
    // if (!_cancelToken.isCancelled && _value != 1){
    //   _cancelToken.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// 使用false禁止返回键返回，达到强制升级目的
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:widget.arguments["content"].length>80?
                    AssetImage('assets/images/Center/update_long.png'):AssetImage('assets/images/Center/update_bk.png'),
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 290.0,
                height: widget.arguments["content"].length>80?420:360.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     Container(
                       alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 30,right: 30,top: 132),
                      child: Text("发现新版本", style: TextStyle(
                          color: Color(0xff333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      )),
                    ),
                    // 版本号
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                      child: Text('V'+widget.arguments["version"],
                          style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: 12
                          )),
                    ),
                    Container(
                      height: widget.arguments["content"].length>80?110:70,
                      child: SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15.0),
                          child: Text(widget.arguments["content"],
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                              )),
                        ),
                      ),
                    ),
                    if(widget.arguments["content"].length>80)10.verticalSpace,
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
                      child: _isDownload
                          ? LinearProgressIndicator(
                              backgroundColor: AppStyles.line,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppStyles.primary),
                              value: _value,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  width: 248.0,
                                  height: 42.0,
                                  child: BeeButton(
                                    fontSize: 14,
                                    onPressed: (){
                                      if (defaultTargetPlatform ==
                                          TargetPlatform.iOS) {
                                        GlobalPages.pop();
                                        VersionUtil.jumpAppStore();
                                      } else {
                                        setState(() {
                                          _isDownload = true;
                                        });
                                        _download();
                                      }
                                    },
                                    text: '立即升级',
                                  ),
                                ),
                                8.verticalSpace,
                                Container(
                                  child: GestureDetector(
                                    onTap: (){
                                      GlobalPages.pop(context);
                                    },
                                    child: AppText(
                                      str: '残忍拒绝',
                                      color: Color(0xff666666),
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    )
                  ],
                )),
          )),
    );
  }

  installApk(filePath) async {
    print(filePath);
    OpenFile.open(filePath);
  }

  indentInstall(filePath) {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: filePath,
      type: 'application/vnd.android.package-archive',
    );
    intent.launch();
  }
  ///下载apk
  _download() async {
    try {
      Directory? storageDir = await getExternalStorageDirectory();
      String storagePath = storageDir!.path;
      print(storagePath);
      File file = File('$storagePath/Daigou.apk');

      if (!file.existsSync()) {
        file.createSync();
      }
      await Dio(BaseOptions(
        connectTimeout: 1000000,
        receiveTimeout: 1000000,
      )).download(widget.arguments["file_path"], file.path,
          // cancelToken: _cancelToken,
          onReceiveProgress: (int count, int total) {
        if (total != -1) {
          setState(() {
            _value = count / total;
          });
          if (count == total) {
            installApk(file.path);
            // indentInstall(file.path);
          }
        }
      });
    } catch (e) {
      BaseUtils.showToast("下载失败!");
      // print(e);
      // print(c);
      setState(() {
        _isDownload = false;
      });
    }
  }
}
