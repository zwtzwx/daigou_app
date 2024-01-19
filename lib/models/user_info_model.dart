import 'package:get/state_manager.dart';
import 'package:huanting_shop/models/ads_pic_model.dart';
import 'package:huanting_shop/models/currency_rate_model.dart';
import 'package:huanting_shop/models/localization_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/models/user_order_count_model.dart';
import 'package:huanting_shop/models/user_vip_model.dart';
import 'package:huanting_shop/services/ads_service.dart';
import 'package:huanting_shop/services/common_service.dart';
import 'package:huanting_shop/services/localization_service.dart';
import 'package:huanting_shop/services/user_service.dart';
import 'package:huanting_shop/storage/language_storage.dart';
import 'package:huanting_shop/storage/user_storage.dart';

class AppStore {
  final token = ''.obs;
  final userInfo = Rxn<UserModel?>();
  final accountInfo = Rxn<Map?>();
  final currencyModel = Rxn<CurrencyRateModel?>();
  final rateList = <CurrencyRateModel>[].obs;
  final _localModel = Rxn<LocalizationModel?>();
  final amountInfo = Rxn<UserOrderCountModel?>();
  final vipInfo = Rxn<UserVipModel?>();
  final adList = <BannerModel>[].obs;
  int shopPlatformType = 1;

  LocalizationModel? get localModel => _localModel.value;

  AppStore() {
    token.value = UserStorage.getToken();
    userInfo.value = UserStorage.getUserInfo();
    accountInfo.value = UserStorage.getAccountInfo();
    refreshToken();
    initCurrency();
    getAds();
  }

  saveInfo(String t, UserModel u) {
    token.value = t;
    userInfo.value = u;
    getBaseCountInfo();
  }

  setShopPlatformType(int value) {
    shopPlatformType = value;
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
    vipInfo.value = null;
    amountInfo.value = null;
    UserStorage.clearToken();
  }

  refreshToken() async {
    if (token.value.isNotEmpty) {
      var res = await CommonService.refreshToken();
      if (res != null) {
        UserStorage.setToken(res);
        token.value = res;
        getBaseCountInfo();
      }
    }
  }

  initCurrency() async {
    var currency = await LanguageStore.getCurrency();
    rateList.value = await CommonService.getRateList();
    var data = await LocalizationService.getInfo();
    _localModel.value = data;
    if (currencyModel.value == null) {
      // 默认哈萨克斯坦货币
      var _data = CurrencyRateModel(
        code: currency?['code'] ?? 'KZT',
        symbol: currency?['symbol'] ?? '〒',
      );
      if (_data.code != data?.currency) {
        // 获取对应的汇率
        var index = rateList.indexWhere((e) => e.code == _data.code);
        if (index != -1) {
          _data.rate = rateList[index].rate;
        }
      }
      currencyModel.value = _data;
    }
  }

  setCurrency(CurrencyRateModel data) async {
    currencyModel.value = data;
  }

  // 获取余额、优惠券、积分
  getBaseCountInfo() async {
    amountInfo.value = await UserService.getOrderDataCount();
    vipInfo.value = await UserService.getVipMemberData();
  }

  // 获取横幅、活动图
  getAds() async {
    adList.value = await AdsService.getList({"source": 4});
  }
}
