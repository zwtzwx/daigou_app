// 文章
//定义枚举类型
enum ArticleType { commonQuestion, contrabandGoods, orderTerms, aboutUs }

extension ArticleTypeExtension on ArticleType {
  int get id {
    switch (this) {
      case ArticleType.commonQuestion:
        return 1;
      case ArticleType.contrabandGoods:
        return 2;
      case ArticleType.orderTerms:
        return 3;
      case ArticleType.aboutUs:
        return 5;
      default:
        return 4;
    }
  }
}

class ArticleModel {
  late int id;
  late String cover;
  late String title;
  late int type;
  late String content;
  late String coverFullPath;
  int? index;
  int? adminId;
  String? createdAt;
  String? updatedAt;
  int? companyId;

  ArticleModel();

  ArticleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    type = json['type'];
    content = json['content'];
    index = json['index'];
    adminId = json['admin_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    coverFullPath = json['cover_full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cover'] = cover;
    data['title'] = title;
    data['type'] = type;
    data['content'] = content;
    data['index'] = index;
    data['admin_id'] = adminId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['cover_full_path'] = coverFullPath;
    return data;
  }
}
