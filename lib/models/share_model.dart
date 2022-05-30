/*
  分享
 */
class ShareModel {
  late int display;
  late String shareInfo;
  late ShareInfoModel? info;
  late String avatar;
  late String name;
  late String qrCode;
  late String shareImg;

  ShareModel(
      {required this.display,
      required this.shareInfo,
      required this.info,
      required this.avatar,
      required this.name,
      required this.qrCode,
      required this.shareImg});

  ShareModel.fromJson(Map<String, dynamic> json) {
    display = json['display'];
    shareInfo = json['share_info'];
    info =
        (json['info'] != null ? ShareInfoModel.fromJson(json['info']) : null)!;
    avatar = json['avatar'];
    name = json['name'];
    qrCode = json['qr_code'];
    shareImg = json['share_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    data['share_info'] = shareInfo;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    data['avatar'] = avatar;
    data['name'] = name;
    data['qr_code'] = qrCode;
    data['share_img'] = shareImg;
    return data;
  }
}

class ShareInfoModel {
  late int id;
  late int displayUserAvatar;
  late int displayUserName;
  late int displayShareInfo;
  late String shareInfo;
  late int avatarSize;
  late List<String> backgroundImages;
  late int companyId;
  late String createdAt;
  late String updatedAt;
  late String shareImage;

  ShareInfoModel(
      {required this.id,
      required this.displayUserAvatar,
      required this.displayUserName,
      required this.displayShareInfo,
      required this.shareInfo,
      required this.avatarSize,
      required this.backgroundImages,
      required this.companyId,
      required this.createdAt,
      required this.updatedAt,
      required this.shareImage});

  ShareInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayUserAvatar = json['display_user_avatar'];
    displayUserName = json['display_user_name'];
    displayShareInfo = json['display_share_info'];
    shareInfo = json['share_info'];
    avatarSize = json['avatar_size'];
    backgroundImages = json['background_images'].cast<String>();
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shareImage = json['share_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_user_avatar'] = displayUserAvatar;
    data['display_user_name'] = displayUserName;
    data['display_share_info'] = displayShareInfo;
    data['share_info'] = shareInfo;
    data['avatar_size'] = avatarSize;
    data['background_images'] = backgroundImages;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['share_image'] = shareImage;
    return data;
  }
}
