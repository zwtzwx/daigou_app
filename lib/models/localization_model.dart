/*
  基本信息
  重量、尺寸、货币、长度单位
 */
class LocalizationModel {
  late String weightName;
  late String weightSymbol;
  late String currencyName;
  late String currencySymbol;
  late String lengthName;
  late String lengthSymbol;
  late int packageExpressLine;
  late String currency;

  LocalizationModel(
      {required this.weightName,
      required this.weightSymbol,
      required this.currencyName,
      required this.currencySymbol,
      required this.lengthName,
      required this.lengthSymbol,
      required this.packageExpressLine,
      required this.currency});

  LocalizationModel.fromJson(Map<String, dynamic> json) {
    weightName = json['weight_name'];
    weightSymbol = json['weight_symbol'];
    currencyName = json['currency_name'];
    currencySymbol = json['currency_symbol'];
    lengthName = json['length_name'];
    lengthSymbol = json['length_symbol'];
    packageExpressLine = json['package_express_line'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weight_name'] = weightName;
    data['weight_symbol'] = weightSymbol;
    data['currency_name'] = currencyName;
    data['currency_symbol'] = currencySymbol;
    data['length_name'] = lengthName;
    data['length_symbol'] = lengthSymbol;
    data['package_express_line'] = packageExpressLine;
    data['currency'] = currency;
    return data;
  }
}
