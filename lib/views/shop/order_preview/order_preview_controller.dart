import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/cart_count_refresh_event.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/insurance_item_model.dart';
import 'package:huanting_shop/models/insurance_model.dart';
import 'package:huanting_shop/models/receiver_address_model.dart';
import 'package:huanting_shop/models/ship_line_model.dart';
import 'package:huanting_shop/models/shop/cart_model.dart';
import 'package:huanting_shop/models/tariff_item_model.dart';
import 'package:huanting_shop/models/tariff_model.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/value_added_service_model.dart';
import 'package:huanting_shop/services/address_service.dart';
import 'package:huanting_shop/services/parcel_service.dart';
import 'package:huanting_shop/services/ship_line_service.dart';
import 'package:huanting_shop/services/shop_service.dart';

class OrderPreviewController extends GlobalLogic {
  late Map<String, dynamic> arguments;
  final goodsList = <CartModel>[].obs;
  final shipModel = 0.obs;
  final address = Rxn<ReceiverAddressModel?>();
  final parcelAddService = <ValueAddedServiceModel>[].obs;
  final orderAddService = <ValueAddedServiceModel>[].obs;
  final lineModel = Rxn<ShipLineModel?>();
  final insurance = Rxn<InsuranceModel?>();
  final tariff = Rxn<TariffModel?>();
  final TextEditingController insuranceController = TextEditingController();
  final FocusNode insuranceNode = FocusNode();
  final orderServiceIds = <int>[].obs;
  final lineServiceIds = <num>[].obs;
  final insuranceChecked = false.obs;
  final tariffChecked = false.obs;
  final insuranceFee = 0.0.obs;
  final agreeProtocol = false.obs;

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;

    if (arguments['ids'] != null) {
      // 购物车提交
      getCarts();
    } else if (arguments['from'] == 'platformGoods') {
      // 代购商品立即购买
      getPlatformGoods();
    } else if (arguments['from'] == 'selfGoods') {
      // 自营商品立即购买
      getSelfGoods();
    }
    getDefaultAddress();
    getParcelAddService();
    getOrderAddService();
    // getInsurance();

