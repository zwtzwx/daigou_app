import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';

class GroupPreviewOrderModel {
  GroupModel? group;
  List<ParcelModel>? packages;

  GroupPreviewOrderModel({
    this.group,
    this.packages,
  });

  GroupPreviewOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['group'] != null) {
      group = GroupModel.fromJson(json['group']);
    }
    if (json['packages'] != null) {
      packages = List.empty(growable: true);
      json['packages'].forEach((v) {
        packages!.add(ParcelModel.fromJson(v));
      });
    }
  }
}
