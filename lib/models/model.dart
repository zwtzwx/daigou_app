import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/localization_service.dart';
import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  Model(this._token, this._userInfo, this._environment);

  String _token; // 用户token的值来区分是否登录(null?token)

  UserModel? _userInfo;

  LocalizationModel? _localizationInfo;

  String _environment;

  String get token => _token;

  UserModel? get userInfo => _userInfo;

  LocalizationModel? get localizationInfo => _localizationInfo;

  String get environment => _environment;

  /*
    设置Token信息
   */
  void setToken(token) {
    _token = token;
    notifyListeners();
  }

  /*
    设置用户信息
   */
  void setUserInfo(UserModel userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  /*
    加载尺寸单位之类的信息
   */
  Future<void> loadLocalization() async {
    _localizationInfo = await LocalizationService.getInfo();
  }

  /*
    设置请求环境
   */
  void setEnvironment(String data) {
    _environment = data;
    notifyListeners();
  }

  void loginOut() {
    _userInfo = null;
    _token = '';
  }
}
