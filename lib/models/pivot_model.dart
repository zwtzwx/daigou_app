class PivotModel {
  late int warehouseId;
  late int countryId;

  PivotModel({required this.warehouseId, required this.countryId});

  PivotModel.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouse_id'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warehouse_id'] = warehouseId;
    data['country_id'] = countryId;
    return data;
  }
}
