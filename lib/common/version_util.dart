import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUtils {
  // 判断 app 版本
  static Future<bool> isAppUpdatedRequired(String latestVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

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

  static void jumpToApp() {
    if (Platform.isIOS) {
      launchUrl(Uri.parse('https://apps.apple.com/cn/app/item/id1670291989'));
    } else {
      launchUrl(Uri.parse(
          'https://play.google.com/store/apps/details?id=com.zhongha.shop_app_client'));
    }
  }
}
