/*
  未入库包裹
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/parcel/parcel_list/parcel_list_controller.dart';
import 'package:jiyun_app_client/views/parcel/widget/parcel_item_cell.dart';

/*
  包裹列表
 */
class ParcelListView extends GetView<ParcelListController> {
  const ParcelListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: ZHTextLine(
            str: (controller.type.value == 1 ? '未入库包裹' : '已入库包裹').ts,
            color: BaseStylesConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          bottom: controller.isLoading.value
              ? TabBar(
                  onTap: (value) {
                    controller.currentWarehouse =
                        controller.warehouseList[value].id!;
                    controller.pageController.jumpToPage(value);
                  },
                  tabs: buildTabs(),
                  isScrollable: true,
                  controller: controller.tabController,
                  labelColor: BaseStylesConfig.primary,
                  unselectedLabelColor: BaseStylesConfig.textBlack,
                  indicatorColor: BaseStylesConfig.primary,
                )
              : null,
        ),
        body: PageView.builder(
          key: const Key('pageView'),
          itemCount: controller.warehouseList.length,
          controller: controller.pageController,
          onPageChanged: controller.onPageChange,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: BaseStylesConfig.bgGray,
              child: ListRefresh(
                renderItem: renderItem,
                refresh: controller.loadList,
                more: controller.loadMoreList,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget renderItem(index, ParcelModel model) {
    return ParcelItemCell(
      model: model,
      index: index,
    );
  }

  List<Widget> buildTabs() {
    List<Widget> widgets = [];
    for (var item in controller.warehouseList) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          item.warehouseName!,
        ),
      ));
    }
    return widgets;
  }
}

// class NotInWarehousePackageList extends StatefulWidget {
//   final WareHouseModel warehouseModel;

//   const NotInWarehousePackageList({Key? key, required this.warehouseModel})
//       : super(key: key);

//   @override
//   NotInWarehousePackageListState createState() =>
//       NotInWarehousePackageListState();
// }

// class NotInWarehousePackageListState extends State<NotInWarehousePackageList> {
//   final GlobalKey<NotInWarehousePackageListState> key = GlobalKey();

//   int pageIndex = 0;

//   LocalizationModel? localizationInfo;

//   @override
//   void initState() {
//     super.initState();
//     localizationInfo =
//         Provider.of<Model>(context, listen: false).localizationInfo;
//   }

//   loadList({type}) async {
//     pageIndex = 0;
//     return await loadMoreList();
//   }

//   loadMoreList() async {
//     return await ParcelService.getList({
//       'status': ParcelStatus.forecast.id, // 未入库包裹
//       'warehouse_id': widget.warehouseModel.id,
//       'page': (++pageIndex),
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: BaseStylesConfig.bgGray,
//       child: ListRefresh(
//         renderItem: renderItem,
//         refresh: loadList,
//         more: loadMoreList,
//       ),
//     );
//   }

//   Widget renderItem(index, ParcelModel model) {
//     return ParcelItemCell(
//       model: model,
//       index: index,
//       localizationInfo: localizationInfo,
//     );
//   }
// }
