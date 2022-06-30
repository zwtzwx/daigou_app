/*
  未入库包裹
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
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/parcel/widget/parcel_item_cell.dart';
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
  bool isLoading = false;
  List<WareHouseModel> warehouseList = [];
  TabController? _tabController;
  final PageController _pageController = PageController();

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

  onPageChange(int index) {
    _tabController?.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '未入库包裹'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
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
              key: const Key('pageView'),
              itemCount: warehouseList.length,
              controller: _pageController,
              onPageChanged: onPageChange,
              itemBuilder: (BuildContext context, int index) {
                return NotInWarehousePackageList(
                  warehouseModel: warehouseList[index],
                );
              })
          : Container(),
    );
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

class NotInWarehousePackageList extends StatefulWidget {
  final WareHouseModel warehouseModel;

  const NotInWarehousePackageList({Key? key, required this.warehouseModel})
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
      'warehouse_id': widget.warehouseModel.id,
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
    return ParcelItemCell(
      model: model,
      index: index,
      localizationInfo: localizationInfo,
    );
  }
}
