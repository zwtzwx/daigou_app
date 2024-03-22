import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/common/version_util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/config/text_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/app_version_model.dart';
import 'package:shop_app_client/storage/user_storage.dart';

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
            child: Text('新版本更新'.inte, style: SizeConfig.textBoldDark18),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
              child: Text(widget.appModel.content ?? '',
                  style: SizeConfig.textDark14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 36.0,
                  child: TextButton(
                    onPressed: () {
                      VersionUtil.jumpToApp();
                      GlobalPages.pop();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: AppStyles.primary,
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: Text(
                      '立即更新'.inte,
                      style: const TextStyle(fontSize: SizeConfig.defaultSize,
                      color: Colors.white),
                    ),
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () {
                    var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                    CommonStorage.setVersionTime(time);
                    GlobalPages.pop();
                  },
                  child: Text(
                    '稍后更新'.inte,
                    style: const TextStyle(
                        color: AppStyles.textGrayC9,
                        fontSize: SizeConfig.middleSize),
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
}
