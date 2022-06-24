/*
  渠道标签
 */
class ShipLineLabelModel {
  late int id;
  late String name;
  late String labelName;

  ShipLineLabelModel({
    required this.id,
    required this.name,
    required this.labelName,
  });

  ShipLineLabelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    labelName = json['label_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['label_name'] = labelName;
    return data;
  }
}
