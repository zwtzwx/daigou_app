import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/version_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/app_version_model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/*
  升级框
 */
class UpdateDialog extends StatefulWidget {
  const UpdateDialog({Key? key, required this.appModel}) : super(key: key);
  final AppVersionModel appModel;

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isDownload = false;
  double _value = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text('新版本更新'.ts, style: TextConfig.textBoldDark18),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
              child: Text(widget.appModel.content ?? '',
                  style: TextConfig.textDark14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
            child: _isDownload
                ? LinearProgressIndicator(
                    backgroundColor: BaseStylesConfig.line,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        BaseStylesConfig.primary),
                    value: _value,
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 36.0,
                        child: TextButton(
                          onPressed: () {
                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                              Routers.pop();
                              VersionUtils.jumpToAppStore();
                            } else {
                              setState(() {
                                _isDownload = true;
                              });
                              _download();
                            }
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: BaseStylesConfig.primary,
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                          child: Text(
                            '立即更新'.ts,
                            style: const TextStyle(
                                fontSize: TextConfig.defaultSize),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          var time =
                              DateTime.now().millisecondsSinceEpoch ~/ 1000;
                          UserStorage.setVersionTime(time);
                          Routers.pop();
                        },
                        child: Text(
                          '稍后更新'.ts,
                          style: const TextStyle(
                              color: BaseStylesConfig.textGrayC9,
                              fontSize: TextConfig.middleSize),
                        ),
                      ),
                      5.verticalSpace,
                    ],
                  ),
          )
        ],
      ),
    );
  }

  installApk(filePath) async {
    OpenFile.open(filePath);
  }

  ///下载apk
  _download() async {
    try {
      Directory? storageDir = await getExternalStorageDirectory();
      String storagePath = storageDir!.path;
      File file = File('$storagePath/${widget.appModel.fileName}');

      if (!file.existsSync()) {
        file.createSync();
      }
      await Dio(BaseOptions(
        connectTimeout: 1000000,
        receiveTimeout: 1000000,
      )).download(widget.appModel.filePath, file.path,
          onReceiveProgress: (int count, int total) {
        if (total != -1) {
          setState(() {
            _value = count / total;
          });
          if (count == total) {
            installApk(file.path);
            Routers.pop();
          }
        }
      });
    } catch (e) {
      EasyLoading.showToast("${'下载失败'.ts}!");
      setState(() {
        _isDownload = false;
      });
    }
  }
}
