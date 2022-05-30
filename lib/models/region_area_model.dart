class RegionAreaModel {
  late int id;
  late int countryId;
  late String countryName;
  num? areaId;
  String? areaName;
  num? subAreaId;
  String? subAreaName;

  RegionAreaModel(
      {required this.id,
      required this.countryId,
      required this.countryName,
      this.areaId,
      this.areaName,
      this.subAreaId,
      this.subAreaName});

  RegionAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    countryName = json['country'];
    areaId = json['area_id'];
    areaName = json['area'];
    subAreaId = json['sub_area_id'];
    subAreaName = json['sub_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['country'] = countryName;
    data['area_id'] = areaId;
    data['area'] = areaName;
    data['sub_area_id'] = subAreaId;
    data['sub_area'] = subAreaName;
    return data;
  }
}
