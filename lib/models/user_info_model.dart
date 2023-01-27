import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class UserInfoModel {
  final token = ''.obs;
  final userInfo = Rxn<UserModel?>();

  UserInfoModel() {
    token.value = UserStorage.getToken();
    userInfo.value = UserStorage.getUserInfo();
  }

  saveInfo(String t, UserModel u) {
    token.value = t;
    userInfo.value = u;
  }

  setUserInfo(UserModel u) {
    userInfo.value = u;
  }

  clear() {
    token.value = '';
    userInfo.value = null;
    UserStorage.clearToken();
  }
}
