class AppVersionModel {
  late int id;
  late String version;
  String? content;
  late String fileName;
  late String filePath;

  AppVersionModel.fromJson(Map json) {
    id = json['id'];
    version = json['version'];
    content = json['content'];
    fileName = json['file_name'];
    filePath = json['file_path'];
  }
}
