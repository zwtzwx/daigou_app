/*
  发货单
 */
class ShipmentModel {
  late int id;
  late String name;
  late String sn;
  late String sourceStation;
  late int destinationCountryId;
  late int status;
  late int boxCount;
  late int weight;
  late int volume;
  late int value;
  late String props;
  late String remark;
  late String createdAt;
  late String updatedAt;
  late int companyId;
  late int warehouseId;
  late String shippedAt;
  late String logisticsSn;
  late String logisticsCompany;

  ShipmentModel(
      {required this.id,
      required this.name,
      required this.sn,
      required this.sourceStation,
      required this.destinationCountryId,
      required this.status,
      required this.boxCount,
      required this.weight,
      required this.volume,
      required this.value,
      required this.props,
      required this.remark,
      required this.createdAt,
      required this.updatedAt,
      required this.companyId,
      required this.warehouseId,
      required this.shippedAt,
      required this.logisticsSn,
      required this.logisticsCompany});

  ShipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sn = json['sn'];
    sourceStation = json['source_station'];
    destinationCountryId = json['destination_country_id'];
    status = json['status'];
    boxCount = json['box_count'];
    weight = json['weight'];
    volume = json['volume'];
    value = json['value'];
    props = json['props'];
    remark = json['remark'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    warehouseId = json['warehouse_id'];
    shippedAt = json['shipped_at'];
    logisticsSn = json['logistics_sn'];
    logisticsCompany = json['logistics_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sn'] = sn;
    data['source_station'] = sourceStation;
    data['destination_country_id'] = destinationCountryId;
    data['status'] = status;
    data['box_count'] = boxCount;
    data['weight'] = weight;
    data['volume'] = volume;
    data['value'] = value;
    data['props'] = props;
    data['remark'] = remark;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['warehouse_id'] = warehouseId;
    data['shipped_at'] = shippedAt;
    data['logistics_sn'] = logisticsSn;
    data['logistics_company'] = logisticsCompany;
    return data;
  }
}
