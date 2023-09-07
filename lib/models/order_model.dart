/*
  订单
 */
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/order_transaction_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_order_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/ship_line_service_model.dart';
import 'package:jiyun_app_client/models/shipment_model.dart';
import 'package:jiyun_app_client/models/user_coupon_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/models/price_model.dart';

//定义枚举类型
enum OrderStatus {
  packIng,
  waitPay,
  readyShip,
  shipping,
  sign,
  checking,
  checkFailure,
  waitComment
}

extension OrderStatusExtension on OrderStatus {
  int get id {
    switch (this) {
      //打包中
      case OrderStatus.packIng:
        return 1;
      //待付款
      case OrderStatus.waitPay:
        return 2;
      //待发货
      case OrderStatus.readyShip:
        return 3;
      //已发货
      case OrderStatus.shipping:
        return 4;
      //已签收
      case OrderStatus.sign:
        return 5;
      //审核中
      case OrderStatus.checking:
        return 11;
      //审核失败
      case OrderStatus.checkFailure:
        return 12;
      //待评价
      case OrderStatus.waitComment:
        return 51;
      default:
        return 0;
    }
  }

  String get name {
    switch (this) {
      //打包中
      case OrderStatus.packIng:
        return "打包中";
      //待付款
      case OrderStatus.waitPay:
        return "待付款";
      //待发货
      case OrderStatus.readyShip:
        return "待发货";
      //已发货
      case OrderStatus.shipping:
        return "已发货";
      //已签收
      case OrderStatus.sign:
        return "已签收";
      //审核中
      case OrderStatus.checking:
        return "审核中";
      //审核失败
      case OrderStatus.checkFailure:
        return "审核失败";
      //待评价
      case OrderStatus.waitComment:
        return "待评价";
      default:
        return "-";
    }
  }
}

class OrderModel {
  /*
    订单iD
   */
  late int id;
  late num userId;
  /*
    订单号
   */
  late String orderSn;
  /*
    物流单号
   */
  late String logisticsSn;
  /*
    物流公司
   */
  late String? logisticsCompany;
  /*
    状态
   */
  late int status;
  /*
    货到付款状态 0 为不是货到付款或者未付款 1 为货到付款未付款 2 为货到付款已付款
   */
  late num onDeliveryStatus;
  /*
    订单评价字段  0  为未评价 1 为已评价
   */
  late num evaluated;
  /*
    选定的快递线路 id
   */
  late num expressLineId;
  /*
    打包装箱类型
   */
  num? regionId; // 渠道分区ID
  /*
    打包装箱类型
   */
  late num boxType;
  /*
    支付费用 以分为单位
   */
  late num paymentFee;
  /*
    运费首费金额
   */
  late num firstFreightFee;
  /*
    运费续费金额
   */
  late num nextFreightFee;
  /*
    订单纯运费金额
   */
  late num freightFee;
  /*
    保费,默认为 0
   */
  late num insuranceFee;
  /*
    关税费用
   */
  late num tariffFee;
  /*
    线路附加费用，无默认为0
   */
  late num lineAppendFee;
  /*
    优惠券抵用金额，无优惠券默认为0
   */
  late num couponDiscountFee;
  /*
    修改价格
   */
  late num modFee;
  /*
    实际支付费用
   */
  late num actualPaymentFee;
  /*
    增值服务
   */
  late List addService;
  /*
    订单价值
   */
  late num value;
  /*
    订单地址
   */
  late ReceiverAddressModel address;

