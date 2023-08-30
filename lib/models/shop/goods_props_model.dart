class GoodsPropsModel {
  String? id;
  String? name;
  bool noStock = false;
  List<GoodsPropsModel>? children;

  GoodsPropsModel({
    this.id,
    this.name,
    this.noStock = false,
    this.children,
  });

  GoodsPropsModel.fromChild({
    this.id,
    this.name,
    this.noStock = false,
  });

  GoodsPropsModel.fromJson(Map<String, dynamic> json, List<String> sotckSKus) {
    id = json['id'];
    name = json['name'];
    if (json['children'] != null) {
      children = [];
      for (var ele in json['children']) {
        var noStock = !sotckSKus.any((sku) => sku.contains('$id:${ele['id']}'));
        children!.add(GoodsPropsModel.fromChild(
          id: ele['id'],
          name: ele['name'],
          noStock: noStock,
        ));
      }
    }
  }
}
