import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/models/article_model.dart';
import 'package:shop_app_client/services/article_service.dart';
import 'package:shop_app_client/common/version_util.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/services/common_service.dart';
import 'package:shop_app_client/views/components/update_dialog_p.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

class BeeLogic extends GlobalController {
  final aboutList = <ArticleModel>[].obs;
  final nowVersion = ''.obs;

  @override
  onInit() async{
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print('当前版本');
    print(currentVersion);
    nowVersion.value = currentVersion;
    getList();
  }

  getList() async {
    var data = await ArticleService.getList({'type': 5});
    aboutList.value = data;
  }

  void showUpdateDialog() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      CommonService.getVersion().then((onlineVersion) async {
        // var shouldUpdate =
        //     onlineVersion["version"].compareTo(packageInfo.version);
        var shouldUpdate =
        await VersionUtil.isAppUpdatedRequired(onlineVersion["version"]);
        if (shouldUpdate) {
          showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (_) => UpdateDialog(
                arguments: onlineVersion,
              ));
        } else {
          showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (_) => CupertinoAlertDialog(
                title: const Text("提示"),
                content: const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text("您已经是最新版本", style: TextStyle(
                    color: AppStyles.textDark
                  )),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('确定'),
                    onPressed: () {
                      GlobalPages.pop();
                    },
                  ),
                ],
              ));
        }
      });
    });
  }
}
