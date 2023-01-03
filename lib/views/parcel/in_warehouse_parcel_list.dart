/*
  已入库包裹
*/

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
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
    onCheckParcel();
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

  // 检查是否有信息不全的包裹
  void onCheckParcel() async {
    int count = await ParcelService.getNotConfirmedParcelCount();
    if (count > 0) {
      BaseDialog.confirmDialog(
        context,
        Translation.t(context, '您有{count}个包裹资料不全请修改完整后再提交请参见红色感叹号包裹已经排在最前面',
            value: {'count': count}),
        showCancelButton: false,
      );
    }
  }

  void _onPageChange(int index) {
    _tabController?.animateTo(index);
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
          title: ZHTextLine(
            str: Translation.t(context, '已入库包裹'),
            color: ColorConfig.textBlack,
            fontSize: 18,
          ),
          bottom: isLoading
              ? TabBar(
                  onTap: (value) {
                    if (!mounted) return;
                    _pageController.jumpToPage(value);
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
        body: isLoading
            ? PageView.builder(
                itemCount: warehouseList.length,
                controller: _pageController,
                onPageChanged: _onPageChange,
                itemBuilder: (BuildContext context, int index) {
                  return _InWarehouseParcelList(
                    localizationInfo: localizationInfo,
                    warehouseModel: warehouseList[index],
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
  }) : super(key: key);
  final LocalizationModel? localizationInfo;
  final WareHouseModel warehouseModel;

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
    return data;
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
    );
  }
}
