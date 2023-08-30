class CategoryModel {
  late int id;
  late String name;
  String? image;
  int? parentId;
  int? enabled;

  CategoryModel(
      {required this.id,
      required this.name,
      this.image,
      this.parentId,
      this.enabled});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    parentId = json['parent_id'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['parent_id'] = parentId;
    data['enabled'] = enabled;
    return data;
  }
}
