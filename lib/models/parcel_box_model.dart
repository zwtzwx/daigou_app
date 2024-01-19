import 'package:huanting_shop/models/parcel_model.dart';

/*
 * 包裹箱
 */
class ParcelBoxModel {
  late num id;
  late num orderId;
  late String logisticsSn;
  num? weight;
  num? length;
  num? width;
  num? height;
  num? volumeWeight;
  String? createdAt;
  String? updatedAt;
  num? companyId;
  List<ParcelModel>? packages;

  ParcelBoxModel(
      {required this.id,
      required this.orderId,
      required this.logisticsSn,
      required this.weight,
      required this.length,
      required this.width,
      required this.height,
      required this.volumeWeight,
      required this.createdAt,
      required this.updatedAt,
      required this.companyId,
      this.packages});

  ParcelBoxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    logisticsSn = json['logistics_sn'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    volumeWeight = json['volume_weight'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    if (json['packages'] != null) {
      packages = <ParcelModel>[];
      json['packages'].forEach((v) {
        packages!.add(ParcelModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['logistics_sn'] = logisticsSn;
    data['weight'] = weight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['volume_weight'] = volumeWeight;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
