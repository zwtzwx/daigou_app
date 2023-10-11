import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/shop/cart_model.dart';
import 'package:jiyun_app_client/models/shop/category_model.dart';
import 'package:jiyun_app_client/models/shop/consult_model.dart';
import 'package:jiyun_app_client/models/shop/goods_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_service_model.dart';
import 'package:jiyun_app_client/models/shop/problem_order_model.dart';
import 'package:jiyun_app_client/models/shop/shop_order_model.dart';

class ShopService {
  static const String recommendGoodsApi = 'shop/get-hot-or-recommend';
  static const String categoryListApi = 'shop/get-category';
  static const String goodsDetailApi = 'shop/get-goods-detail/v2/:id';
  static const String goodsListApi = 'shop/get-category-goods';
  static const String addCartApi = 'daigou-carts/shop/create';
  static const String addPlatformCartApi = 'daigou-carts';
  static const String cartListApi = 'daigou-carts';
  static const String updateCartGoodsQtyApi = 'daigou-carts/:id/count';
  static const String delCartGoodsApi = 'daigou-carts/batch-delete';
  static const String orderAmountPreivewApi = 'daigou-orders/shop/order-amount';
  static const String orderCreateApi = 'daigou-orders/shop/create';
  static const String orderListApi = 'daigou-orders';
  static const String orderDetailApi = 'daigou-orders/:id';
  static const String orderCancelApi = 'daigou-orders/:id/cancel';
  static const String orderPayByBalanceApi = 'daigou-orders/pay/balance';
  static const String orderPayByWechatApi = 'daigou-orders/pay/wechat';
  static const String orderStatusCountApi = 'daigou-orders/status/count';
  static const String cartCountApi = 'daigou-carts/sku-num';
  static const String daigouGoodsApi = 'purchase/search/item';
  static const String daigouGoodsDetailApi = 'purchase/product-info';
  static const String platformGoodsOrderServiceApi =
      'daigou-order-services/custom-count';
  static const String platformCustomOrderCreateApi =
      'daigou-orders/custom-create';
  static const String selfOrderCreateApi = 'daigou-orders/shop/create/info';
  static const String platformOrderServiceApi = 'daigou-order-services/count';
  static const String orderConfirmApi = 'daigou-orders/confirm';
  static const String probleShopOrderApi = 'daigou-problem-order';
  static const String problemOrderPayApi = 'daigou-problem-order/pay/balance';
  static const String chatMessageApi = 'daigou-consult';
  static const String chatMessageMarkApi = '/daigou-problem-order/mark/:id';
  static const String platformGoodsCategoryApi = 'package-category/daigou';

