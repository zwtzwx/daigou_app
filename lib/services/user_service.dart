// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/common/http_response.dart';
import 'package:jiyun_app_client/exceptions/login_error_exception.dart';
import 'package:jiyun_app_client/models/token_model.dart';
import 'package:jiyun_app_client/models/user_agent_status_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/base_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class UserService {
  // 登录
  static const String LOGIN = 'website-user/pwd-login';
  // 注册
  static const String registerApi = 'website-user/register';
  // google、facebook 第三方登录
  static const String LoginWithFirebase = 'firebase/login';
  // 微信登录
  static const String LoginWithWeChat = 'oauth-login/app';
  // 微信登陆switch
  static const String WeChatSwitch = 'third-part-login/status';
  // 验证码登录
  static const String VeritfyCodeLOGIN = 'website-user/verify-login';
  // 获取验证码
  static const String GETVERIFYCODE = 'user/verify-code';
  // 我要分享数据
  static const String USERSHAREINFO = 'user/share-info';
  // 获取个人信息数量 余额优惠券数量等数据
  static const String INDEX = 'index';
  // 获取会员中心基础数据
  static const String UserMemberInfo = 'user-member/member-info';
  // 代理状态
  static const String AgentStatus = 'agent/status';

  // 我的详细信息
  static const String userProfileApi = 'user/me';

  // 更新个人信息
  static const String userEditProfileApi = 'user/profile';

  // 更新个人资料
  static const String userEditApi = 'user/information';

  // 更新用户头像昵称
  static const String userEditNameAndAvaterApi = 'user/wechat-user-info';

  // 更改手机号
  static const String changePhoneApi = 'user/change-phone';
  // 更改手机号
  static const String changeEmailApi = 'user/change-email';

  // 绑定邮箱号
  static const String bindEmailApi = 'user/bind-email';
  // 重置密码然后登录
  static const String resetPaswordApi = 'website-user/reset-password';
  // 第三方登录开启状态
  static const String thirdLoginStatusApi = 'app-third-login-status';
  // 注销用户
  static const String deletionApi = 'user/cancel';

  // 修改密码
  static const String passwordApi = 'website-user/set-pwd';

  // 微信登陆switch
  static Future<Map> isShowWechat() async {
    Map? result;
    await HttpClient()
        .get(WeChatSwitch)
        .then((response) => {result = response.data}, onError: (ret, msg) {
      result = {
        "msg": msg,
      };
    });
    return result!;
  }

  // 登录的处理
  static TokenModel _loginResult(HttpResponse response) {
    if (response.ok) {
      var responseList = response.data;
      TokenModel tokenModel = TokenModel.fromJson(responseList);

      var token = tokenModel.tokenType + ' ' + tokenModel.accessToken;
      //存入storage 方便下次启动读取
      UserStorage.setToken(token);
      UserStorage.setUserInfo(tokenModel.user!);

      return tokenModel;
    } else {
      throw LoginErrorException(response.error!.message);
    }
  }

  // 注册
  static Future<Map> register(Map<String, dynamic> params) async {
    Map res = {'ok': false, 'msg': ''};
    await HttpClient()
        .post(UserService.registerApi, queryParameters: params)
        .then((response) {
      res = {
        'ok': response.ok,
        'msg': response.msg ?? response.error?.message ?? ''
      };
    });

    return res;
  }

  // 账号密码登录
  static Future<TokenModel?> login(Map<String, dynamic> params) async {
    TokenModel? token;
    await HttpClient()
        .post(UserService.LOGIN, queryParameters: params)
        .then((response) {
      token = _loginResult(response);
    });

    return token;
  }

  // google、facebook 第三方登录
  static Future<TokenModel?> loginWithFirebase(
      Map<String, dynamic> params) async {
    TokenModel? token;
    await HttpClient()
        .post(UserService.LoginWithFirebase, queryParameters: params)
        .then((response) {
      token = _loginResult(response);
    });

    return token;
  }

  // 获列表
  static Future<TokenModel?> loginWithWechat(
      Map<String, dynamic> params) async {
    params = {
      'code': params['code'],
    };
    TokenModel? token;
    await HttpClient()
        .post(LoginWithWeChat, queryParameters: params)
        .then((response) {
      token = _loginResult(response);
    });
    return token;
  }

  static Future<TokenModel?> loginBy(Map<String, dynamic> params) async {
    TokenModel? token;
    await HttpClient()
        .post(VeritfyCodeLOGIN, queryParameters: params)
        .then((response) {
      token = _loginResult(response);
    });
    return token;
  }

  /*
    获取验证码
    1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
   */
  static Future getVerifyCode(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient()
        .post(GETVERIFYCODE, queryParameters: params)
        .then((response) {
      if (response.ok) {
        return onSuccess(response);
      }
      // response.
      return onFail(response.error!.message);
    });
  }

  static Future getShareInfo(
      Map<String, dynamic>? params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient()
        .get(USERSHAREINFO, queryParameters: params)
        .then((response) => {
              // String jsonStr = convert.jsonEncode(response.data);
              if (response.ok)
                {onSuccess(response)}
              else
                onFail(response.error!.message)
            });
  }

  /*
     订单包裹统计
     含多少预报 ， 入库， 支付
   */
  static Future<UserOrderCountModel?> getOrderDataCount(
      [Map<String, dynamic>? params]) async {
    UserOrderCountModel? model;
    await HttpClient().get(INDEX, queryParameters: params).then((response) {
      model = UserOrderCountModel.fromJson(response.data);
    }).onError((error, stackTrace) {});
    return model;
  }

  /*
   *  会员数据统计
   *  积分，成长值，等级 
   */
  static Future<UserVipModel?> getVipMemberData(
      [Map<String, dynamic>? params]) async {
    UserVipModel? model;
    await HttpClient()
        .get(UserMemberInfo, queryParameters: params)
        .then((response) {
      model = UserVipModel.fromJson(response.data);
    }).onError((error, stackTrace) {});
    return model;
  }

  /*
    获取代理状态
    需要实时调取
    0= 身份: 未申请
    1= 身份：代理
    2= 身份：审核中
    3= 代理：代理身份禁用
   */
  static Future<UserAgentStatusModel?> getAgentStatus(
      [Map<String, dynamic>? params]) async {
    UserAgentStatusModel? result;
    await HttpClient()
        .get(AgentStatus, queryParameters: params)
        .then((response) {
      result = UserAgentStatusModel.fromId(response.data);
    }).onError((error, stackTrace) {});
    return result;
  }

  /*
    获取基础信息
   */
  static Future<UserModel?> getProfile() async {
    UserModel? result;

    await HttpClient().get(userProfileApi).then((response) {
      result = UserModel.fromJson(response.data);
    });
    return result;
  }

  /*
    更新个人信息
   */
  static Future<Map> updateByModel(Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};

    await HttpClient()
        .put(userEditApi, queryParameters: params)
        .then((response) {
      result = {
        'ok': response.ok,
        'data': UserModel.fromJson(response.data),
        'msg': response.msg ?? response.error?.message,
      };
    });

    return result;
  }

  /*
    更新个人信息 
    昵称 头像
   */
  static Future<bool> updateByMap(Map<String, dynamic> params) async {
    bool result = false;

    await HttpClient()
        .put(userEditNameAndAvaterApi, queryParameters: params)
        .then((response) {
      result = response.ok;
    });

    return result;
  }

  /*
    更改手机号
   */
  static Future<void> changePhone(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient().post(changePhoneApi, data: params).then((response) {
      if (response.ok) {
        onSuccess(response.msg);
      } else {
        onFail(response.error!.message);
      }
    });
  }

  /*
    更改手机号
   */
  static Future<void> changeEmail(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient().post(changeEmailApi, data: params).then((response) {
      if (response.ok) {
        onSuccess(response.msg);
      } else {
        onFail(response.error!.message);
      }
    });
  }

  /*
    绑定邮编
   */
  static Future<void> bindEmail(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient().post(bindEmailApi, data: params).then((response) {
      if (response.ok) {
        onSuccess(response.msg);
      } else {
        onFail(response.error!.message);
      }
    });
  }

  /*
    重置密码然后登录
   */
  static Future<TokenModel?> resetPaswordAndLogin(
      Map<String, dynamic> params) async {
    TokenModel? token;
    await HttpClient().put(resetPaswordApi, data: params).then((response) {
      token = _loginResult(response);
    });
    return token;
  }

  /*
    获取第三方登录开启状态
   */
  static Future<bool> getThirdLoginStatus() async {
    bool result = false;
    await HttpClient().get(thirdLoginStatusApi).then((res) {
      if (res.ok && res.data['status'] == 1) {
        result = true;
      }
    });
    return result;
  }

  /*
    用户注销
   */
  static Future<Map> userDeletion() async {
    Map result = {'ok': false, 'msg': ''};
    await HttpClient().put(deletionApi).then((res) {
      result = {
        'ok': res.ok,
        'msg': res.msg ?? res.error!.message,
      };
    });
    return result;
  }

  /*
    修改密码
   */
  static Future<Map> onChangePassword(Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};
    await HttpClient().post(passwordApi, queryParameters: params).then((res) {
      result = {
        'ok': res.ok,
        'msg': res.msg ?? res.error!.message,
        // 'data':
      };
    });
    return result;
  }
}
