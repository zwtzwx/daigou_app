/*
  已入库包裹
*/

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/parcel/widget/parcel_item_cell.dart';
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
  bool isLoading = false;
  List<WareHouseModel> warehouseList = [];

  TabController? _tabController;
  final PageController _pageController = PageController();

  List<int> selectedParcelList = [];
  List<ParcelModel> allParcelList = [];

  LocalizationModel? localizationInfo;

  int selectedQty = 0;
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    created();
  }

  /*
    拉取仓库
   */
  void created() async {
    //拉取仓库
    EasyLoading.show();
    var _warehouseList = await WarehouseService.getList();
    EasyLoading.dismiss();

    setState(() {
      warehouseList = _warehouseList;
      _tabController =
          TabController(length: _warehouseList.length, vsync: this);
      isLoading = true;
    });
  }

  // 获取包裹数据
  void onLoadList(List<ParcelModel> data, bool clear) {
    setState(() {
      if (clear) {
        allParcelList.clear();
      }
      allParcelList.addAll(data);
    });
  }

  // 选择单个包裹
  void onChecked(int id) {
    setState(() {
      if (selectedParcelList.contains(id)) {
        selectedParcelList.remove(id);
      } else {
        selectedParcelList.add(id);
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
      int totalQty = 0;
      if (selectAll) {
        selectedParcelList.clear();
      } else {
        List<int> ids = [];
        for (var e in allParcelList) {
          if (e.notConfirmed! == 0) {
            ids.add(e.id!);
            totalQty += 1;
          }
        }
        selectedParcelList = ids;
      }
      selectedQty = totalQty;
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
      setState(() {
        selectAll = false;
        selectedParcelList.clear();
        selectedQty = 0;
      });
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  // 清除选择数据
  void onCleanSelected() {
    setState(() {
      allParcelList.clear();
      selectedParcelList.clear();
      selectAll = false;
      selectedQty = 0;
    });
  }

  void _onPageChange(int index) {
    _tabController?.animateTo(index);
    onCleanSelected();
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
          ),
          bottom: isLoading
              ? TabBar(
                  onTap: (value) {
                    if (!mounted) return;
                    _pageController.jumpToPage(value);
                    onCleanSelected();
                  },
                  tabs: buildTabs(),
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: ColorConfig.primary,
                  unselectedLabelColor: ColorConfig.textBlack,
                  indicatorColor: ColorConfig.primary,
                )
              : null,
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
                                    ? ColorConfig.primary
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
                                str: "已选" + selectedQty.toString() + "件",
                                fontSize: 14,
                                color: ColorConfig.textGrayC9,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                height: 40,
                                child: MainButton(
                                  text: '申请打包&合箱',
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
            ? PageView.builder(
                itemCount: warehouseList.length,
                controller: _pageController,
                onPageChanged: _onPageChange,
                itemBuilder: (BuildContext context, int index) {
                  return _InWarehouseParcelList(
                    localizationInfo: localizationInfo,
                    warehouseModel: warehouseList[index],
                    selectedParcelList: selectedParcelList,
                    onChecked: onChecked,
                    onLoadList: onLoadList,
                  );
                })
            : Container());
  }

  List<Widget> buildTabs() {
    List<Widget> widgets = [];
    for (var item in warehouseList) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          item.warehouseName!,
        ),
      ));
    }
    return widgets;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _InWarehouseParcelList extends StatefulWidget {
  const _InWarehouseParcelList({
    Key? key,
    required this.localizationInfo,
    required this.warehouseModel,
    required this.selectedParcelList,
    required this.onChecked,
    required this.onLoadList,
  }) : super(key: key);
  final LocalizationModel? localizationInfo;
  final WareHouseModel warehouseModel;
  final List<int> selectedParcelList;
  final Function onChecked;
  final Function onLoadList;

  @override
  State<_InWarehouseParcelList> createState() => __InWarehouseParcelListState();
}

class __InWarehouseParcelListState extends State<_InWarehouseParcelList> {
  int pageIndex = 0;

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await ParcelService.getList({
      'status': ParcelStatus.inWarehouse.id, // 已入库包裹
      'warehouse_id': widget.warehouseModel.id,
      'page': (++pageIndex),
    });
    widget.onLoadList(data['dataList'], pageIndex == 1);
    return data;
  }

  // 选择包裹
  _onChecked(int id) {
    widget.onChecked(id);
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
    return ParcelItemCell(
      model: model,
      localizationInfo: widget.localizationInfo,
      checked: widget.selectedParcelList.contains(model.id),
      onChecked: _onChecked,
    );
  }
}
