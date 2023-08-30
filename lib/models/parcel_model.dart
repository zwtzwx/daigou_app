import 'package:jiyun_app_client/models/additional_model.dart';
import 'package:jiyun_app_client/models/concat_info_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/parcel_goods_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';

//定义枚举类型
enum ParcelStatus { forecast, inWarehouse }

extension ParcelStatusExtension on ParcelStatus {
  int get id {
    switch (this) {
      case ParcelStatus.forecast:
        return 1;
      case ParcelStatus.inWarehouse:
        return 2;
      default:
        return 3;
    }
  }
}

/*
  预报包裹表
 */
class ParcelModel {
  int? id;
  String? expressNum;
  String? packageName;
  num? packageValue;
  String? senderAddress;
  String? exceptionalRemark;
  num? hasInsurance;
  num? propId;
  num? orderId;
  num? status;
  num? subStatus;
  num? userId;
  num? packageVolumeWeight;
  num? packageWeight;
  num? length;
  num? width;
  num? height;
  String? location;
  num? locationSuffix;
  List<String>? itemPictures;
  List<String>? packagePictures;
  String? remark;
  num? operatorId;
  String? inStorageRemark;
  int? notConfirmed;
  String? inStorageAt;
  String? receivedAt;
  String? weighedAt;
  String? createdAt;
  String? updatedAt;
  num? companyId;
  num? expressId;
  num? countryId;
  num? warehouseId;
  num? categoryId;
  int? qty;
  String? operateLogs;
  String? invalidAt;
  ContactModel? contactInfo;
  num? expressLineId;
  num? paymentId;
  num? mode;
  num? paymentMode;
  List<String>? addedService;
  num? batchId;
  AdditionalModel? additionalInfo;
  num? groupBuyingId;
  num? number;
  num? isWarning;
  var code;
  num? shipMode;
  num? channelId;
  num? ignoreClaim;
  num? countWeight;
  String? expressName;
  String? brandName;
  List<ParcelPropsModel>? prop;
  Map? order;
  List<Map>? chosenService;
  List<GoodsCategoryModel>? categories;
  WareHouseModel? warehouse;
  Map? express;
  CountryModel? country;
  bool? select;
  String? categoriesStr;
  int? isExceptional;
  List<ParcelGoodsModel>? details;
  int? freeTime;

  ParcelModel(
      {this.isExceptional,
      this.exceptionalRemark,
      this.id,
      this.expressNum,
      this.packageName,
      this.packageValue,
      this.senderAddress,
      this.hasInsurance,
      this.propId,
      this.orderId,
      this.status,
      this.subStatus,
      this.userId,
      this.packageVolumeWeight,
      this.packageWeight,
      this.length,
      this.width,
      this.height,
      this.location,
      this.locationSuffix,
      this.itemPictures,
      this.packagePictures,
      this.remark,
      this.operatorId,
      this.inStorageRemark,
      this.notConfirmed,
      this.inStorageAt,
      this.receivedAt,
      this.weighedAt,
      this.createdAt,
      this.updatedAt,
      this.companyId,
      this.expressId,
      this.countryId,
      this.warehouseId,
      this.categoryId,
      this.qty = 1,
      this.operateLogs,
      this.invalidAt,
      this.contactInfo,
      this.expressLineId,
      this.paymentId,
      this.mode,
      this.paymentMode,
      this.addedService,
      this.batchId,
      this.additionalInfo,
      this.groupBuyingId,
      this.number,
      this.isWarning,
      this.code,
      this.shipMode,
      this.channelId,
      this.ignoreClaim,
      this.countWeight,
      this.expressName,
      this.brandName,
      this.prop,
      this.order,
      this.chosenService,
      this.categories,
      this.warehouse,
      this.express,
      this.country,
      this.categoriesStr = '',
      this.details,
      this.select = false});

  ParcelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expressNum = json['express_num'];
    packageName = json['package_name'];
    packageValue = json['package_value'];
    senderAddress = json['sender_address'];
    hasInsurance = json['has_insurance'];
    propId = json['prop_id'];
    orderId = json['order_id'];
    status = json['status'];
    subStatus = json['sub_status'];
    userId = json['user_id'];
    packageVolumeWeight = json['package_volume_weight'];
    packageWeight = json['package_weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    location = json['location'];
    locationSuffix = json['location_suffix'];
    if (json['item_pictures'] != null) {
      itemPictures = List<String>.empty(growable: true);
      json['item_pictures'].forEach((v) {
        itemPictures!.add(v);
      });
    }
    if (json['package_pictures'] != null) {
      packagePictures = List<String>.empty(growable: true);
      json['package_pictures'].forEach((v) {
        packagePictures!.add(v);
      });
    }
    remark = json['remark'];
    operatorId = json['operator_id'];
    inStorageRemark = json['in_storage_remark'];
    notConfirmed = json['not_confirmed'];
    inStorageAt = json['in_storage_at'];
    receivedAt = json['received_at'];
    weighedAt = json['weighed_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    expressId = json['express_id'];
    countryId = json['country_id'];
    warehouseId = json['warehouse_id'];
    categoryId = json['category_id'];
    isExceptional = json['is_exceptional'];
    exceptionalRemark = json['exceptional_remark'];
    qty = json['qty'];
    operateLogs = json['operate_logs'];
    invalidAt = json['invalid_at'];
    contactInfo = json['contact_info'] != null
        ? ContactModel.fromJson(json['contact_info'])
        : null;
    expressLineId = json['express_line_id'];
    paymentId = json['payment_id'];
    mode = json['mode'];
    paymentMode = json['payment_mode'];
    if (json['added_service'] != null) {
      addedService = List<String>.empty(growable: true);
      json['added_service'].forEach((v) {
        addedService!.add(v);
      });
    }
    batchId = json['batch_id'];

    if (json['additional_info'] != null) {
      additionalInfo = AdditionalModel.fromJson(json['additional_info']);
    }

    groupBuyingId = json['group_buying_id'];
    number = json['number'];
    isWarning = json['is_warning'];
    code = json['code'];
    shipMode = json['ship_mode'];
    channelId = json['channel_id'];
    ignoreClaim = json['ignore_claim'];
    countWeight = json['count_weight'];
    expressName = json['express_name'];
    brandName = json['brand_name'];
    if (json['prop'] != null) {
      prop = List<ParcelPropsModel>.empty(growable: true);
      json['prop'].forEach((v) {
        prop!.add(ParcelPropsModel.fromJson(v));
      });
    }
    order = json['order'];
    if (json['chosen_service'] != null) {
      chosenService = List<Map>.empty(growable: true);
      json['chosen_service'].forEach((v) {
        chosenService!.add(v);
      });
    }
    if (json['categories'] != null) {
      categories = List<GoodsCategoryModel>.empty(growable: true);
      json['categories'].forEach((v) {
        categories!.add(GoodsCategoryModel.fromJson(v));
      });
    }

    if (json['warehouse'] != null) {
      warehouse = WareHouseModel.fromJson(json['warehouse']);
    }

    express = json['express'];

    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country']);
    }
    if (json['details'] != null && json['details'].isNotEmpty) {
      details = List.empty(growable: true);
      for (var item in json['details']) {
        details!.add(ParcelGoodsModel.fromJson(item));
      }
    }
    if (status == 2 &&
        (warehouse?.freeStoreDays ?? 0) > 0 &&
        (weighedAt != null || inStorageAt != null)) {
      getFreeDay();
    }
    select = false;
  }

  /*
    用于同步信息包裹列表
   */
  ParcelModel.fromSimpleJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    expressNum = json['express_num'];
  }

  // 仓储时间
  void getFreeDay() {
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    var packTime = (weighedAt ?? inStorageAt)!.split(' ').join('T');
    var storage = DateTime.parse(packTime).millisecondsSinceEpoch +
        (warehouse!.freeStoreDays! * 24 * 60 * 60 * 1000);
    var diff = (storage - nowTime) / (24 * 60 * 60 * 1000);
    if (diff > 0) {
      freeTime = diff.floor();
    } else {
      freeTime = diff.ceil();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['express_num'] = expressNum;
    data['package_name'] = packageName;
    data['package_value'] = packageValue;
    data['sender_address'] = senderAddress;
    data['has_insurance'] = hasInsurance;
    data['prop_id'] = propId;
    data['order_id'] = orderId;
    data['status'] = status;
    data['sub_status'] = subStatus;
    data['user_id'] = userId;
    data['package_volume_weight'] = packageVolumeWeight;
    data['package_weight'] = packageWeight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['location'] = location;
    data['location_suffix'] = locationSuffix;
    if (itemPictures != null) {
      data['item_pictures'] = itemPictures!.map((v) => v).toList();
    }
    if (packagePictures != null) {
      data['package_pictures'] = packagePictures!.map((v) => v).toList();
    }
    data['remark'] = remark;
    data['operator_id'] = operatorId;
    data['in_storage_remark'] = inStorageRemark;
    data['not_confirmed'] = notConfirmed;
    data['in_storage_at'] = inStorageAt;
    data['received_at'] = receivedAt;
    data['weighed_at'] = weighedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['express_id'] = expressId;
    data['country_id'] = countryId;
    data['warehouse_id'] = warehouseId;
    data['category_id'] = categoryId;
    data['qty'] = qty;
    data['operate_logs'] = operateLogs;
    data['invalid_at'] = invalidAt;
    if (contactInfo != null) {
      data['contact_info'] = contactInfo!.toJson();
    }
    data['express_line_id'] = expressLineId;
    data['payment_id'] = paymentId;
    data['mode'] = mode;
    data['payment_mode'] = paymentMode;
    if (addedService != null) {
      data['added_service'] = addedService!.map((v) => v).toList();
    }
    data['batch_id'] = batchId;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.toJson();
    }
    data['group_buying_id'] = groupBuyingId;
    data['number'] = number;
    data['is_warning'] = isWarning;
    data['code'] = code;
    data['ship_mode'] = shipMode;
    data['channel_id'] = channelId;
    data['ignore_claim'] = ignoreClaim;
    data['count_weight'] = countWeight;
    data['express_name'] = expressName;
    data['brand_name'] = brandName;
    data['is_exceptional'] = isExceptional;
    data['exceptional_remark'] = exceptionalRemark;
    if (prop != null) {
      data['prop'] = prop!.map((v) => v.toJson()).toList();
    }
    data['order'] = order;
    if (chosenService != null) {
      data['chosen_service'] = chosenService!.map((v) => v).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (warehouse != null) {
      data['warehouse'] = warehouse!.toJson();
    }
    data['express'] = express;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}
