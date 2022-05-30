/*
  广告图集合
  各类广告图
 */
class BannersModel {
  int? id;
  String? appId;
  String? token;
  String? aesKey;
  int? isOversea;
  String? videoEntranceImage;
  String? commentEntranceImage;
  String? forecastImage;
  String? freightImage;
  int? displayShareInfo;
  String? trackImage;
  String? supportImage;
  String? userCenterImage;
  String? agentApproveImage;
  String? licenseImage;
  String? shareImage;
  String? indexImage;
  String? videoImage;
  String? commentImage;
  int? companyId;
  String? createdAt;
  String? updatedAt;
  String? appcodeImage;
  String? warehouseImage;
  String? groupBuyingImage;
  String? backupImg1;
  String? backupImg2;
  String? backupImg3;
  String? backupImg4;
  String? serverUrl;

  BannersModel();

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['app_id'];
    token = json['token'];
    aesKey = json['aes_key'];
    isOversea = json['is_oversea'];
    videoEntranceImage = json['video_entrance_image'];
    commentEntranceImage = json['comment_entrance_image'];
    forecastImage = json['forecast_image'];
    freightImage = json['freight_image'];
    displayShareInfo = json['display_share_info'];
    trackImage = json['track_image'];
    supportImage = json['support_image'];
    userCenterImage = json['user_center_image'];
    agentApproveImage = json['agent_approve_image'];
    licenseImage = json['license_image'];
    shareImage = json['share_image'];
    indexImage = json['index_image'];
    videoImage = json['video_image'];
    commentImage = json['comment_image'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appcodeImage = json['appcode_image'];
    warehouseImage = json['warehouse_image'];
    groupBuyingImage = json['group_buying_image'];
    backupImg1 = json['backup_img1'];
    backupImg2 = json['backup_img2'];
    backupImg3 = json['backup_img3'];
    backupImg4 = json['backup_img4'];
    serverUrl = json['server_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_id'] = appId;
    data['token'] = token;
    data['aes_key'] = aesKey;
    data['is_oversea'] = isOversea;
    data['video_entrance_image'] = videoEntranceImage;
    data['comment_entrance_image'] = commentEntranceImage;
    data['forecast_image'] = forecastImage;
    data['freight_image'] = freightImage;
    data['display_share_info'] = displayShareInfo;
    data['track_image'] = trackImage;
    data['support_image'] = supportImage;
    data['user_center_image'] = userCenterImage;
    data['agent_approve_image'] = agentApproveImage;
    data['license_image'] = licenseImage;
    data['share_image'] = shareImage;
    data['index_image'] = indexImage;
    data['video_image'] = videoImage;
    data['comment_image'] = commentImage;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['appcode_image'] = appcodeImage;
    data['warehouse_image'] = warehouseImage;
    data['group_buying_image'] = groupBuyingImage;
    data['backup_img1'] = backupImg1;
    data['backup_img2'] = backupImg2;
    data['backup_img3'] = backupImg3;
    data['backup_img4'] = backupImg4;
    data['server_url'] = serverUrl;
    return data;
  }
}
