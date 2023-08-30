class GoodsSpecModel {
  late String name;
  List<String>? specs;
  String? value;

  GoodsSpecModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['specs'] != null) {
      specs = (json['specs'] as List).cast<String>();
    }
    if (json['value'] is String) {
      value = json['value'];
    }
  }
}
