import 'package:get/state_manager.dart';
import 'package:shop_app_client/models/currency_rate_model.dart';
import 'package:shop_app_client/models/language_model.dart';
import 'package:shop_app_client/models/localization_model.dart';
import 'package:shop_app_client/models/user_model.dart';
import 'package:shop_app_client/models/user_order_count_model.dart';
import 'package:shop_app_client/services/common_service.dart';
import 'package:shop_app_client/services/language_service.dart';
import 'package:shop_app_client/services/localization_service.dart';
import 'package:shop_app_client/services/shop_service.dart';
import 'package:shop_app_client/services/user_service.dart';
import 'package:shop_app_client/storage/language_storage.dart';
import 'package:shop_app_client/storage/user_storage.dart';

class AppStore {
  final token = ''.obs;
  final userInfo = Rxn<UserModel?>();
  final accountInfo = Rxn<Map?>();
  final currencyModel = Rxn<CurrencyRateModel?>();
  final rateList = <CurrencyRateModel>[].obs;
  final _localModel = Rxn<LocalizationModel?>();
  final amountInfo = Rxn<UserOrderCountModel?>();
  final langList = <LanguageModel>[].obs;
  int shopPlatformType = 1;
  final cartCount = 0.obs;
  final hasNotRead = false.obs;

  LocalizationModel? get localModel => _localModel.value;

  AppStore() {
    token.value = CommonStorage.getToken();
    userInfo.value = CommonStorage.getUserInfo();
    accountInfo.value = CommonStorage.getAccountInfo();
    refreshToken();
    initCurrency();
    getLanguages();
  }

  saveInfo(String t, UserModel u) {
    token.value = t;
    userInfo.value = u;
    getBaseCountInfo();
    getCartCount();
  }

  setShopPlatformType(int value) {
    shopPlatformType = value;
  }

  setUserInfo(UserModel u) {
    userInfo.value = u;
  }

  saveAccount(Map data) {
    accountInfo.value = data;
    CommonStorage.setAccountInfo(data);
  }

  clearAccount() {
    accountInfo.value = null;
    CommonStorage.clearnAccountInfo();
  }

  clear() {
    token.value = '';
    userInfo.value = null;
    amountInfo.value = null;
    cartCount.value = 0;
    CommonStorage.clearToken();
  }

  // 判断是否有未读消息
  saveRead(bool read) {
    if (token.value.isNotEmpty) {
      hasNotRead.value = read;
      // print('保存的hasNotRead');
      // print(hasNotRead.value);
    }
  }

  refreshToken() async {
    if (token.value.isNotEmpty) {
      var res = await CommonService.refreshToken();
      if (res != null) {
        CommonStorage.setToken(res);
        token.value = res;
        getBaseCountInfo();
        getCartCount();
      }
    }
  }

  initCurrency() async {
    var currency = await LocaleStorage.getCurrency();
    rateList.value = await CommonService.getRateList();
    var data = await LocalizationService.getInfo();
    _localModel.value = data;
    if (currencyModel.value == null) {
      // 默认美金
      var _data = CurrencyRateModel(
        code: currency?['code'] ?? 'USD',
        symbol: currency?['symbol'] ?? '\$',
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

  // 获取语言列表
  getLanguages() async {
    var data = await LanguageService.getLanguage();
    langList.value = data;
  }

  // 包裹、订单数量、余额
  getBaseCountInfo() async {
    if (token.value.isEmpty) return;
    amountInfo.value = await UserService.getOrderDataCount();
  }

  // 购物车商品数量
  void getCartCount() async {
    var token = CommonStorage.getToken();
    if (token.isNotEmpty) {
      var data = await ShopService.getCartCount();
      cartCount.value = data ?? 0;
    } else {
      cartCount.value = 0;
    }
  }
}
