import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class UserInfoModel {
  final token = ''.obs;
  final userInfo = Rxn<UserModel?>();
  final accountInfo = Rxn<Map?>();

  UserInfoModel() {
    token.value = UserStorage.getToken();
    userInfo.value = UserStorage.getUserInfo();
    accountInfo.value = UserStorage.getAccountInfo();
    refreshToken();
  }

  saveInfo(String t, UserModel u) {
    token.value = t;
    userInfo.value = u;
  }

  setUserInfo(UserModel u) {
    userInfo.value = u;
  }

  saveAccount(Map data) {
    accountInfo.value = data;
    UserStorage.setAccountInfo(data);
  }

  clearAccount() {
    accountInfo.value = null;
    UserStorage.clearnAccountInfo();
  }

  clear() {
    token.value = '';
    userInfo.value = null;
    UserStorage.clearToken();
  }

  refreshToken() async {
    if (token.value.isNotEmpty) {
      var res = await CommonService.refreshToken();
      if (res != null) {
        UserStorage.setToken(res);
        token.value = res;
      }
    }
  }
}