  late int? shipmentId;
  /*
    实际重量
   */
  late num actualWeight;
  /*
    体积重
   */
  late num volumeWeight;
  /*
    支付重
   */
  late num paymentWeight;
  /*
    长
   */
  late num length;
  /*
    宽
   */
  late num width;
  /*
    高
   */
  late num height;
  /*
    
   */
  late String location;
  late String paymentTypeName;
  /*
    下单备注
   */
  late String remark;
  /*
    清关代码
   */
  late String clearanceCode;
  /*
    个人通关码
   */
  late String personalCode;
  /*
    ???
   */
  late String lineExtraRemark;
  /*
    创建时间
   */
  late String createdAt;
  /*
    更新时间
   */
  late String updatedAt;
  /*
    打包时间
   */
  String? packedAt;
  /*
    支付时间
   */
  String? paidAt;
  /*
    发货时间
   */
  String? shippedAt;
  /*
    签收时间
   */
  String? signedAt;
  late num companyId;
  /*
    仓库ID
   */
  num? warehouseId;
  /*
    退款金额
   */
  late num refundAmount;
  /*
    退款时间
   */
  late String invalidAt;
  /*
    操作日志
   */
  Map? operateLogs;
  /*
    身份证
   */
  late String idCard;
  /*
    自提点ID
   */
  num? stationId;
  /*
    支付方式
   */
  late num paymentMode;
  /*
    ???
   */
  int? groupBuyingId;
  /*
    父级订单ID
   */
  late num parentId;
  /*
    团购状态  0 待处理 1 已处理 2 已完成
   */
  int? groupBuyingStatus;
  /*
    取件状态
   */
  int? pickStatus;
  String? valueAddedAmount;
  late num lineServiceFee;
  late num lineRuleFee;
  /*
    用户备注
   */
  late String vipRemark;
  num? thriftFreightFee;
  num? volumeSum;
  num? factor;
  String? eurPayAmount;
  /*
    团购结束时间
   */
  int? groupEndUntil;
  /*
    团购模式 0 自付 1 团长付
   */
  late int groupMode;
  /*
    是否团长订单
   */
  late bool isLeaderOrder;
  late String expressName;
  /*
    优惠金额
   */
  late num discountPaymentFee;
  /*
    这是什么费用
   */
  late num allFreightFee;
  late List<ValueAddedServiceModel> valueAddedService;
  /*
    包裹列表
   */
  late List<ParcelModel> packages;
  /*
    仓库
   */
  late WareHouseModel warehouse;
  /*
    线路渠道
   */
  late ShipLineModel expressLine;
  /*
    打包照片
   */
  late List<Map<String, dynamic>> packPictures;
  /*
    入库照片
   */
  late List<Map<String, dynamic>> inWarehousePictures;
  String? inWarehouseItem;
  // List<ExpressLineCosts> expressLineCosts;

  /*
    包裹箱
   */
  late List<ParcelBoxModel> boxes;

  /*
    自提点
   */
  SelfPickupStationModel? station;

  /*
    自提点订单
   */
  SelfPickupStationOrderModel? stationOrder;
  /*
    订单交易流水
   */
  late List<OrderTransactionModel> transaction;
  /*
    发货单
   */
  late ShipmentModel shipment;
  /*
    优惠券
   */
  UserCouponModel? coupon;
  /*
    使用积分数量
   */
  late num point;
  /*
    是否使用积分
   */
  late int isusepoint;
  /*
    积分抵现金额
   */
  late num pointamount;
  late num userPoint;
  late int isInvoice;

  /*
    线路服务
   */
  late List<ShipLineServiceModel> lineServices;

  late PriceModel? price;

  late int exceptional;
  int? paymentStatus;
  GroupModel? groupBuying; // 拼团信息
  GroupMemberModel? user;
  num? exceptWeight;
  num? exceptVolumeWeight;
  int? boxesCount;

  OrderModel();

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    orderSn = json['order_sn'];
    logisticsSn = json['logistics_sn'] ?? '';
    logisticsCompany = json['logistics_company'];
    boxesCount = json['boxes_count'];
    status = json['status'];
    exceptWeight = json['except_weight'];
    exceptVolumeWeight = json['except_volume_weight'];
    onDeliveryStatus = json['on_delivery_status'] ?? 0;
    evaluated = json['evaluated'] ?? 0;
    expressLineId = json['express_line_id'] ?? 0;
    regionId = json['region_id'];
    boxType = json['box_type'] ?? 1;
    paymentFee = json['payment_fee'] ?? 0;
    firstFreightFee = json['first_freight_fee'] ?? 0;
    nextFreightFee = json['next_freight_fee'] ?? 0;
    freightFee = json['freight_fee'] ?? 0;
    insuranceFee = json['insurance_fee'] ?? 0;
    tariffFee = json['tariff_fee'] ?? 0;
    lineAppendFee = json['line_append_fee'] ?? 0;
    couponDiscountFee = json['coupon_discount_fee'] ?? 0;
    modFee = json['mod_fee'] ?? 0;
    actualPaymentFee = json['actual_payment_fee'] ?? 0;
    valueAddedAmount = json['value_added_amount'];
    lineServiceFee = json['line_service_fee'] ?? 0;
    lineRuleFee = json['line_rule_fee'] ?? 0;
    value = json['value'] ?? 0;
    exceptional = json['exceptional'] ?? 0;
    if (json['address'] != null) {
      address = ReceiverAddressModel.fromJson(json['address']);
    }

