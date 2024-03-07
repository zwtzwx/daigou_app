import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:huanting_shop/extension/translation.dart';

class WechatConfig {
  static WechatConfig? _instance;

  Fluwx _fluwx;

  factory WechatConfig() {
    _instance ??= WechatConfig._internal();
    return _instance!;
  }

  WechatConfig._internal() : _fluwx = Fluwx();

  initConfig() {
    _fluwx.registerApi(
      appId: "wxb1290b1691a16593",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://jiyun-demo.yunliantiao.com/app/",
    );
  }

  openMiniProgram(String thumbnail, String linkPath) {
    _fluwx.isWeChatInstalled.then((installed) {
      if (installed) {
        _fluwx.share(
          WeChatShareMiniProgramModel(
            webPageUrl: linkPath,
            userName: 'gh_14bbb18ac55c',
            thumbnail: WeChatImage.network(thumbnail),
          ),
        );
      } else {
        EasyLoading.showToast('请先安装微信'.ts);
      }
    });
  }
}
