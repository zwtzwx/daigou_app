import 'package:get/instance_manager.dart';
import 'package:huanting_shop/models/user_info_model.dart';

extension RateConvert on num {
  String rate({
    bool showPriceSymbol = true,
    bool needFormat = true,
    bool showInt = false,
  }) {
    var currency = Get.find<AppStore>().currencyModel;
    var localizationInfo = Get.find<AppStore>().localModel;
    var rate = currency.value?.rate ?? 1;
    var currencySymbol =
        currency.value?.code ?? localizationInfo?.currency ?? '';
    num value = (this * rate / (needFormat ? 100 : 1));
    var len = showInt && value.ceil() == value ? 0 : 2;
    return (showPriceSymbol ? currencySymbol : '') + value.toStringAsFixed(len);
  }

  num get originPrice {
    var currency = Get.find<AppStore>().currencyModel;
    var rate = currency.value?.rate ?? 1;
    return this / rate;
  }
}
