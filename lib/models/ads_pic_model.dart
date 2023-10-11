/*
  广告图
 */
class BannerModel {
  late int id;
  late int linkType;
  late String fullPath;
  late String linkPath;
  late String pictureName;
  late String picturePath;
  late int position;
  late int source;
  late int type;
  late int companyId;

  BannerModel(
      {required this.id,
      required this.linkType,
      required this.fullPath,
      required this.linkPath,
      required this.pictureName,
      required this.picturePath,
      required this.position,
      required this.source,
      required this.type,
      required this.companyId});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    linkType = json['link_type'] ?? 0;
    fullPath = json['full_path'] ?? '';
    linkPath = json['link_path'] ?? '';
    pictureName = json['picture_name'] ?? '';
    picturePath = json['picture_path'] ?? '';
    position = json['position'] ?? 0;
    source = json['source'] ?? 0;
    type = json['type'] ?? 0;
    companyId = json['company_id'] ?? 0;
  }
}