  // 推荐商品列表
  static Future<Map<String, dynamic>> getRecommendGoods(
      [Map<String, dynamic>? params]) async {
    Map<String, dynamic> result = {
      'page': params?['page'] ?? 1,
      'dataList': null,
      'totalPage': 1
    };
    await BeeRequest.instance
        .get(recommendGoodsApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        List<GoodsModel> list = [];
        res.data.forEach((goods) => list.add(GoodsModel.fromJson(goods)));
        result['dataList'] = list;
        result['totalPage'] = res.meta?['last_page'] ?? 1;
      }
    });
    return result;
  }

  // 分类列表
  static Future<List<CategoryModel>?> getCategories(
      [Map<String, dynamic>? params]) async {
    List<CategoryModel>? list;
    await BeeRequest.instance
        .get(categoryListApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        list = List<CategoryModel>.empty(growable: true);
        res.data.forEach((goods) => list!.add(CategoryModel.fromJson(goods)));
      }
    });
    return list;
  }

  // 商品详情
  static Future<PlatformGoodsModel?> getGoodsDetail(int id) async {
    PlatformGoodsModel? goods;
    await BeeRequest.instance
        .get(goodsDetailApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        goods = PlatformGoodsModel.fromJson(res.data);
      }
    });
    return goods;
  }

  // 代购商品详情
  static Future<PlatformGoodsModel?> getDaigouGoodsDetail(
      Map<String, dynamic> params) async {
    PlatformGoodsModel? goods;
    await BeeRequest.instance
        .get(daigouGoodsDetailApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        goods = PlatformGoodsModel.fromJson(res.data);
      } else {
        EasyLoading.showError(res.msg ?? '');
      }
    });
    return goods;
  }

  // 商品列表
  static Future<Map<String, dynamic>> getGoodsList(
      [Map<String, dynamic>? params]) async {
    Map<String, dynamic> result = {
      'pageIndex': params?['page'] ?? 1,
      'total': 1,
      'dataList': []
    };
    List<GoodsModel>? list;
    await BeeRequest.instance
        .get(goodsListApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        list = List<GoodsModel>.empty(growable: true);
        res.data.forEach((goods) => list!.add(GoodsModel.fromJson(goods)));
        result = {
          'pageIndex': res.meta!['current_page'],
          'total': res.meta!['last_page'],
          'dataList': list,
        };
      }
    });
    return result;
  }

  // 自营商品 添加商品进购物车
  static Future<bool> onAddCart(Map<String, dynamic> params) async {
    bool res = false;
    await BeeRequest.instance
        .post(
          addCartApi,
          data: params,
        )
        .then((response) => res = response.ok);
    return res;
  }

  // 代购商品 添加购物车
  static Future<bool> onPlatformAddCart(Map<String, dynamic> params) async {
    bool res = false;
    await BeeRequest.instance
        .post(
          addPlatformCartApi,
          data: params,
        )
        .then((response) => res = response.ok);
    return res;
  }

  // 购物车列表
  static Future<List<CartModel>?> getCarts(
      [Map<String, dynamic>? params]) async {
    List<CartModel>? list;
    await BeeRequest.instance
        .get(cartListApi, queryParameters: params)
        .then((res) {
      if (res.ok && res.data.isNotEmpty) {
        list = List<CartModel>.empty(growable: true);
        for (var item in res.data) {
          list!.add(CartModel.fromJson(item, initTextEdit: params != null));
        }
      }
    });
    return list;
  }

  // 修改购物车商品数量
  static Future<bool> updateGoodsQty(
      int id, Map<String, dynamic> params) async {
    bool res = false;
    await BeeRequest.instance
        .put(updateCartGoodsQtyApi.replaceAll(':id', id.toString()),
            data: params)
        .then((response) => res = response.ok);
    return res;
  }

  // 删除购物车商品
  static Future<bool> deleteCartGoods(Map<String, dynamic> params) async {
    bool res = false;
    await BeeRequest.instance
        .put(delCartGoodsApi, data: params)
        .then((response) => res = response.ok);
    return res;
  }

  // 预览订单
  static Future<List<CartModel>?> orderPreview(
      Map<String, dynamic> params) async {
    List<CartModel>? list;
    await BeeRequest.instance
        .get(selfOrderCreateApi,
            queryParameters: params,
            options: Options(contentType: 'application/json'))
        .then((res) {
      if (res.ok && res.data.isNotEmpty) {
        list = List<CartModel>.empty(growable: true);
        for (var item in res.data) {
          list!.add(CartModel.fromJson(item));
        }
      } else {
        CommonMethods.showToast(res.msg ?? res.error?.message ?? '');
      }
    });
    return list;
  }

  // 预览订单金额
  static Future<Map?> orderAmountPreview(Map<String, dynamic> params) async {
    Map? res;
    await BeeRequest.instance
        .get(
      orderAmountPreivewApi,
      queryParameters: params,
    )
        .then((response) {
      if (response.ok) {
        res = response.data as Map;
      }
    });
    return res;
  }

  // 提交自营商店订单
  static Future<Map> orderCreate(Map<String, dynamic> params) async {
    Map res = {'ok': false};
    await BeeRequest.instance
        .post(
          orderCreateApi,
          data: params,
        )
        .then((response) => res = {
              'ok': response.ok,
              'order': response.ok ? [response.data['order_sn']] : null,
            });
    return res;
  }

  // 提交代购商品订单
  static Future<Map> platformOrderCreate(Map<String, dynamic> params) async {
    Map res = {'ok': false};
    await BeeRequest.instance
        .post(
      orderListApi,
      data: params,
    )
        .then((response) {
      res = {
        'ok': response.ok,
        'order': response.ok
            ? response.data.map((ele) => ele['order_sn']).toList()
            : null,
      };
    });
    return res;
  }

  // 提交自营商品订单
  static Future<CartModel?> selfOrderCreate(Map<String, dynamic> params) async {
    CartModel? model;
    await BeeRequest.instance
        .post(selfOrderCreateApi,
            data: params, options: Options(extra: {'showSuccess': false}))
        .then((res) {
      if (res.ok && res.data != null && res.data.isNotEmpty) {
        var data = res.data.first;
        var params = {
          'shop': {
            'id': data['shop_id'],
            'name': data['shop_name'],
            'freight_fee': data['freight_fee'],
            'goods_amount': data['amount']
          },
          'skus': [data]
        };
        model = CartModel.fromJson(params, initTextEdit: true);
      }
    });
    return model;
  }

  // 代购商品直接购买
  static Future<Map> platformCustomOrderCreate(
      Map<String, dynamic> params) async {
    Map res = {'ok': false};
    await BeeRequest.instance
        .post(
          platformCustomOrderCreateApi,
          data: params,
        )
        .then((response) => res = {
              'ok': response.ok,
              'order': response.ok
                  ? response.data.map((ele) => ele['order_sn']).toList()
                  : null,
            });
    return res;
  }

  // 订单列表
  static Future<Map> getOrderList(Map<String, dynamic> params) async {
    Map<String, dynamic> result = {
      'pageIndex': params['page'] ?? 1,
      'total': 1,
      'dataList': []
    };
    List<ShopOrderModel>? list;
    await BeeRequest.instance
        .get(orderListApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        list = List<ShopOrderModel>.empty(growable: true);
        res.data.forEach((goods) => list!.add(ShopOrderModel.fromJson(goods)));
        result = {
          'pageIndex': res.meta!['current_page'],
          'total': res.meta!['last_page'],
          'dataList': list,
        };
      }
    });
    return result;
  }

  // 订单列表
  static Future<Map> getProbleOrderList(Map<String, dynamic> params) async {
    Map<String, dynamic> result = {
      'pageIndex': params['page'] ?? 1,
      'total': 1,
      'dataList': []
    };
    List<ProblemOrderModel>? list;
    await BeeRequest.instance
        .get(probleShopOrderApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        list = List<ProblemOrderModel>.empty(growable: true);
        res.data
            .forEach((goods) => list!.add(ProblemOrderModel.fromJson(goods)));
        result = {
          'pageIndex': res.meta!['current_page'],
          'total': res.meta!['last_page'],
          'dataList': list,
        };
      }
    });
    return result;
  }

  // 订单详情
  static Future<ShopOrderModel?> getOrderDetail(int id) async {
    ShopOrderModel? order;
    await BeeRequest.instance
        .get(orderDetailApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        order = ShopOrderModel.fromJson(res.data);
      }
    });
    return order;
  }

  // 取消订单
  static Future<Map> orderCancel(int id) async {
    Map res = {'ok': false, 'msg': ''};
    await BeeRequest.instance
        .put(
          orderCancelApi.replaceAll(':id', id.toString()),
        )
        .then((response) => res = {
              'ok': response.ok,
              'msg': response.msg ?? response.error?.message,
            });
    return res;
  }

  // 余额支付
  static Future<Map> payByBalance(Map<String, dynamic> params) async {
    Map res = {'ok': false, 'msg': ''};
    await BeeRequest.instance
        .post(orderPayByBalanceApi, data: params)
        .then((response) => res = {
              'ok': response.ok,
              'msg': response.msg ?? response.error?.message,
            });
    return res;
  }

  // 余额支付（订单补款）
  static Future<Map> problemPayByBalance(Map<String, dynamic> params) async {
    Map res = {'ok': false, 'msg': ''};
    await BeeRequest.instance
        .post(problemOrderPayApi, data: params)
        .then((response) => res = {
              'ok': response.ok,
              'msg': response.msg ?? response.error?.message,
            });
    return res;
  }

  // 微信支付
  static Future<Map?> payByWechat(Map<String, dynamic> params) async {
    Map? res;
    await BeeRequest.instance
        .post(orderPayByWechatApi, data: params)
        .then((response) {
      if (response.ok) {
        res = response.data;
      } else {
        CommonMethods.showToast(response.msg ?? response.error?.message ?? '');
      }
    });
    return res;
  }

  // 订单状态数量统计
  static Future<Map?> getOrderStatusCount() async {
    Map? res;
    await BeeRequest.instance.get(orderStatusCountApi).then((response) {
      if (response.ok) {
        res = response.data;
      }
    });
    return res;
  }

  // 购物车商品数量
  static Future<int?> getCartCount() async {
    int? res;
    await BeeRequest.instance.get(cartCountApi).then((response) {
      if (response.ok) {
        res = response.data['sku_num'];
      }
    });
    return res;
  }

  // 代购商品列表
  static Future<Map> getDaigouGoods(Map<String, dynamic> params) async {
    Map result = {
      "dataList": null,
      'total': (params['page'] ?? 1) + 1,
      'pageIndex': params['page'] ?? 1
    };
    await BeeRequest.instance
        .get(daigouGoodsApi, queryParameters: params)
        .then((res) {
      if (res.data['items'] != null) {
        List<PlatformGoodsModel> list = [];
        for (var item in res.data['items']['item']) {
          item['platform'] =
              res.data['api_type'] ?? res.data['items']['api_type'];
          list.add(PlatformGoodsModel.fromJson(item));
        }
        result['dataList'] = list;
        if (list.isEmpty) {
          result['total'] = result['pageIndex'];
        }
      }
    });
    return result;
  }

  // 自定义订单服务费
  static Future<PlatformGoodsServiceModel?> getPlatformGoodsService(
      Map<String, dynamic> params) async {
    PlatformGoodsServiceModel? model;
    await BeeRequest.instance
        .get(platformGoodsOrderServiceApi, queryParameters: params)
        .then((res) {
      if (res.ok && res.data != null) {
        model = PlatformGoodsServiceModel.fromJson(res.data);
      }
    });
    return model;
  }

  // 购物车订单服务费
  static Future<PlatformGoodsServiceModel?> getCartGoodsService(
      Map<String, dynamic> params) async {
    PlatformGoodsServiceModel? model;
    await BeeRequest.instance
        .get(platformOrderServiceApi, queryParameters: params)
        .then((res) {
      if (res.ok && res.data != null) {
        model = PlatformGoodsServiceModel.fromJson(res.data);
      }
    });
    return model;
  }

  // 订单支付确认
  static Future<List<ShopOrderModel>?> getOrderConfirm(
      Map<String, dynamic> params) async {
    List<ShopOrderModel>? list;
    await BeeRequest.instance
        .get(orderConfirmApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        list = [];
        res.data.forEach((ele) {
          list!.add(ShopOrderModel.fromJson(ele));
        });
      }
    });
    return list;
  }

  // 咨询消息
  static Future<Map> getMessage(Map<String, dynamic> params) async {
    Map result = {
      "dataList": null,
      'total': (params['page'] ?? 1) + 1,
      'pageIndex': params['page'] ?? 1
    };
    await BeeRequest.instance
        .get(chatMessageApi, queryParameters: params)
        .then((res) {
      if (res.ok) {
        var list = List<ConsultModel>.empty(growable: true);
        res.data.forEach((goods) => list.add(ConsultModel.fromJson(goods)));
        result = {
          'pageIndex': res.meta!['current_page'],
          'total': res.meta!['last_page'],
          'dataList': list,
        };
      }
    });
    return result;
  }

  // 发送咨询消息
  static Future<bool> sendMessage(Map<String, dynamic> params) async {
    bool value = false;
    await BeeRequest.instance
        .post(chatMessageApi,
            data: params, options: Options(extra: {'showSuccess': false}))
        .then((res) => value = res.ok);
    return value;
  }

  // 咨询消息设为已读
  static Future<bool> markMessage(id) async {
    bool value = false;
    await BeeRequest.instance
        .put(chatMessageMarkApi.replaceAll(':id', id.toString()),
            options: Options(extra: {'loading': false, 'showSuccess': false}))
        .then((res) => value = res.ok);
    return value;
  }

  // 获取代购分类列表
  static Future<List<GoodsCategoryModel>> getCategoryList(
      [Map<String, dynamic>? params]) async {
    List<GoodsCategoryModel> result =
        List<GoodsCategoryModel>.empty(growable: true);

    await BeeRequest.instance
        .get(platformGoodsCategoryApi, queryParameters: params)
        .then((response) {
      if (response.data != null) {
        response.data.forEach((good) {
          result.add(GoodsCategoryModel.fromJson(good));
        });
      }
    });
    return result;
  }
}
