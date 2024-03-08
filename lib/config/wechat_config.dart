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

  onCustomer() {
    _fluwx.isWeChatInstalled.then((installed) {
      if (installed) {
        _fluwx.open(
          target: CustomerServiceChat(
            corpId: 'ww956f22ae6465bb51',
            url: 'https://work.weixin.qq.com/kfid/kfc6427e510860ac433',
          ),
        );
      } else {
        EasyLoading.showToast('请先安装微信'.ts);
      }
    });
  }

  onPay(Map appconfig) async {
    _fluwx.isWeChatInstalled.then((installed) {
      if (installed) {
        _fluwx.pay(
          which: Payment(
            appId: appconfig['appid'].toString(),
            partnerId: appconfig['partnerid'].toString(),
            prepayId: appconfig['prepayid'].toString(),
            packageValue: appconfig['package'].toString(),
            nonceStr: appconfig['noncestr'].toString(),
            timestamp: appconfig['timestamp'],
            sign: appconfig['sign'].toString(),
          ),
        );
      } else {
        EasyLoading.showToast('请先安装微信'.ts);
      }
    });
  }

  // 监听支付
  onAddListener(Function(WeChatResponse) listener) {
    _fluwx.addSubscriber(listener);
  }

  // 移除监听
  onRemoveListener(Function(WeChatResponse) listener) {
    _fluwx.removeSubscriber(listener);
  }
}
