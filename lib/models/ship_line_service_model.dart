class ShipLineServiceModel {
  late num id;
  late String name;
  late int isForced;
  late num type;
  late num value;
  late String remark;
  late bool isOpen;
  late num price;

  ShipLineServiceModel(
      {required this.id,
      required this.name,
      required this.isForced,
      required this.type,
      required this.value,
      required this.remark,
      required this.price,
      required this.isOpen});

  ShipLineServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isForced = json['is_forced'] ?? 0;
    type = json['type'];
    value = json['value'] ?? 0;
    remark = json['remark'];
    price = json['price'] ?? 0;
    isOpen = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_forced'] = isForced;
    data['type'] = type;
    data['value'] = value;
    data['remark'] = remark;
    data['price'] = price;
    return data;
  }
}
