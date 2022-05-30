/*
  已入库包裹
*/

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/*
 * 已入库包裹列表 
 */

class InWarehouseParcelListPage extends StatefulWidget {
  const InWarehouseParcelListPage({Key? key}) : super(key: key);

  @override
  InWarehouseParcelListPageState createState() =>
      InWarehouseParcelListPageState();
}

class InWarehouseParcelListPageState extends State<InWarehouseParcelListPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<WareHouseModel> warehouseList = [];
  List<GoodsPropsModel> propList = [];
  List<GoodsCategoryModel> categoryList = [];

  List<int> selectedParcelList = [];
  List<ParcelModel> allParcelList = [];

  LocalizationModel? localizationInfo;

  int selectedQty = 0;
  num selectedTotalWeight = 0;
  bool selectAll = false;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   created();
    //   loadList();
    // });
  }

  /*
    拉取仓库
   */
  void created() async {
    //拉取仓库
    var _warehouseList = await WarehouseService.getList();
    //拉取属性
    var _propList = await GoodsService.getPropList();
    //拉取分类
    var _categoryList = await GoodsService.getCategoryList();

    setState(() {
      warehouseList = _warehouseList;
      propList = _propList;
      categoryList = _categoryList;
      isLoading = true;
    });
  }

  loadList({type}) async {
    if (selectedParcelList.isNotEmpty) {
      setState(() {
        selectedParcelList.clear();
        selectAll = false;
        selectedQty = selectedParcelList.length;
        selectedTotalWeight = 0;
      });
    }
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await ParcelService.getList({
      'status': ParcelStatus.inWarehouse.id, // 已入库包裹
      'page': (++pageIndex),
    });

    if (pageIndex == 1) {
      allParcelList.clear();
      allParcelList.addAll(data['dataList']);
    } else {
      allParcelList.addAll(data['dataList']);
    }
    return data;
  }

  // 选择单个包裹
  void onChecked(ParcelModel model) {
    setState(() {
      if (selectedParcelList.contains(model.id)) {
        selectedParcelList.remove(model.id);
        selectedTotalWeight -= (model.packageWeight ?? 0);
      } else {
        selectedParcelList.add(model.id!);
        selectedTotalWeight += (model.packageWeight ?? 0);
      }
      selectedQty = selectedParcelList.length;
      int confirmedLength =
          allParcelList.where((e) => e.notConfirmed! == 0).toList().length;
      selectAll = selectedParcelList.length == confirmedLength;
    });
  }

  // 全选
  void onAllChecked() {
    setState(() {
      num totalWeight = 0;
      int totalQty = 0;
      if (selectAll) {
        selectedParcelList.clear();
      } else {
        List<int> ids = [];
        for (var e in allParcelList) {
          if (e.notConfirmed! == 0) {
            ids.add(e.id!);
            totalWeight += (e.packageWeight ?? 0);
            totalQty += 1;
          }
        }
        selectedParcelList = ids;
      }
      selectedQty = totalQty;
      selectedTotalWeight = totalWeight;
      selectAll = !selectAll;
    });
  }

  // 合并打包
  void onSubmit() async {
    if (selectedParcelList.isEmpty) {
      Util.showToast('请选择包裹');
      return;
    }
    List<ParcelModel> checkedList =
        allParcelList.where((e) => selectedParcelList.contains(e.id!)).toList();
    var s = await Navigator.pushNamed(context, '/CreateOrderPage',
        arguments: {'modelList': checkedList});
    if (s == 'succeed') {
      loadList();
    }
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '已入库',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBar: SafeArea(
            child: isLoading
                ? Container(
                    color: ColorConfig.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: onAllChecked,
                          child: Row(
                            children: [
                              Icon(
                                selectAll
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: selectAll
                                    ? ColorConfig.warningText
                                    : ColorConfig.line,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: const Text('全选'),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Caption(
                                str: "已选" +
                                    selectedQty.toString() +
                                    "件预估" +
                                    (selectedTotalWeight / 1000)
                                        .toStringAsFixed(2) +
                                    localizationInfo!.weightSymbol,
                                fontSize: 14,
                                color: ColorConfig.textGrayC9,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                height: 40,
                                child: MainButton(
                                  text: '合并打包',
                                  onPressed: onSubmit,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                : Container()),
        body: isLoading
            ? Container(
                color: ColorConfig.bgGray,
                child: ListRefresh(
                  renderItem: renderItem,
                  refresh: loadList,
                  more: loadMoreList,
                ))
            : Container());
  }

  Widget renderItem(index, ParcelModel model) {
    String packageName = model.packageName!;
    if (model.notConfirmed == 1) {}
    return GestureDetector(
        onTap: () async {
          if (model.notConfirmed == 1) {
            return;
          }
          Routers.push('/PackageDetailPage', context, {
            "edit": true,
            'id': model.id,
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: Colors.white),
          ),
          height: model.notConfirmed == 1 ? 200 : 150,
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  margin: const EdgeInsets.only(
                      top: 10, left: 0, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: const EdgeInsets.only(bottom: 0),
                              icon: model.notConfirmed == 1
                                  ? const Icon(
                                      Icons.error_outline,
                                      color: ColorConfig.textRed,
                                    )
                                  : selectedParcelList.contains(model.id)
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: ColorConfig.warningText,
                                        )
                                      : const Icon(
                                          Icons.radio_button_unchecked,
                                          color: ColorConfig.line,
                                        ),
                              onPressed: () {
                                if (model.notConfirmed == 1) {
                                  return;
                                }
                                onChecked(model);
                              }),
                          Caption(
                            fontSize: 14,
                            str: '快递单号：' + model.expressNum!,
                          ),
                        ],
                      ),
                      model.isExceptional == 1
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('异常件提示'),
                                        content: Caption(
                                          str: model.exceptionalRemark!,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('确定'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                height: 15,
                                width: 40,
                                alignment: Alignment.center,
                                color: ColorConfig.textRed,
                                child: const Caption(
                                  fontSize: 10,
                                  str: '异常件',
                                  color: ColorConfig.white,
                                ),
                              ))
                          : Container()
                    ],
                  )),
              Gaps.line,
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Caption(
                              fontSize: 16,
                              str: '包裹名称：' + packageName,
                              color: ColorConfig.textBlack,
                            )
                          ],
                        ),
                      ],
                    ),
                    Gaps.vGap5,
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Caption(
                              fontSize: 16,
                              str: '包裹价值：' +
                                  localizationInfo!.currencySymbol +
                                  (model.packageValue! / 100)
                                      .toStringAsFixed(2),
                            )
                          ],
                        ),
                      ],
                    ),
                    Gaps.vGap5,
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Caption(
                              fontSize: 16,
                              str: '包裹重量：' +
                                  ((model.packageWeight ?? 0) / 1000)
                                      .toStringAsFixed(2) +
                                  localizationInfo!.weightSymbol,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              model.notConfirmed == 1
                  ? Container(
                      margin:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Routers.push('/EditParcelPage', context, {
                                    "edit": true,
                                    'model': model,
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: ColorConfig.textRed)),
                                    alignment: Alignment.center,
                                    height: 40,
                                    child: const Caption(
                                      str: '补全信息',
                                      color: ColorConfig.textRed,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
