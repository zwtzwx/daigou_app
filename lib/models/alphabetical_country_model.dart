import 'package:jiyun_app_client/models/country_model.dart';

class AlphabeticalCountryModel {
  late String letter;
  late List<CountryModel> items;

  AlphabeticalCountryModel();

  AlphabeticalCountryModel.fromJson(Map<String, dynamic> json) {
    letter = json["key"];
    if (json['items'] != null) {
      items = <CountryModel>[];
      json['items'].forEach((v) {
        items.add(CountryModel.fromJson(v));
      });
    }
  }
}
