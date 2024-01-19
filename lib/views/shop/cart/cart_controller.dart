import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/loading_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/cart_count_refresh_event.dart';
import 'package:huanting_shop/events/language_change_event.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/shop/cart_model.dart';
import 'package:huanting_shop/models/shop/platform_goods_model.dart';
import 'package:huanting_shop/services/shop_service.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';

class CartController extends GlobalLogic {
  final Rx<LoadingUtil<PlatformGoodsModel>> loadingUtil =
      LoadingUtil<PlatformGoodsModel>().obs;
  final cartLoading = false.obs;
  List<CartModel> allCartList = [];
  final showCartList = <CartModel>[].obs;
  final cartType = 1.obs;
  final checkedList = <int>[].obs;
  final allChecked = false.obs;
  final configState = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCartGoods();
    loadingUtil.value.initListener(getRecommendGoods);
    ApplicationEvent.getInstance()
        .event
        .on<CartCountRefreshEvent>()
        .listen((event) {
      getCartGoods();
    });
    ApplicationEvent.getInstance()
        .event
        .on<LanguageChangeEvent>()
        .listen((event) {
      loadingUtil.value.clear();
      getRecommendGoods();
    });
  }

  getCartNum() async {
    ShopService.getCartCount();
  }

  getCartGoods() async {
    cartLoading.value = true;
    try {
      var data = await ShopService.getCarts();
      allCartList = data ?? [];
      getShowCartList();
    } finally {
      cartLoading.value = false;
    }
  }

  void getShowCartList() {
    showCartList.value = allCartList
        .where((value) =>
            cartType.value == 1 ? value.shopId != -1 : value.shopId == -1)
        .toList();
  }

  Future<void> handleRefresh() async {
    loadingUtil.value.clear();
    await getCartGoods();
    await getCartNum();
    getRecommendGoods();
  }

  // 代购推荐商品
  Future<void> getRecommendGoods() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      var data = await ShopService.getDaigouGoods({
        'keyword': '服饰',
        'page': ++loadingUtil.value.pageIndex,
        'page_size': 10,
        'platform': '1688'
      });
      loadingUtil.value.isLoading = false;
      if (data['dataList'] != null) {
        if (data.isNotEmpty) {
          loadingUtil.value.list.addAll(data['dataList']);
        } else if (loadingUtil.value.list.isEmpty) {
          loadingUtil.value.isEmpty = true;
        } else {
          loadingUtil.value.hasMoreData = false;
        }
      }
    } catch (e) {
      loadingUtil.value.isLoading = false;
      loadingUtil.value.pageIndex--;
      loadingUtil.value.hasError = true;
    } finally {
      loadingUtil.refresh();
    }
  }

  // 商品加减
  void onSkuQty(int step, CartSkuModel sku) async {
    var res = await ShopService.updateGoodsQty(sku.id, {
      'operate': step > 0 ? '+' : '-',
      'quantity': step > 0 ? step : -step,
    });
    if (res) {
      sku.quantity += step;
      showCartList.refresh();
    }
  }

  void onChangeQty(CartSkuModel model) {
    model.changeQty = true;
    showCartList.refresh();
  }

  void onChecked(List<int> ids) {
    var isChecked = ids.every((id) => checkedList.contains(id));
    if (isChecked) {
      checkedList.removeWhere((ele) => ids.contains(ele));
    } else {
      var set = checkedList.toSet();
      set.addAll(ids);
      checkedList.value = set.toList();
    }
    allChecked.value = allSkuIds.length == checkedList.length;
  }

  void onAllCheck(bool value) {
    if (value) {
      checkedList.value = allSkuIds;
    } else {
      checkedList.clear();
    }
    allChecked.value = value;
  }

  // 提交
  void onSubmit() {
    if (checkedList.isEmpty) {
      showToast('请选择商品');
      return;
    }

    BeeNav.push(BeeNav.orderPreview, {
      'ids': checkedList,
      'from': 'cart',
      'platformGoods': cartType.value == 1,
    });
  }

  void onCartDelete(BuildContext context) async {
    if (checkedList.isEmpty) return;
    var confirmed =
        await BaseDialog.cupertinoConfirmDialog(context, '您确定要删除吗'.ts);
    if (confirmed == true) {
      var res = await ShopService.deleteCartGoods({'ids': checkedList});
      if (res) {
        checkedList.clear();
        allChecked.value = false;
        getCartGoods();
        ApplicationEvent.getInstance().event.fire(CartCountRefreshEvent());
      }
    }
  }

  int get cartSkuNum => allCartList
      .where((ele) => ele.shopId == -1)
      .fold(0, (pre, cur) => pre + cur.skus.length);

  int get platformCartSkuNum => allCartList
      .where((ele) => ele.shopId != -1)
      .fold(0, (pre, cur) => pre + cur.skus.length);

  num get totalCheckedPrice => showCartList.fold(
        0,
        (pre, cur) =>
            pre +
            cur.skus.fold(
              0,
              (sPre, sCur) =>
                  sPre +
                  (checkedList.contains(sCur.id)
                      ? (sCur.price * sCur.quantity)
                      : 0),
            ),
      );

  List<int> get allSkuIds => showCartList.fold([], (pre, cur) {
        pre.addAll(cur.skus.map((e) => e.id));
        return pre;
      });

  @override
  dispose() {
    loadingUtil.value.controllerDestroy();
    super.dispose();
  }
}
