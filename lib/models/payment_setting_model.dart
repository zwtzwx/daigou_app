/*
 * 支付设置
 * 主要用于线下收款
 */
class PaymentSettingModel {
  late int id;
  late int paymentSettingsId;
  late String name;
  late String content;

  PaymentSettingModel({
    required this.id,
    required this.paymentSettingsId,
    required this.name,
    required this.content,
  });

  PaymentSettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentSettingsId = json['payment_settings_id'];
    name = json['name'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_settings_id'] = paymentSettingsId;
    data['name'] = name;
    data['content'] = content;
    return data;
  }
}
