import 'package:jiyun_app_client/models/insurance_item_model.dart';

/*
  附加费用
 */
class InsuranceModel {
  late int enabled;
  late List<InsuranceItemModel> items;
  late String explanation;
  late List<int> enabledLineIds;

  InsuranceModel();

  InsuranceModel.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    if (json['data'] != null) {
      items = <InsuranceItemModel>[];
      json['data'].forEach((v) {
        items.add(InsuranceItemModel.fromJson(v));
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
