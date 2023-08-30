class ConsultModel {
  int? id;
  int? problemOrderId;
  String? orderSn;
  int? orderId;
  int? type;
  String? content;
  late List<ConsultContentModel> contents;
  String? createdAt;

  ConsultModel({
    this.problemOrderId,
    this.orderSn,
    this.content,
    this.orderId,
    required this.contents,
  });

  ConsultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    problemOrderId = json['problem_order_id'];
    orderSn = json['order_sn'];
    orderId = json['order_id'];
    type = json['type'];
    content = json['content'];
    createdAt = json['created_at'];
    contents = [];

    if (json['contents'] is List) {
      for (var ele in json['contents']) {
        contents.add(ConsultContentModel.fromJson(ele));
      }
    }
  }
}

class ConsultContentModel {
  int? id;
  String? nickName;
  String? content;
  late bool isRight;
  int? status;
  late String createdAt;

  ConsultContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nickName'];
    isRight = json['is_right'] == 1;
    status = json['status'];
    content = json['content'];
    createdAt = json['created_at'];
  }
}
