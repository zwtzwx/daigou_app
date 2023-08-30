import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/goods_props_model.dart';
import 'package:jiyun_app_client/models/shop/goods_sku_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class SKUBottomSheet extends StatefulWidget {
  const SKUBottomSheet({
    Key? key,
    required this.model,
    required this.sku,
    this.qty,
    required this.onSkuChange,
    required this.type,
    this.onQtyChange,
    this.onAddCart,
    this.onBuy,
  }) : super(key: key);
  final PlatformGoodsModel model;
  final GoodsSkuModel? sku;
  final int? qty;
  final Function(GoodsSkuModel value) onSkuChange;
  final Function(int value)? onQtyChange;
  final Function? onAddCart;
  final Function? onBuy;
  final String type;

  @override
  State<SKUBottomSheet> createState() => _SKUBottomSheetState();
}

class _SKUBottomSheetState extends State<SKUBottomSheet> {
  late int qty;
  GoodsSkuModel? sku;
  Map<String, String> tempSelectProps = {};
  late List<GoodsPropsModel> propList;

  @override
  initState() {
    super.initState();
    qty = widget.qty ?? 1;
    sku = widget.sku;
    propList = [];
    for (GoodsPropsModel prop in (widget.model.propsList ?? [])) {
      List<GoodsPropsModel> children = prop.children!
          .map((e) =>
              GoodsPropsModel(id: e.id, name: e.name, noStock: e.noStock))
          .toList();
      propList.add(GoodsPropsModel(
        id: prop.id,
        name: prop.name,
        children: children,
      ));
    }
    if (widget.sku != null) {
      (widget.sku!.properties ?? '').split(';').forEach((ele) {
        var prop = ele.split(':');
        tempSelectProps[prop.first] = prop.last;
      });
    }
    onPropStock();
  }

  onQty(int step) {
    if (step < 0 && qty == 1) return;
    setState(() {
      qty += step;
    });
  }

  String getTypeName() {
    switch (widget.type) {
      case 'select':
        return '确定';
      case 'cart':
        return '加入购物车';
      default:
        return '购买';
    }
  }

  void onPropChecked(String prop, String value) {
    if (tempSelectProps[prop] == value) return;
    setState(() {
      tempSelectProps[prop] = value;
    });
    if (tempSelectProps.length == propList.length) {
      List<String> propStr = tempSelectProps.keys
          .map((key) => '$key:${tempSelectProps[key]}')
          .toList();
      var index = widget.model.skus!.indexWhere(
          (sku) => propStr.every((prop) => sku.properties!.contains(prop)));
      if (index != -1) {
        setState(() {
          sku = widget.model.skus![index];
        });
      }
    }
    onPropStock();
  }

  void onPropStock() {
    var stockList = widget.model.stockSkus.map((e) {
      var list = e.split(';');
      Map<String, String> propMap = {};
      for (var prop in list) {
        propMap[prop.split(':').first] = prop.split(':').last;
      }
      return propMap;
    }).toList();
    setState(() {
      for (var propParent in propList) {
        for (var child in propParent.children!) {
          var tempMap = {...tempSelectProps, propParent.id: child.id};
          var hasStock = stockList.any(
              (ele) => tempMap.keys.every((key) => ele[key] == tempMap[key]));
          child.noStock = !hasStock;
        }
      }
    });
  }

  void onSubmit() {
    if (sku == null) {
      for (var ele in propList) {
        if (!tempSelectProps.containsKey(ele.id)) {
          EasyLoading.showToast('请选择'.ts + ele.name!);
          return;
        }
      }
    }
    if (widget.onQtyChange != null) {
      widget.onQtyChange!(qty);
    }
    widget.onSkuChange(sku!);
    Navigator.pop(context);
    if (widget.type == 'cart') {
      widget.onAddCart!();
    } else if (widget.type == 'buy') {
      widget.onBuy!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            15.verticalSpaceFromWidth,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LoadImage(
                    sku != null && sku!.images.isNotEmpty
                        ? sku!.images.first
                        : (widget.model.picUrl ?? ''),
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                  ),
                ),
                Sized.hGap15,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: ((sku?.price ?? widget.model.price ?? 0) *
                                      qty)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFBABABA),
                    ),
                  ),
                ),
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 300.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...propList
                        .map((e) => Container(
                              margin: EdgeInsets.only(top: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ZHTextLine(
                                    str: e.name ?? '',
                                    fontSize: 14,
                                  ),
                                  12.verticalSpace,
                                  Wrap(
                                    spacing: 20.w,
                                    runSpacing: 15.w,
                                    children: (e.children ?? [])
                                        .map(
                                          (prop) => GestureDetector(
                                            onTap: () {
                                              if (prop.noStock) return;
                                              onPropChecked(e.id!, prop.id!);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: tempSelectProps[e.id] ==
                                                        prop.id
                                                    ? const Color(0xFFFFEFEF)
                                                    : BaseStylesConfig.bgGray,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 3.w),
                                              child: ZHTextLine(
                                                str: (prop.name ?? '') +
                                                    (prop.noStock
                                                        ? '(${'缺货'.ts})'
                                                        : ''),
                                                lines: 4,
                                                fontSize: 12,
                                                color: tempSelectProps[e.id] ==
                                                        prop.id
                                                    ? const Color(0xFFFF6868)
                                                    : BaseStylesConfig
                                                        .textGrayC9,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZHTextLine(
                          str: '数量'.ts,
                          fontSize: 14,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                onQty(-1);
                              },
                              child: Icon(
                                Icons.remove,
                                size: 24,
                                color: qty == 1
                                    ? BaseStylesConfig.textGray
                                    : Colors.black,
                              ),
                            ),
                            Container(
                              height: ScreenUtil().setHeight(22),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              width: ScreenUtil().setWidth(50),
                              child: ZHTextLine(
                                str: qty.toString(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onQty(1);
                              },
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: qty == sku?.quantity
                                    ? BaseStylesConfig.textGray
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
              width: double.infinity,
              child: MainButton(
                text: getTypeName().ts,
                borderRadis: 999,
                fontWeight: FontWeight.bold,
                onPressed: () {
                  onSubmit();
                },
              ),
            ),
            15.verticalSpace,
          ],
        ),
      ),
    );
  }
}
