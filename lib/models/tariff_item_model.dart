class TariffItemModel {
  late int id;
  late int enabled;
  late int? threshold;
  late int type;
  late int amount;
  late int enforce;
  late String remark;
  late String createdAt;

  TariffItemModel();

  TariffItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enabled = json['enabled'];
    threshold = json['threshold'];
    type = json['type'];
    amount = json['amount'];
    enforce = json['enforce'];
    remark = json['remark'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['enabled'] = enabled;
    data['threshold'] = threshold;
    data['type'] = type;
    data['amount'] = amount;
    data['enforce'] = enforce;
    data['remark'] = remark;
    data['created_at'] = createdAt;
    return data;
  }
}