    // insuranceController.addListener(() {
    //   caclInsuranceFee();
    // });
  }

  @override
  void onClose() {
    for (var e in goodsList) {
      if (e.remarkController != null) {
        e.remarkController!.dispose();
        e.remarkNode!.dispose();
      }
    }
    insuranceController.dispose();
    insuranceNode.dispose();
    super.onClose();
  }

  // 购物车商品
  void getCarts() async {
    Map<String, dynamic> params = {};
    for (var i = 0; i < arguments['ids'].length; i++) {
      params['ids[$i]'] = arguments['ids'][i];
    }
    showLoading();
    var data = await ShopService.getCarts(params);
    hideLoading();
    if (arguments['platformGoods'] == true && data != null) {
      var skuIds = data.fold<List>([], (pre, cur) {
        pre.addAll(cur.skus.map((e) => e.id));
        return pre;
      });
      Map<String, dynamic> cartParams = {};
      for (var i = 0; i < skuIds.length; i++) {
        cartParams['cart_ids[$i]'] = skuIds[i];
      }
      var service = await ShopService.getCartGoodsService(cartParams);
      if (service != null) {
        for (var shop in data) {
          shop.service = service;
        }
      }
    }
    if (data != null) {
      goodsList.value = data;
    }
  }

  // 代购商品详情
  void getPlatformGoods() async {
    var cartModel =
        CartModel.fromJson(arguments['goodsInfo'], initTextEdit: true);
    showLoading();
    var data = await ShopService.getPlatformGoodsService({
      'goods_amount': cartModel.goodsAmount,
      'quantity': cartModel.skus.first.quantity,
      'price': cartModel.skus.first.price,
    });
    hideLoading();
    cartModel.service = data;
    goodsList.add(cartModel);
  }

  // 自营商品详情
  void getSelfGoods() async {
    var params = {
      'sku_list': [arguments['goodsInfo']]
    };
    var data = await ShopService.selfOrderCreate(params);
    if (data != null) {
      goodsList.add(data);
    }
  }

  // 默认收货地址
  void getDefaultAddress() async {
    var data = await AddressService.getDefaultAddress();
    if (data != null) {
      address.value = data;
    }
  }

  // 选择收货地址
  void onAddress() async {
    var s = await BeeNav.push(BeeNav.addressList, arg: {'select': 1});
    if (s == null) return;
    address.value = s as ReceiverAddressModel;
    lineModel.value = null;
  }

  // 包裹增值服务
  void getParcelAddService() async {
    var data = await ParcelService.getValueAddedServiceList();
    parcelAddService.value = data;
  }

  // 订单增值服务
  void getOrderAddService() async {
    var data = await ShipLineService.getValueAddedServiceList();
    orderAddService.value = data;
  }

  // 保险服务
  void getInsurance() async {
    var _insurance = await ShipLineService.getInsurance();
    var _tariff = await ShipLineService.getTariff();
    if (_insurance != null) {
      insurance.value = _insurance;
    }
    if (_tariff != null) {
      tariff.value = _tariff;
    }
  }

  // 选择包裹增值服务
  void onParcelServiceChecked(CartModel shop, int serviceId) {
    if (shop.addServiceIds!.contains(serviceId)) {
      shop.addServiceIds!.remove(serviceId);
    } else {
      shop.addServiceIds!.add(serviceId);
    }
    goodsList.refresh();
  }

  // 选择渠道
  onLine() async {
    if (address.value == null) {
      return showToast('请选择收货地址');
    }

    Map<String, dynamic> dic = {
      'country_id': address.value!.countryId,
      'area_id': address.value!.area?.id ?? '',
      'sub_area_id': address.value!.subArea?.id ?? '',
    };
    var s = await BeeNav.push(BeeNav.lineQueryResult, arg: {"data": dic});
    if (s == null) return;
    lineModel.value = s;
    // lineServiceIds.value = (lineModel.value!.region?.services ?? [])
    //     .where((ele) => ele.isForced == 1)
    //     .map((e) => e.id)
    //     .toList();
  }

  // 提交
  onSubmit() {
    if (!agreeProtocol.value) {
      return showToast('请同意《禁购商品声明》《免责声明》');
    } else if (address.value == null) {
      return showToast('请选择收件地址');
    } else if (shipModel.value == 1 && lineModel.value == null) {
      return showToast('请选择物流方案');
    }
    if (arguments['from'] == 'cart') {
      onCartSubmit();
    } else if (arguments['from'] == 'platformGoods') {
      onPlatformGoodsSubmit();
    } else {
      onSelfGoodsSubmit();
    }
  }

  Map<String, dynamic> getBaseCommitParams(bool isPlatformGoods) {
    Map<String, dynamic> parcelServiceIds = {};
    Map<String, dynamic> remarks = {};
    for (var shop in goodsList) {
      if (shop.addServiceIds!.isNotEmpty) {
        parcelServiceIds[shop.shopId.toString()] = shop.addServiceIds;
      }
      if (isPlatformGoods && shop.remarkController!.text.isNotEmpty) {
        remarks[shop.shopId.toString()] = shop.remarkController!.text;
      }
    }
    Map<String, dynamic> params = {
      'package_service_ids': parcelServiceIds,
      'address_type': address.value?.addressType,
      'address_id': address.value?.id,
      'mode': shipModel.value + 1,
    };
    if (isPlatformGoods) {
      params['remark'] = remarks;
    } else {
      params['remark'] = goodsList.first.remarkController!.text;
    }
    if (shipModel.value == 1) {
      // 到件即发
      params['express_line_id'] = lineModel.value?.id ?? '';
      params['order_service_ids'] = orderServiceIds;
    }
    return params;
  }

  // 购物车提交
  void onCartSubmit() async {
    List<int> cartIds = [];

    for (var shop in goodsList) {
      cartIds.addAll(shop.skus.map((e) => e.id));
    }
    Map<String, dynamic> params = {
      'cart_ids': cartIds,
      'amount': shopOrderValue,
    };
    params.addAll(getBaseCommitParams(arguments['platformGoods'] == true));
    Map res = {};
    if (arguments['platformGoods'] == true) {
      // 代购商品
      res = await ShopService.platformOrderCreate(params);
    } else {
      // 自营商品
      List skuList = [];
      for (var shop in goodsList) {
        skuList.addAll(shop.skus
            .map((e) => {'sku_id': e.goodsSkuId, 'quantity': e.quantity}));
      }
      params['sku_list'] = skuList;

      res = await ShopService.orderCreate(params);
    }
    if (res['ok']) {
      Get.find<AppStore>().getCartCount();
      ApplicationEvent.getInstance().event.fire(CartCountRefreshEvent());
      BeeNav.redirect(BeeNav.shopOrderPay, {'order': res['order']});
    }
  }

  // 代购商品直接购买
  void onPlatformGoodsSubmit() async {
    var goodsModel = goodsList.first;
    Map<String, dynamic> params = {
      'warehouse_id': goodsModel.skus.first.warehouseId,
      'platform_url': goodsModel.skus.first.platformUrl,
      'name': goodsModel.skus.first.name,
      'price': goodsModel.skus.first.price,
      'quantity': goodsModel.skus.first.quantity,
      'amount': goodsModel.skus.first.amount,
      'sku_info': {
        'specs': goodsModel.skus.first.skuInfo?.attributes,
        'shop_id': goodsModel.shopId,
        'sku_img': goodsModel.skus.first.skuInfo?.picUrl,
        'shop_name': goodsModel.shopName,
        'spec_id': goodsModel.skus.first.skuInfo?.specId ?? '',
      },
      'freight_fee': goodsModel.freightFee,
    };
    params.addAll(getBaseCommitParams(false));
    Map res = await ShopService.platformCustomOrderCreate(params);
    if (res['ok']) {
      BeeNav.redirect(BeeNav.shopOrderPay, {'order': res['order']});
    }
  }

  // 自营商品直接购买
  void onSelfGoodsSubmit() async {
    var skuList = goodsList.first.skus
        .map((e) => {'sku_id': e.goodsSkuId, 'quantity': e.skuInfo?.qty})
        .toList();
    Map<String, dynamic> params = {
      'sku_list': skuList,
      'amount': shopOrderValue,
    };
    params.addAll(getBaseCommitParams(false));
    Map res = await ShopService.orderCreate(params);
    if (res['ok']) {
      BeeNav.redirect(BeeNav.shopOrderPay, {'order': res['order']});
    }
  }

  String getLineServiceValue(num type, num value) {
    String content = '';
    switch (type) {
      case 1:
        content = '实际运费'.ts + (value / 100).toStringAsFixed(2) + '%';

        break;
      case 2:
        content = (localModel?.currencySymbol ?? '') +
            (value / 100).toStringAsFixed(2);

        break;
      case 3:
        content = (localModel?.currencySymbol ?? '') +
            (value / 100).toStringAsFixed(2) +
            '/${'箱'.ts}';

        break;
      case 4:
        content = (localModel?.currencySymbol ?? '') +
            (value / 100).toStringAsFixed(2) +
            '/${localModel?.weightSymbol} (${'计费重'.ts})';

        break;
      case 5:
        content = (localModel?.currencySymbol ?? '') +
            (value / 100).toStringAsFixed(2) +
            '/${localModel?.weightSymbol} (${'实重'.ts})';

        break;
      case 6:
        content = (localModel?.currencySymbol ?? '') +
            ((value / 10000) * (shopOrderValue / 100)).toStringAsFixed(2) +
            '/${localModel?.weightSymbol} (${'实重'.ts})';

        break;
      default:
    }
    return content;
  }

  // 计算保险费
  void caclInsuranceFee() {
    var text = insuranceController.text;
    if (num.tryParse(text) != null && insurance.value?.enabled == 1) {
      num value = num.parse(text);
      for (InsuranceItemModel item in insurance.value!.items) {
        if ((item.start / 100) < value) {
          if (item.insuranceType == 1) {
            var tempValue = value * (item.insuranceProportion / 100);
            if ((item.max ?? 0) != 0 && tempValue > item.max! / 100) {
              insuranceFee.value = (item.max! / 100);
            } else if ((item.min ?? 0) != 0 && tempValue < item.min! / 100) {
              insuranceFee.value = (item.min! / 100);
            } else {
              insuranceFee.value = tempValue;
            }
          } else {
            insuranceFee.value = item.insuranceProportion.toDouble();
          }
        }
      }
    }
  }

  String getServiceStr(int feeType, num fee) {
    String content = '';
    switch (feeType) {
      case 1:
        content = '固定费用为'.ts + '：' + fee.rate(needFormat: false);
        break;
      case 2:
      case 4:
        content = '比例值为'.ts + '：' + fee.toStringAsFixed(2) + '%';
        break;
      case 3:
        content = '固定费用为'.ts + '：' + fee.rate(needFormat: false) + '/${'件'.ts}';
        break;
    }
    return content;
  }

  double get shopOrderValue {
    var shopValue = goodsList.fold<double>(
        0,
        (pre, cur) =>
            pre +
            (cur.freightFee ?? 0) +
            (cur.goodsAmount ?? 0) +
            (cur.service?.serviceFee ?? 0));
    return shopValue;
  }

  // 关税费
  String get tariffValue {
    if (tariff.value?.enabled == 1) {
      String content = '';
      for (TariffItemModel item in tariff.value!.items) {
        if ((item.threshold ?? 0) / 100 < shopOrderValue) {
          if (item.type == 1) {
            content =
                (shopOrderValue * (item.amount / 10000)).toStringAsFixed(2);
          } else {
            content = (item.amount / 100).toStringAsFixed(2);
          }
        }
      }
      return content;
    }
    return '';
  }
}
