class AdditionalModel {
  late String brandName;

  AdditionalModel({required this.brandName});

  AdditionalModel.fromJson(Map<String, dynamic> json) {
    brandName = json['brand_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand_name'] = brandName;
    return data;
  }
}
