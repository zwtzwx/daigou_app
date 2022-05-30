import 'package:jiyun_app_client/models/tariff_item_model.dart';

/*
  附加费用
 */
class TariffModel {
  late int enabled;
  late List<TariffItemModel> items;
  late String explanation;
  late List<int> enabledLineIds;

  TariffModel();

  TariffModel.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    if (json['data'] != null) {
      items = <TariffItemModel>[];
      json['data'].forEach((v) {
        items.add(TariffItemModel.fromJson(v));
      });
    }
    explanation = json['explanation'];
    enabledLineIds = json['enabled_line_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    if (data['items'] != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    data['explanation'] = explanation;
    data['enabled_line_ids'] = enabledLineIds;
    return data;
  }
}
