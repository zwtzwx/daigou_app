import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/line_icon_model.dart';
import 'package:jiyun_app_client/models/price_grade_model.dart';
import 'package:jiyun_app_client/models/region_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_label_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';

/*
  线路渠道
 */
class ShipLineModel {
  late int id;
  late String name;
  // late String cnName;
  // late String enName;
  late num mode;
  late num isGreatValue;
  num? iconId;
  num? firstWeight;
  num? firstMoney;
  num? firstCostMoney;
  num? nextWeight;
  num? nextMoney;
  num? nextCostMoney;
  num? minWeight;
  num? maxWeight;
  String? referenceTime;
  int? enabled;
  late String remark;
  late String createdAt;
  // late String updatedAt;
  // late num companyId;
  late num factor;
  late num hasFactor;
  num? extraRemarkEnabled;
  String? extraRemarkName;
  String? extraRemarkInstruction;
  late int needClearanceCode;
  late String clearanceCodeRemark;
  late int needIdCard;
  late int isDelivery;
  // late num? defaultPickupStationId;
  late num shouldAutoDelivery;
  num? ceilWeight;
  num? weightRise;
  num? multiBoxes;
  num? multiBoxesCeil;
  num? needPersonalCode;
  num? isHidden;
  num? dockingType;
  num? expressCompanyId;
  num? isUnique;
  num? orderMode;
  num? multiBoxMinWeight;
  late num isAvgWeight;
  late num ruleFeeMode;
  late num maxRuleFee;
  num? groupId;
  late int baseMode;
  num? countWeight;
  num? countFirst;
  num? countNext;
  RegionModel? region;
  List<RegionModel>? regions;
  num? expireFee;
  LineIconModel? icon;
  List<ParcelPropsModel>? props;
  List<PriceGradeModel>? priceGrade;
  Map? defaultStation;
  List<SelfPickupStationModel>? selfPickupStations;
  List<WareHouseModel>? warehouses;
  List<ShipLineLabelModel>? labels;

  ShipLineModel(
      {required this.id,
      // required this.cnName,
      // required this.enName,
      required this.mode,
      required this.isGreatValue,
      required this.iconId,
      required this.firstWeight,
      required this.firstMoney,
      required this.firstCostMoney,
      required this.nextWeight,
      required this.nextMoney,
      required this.nextCostMoney,
      required this.minWeight,
      required this.maxWeight,
      required this.referenceTime,
      required this.enabled,
      required this.remark,
      required this.createdAt,
      // required this.updatedAt,
      // required this.companyId,
      required this.factor,
      required this.hasFactor,
      required this.extraRemarkEnabled,
      required this.extraRemarkName,
      required this.extraRemarkInstruction,
      required this.needClearanceCode,
      required this.clearanceCodeRemark,
      required this.needIdCard,
      required this.name,
      required this.isDelivery,
      // required this.defaultPickupStationId,
      required this.shouldAutoDelivery,
      required this.ceilWeight,
      required this.weightRise,
      required this.multiBoxes,
      required this.multiBoxesCeil,
      required this.needPersonalCode,
      required this.isHidden,
      required this.dockingType,
      required this.expressCompanyId,
      required this.isUnique,
      required this.orderMode,
      required this.multiBoxMinWeight,
      required this.isAvgWeight,
      required this.ruleFeeMode,
      required this.maxRuleFee,
      required this.groupId,
      required this.baseMode,
      this.countWeight,
      required this.countFirst,
      required this.countNext,
      required this.region,
      required this.expireFee,
      required this.icon,
      required this.props,
      this.regions,
      required this.defaultStation,
      required this.selfPickupStations,
      required this.warehouses});

  ShipLineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // cnName = json['cn_name'];
    // enName = json['en_name'];
    mode = json['mode'] ?? 0;
    isGreatValue = json['is_great_value'] ?? 0;
    iconId = json['icon_id'];
    firstWeight = json['first_weight'];
    firstMoney = json['first_money'];
    firstCostMoney = json['first_cost_money'];
    nextWeight = json['next_weight'];
    nextMoney = json['next_money'];
    nextCostMoney = json['next_cost_money'];
    minWeight = json['min_weight'];
    maxWeight = json['max_weight'];
    referenceTime = json['reference_time'];
    enabled = json['enabled'];
    remark = json['remark'] ?? '';
    createdAt = json['created_at'] ?? '';
    // updatedAt = json['updated_at'];
    // companyId = json['company_id'];
    factor = json['factor'] ?? 0;
    hasFactor = json['has_factor'] ?? 0;
    extraRemarkEnabled = json['extra_remark_enabled'];
    extraRemarkName = json['extra_remark_name'];
    extraRemarkInstruction = json['extra_remark_instruction'];
    needClearanceCode = json['need_clearance_code'] ?? 0;
    clearanceCodeRemark = json['clearance_code_remark'] ?? '';
    needIdCard = json['need_id_card'] ?? 0;
    name = json['name'];
    isDelivery = json['is_delivery'] ?? 0;
    // defaultPickupStationId = json['default_pickup_station_id'];
    shouldAutoDelivery = json['should_auto_delivery'] ?? 0;
    ceilWeight = json['ceil_weight'];
    weightRise = json['weight_rise'];
    multiBoxes = json['multi_boxes'];
    multiBoxesCeil = json['multi_boxes_ceil'];
    needPersonalCode = json['need_personal_code'];
    isHidden = json['is_hidden'];
    dockingType = json['docking_type'];
    expressCompanyId = json['express_company_id'];
    isUnique = json['is_unique'];
    orderMode = json['order_mode'];
    multiBoxMinWeight = json['multi_box_min_weight'];
    isAvgWeight = json['is_avg_weight'] ?? 0;
    ruleFeeMode = json['rule_fee_mode'] ?? 0;
    maxRuleFee = json['max_rule_fee'] ?? 0;
    groupId = json['group_id'];
    baseMode = json['base_mode'] ?? 0;
    countWeight = json['count_weight'];
    countFirst = json['count_first'];
    countNext = json['count_next'];
    region =
        (json['region'] != null ? RegionModel.fromJson(json['region']) : null);
    expireFee = json['expire_fee'];
    icon = (json['icon'] != null ? LineIconModel.fromJson(json['icon']) : null);
    if (json['props'] != null) {
      props = List<ParcelPropsModel>.empty(growable: true);
      json['props'].forEach((v) {
        props!.add(ParcelPropsModel.fromJson(v));
      });
    }
    defaultStation = json['default_station'];
    if (json['self_pickup_stations'] != null) {
      selfPickupStations = List<SelfPickupStationModel>.empty(growable: true);
      json['self_pickup_stations'].forEach((v) {
        selfPickupStations!.add(SelfPickupStationModel.fromJson(v));
      });
    }
    if (json['warehouses'] != null) {
      warehouses = List<WareHouseModel>.empty(growable: true);
      json['warehouses'].forEach((v) {
        warehouses!.add(WareHouseModel.fromJson(v));
      });
    }
    if (json['regions'] != null) {
      regions = List<RegionModel>.empty(growable: true);
      json['regions'].forEach((v) {
        regions!.add(RegionModel.fromJson(v));
      });
    }
    if (json['labels'] != null) {
      labels = List<ShipLineLabelModel>.empty(growable: true);
      json['labels'].forEach((v) {
        labels!.add(ShipLineLabelModel.fromJson(v));
      });
    }
  }

  String get propStr => (props ?? []).map((e) => e.name).join('、');

  String get basePrice {
    num price = 0;
    num basePrice = 0;
    if (region != null) {
      for (var item in region!.prices!) {
        if (item.type == 8) {
          basePrice = item.price;
        } else if ([0, 2, 3].contains(item.type)) {
          price = item.price;
        }
      }
      if (mode == 1 || mode == 3 || mode == 4 || (mode == 2 && price != 0)) {
        return (price / 100).toStringAsFixed(2);
      } else if (mode == 2) {
        return (basePrice / 100).toStringAsFixed(2);
      } else if (mode == 5) {
        price =
            region!.prices!.first.price.isNaN ? 0 : region!.prices!.first.price;
        return (price / 100).toStringAsFixed(2);
      }
    }
    return '0.00';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['cn_name'] = cnName;
    // data['en_name'] = enName;
    data['mode'] = mode;
    data['is_great_value'] = isGreatValue;
    data['icon_id'] = iconId;
    data['first_weight'] = firstWeight;
    data['first_money'] = firstMoney;
    data['first_cost_money'] = firstCostMoney;
    data['next_weight'] = nextWeight;
    data['next_money'] = nextMoney;
    data['next_cost_money'] = nextCostMoney;
    data['min_weight'] = minWeight;
    data['max_weight'] = maxWeight;
    data['reference_time'] = referenceTime;
    data['enabled'] = enabled;
    data['remark'] = remark;
    data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    // data['company_id'] = companyId;
    data['factor'] = factor;
    data['has_factor'] = hasFactor;
    data['extra_remark_enabled'] = extraRemarkEnabled;
    data['extra_remark_name'] = extraRemarkName;
    data['extra_remark_instruction'] = extraRemarkInstruction;
    data['need_clearance_code'] = needClearanceCode;
    data['clearance_code_remark'] = clearanceCodeRemark;
    data['need_id_card'] = needIdCard;
    data['name'] = name;
    data['is_delivery'] = isDelivery;
    // data['default_pickup_station_id'] = defaultPickupStationId;
    data['should_auto_delivery'] = shouldAutoDelivery;
    data['ceil_weight'] = ceilWeight;
    data['weight_rise'] = weightRise;
    data['multi_boxes'] = multiBoxes;
    data['multi_boxes_ceil'] = multiBoxesCeil;
    data['need_personal_code'] = needPersonalCode;
    data['is_hidden'] = isHidden;
    data['docking_type'] = dockingType;
    data['express_company_id'] = expressCompanyId;
    data['is_unique'] = isUnique;
    data['order_mode'] = orderMode;
    data['multi_box_min_weight'] = multiBoxMinWeight;
    data['is_avg_weight'] = isAvgWeight;
    data['rule_fee_mode'] = ruleFeeMode;
    data['max_rule_fee'] = maxRuleFee;
    data['group_id'] = groupId;
    data['base_mode'] = baseMode;
    data['count_weight'] = countWeight;
    data['count_first'] = countFirst;
    data['count_next'] = countNext;
    if (region != null) {
      data['region'] = region!.toJson();
    }
    data['expire_fee'] = expireFee;
    if (icon != null) {
      data['icon'] = icon!.toJson();
    }
    if (props != null) {
      data['props'] = props!.map((v) => v.toJson()).toList();
    }
    data['default_station'] = defaultStation;
    if (selfPickupStations != null) {
      data['self_pickup_stations'] =
          selfPickupStations!.map((v) => v.toJson()).toList();
    }
    if (warehouses != null) {
      data['warehouses'] = warehouses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
