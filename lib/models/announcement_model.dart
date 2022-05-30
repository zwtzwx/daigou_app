/*
  通知文章类
 */
class AnnouncementModel {
  late int id;
  late String title;
  late String content;
  late List<String> attachments;
  late String operator;
  late int enabled;
  late int type;
  late int index;
  late int companyId;
  late String createdAt;
  late String updatedAt;
  late String uniqueId;

  AnnouncementModel(
      {required this.id,
      required this.title,
      required this.content,
      required this.attachments,
      required this.operator,
      required this.enabled,
      required this.type,
      required this.index,
      required this.companyId,
      required this.createdAt,
      required this.updatedAt,
      required this.uniqueId});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    attachments = json['attachments'].cast<String>();
    operator = json['operator'];
    enabled = json['enabled'];
    type = json['type'];
    index = json['index'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['attachments'] = attachments;
    data['operator'] = operator;
    data['enabled'] = enabled;
    data['type'] = type;
    data['index'] = index;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['unique_id'] = uniqueId;
    return data;
  }
}
