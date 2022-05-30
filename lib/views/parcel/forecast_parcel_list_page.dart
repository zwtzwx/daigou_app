/*
  未入库包裹
*/

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/provider/data_index_proivder.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/*
  未入库包裹列表
*/

class ForcastParcelListPage extends StatefulWidget {
  const ForcastParcelListPage({Key? key}) : super(key: key);

  @override
  ForcastParcelListPageState createState() => ForcastParcelListPageState();
}

class ForcastParcelListPageState extends State<ForcastParcelListPage>
    with SingleTickerProviderStateMixin {
  DataIndexProvider provider = DataIndexProvider();

  bool isLoading = true;
  List<WareHouseModel> warehouseList = [];
  List<GoodsPropsModel> propList = [];
  List<GoodsCategoryModel> categoryList = [];

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   created();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              title: const Caption(
                str: '未入库',
                color: ColorConfig.textBlack,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: isLoading
                ? NotInWarehousePackageList(params: {
                    'wareHouseList': warehouseList,
                    'propList': propList,
                    'categoriesList': categoryList,
                  })
                : Container()));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class NotInWarehousePackageList extends StatefulWidget {
  final Map<String, dynamic> params;

  const NotInWarehousePackageList({Key? key, required this.params})
      : super(key: key);

  @override
  NotInWarehousePackageListState createState() =>
      NotInWarehousePackageListState();
}

class NotInWarehousePackageListState extends State<NotInWarehousePackageList> {
  final GlobalKey<NotInWarehousePackageListState> key = GlobalKey();

  int pageIndex = 0;

  LocalizationModel? localizationInfo;

  @override
  void initState() {
    super.initState();
    // loadList();
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    return await ParcelService.getList({
      'status': ParcelStatus.forecast.id, // 未入库包裹
      'page': (++pageIndex),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: renderItem,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget renderItem(index, ParcelModel model) {
    return GestureDetector(
        onTap: () {
          Routers.push(
              '/PackageDetailPage', context, {'id': model.id, 'edit': false});
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: Colors.white),
          ),
          height: 200,
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  margin: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Caption(
                            fontSize: 16,
                            str: '快递单号：' + model.expressNum!,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('确定要删除吗?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('取消'),
                                          onPressed: () {
                                            Navigator.of(context).pop();

                                            if (kDebugMode) {
                                              print('取消');
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('确定'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            if (await ParcelService.delete(
                                                model.id!)) {
                                              Util.showToast('删除包裹成功');
                                              ApplicationEvent.getInstance()
                                                  .event
                                                  .fire(ListRefreshEvent(
                                                      type: 'refresh',
                                                      index: index));
                                            } else {
                                              Util.showToast("删除包裹失败");
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: const ImageIcon(
                              AssetImage(
                                  "assets/images/PackageAndOrder/删除@3x.png"),
                              color: ColorConfig.warningText,
                              size: 20,
                            ),
                          )
                        ],
                      ),
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
                              str: '包裹名称：' + model.packageName!,
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
                              str: '包裹属性：' + model.prop!.first.name!,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // TextButton(
                        //   onPressed: () {
                        //     if (model.order != null) {
                        //       Routers.push('/TrackingDetailPage', context,
                        //           {"order_sn": model.order!['order_sn']});
                        //     } else {
                        //       Util.showToast('查看失败，暂时没有物流信息');
                        //     }
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.only(left: 20, right: 20),
                        //     decoration: BoxDecoration(
                        //         borderRadius: const BorderRadius.all(
                        //             Radius.circular(20.0)),
                        //         border: Border.all(
                        //             width: 0.3, color: ColorConfig.textGray)),
                        //     alignment: Alignment.center,
                        //     height: 40,
                        //     child: const Caption(
                        //       str: '查看物流',
                        //     ),
                        //   ),
                        // ),
                        PlainButton(
                          text: '修改信息',
                          borderColor: ColorConfig.warningText,
                          onPressed: () {
                            Routers.push('/EditParcelPage', context,
                                {'model': model, 'edit': true});
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  getListProp(ParcelModel model) {
    List<Widget> propList = [];
    if (model.prop != null) {
      for (GoodsPropsModel item in model.prop!) {
        var container = Container(
          height: 30,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(width: 1, color: ColorConfig.warningText),
          ),
          child: Text(
            '   ' + (item.name ?? '') + '   ',
            style: const TextStyle(color: ColorConfig.warningText),
          ),
        );
        propList.add(container);
      }
    }
    return propList;
  }

  Widget buildSubView(int index, ParcelModel model) {
    String content = '';
    if (index == 1) {
      content = model.warehouse!.warehouseName!;
    } else if (index == 2) {
      content = '未入库';
    } else if (index == 3) {
      if (model.country != null) {
        content = model.country!.name ?? '无';
      }
    }

    return SizedBox(
      height: 55,
      child: Column(
        children: <Widget>[
          index == 1
              ? const Text("●",
                  style: TextStyle(color: ColorConfig.green, fontSize: 15))
              : Container(),
          index == 2
              ? const Icon(
                  Icons.place_rounded,
                  color: ColorConfig.textGray,
                  size: 18,
                )
              : Container(),
          index == 3
              ? const Text("●",
                  style: TextStyle(color: ColorConfig.themeRed, fontSize: 15))
              : Container(),
          Gaps.vGap16,
          Text(
            content,
            style: const TextStyle(fontSize: 15, color: ColorConfig.textBlack),
          )
        ],
      ),
    );
  }
}
