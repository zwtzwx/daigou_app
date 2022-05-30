/*
  代理用户
  基础信息
 */

import 'package:jiyun_app_client/models/agent_commissions_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';

class AgentModel {
  late int id;
  late int agentId;
  late String agentName;
  late String contactName;
  late String contactPhone;
  late String contactEmail;
  late String wechatId;
  late int commission;
  late String remark;
  late String qrCode;
  late int shouldNotify;
  late String qrCodeUrl;
  late String promoteUrl;
  late int enabled;
  late int mode;
  late int type;
  late int templateId;
  late int companyId;
  late String createdAt;
  late String updatedAt;
  late int isBind;
  late String fullname;
  late String idcard;
  late String bankCode;
  late String bankName;
  late String bankNumber;
  late String phone;
  late String email;
  late String address;
  late String faceImg;
  late String backImg;
  List<UserModel>? agentUsers;
  List<AgentCommissionsModel>? commissions;

  AgentModel(
      {required this.id,
      required this.agentId,
      required this.agentName,
      required this.contactName,
      required this.contactPhone,
      required this.contactEmail,
      required this.wechatId,
      required this.commission,
      required this.remark,
      required this.qrCode,
      required this.shouldNotify,
      required this.qrCodeUrl,
      required this.promoteUrl,
      required this.enabled,
      required this.mode,
      required this.type,
      required this.templateId,
      required this.companyId,
      required this.createdAt,
      required this.updatedAt,
      required this.isBind,
      required this.fullname,
      required this.idcard,
      required this.bankCode,
      required this.bankName,
      required this.bankNumber,
      required this.phone,
      required this.email,
      required this.address,
      required this.faceImg,
      required this.backImg,
      required this.agentUsers,
      required this.commissions});

  AgentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    agentName = json['agent_name'];
    contactName = json['contact_name'];
    contactPhone = json['contact_phone'];
    contactEmail = json['contact_email'];
    wechatId = json['wechat_id'];
    commission = json['commission'];
    remark = json['remark'];
    qrCode = json['qr_code'];
    shouldNotify = json['should_notify'];
    qrCodeUrl = json['qr_code_url'];
    promoteUrl = json['promote_url'];
    enabled = json['enabled'];
    mode = json['mode'];
    type = json['type'];
    templateId = json['template_id'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isBind = json['is_bind'];
    fullname = json['fullname'];
    idcard = json['idcard'];
    bankCode = json['bank_code'];
    bankName = json['bank_name'];
    bankNumber = json['bank_number'];
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    address = json['address'] ?? '';
    faceImg = json['face_img'];
    backImg = json['back_img'];
    if (json['agent_users'] != null) {
      agentUsers = <UserModel>[];
      json['agent_users'].forEach((v) {
        agentUsers!.add(UserModel.fromJson(v));
      });
    }
    if (json['commissions'] != null) {
      commissions = <AgentCommissionsModel>[];
      json['commissions'].forEach((v) {
        commissions!.add(AgentCommissionsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['agent_id'] = agentId;
    data['agent_name'] = agentName;
    data['contact_name'] = contactName;
    data['contact_phone'] = contactPhone;
    data['contact_email'] = contactEmail;
    data['wechat_id'] = wechatId;
    data['commission'] = commission;
    data['remark'] = remark;
    data['qr_code'] = qrCode;
    data['should_notify'] = shouldNotify;
    data['qr_code_url'] = qrCodeUrl;
    data['promote_url'] = promoteUrl;
    data['enabled'] = enabled;
    data['mode'] = mode;
    data['type'] = type;
    data['template_id'] = templateId;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_bind'] = isBind;
    data['fullname'] = fullname;
    data['idcard'] = idcard;
    data['bank_code'] = bankCode;
    data['bank_name'] = bankName;
    data['bank_number'] = bankNumber;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['face_img'] = faceImg;
    data['back_img'] = backImg;
    data['agent_users'] = agentUsers!.map((v) => v.toJson()).toList();
    data['commissions'] = commissions!.map((v) => v.toJson()).toList();
    return data;
  }
}
