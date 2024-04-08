import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class VersionUtil {
  static const MethodChannel _channel = MethodChannel('version');

  /// 应用安装
  static void install(String path) {
    _channel.invokeMethod("install", {'path': path});
  }

  /// AppStore跳转
  static void jumpAppStore() {
    // _channel.invokeListMethod("jumpAppStore");
    LaunchReview.launch(
      writeReview: false,
      androidAppId: "101931221",
      iOSAppId: "1492557133",
    );
  }


  static void jumpToApp() {
    if (Platform.isIOS) {
      launchUrl(Uri.parse('https://apps.apple.com/cn/app/item/id1629807090'));
    } else {
      launchUrl(Uri.parse(
          'https://play.google.com/store/apps/details?id=com.tongxiao.shop_app_client'));
    }
  }
  // 判断 app 版本
  static Future<bool> isAppUpdatedRequired(String latestVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    // print('当前版本');
    // print(currentVersion);
    List<String> latestVersionList = latestVersion.split('.');
    List<String> currentVersionList = currentVersion.split('.');

    while (latestVersionList.length < currentVersionList.length) {
      latestVersionList.add('0');
    }
    while (currentVersionList.length < latestVersionList.length) {
      currentVersionList.add('0');
    }
    for (var i = 0; i < latestVersionList.length; i++) {
      int latestVerionNum = int.parse(latestVersionList[i]);
      int currentVersionNum = int.parse(currentVersionList[i]);
      if (latestVerionNum > currentVersionNum) {
        return true;
      } else if (latestVerionNum < currentVersionNum) {
        return false;
      }
    }
    return false;
  }
}
