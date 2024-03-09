import 'package:shop_app_client/models/user_model.dart';

/*
  登录TOKEN
 */
class TokenModel {
  late String accessToken;
  late String tokenType;
  late num expiresIn;
  late UserModel? user;
  late num isAgent;
  late String? unionid;
  int? isNewUser;

  TokenModel(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      required this.user,
      required this.isAgent,
      required this.unionid});

  TokenModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = (json['user'] != null ? UserModel.fromJson(json['user']) : null)!;
    isAgent = json['is_agent'] ?? 0;
    unionid = json['unionid'];
    isNewUser = json['is_new_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['is_agent'] = isAgent;
    data['unionid'] = unionid;
    return data;
  }
}
