/*
  线路图标
 */
class LineIconModel {
  late num id;
  late String icon;
  late String name;

  LineIconModel({required this.id, required this.icon, required this.name});

  LineIconModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['name'] = name;
    return data;
  }
}
