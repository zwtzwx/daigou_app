class NoticeModel {
  late num id;
  late int type;
  late int read;
  String? title;
  String? content;
  String? value;
  String? createdAt;

  NoticeModel.fromJson(Map json) {
    id = json['id'];
    type = json['type'];
    read = json['read'];
    title = json['title'];
    content = json['content'];
    if (json['data'] != null && json['data'] is Map) {
      value = json['data']['value'];
    }
    createdAt = json['created_at'];
  }
}