    if (json['add_service'] != null) {
      addService = [];
      json['add_service'].forEach((v) {
        addService.add(v);
      });
    }
    if (json['user'] != null) {
      user = GroupMemberModel.fromJson(json['user']);
    }
    if (json['group_buying'] != null) {
      groupBuying = GroupModel.fromJson(json['group_buying']);
    }

    shipmentId = json['shipment_id'];
    actualWeight = json['actual_weight'] ?? 0;
    volumeWeight = json['volume_weight'] ?? 0;
    paymentWeight = json['payment_weight'] ?? 0;
    length = json['length'] ?? 0;
    width = json['width'] ?? 0;
    height = json['height'] ?? 0;
    location = json['location'] ?? '';
    paymentTypeName = json['payment_type_name'] ?? "";
    remark = json['remark'] ?? '';
    clearanceCode = json['clearance_code'] ?? '';
    personalCode = json['personal_code'] ?? '';
    lineExtraRemark = json['line_extra_remark'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    packedAt = json['packed_at'];
    paidAt = json['paid_at'] ?? "";
    shippedAt = json['shipped_at'] ?? "";
    signedAt = json['signed_at'] ?? "";
    companyId = json['company_id'] ?? 0;
    warehouseId = json['warehouse_id'];
    refundAmount = json['refund_amount'] ?? 0;
    invalidAt = json['invalid_at'] ?? "";
    operateLogs = json['operate_logs'];
    idCard = json['id_card'] ?? "";
    stationId = json['station_id'] ?? 0;
    paymentMode = json['payment_mode'] ?? 0;
    groupBuyingId = json['group_buying_id'];
    parentId = json['parent_id'] ?? 0;
    groupBuyingStatus = json['group_buying_status'];
    pickStatus = json['pick_status'];
    vipRemark = json['vip_remark'] ?? '';
    thriftFreightFee = json['thrift_freight_fee'] ?? 0;
    volumeSum = json['volume_sum'];
    factor = json['factor'];
    eurPayAmount = json['eur_pay_amount'];
    groupEndUntil = json['group_end_until'];
    groupMode = json['group_mode'] ?? 0;
    isLeaderOrder = json['is_leader_order'] ?? false;
    expressName = json['express_name'] ?? '';
    discountPaymentFee = json['discount_payment_fee'] ?? 0;
    allFreightFee = json['all_freight_fee'] ?? 0;
    point = json['point'] ?? 0;
    isInvoice = json['is_invoice'] ?? 0;
    isusepoint = json['is_use_point'] ?? 0;
    pointamount = json['point_amount'] ?? 0;
    userPoint = json['user_point'] ?? 0;
    paymentStatus = json['payment_status'];
    if (json['value_added_service'] != null) {
      valueAddedService = <ValueAddedServiceModel>[];
      json['value_added_service'].forEach((v) {
        valueAddedService.add(ValueAddedServiceModel.fromJson(v));
      });
    }
    if (json['packages'] != null) {
      packages = <ParcelModel>[];
      json['packages'].forEach((v) {
        packages.add(ParcelModel.fromJson(v));
      });
    }

    if (json['warehouse'] != null) {
      warehouse = WareHouseModel.fromJson(json['warehouse']);
    }

    if (json['express_line'] != null) {
      expressLine = ShipLineModel.fromJson(json['express_line']);
    }

    if (json['pack_pictures'] != null) {
      packPictures = <Map<String, dynamic>>[];
      json['pack_pictures'].forEach((v) {
        packPictures.add(v);
      });
    }
    if (json['in_warehouse_pictures'] != null) {
      inWarehousePictures = <Map<String, dynamic>>[];
      json['in_warehouse_pictures'].forEach((v) {
        inWarehousePictures.add(v);
      });
    }
    if (json['in_warehouse_item'] != null) {
      inWarehouseItem = json['in_warehouse_item']['item'];
    }
    // if (json['express_line_costs'] != null) {
    //   expressLineCosts = new List<ExpressLineCosts>();
    //   json['express_line_costs'].forEach((v) {
    //     expressLineCosts.add(new ExpressLineCosts.fromJson(v));
    //   });
    // }
    if (json['boxes'] != null) {
      boxes = <ParcelBoxModel>[];
      json['boxes'].forEach((v) {
        boxes.add(ParcelBoxModel.fromJson(v));
      });
    }

    if (json['station'] != null) {
      station = SelfPickupStationModel.fromJson(json['station']);
    }

    if (json['station_order'] != null) {
      stationOrder =
          SelfPickupStationOrderModel.fromJson(json['station_order']);
    }

    // groupBuying = json['group_buying'];
    if (json['transaction'] != null) {
      transaction = <OrderTransactionModel>[];
      json['transaction'].forEach((v) {
        transaction.add(OrderTransactionModel.fromJson(v));
      });
    }

    if (json['coupon'] != null) {
      coupon = UserCouponModel.fromJson(json['coupon']);
    }

    if (json['price'] != null) {
      price = PriceModel.fromJson(json['price']);
    }

    if (json['line_services'] != null) {
      lineServices = <ShipLineServiceModel>[];
      json['line_services'].forEach((v) {
        lineServices.add(ShipLineServiceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_sn'] = orderSn;
    data['logistics_sn'] = logisticsSn;
    // data['logistics_company'] = logisticsCompany;
    data['status'] = status;
    data['on_delivery_status'] = onDeliveryStatus;
    data['evaluated'] = evaluated;
    data['express_line_id'] = expressLineId;
    data['region_id'] = regionId;
    data['box_type'] = boxType;
    data['payment_fee'] = paymentFee;
    data['first_freight_fee'] = firstFreightFee;
    data['next_freight_fee'] = nextFreightFee;
    data['freight_fee'] = freightFee;
    data['insurance_fee'] = insuranceFee;
    data['tariff_fee'] = tariffFee;
    data['line_append_fee'] = lineAppendFee;
    data['coupon_discount_fee'] = couponDiscountFee;
    data['mod_fee'] = modFee;
    data['actual_payment_fee'] = actualPaymentFee;
    data['add_service'] = addService;
    data['is_invoice'] = isInvoice;
    data['value'] = value;
    data['address'] = address.toJson();
    data['shipment_id'] = shipmentId;
    data['actual_weight'] = actualWeight;
    data['volume_weight'] = volumeWeight;
    data['payment_weight'] = paymentWeight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['location'] = location;
    data['payment_type_name'] = paymentTypeName;
    data['remark'] = remark;
    data['clearance_code'] = clearanceCode;
    data['personal_code'] = personalCode;
    data['line_extra_remark'] = lineExtraRemark;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['packed_at'] = packedAt;
    data['paid_at'] = paidAt;
    data['shipped_at'] = shippedAt;
    data['signed_at'] = signedAt;
    data['company_id'] = companyId;
    data['warehouse_id'] = warehouseId;
    data['refund_amount'] = refundAmount;
    data['invalid_at'] = invalidAt;
    data['operate_logs'] = operateLogs;
    data['id_card'] = idCard;
    data['station_id'] = stationId;
    data['payment_mode'] = paymentMode;
    data['group_buying_id'] = groupBuyingId;
    data['parent_id'] = parentId;
    data['group_buying_status'] = groupBuyingStatus;
    data['pick_status'] = pickStatus;
    data['value_added_amount'] = valueAddedAmount;
    data['line_service_fee'] = lineServiceFee;
    data['line_rule_fee'] = lineRuleFee;
    data['vip_remark'] = vipRemark;
    data['thrift_freight_fee'] = thriftFreightFee;
    data['volume_sum'] = volumeSum;
    data['factor'] = factor;
    data['eur_pay_amount'] = eurPayAmount;
    data['group_end_until'] = groupEndUntil;
    data['group_mode'] = groupMode;
    data['is_leader_order'] = isLeaderOrder;
    data['express_name'] = expressName;
    data['discount_payment_fee'] = discountPaymentFee;
    data['all_freight_fee'] = allFreightFee;
    data['point'] = point;
    data['is_use_point'] = isusepoint;
    data['point_amount'] = pointamount;
    data['value_added_service'] =
        valueAddedService.map((v) => v.toJson()).toList();
    data['packages'] = packages.map((v) => v.toJson()).toList();

    data['warehouse'] = warehouse.toJson();
    data['express_line'] = expressLine.toJson();
    data['pack_pictures'] = packPictures.map((v) => v).toList();
    data['in_warehouse_pictures'] = inWarehousePictures.map((v) => v).toList();
    // data['in_warehouse_item'] = inWarehouseItem;
    // if (expressLineCosts != null) {
    //   data['express_line_costs'] =
    //       expressLineCosts.map((v) => v.toJson()).toList();
    // }
    data['boxes'] = boxes.map((v) => v.toJson()).toList();
    data['station'] = station!.toJson();
    data['station_order'] = stationOrder!.toJson();
    // data['group_buying'] = groupBuying;
    data['transaction'] = transaction.map((v) => v.toJson()).toList();
    data['shipment'] = shipment.toJson();
    data['coupon'] = coupon;
    return data;
  }
}
