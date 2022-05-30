/*
  支付方式
 */
import 'package:jiyun_app_client/models/current_currency_model.dart';
import 'package:jiyun_app_client/models/payment_setting_model.dart';

class PayTypeModel {
  late int id;
  late String name;
  late String qrCode;
  late String remark;
  late int enabled;
  late String account;
  late int showRate;
  late String currency;
  late num rate;
  late int rateType;
  late CurrentCurrencyModel? currentCurrency;
  late String fullPath;
  late String currencySymbol;
  late String createdAt;
  late List<PaymentSettingModel> paymentSettingConnection;
  bool select = false;

  PayTypeModel(
      {required this.id,
      required this.name,
      required this.qrCode,
      required this.remark,
      required this.enabled,
      required this.account,
      required this.showRate,
      required this.currency,
      required this.rate,
      required this.rateType,
      this.currentCurrency,
      required this.fullPath,
      required this.currencySymbol,
      required this.createdAt,
      required this.paymentSettingConnection,
      this.select = false});

  PayTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    qrCode = json['qr_code'];
    remark = json['remark'];
    enabled = json['enabled'];
    account = json['account'];
    showRate = json['show_rate'];
    currency = json['currency'];
    rate = num.parse(json['rate']);
    rateType = json['rate_type'];

    if (json['payment_setting_connection'] != null) {
      currentCurrency = CurrentCurrencyModel.fromJson(json['current_currency']);
    }
    fullPath = json['full_path'];
    currencySymbol = json['currency_symbol'] ?? "";
    createdAt = json['created_at'];
    if (json['payment_setting_connection'] != null) {
      paymentSettingConnection = <PaymentSettingModel>[];
      json['payment_setting_connection'].forEach((v) {
        paymentSettingConnection.add(PaymentSettingModel.fromJson(v));
      });
    }
    select = false;
  }

  PayTypeModel.empty() {
    id = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['qr_code'] = qrCode;
    data['remark'] = remark;
    data['enabled'] = enabled;
    data['account'] = account;
    data['show_rate'] = showRate;
    data['currency'] = currency;
    data['rate'] = rate;
    data['rate_type'] = rateType;
    data['current_currency'] = currentCurrency?.toJson();
    data['full_path'] = fullPath;
    data['currency_symbol'] = currencySymbol;
    data['created_at'] = createdAt;
    data['payment_setting_connection'] =
        paymentSettingConnection.map((v) => v.toJson()).toList();
    return data;
  }
}
