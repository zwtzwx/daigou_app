import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/cart_count_refresh_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/goods_sku_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/sku_bottom_sheet.dart';

class GoodsDetailController extends BaseController {
  final isPlatformGoods = false.obs; // 是否是代购商品
  String platformGoodsUrl = '';
  int? goodsId;
  final goodsModel = Rxn<PlatformGoodsModel?>();
  final TextEditingController priceController =
      TextEditingController(text: '0');
  final FocusNode priceNode = FocusNode();
  final isLoading = true.obs;
  final sku = Rxn<GoodsSkuModel?>();
  final warehouseList = <WareHouseModel>[].obs;
  final selectedWarehouse = Rxn<WareHouseModel?>();
  final qty = 1.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments['url'] != null) {
      platformGoodsUrl = arguments['url'];
      isPlatformGoods.value = true;
    } else {
      goodsId = arguments['id'];
    }
    getGoodsDetail();
    getWarehouse();
  }

  @override
  onClose() {
    priceController.dispose();
    priceNode.dispose();
  }

  // 仓库列表
  void getWarehouse() async {
    var data = await WarehouseService.getList();
    warehouseList.value = data;
    if (data.isNotEmpty) {
      selectedWarehouse.value = data.first;
    }
  }

  // 商品详情
  Future<void> getGoodsDetail() async {
    isLoading.value = true;
    try {
      if (isPlatformGoods.value) {
        var data = await ShopService.getDaigouGoodsDetail({
          'keyword': platformGoodsUrl,
        });
        goodsModel.value = data;
      } else {
        var data = await ShopService.getGoodsDetail(goodsId!);
        goodsModel.value = data;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void onQty(value) {
    qty.value = value;
  }

  // 自营商城添加到购物车
  void onGoodsAddCart() async {
    var res = await ShopService.onAddCart({
      'sku_id': sku.value!.id,
      'quantity': qty.value,
    });
    if (res) {
      ApplicationEvent.getInstance().event.fire(CartCountRefreshEvent());
    }
  }

  // 第三方平台商品加入购物车
  void onPlatformGoodsAddCart() async {
    if (selectedWarehouse.value == null) {
      showToast('请选择仓库');
      return;
    }
    var properties = (sku.value?.properties ?? '').split(';');
    var spec = goodsModel.value!.propsList!.map((parent) {
      var value = parent.children!.firstWhere(
          (child) => properties.contains('${parent.id}:${child.id}'));
      return {'label': parent.name, 'value': value.name};
    }).toList();
    var res = await ShopService.onPlatformAddCart({
      'warehouse_id': selectedWarehouse.value!.id,
      'platform': goodsModel.value?.platform ?? '',
      'platform_sku': sku.value?.skuId,
      'platform_url': goodsModel.value?.detailUrl,
      'name': goodsModel.value?.title,
      'price': sku.value?.price,
      'quantity': qty.value,
      'amount': (sku.value?.price ?? 0) * qty.value,
      'freight_fee': priceController.text,
      'sku_info': {
        'shop_id': goodsModel.value?.shopId,
        'imgs': goodsModel.value?.images,
        'shop_name': goodsModel.value?.nick,
        'sku_img': sku.value!.images.isEmpty
            ? goodsModel.value?.picUrl
            : sku.value!.images.first,
        'specs': spec,
      }
    });
    if (res) {
      ApplicationEvent.getInstance().event.fire(CartCountRefreshEvent());
    }
  }

  // 第三方平台立即购买
  void onPlatformGoodsBuy() async {
    if (selectedWarehouse.value == null) {
      showToast('请选择仓库');
      return;
    }
    var properties = (sku.value?.properties ?? '').split(';');
    var spec = goodsModel.value!.propsList!.map((parent) {
      var value = parent.children!.firstWhere(
          (child) => properties.contains('${parent.id}:${child.id}'));
      return {'label': parent.name, 'value': value.name};
    }).toList();
    var params = {
      'shop': {
        'freight_fee': num.tryParse(priceController.text) != null
            ? num.parse(priceController.text)
            : 0,
        'goods_amount': (sku.value?.price ?? 0) * qty.value,
        'id': goodsModel.value?.shopId,
        'name': goodsModel.value?.nick,
      },
      'skus': [
        {
          'warehouse_id': selectedWarehouse.value!.id,
          'platform': goodsModel.value?.platform ?? '',
          'platform_sku': sku.value?.skuId,
          'platform_url': goodsModel.value?.detailUrl,
          'name': goodsModel.value?.title,
          'price': sku.value?.price,
          'quantity': qty.value,
          'amount': (sku.value?.price ?? 0) * qty.value,
          'sku_info': {
            'sku_img': sku.value!.images.isEmpty
                ? goodsModel.value?.picUrl
                : sku.value!.images.first,
            'attributes': spec,
            'price': sku.value?.price,
            'qty': qty.value,
            'url': goodsModel.value?.detailUrl,
            'pic_url': sku.value!.images.isEmpty
                ? goodsModel.value?.picUrl
                : sku.value!.images.first,
          }
        }
      ]
    };
    Routers.push(Routers.orderPreview, {
      'from': 'platformGoods',
      'platformGoods': true,
      'goodsInfo': params,
    });
  }

  // 自营商品立即购买
  void onSelfGoodsBuy() {
    var params = {
      'sku_id': sku.value?.id,
      'quantity': qty.value,
    };
    Routers.push(Routers.orderPreview, {
      'from': 'selfGoods',
      'goodsInfo': params,
    });
  }

  bool onCheckLogin() {
    String token = Get.find<UserInfoModel>().token.value;
    if (token.isEmpty) {
      Routers.push(Routers.login);
    }
    return token.isNotEmpty;
  }

  void showSkuModal(String type) {
    Get.bottomSheet(
      SKUBottomSheet(
        model: goodsModel.value!,
        qty: qty.value,
        sku: sku.value,
        type: type,
        onSkuChange: (value) {
          sku.value = value;
        },
        onQtyChange: onQty,
        onAddCart: () {
          if (onCheckLogin()) {
            if (isPlatformGoods.value) {
              onPlatformGoodsAddCart();
            } else {
              onGoodsAddCart();
            }
          }
        },
        onBuy: () {
          if (onCheckLogin()) {
            if (isPlatformGoods.value) {
              onPlatformGoodsBuy();
            } else {
              onSelfGoodsBuy();
            }
          }
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  void showWarehousePicker(BuildContext context) {
    Picker(
      height: 150.h,
      adapter: PickerDataAdapter(
          data: warehouseList
              .map((ele) => PickerItem(
                    text: ZHTextLine(
                      fontSize: 16,
                      str: ele.warehouseName!,
                    ),
                  ))
              .toList()),
      cancelText: '取消'.ts,
      confirmText: '确认'.ts,
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onConfirm: (Picker picker, List value) {
        selectedWarehouse.value = warehouseList[value.first];
      },
    ).showModal(context);
  }
}
