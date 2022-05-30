/*
  当前货币
 */
class CurrentCurrencyModel {
  late String name;
  late String code;

  CurrentCurrencyModel({required this.name, required this.code});

  CurrentCurrencyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}
