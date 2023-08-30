import 'package:jiyun_app_client/models/profile_model.dart';

/*
  用户基本资料
 */
class UserModel {
  late dynamic id;
  late String uid;
  late String? openId;
  late num userGroupId;
  late String? sessionToken;
  late String name;
  String? remarkName;
  String? email;
  late String avatar;
  late bool forbidLogin;
  late String lastLoginAt;
  late num notify;
  late String createdAt;
  late String updatedAt;
  late num companyId;
  late num isAgentInvite;
  late String? unionid;
  late String? phone;
  late num source;
  late String shareInfo;
  late String inviteType;
  String? timezone;
  ProfileModel? profile;
  late String registerIp;
  late String lastLoginIp;
  late String liveCity;
  late String wechatId;
  String? birth;
  int? gender;
  int? orderCount;
  int? profit;

  UserModel(
      {required this.id,
      required this.uid,
      required this.openId,
      required this.userGroupId,
      required this.sessionToken,
      required this.name,
      required this.remarkName,
      this.email,
      required this.avatar,
      required this.forbidLogin,
      // required this.emailVerifiedAt,
      required this.lastLoginAt,
      required this.notify,
      required this.createdAt,
      required this.updatedAt,
      required this.companyId,
      // required this.inviteId,
      required this.isAgentInvite,
      required this.unionid,
      // required this.oaOpenId,
      required this.phone,
      required this.source,
      required this.shareInfo,
      required this.inviteType,
      required this.timezone,
      this.profile,
      required this.registerIp,
      required this.lastLoginIp,
      this.liveCity = '',
      this.wechatId = '',
      this.gender,
      this.birth = ''});

  UserModel.empty();
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    openId = json['open_id'];
    userGroupId = json['user_group_id'];
    sessionToken = json['session_token'];
    name = json['name'];
    remarkName = json['remark_name'];
    email = json['email'] ?? "";
    avatar = json['avatar'] ?? '';
    forbidLogin = json['forbid_login'] ?? false;
    // emailVerifiedAt = json['email_verified_at'];
    lastLoginAt = json['last_login_at'] ?? '';
    notify = json['notify'] ?? 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    // inviteId = json['invite_id'];
    isAgentInvite = json['is_agent_invite'] ?? 0;
    unionid = json['unionid'];
    // oaOpenId = json['oa_open_id'];
    phone = json['phone'];
    source = json['source'] ?? 0;
    shareInfo = json['share_info'] ?? '';
    inviteType = json['invite_type'] ?? '1';
    timezone = json['timezone'];
    if (json['profile'] != null) {
      profile = ProfileModel.fromJson(json['profile']);
    }
    registerIp = json['register_ip'] ?? '';
    lastLoginIp = json['last_login_ip'] ?? '';
    liveCity = json['live_city'] ?? "";
    wechatId = json['wechat_id'] ?? "";
    birth = json['birth'] ?? "";
    if (json['gender'] != null) {
      gender = int.parse(json['gender'].toString());
    }
    orderCount = json['order_count'];
    profit = json['profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['open_id'] = openId;
    data['user_group_id'] = userGroupId;
    data['session_token'] = sessionToken;
    data['name'] = name;
    data['remark_name'] = remarkName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['forbid_login'] = forbidLogin;
    // data['email_verified_at'] = emailVerifiedAt;
    data['last_login_at'] = lastLoginAt;
    data['notify'] = notify;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    // data['invite_id'] = inviteId;
    data['is_agent_invite'] = isAgentInvite;
    data['unionid'] = unionid;
    // data['oa_open_id'] = oaOpenId;
    data['phone'] = phone;
    data['source'] = source;
    data['share_info'] = shareInfo;
    data['invite_type'] = inviteType;
    data['timezone'] = timezone;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['register_ip'] = registerIp;
    data['last_login_ip'] = lastLoginIp;
    data['live_city'] = liveCity;
    data['wechat_id'] = wechatId;
    data['birth'] = birth;
    data['gender'] = gender;
    return data;
  }
}
