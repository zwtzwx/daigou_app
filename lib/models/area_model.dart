class AreaModel {
  late int id;
  late String name;
  int? countryId;
  int? parentId;
  String? code;
  String? postcode;
  int? enabled;
  List<AreaModel>? areas;

  AreaModel(
      {required this.id,
      required this.name,
      this.countryId,
      this.parentId,
      this.code,
      this.postcode,
      this.enabled,
      this.areas});

  AreaModel.empty() {
    id = 0;
    name = '';
  }

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
    parentId = json['parent_id'];
    code = json['code'];
    postcode = json['postcode'];
    enabled = json['enabled'];
    if (json['areas'] != null) {
      areas = List<AreaModel>.empty(growable: true);
      json['areas'].forEach((v) {
        areas!.add(AreaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['code'] = code;
    data['postcode'] = postcode;
    data['enabled'] = enabled;
    if (areas != null) {
      data['areas'] = areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
