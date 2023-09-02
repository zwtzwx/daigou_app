import 'package:jiyun_app_client/models/coordinate_model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/region_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';

class GroupModel {
  String? country;
  String? countryString;
  String? createdAt;
  int? endUntil;
  int? id;
  List<String>? images;
  List<String>? membersAvatar;
  int? membersCount;
  String? name;
  num? packageVolumeWeight;
  num? packageWeight;
  String? postcode;
  String? remark;
  int? status;
  int? warehouseId;
  String? warehouseName;
  ShipLineModel? expressLine;
  ReceiverAddressModel? address;
  bool? isDismissible;
  bool? isExitable;
  bool? isGroupLeader;
  bool? isJoined;
  bool? isSubmitted;
  String? orderSn;
  SelfPickupStationModel? station;
  RegionModel? region;
  List<GroupMemberModel>? members;
  int? packagesCount;
  int? membersSubmittedCount;
  String? code;
  String? endTime;
  GroupMemberModel? leader;
  CoordinateModel? coordinate;
  OrderModel? order;
  bool canSubmit = false;

  GroupModel(
      {this.country,
      this.countryString,
      this.createdAt,
      this.endUntil,
      this.id,
      this.images,
      this.membersAvatar,
      this.membersCount,
      this.name,
      this.packageVolumeWeight,
      this.packageWeight,
      this.postcode,
      this.remark,
      this.status,
      this.warehouseId,
      this.expressLine,
      this.warehouseName});

  GroupModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    countryString = json['country_string'];
    createdAt = json['created_at'];
    endUntil = json['end_until'];
    id = json['id'];
    packagesCount = json['packages_count'];
    membersCount = json['members_count'];
    name = json['name'];
    packageVolumeWeight = json['package_volume_weight'];
    packageWeight = json['package_weight'];
    postcode = json['postcode'];
    if (json['remark'] is String) {
      remark = json['remark'];
    }
    status = json['status'];
    endTime = json['end_time'];
    warehouseId = json['warehouse_id'];
    warehouseName = json['warehouse_name'];
    isDismissible = json['is_dismissible'];
    isExitable = json['is_exitable'];
    isGroupLeader = json['is_group_leader'];
    isJoined = json['is_joined'];
    isSubmitted = json['is_submitted'] == 1;
    orderSn = json['order_sn'];
    membersSubmittedCount = json['members_submitted_count'];
    code = json['code'];
    if (json['members_avatar'] != null) {
      membersAvatar = json['members_avatar'].cast<String>();
    }
    if (json['images'] != null) {
      images = json['images'].cast<String>();
    }
    if (json['express_line'] != null) {
      expressLine = ShipLineModel.fromJson(json['express_line']);
    }
    if (json['address'] != null) {
      address = ReceiverAddressModel.fromJson(json['address']);
    }
    if (json['station'] != null) {
      station = SelfPickupStationModel.fromJson(json['station']);
    }
    if (json['region'] != null) {
      region = RegionModel.fromJson(json['region']);
    }
    if (json['members'] != null) {
      members = List.empty(growable: true);
      json['members'].forEach((v) {
        members!.add(GroupMemberModel.fromJson(v));
      });
    }
    if (json['leader'] != null) {
      leader = GroupMemberModel.fromJson(json['leader']);
    }
    if (json['lng'] != null && json['lng'].isNotEmpty) {
      coordinate = CoordinateModel(
        latitude: double.parse(json['lat']),
        longitude: double.parse(json['lng']),
      );
    }
    if (json['order'] != null) {
      order = OrderModel.fromJson(json['order']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['country_string'] = countryString;
    data['created_at'] = createdAt;
    data['end_until'] = endUntil;
    data['id'] = id;
    if (images != null) {
      data['images'] = images;
    }
    data['members_avatar'] = membersAvatar;
    data['members_count'] = membersCount;
    data['name'] = name;
    data['package_volume_weight'] = packageVolumeWeight;
    data['package_weight'] = packageWeight;
    data['postcode'] = postcode;
    data['remark'] = remark;
    data['status'] = status;
    data['warehouse_id'] = warehouseId;
    data['warehouse_name'] = warehouseName;
    return data;
  }
}

class GroupMemberModel {
  String? avatar;
  int? id;
  int? isGroupLeader;
  int? isSubmitted;
  String? name;

  String? ordern;
  num? weight;
  num? volumeWeight;
  List<String>? packages;

  GroupMemberModel({
    this.avatar,
    this.id,
    this.isGroupLeader,
    this.isSubmitted,
    this.name,
  });

  GroupMemberModel.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    id = json['id'];
    name = json['name'];
    if (json['is_group_leader'] is bool) {
      isGroupLeader = json['is_group_leader'] ? 1 : 0;
    } else {
      isGroupLeader = json['is_group_leader'];
    }
    isSubmitted = json['is_submitted'];
    ordern = json['order_sn'];
    weight = json['weight'];
    volumeWeight = json['volume_weight'];
    if (json['packages'] != null) {
      packages = List.empty(growable: true);
      json['packages'].forEach((v) {
        packages!.add(v['express_num']);
      });
    }
  }
}
