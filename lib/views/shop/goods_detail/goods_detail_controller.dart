import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/cart_count_refresh_event.dart';
import 'package:shop_app_client/events/change_goods_info_event.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/shop/goods_comment_model.dart';
import 'package:shop_app_client/models/shop/goods_sku_model.dart';
import 'package:shop_app_client/models/shop/platform_goods_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/warehouse_model.dart';
import 'package:shop_app_client/services/shop_service.dart';
import 'package:shop_app_client/services/warehouse_service.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/goods/sku_bottom_sheet.dart';
import 'package:shop_app_client/views/shop/image_search_goods_list/binding.dart';
import 'package:shop_app_client/views/shop/image_search_goods_list/view.dart';
import 'package:shop_app_client/views/shop/widget/goods_comments_sheet.dart';

class GoodsDetailController extends GlobalController {
  final isPlatformGoods = false.obs; // 是否是代购商品
  String platformGoodsUrl = '';
  int? goodsId;
  final goodsModel = Rxn<PlatformGoodsModel?>();

  final isLoading = true.obs;
  final sku = Rxn<GoodsSkuModel?>();
  List<WareHouseModel> warehouseList = [];
  final selectedWarehouse = Rxn<WareHouseModel?>();
  final comments = <GoodsCommentModel>[].obs;
  final commentsTotal = ''.obs;
  final commentLoading = false.obs;
  final qty = RxnInt();
  final ScrollController scrollController = ScrollController();
  final prcent = 0.0.obs;
  num freightFee = 0;

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
    ApplicationEvent.getInstance()
        .event
        .on<ChangeGoodsInfoEvent>()
        .listen((event) {
      isPlatformGoods.value = true;
      platformGoodsUrl = event.url;
      getGoodsDetail();
    });
    scrollController.addListener(() {
      var pixel = scrollController.position.pixels;
      var value = pixel / 120.h;
      prcent.value = value > 1 ? 1 : (value < 0 ? 0 : value);
    });
  }

  String get platformName {
    switch (goodsModel.value?.platform) {
      case '1688':
        return '1688';
      case 'taobao':
        return '淘宝';
      case 'pinduoduo':
        return '拼多多';
      case 'jd':
        return '京东';
    }
    return '';
  }

  // 以图搜物
  void onPhotoSearch() async {
    String url = goodsModel.value!.images!.first;
    Get.to(
      GoodsImageSearchResultPage(
        controllerTag: url,
      ),
      arguments: {'url': url},
      binding: GoodsImageSearchResultBinding(tag: url),
    );
  }

  // 仓库列表
  void getWarehouse() async {
    var data = await WarehouseService.getSimpleList();
    warehouseList = data;
    if (data.isNotEmpty) {
      selectedWarehouse.value = data.first;
    }
  }

  // 商品详情
  Future<void> getGoodsDetail() async {
    isLoading.value = true;
    try {
      PlatformGoodsModel? data;
      if (isPlatformGoods.value) {
        data = await ShopService.getDaigouGoodsDetail({
          'keyword': platformGoodsUrl,
        });
      } else {
        data = await ShopService.getGoodsDetail(goodsId!);
      }
      goodsModel.value = data;
      if (isPlatformGoods.value &&
          goodsModel.value != null &&
          ['taobao', 'jd'].contains(goodsModel.value?.platform)) {
        getGoodsComments();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 商品评价
  void getGoodsComments() async {
    commentLoading.value = true;
    var res =
        await ShopService.getGoodsComments(goodsModel.value!.id.toString(), {
      'platform': goodsModel.value?.platform,
      'user_id': goodsModel.value?.shopId,
      'nick': goodsModel.value?.nick,
      'page_size': 2,
    });
    commentLoading.value = false;
    if (res['dataList'] is List) {
      commentsTotal.value = res['total'];
      comments.value = res['dataList'].take(2).toList();
    }
  }

  void onShowCommentSheet() {
    Get.bottomSheet(
      GoodsCommentsList(
        goodsId: goodsModel.value!.id.toString(),
        total: commentsTotal.value,
        platform: goodsModel.value?.platform,
        userId: goodsModel.value?.shopId,
        nick: goodsModel.value?.nick,
      ),
      isScrollControlled: true,
    );
  }

  void onQty(value) {
    qty.value = value;
  }

  // 自营商城添加到购物车
  void onGoodsAddCart() async {
    var res = await ShopService.onAddCart({
      'sku_id': (goodsModel.value?.propsList ?? []).isEmpty
          ? goodsModel.value?.skus?.first.id
          : sku.value?.id,
      'quantity': qty.value,
    });
    if (res) {
      Get.find<AppStore>().getCartCount();
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
      'platform_sku': sku.value?.skuId ?? goodsModel.value?.id,
      'platform_url': goodsModel.value?.detailUrl,
      'name': goodsModel.value?.title,
      'price': sku.value?.price ?? goodsModel.value?.price,
      'quantity': qty.value,
      'amount': (sku.value?.price ?? goodsModel.value?.price ?? 0) * qty.value!,
      'freight_fee': freightFee / (currencyModel.value?.rate ?? 1),
      'sku_info': {
        'shop_id': goodsModel.value?.shopId,
        'imgs': goodsModel.value?.images,
        'shop_name': goodsModel.value?.nick,
        'sku_img': (sku.value?.images ?? []).isEmpty
            ? goodsModel.value?.picUrl
            : sku.value!.images.first,
        'specs': spec,
        'min_order_quantity': goodsModel.value?.minOrderQuantity ?? 1,
        'batch_number': goodsModel.value?.batchNumber ?? 1,
        'spec_id': sku.value!.specId ?? '',
      }
    });
    if (res) {
      Get.find<AppStore>().getCartCount();
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
        'freight_fee': freightFee / (currencyModel.value?.rate ?? 1),
        'goods_amount':
            (sku.value?.price ?? goodsModel.value?.price ?? 0) * qty.value!,
        'id': goodsModel.value?.shopId,
        'name': goodsModel.value?.nick,
      },
      'skus': [
        {
          'warehouse_id': selectedWarehouse.value!.id,
          'platform': goodsModel.value?.platform ?? '',
          'platform_sku': sku.value?.skuId ?? goodsModel.value?.id ?? '',
          'platform_url': goodsModel.value?.detailUrl,
          'name': goodsModel.value?.title,
          'price': sku.value?.price ?? goodsModel.value?.price,
          'quantity': qty.value,
          'amount':
              (sku.value?.price ?? goodsModel.value?.price ?? 0) * qty.value!,
          'sku_info': {
            'sku_img': (sku.value?.images ?? []).isEmpty
                ? goodsModel.value?.picUrl
                : sku.value!.images.first,
            'specs': spec,
            'price': sku.value?.price ?? goodsModel.value?.price,
            'qty': qty.value,
            'url': goodsModel.value?.detailUrl,
            'pic_url': (sku.value?.images ?? []).isEmpty
                ? goodsModel.value?.picUrl
                : sku.value!.images.first,
            'spec_id': sku.value!.specId ?? '',
          }
        }
      ]
    };
    GlobalPages.push(GlobalPages.orderPreview, arg: {
      'from': 'platformGoods',
      'platformGoods': true,
      'goodsInfo': params,
    });
  }

  // 自营商品立即购买
  void onSelfGoodsBuy() {
    // 没有规格，默认取第一个 sku
    var params = {
      'sku_id': (goodsModel.value?.propsList ?? []).isEmpty
          ? goodsModel.value?.skus?.first.id
          : sku.value?.id,
      'quantity': qty.value,
    };
    GlobalPages.push(GlobalPages.orderPreview, arg: {
      'from': 'selfGoods',
      'goodsInfo': params,
    });
  }

  bool onCheckLogin() {
    String token = Get.find<AppStore>().token.value;
    if (token.isEmpty) {
      GlobalPages.push(GlobalPages.login);
    }
    return token.isNotEmpty;
  }

  void showSkuModal(String type) {
    Get.bottomSheet(
      BeeShopGoodsSku(
        model: goodsModel.value!,
        qty: qty.value ?? goodsModel.value?.minOrderQuantity ?? 1,
        sku: sku.value,
        type: type,
        freightFee: freightFee,
        warehouse: selectedWarehouse.value,
        warehouseList: warehouseList,
        currencySymbol: currencyModel.value?.code,
        onSkuChange: (value) {
          sku.value = value;
        },
        onQtyChange: onQty,
        onAddCart: (num fee, WareHouseModel? warehouse) {
          freightFee = fee;
          selectedWarehouse.value = warehouse;
          if (onCheckLogin()) {
            if (isPlatformGoods.value) {
              onPlatformGoodsAddCart();
            } else {
              onGoodsAddCart();
            }
          }
        },
        onBuy: (num fee, WareHouseModel? warehouse) {
          freightFee = fee;
          selectedWarehouse.value = warehouse;
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
                    text: AppText(
                      fontSize: 16,
                      str: ele.warehouseName!,
                    ),
                  ))
              .toList()),
      cancelText: '取消'.inte,
      confirmText: '确认'.inte,
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onConfirm: (Picker picker, List value) {
        selectedWarehouse.value = warehouseList[value.first];
      },
    ).showModal(context);
  }
}
