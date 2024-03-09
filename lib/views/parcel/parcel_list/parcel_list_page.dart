/*
  未入库包裹
*/

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/list_refresh_event.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/parcel_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/parcel_service.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/order/center/order_center_controller.dart';
import 'package:shop_app_client/views/parcel/widget/parcel_item_cell.dart';

class ParcelListWidget extends StatefulWidget {
  const ParcelListWidget({
    Key? key,
    required this.status,
  }) : super(key: key);
  final int status;

  @override
  State<ParcelListWidget> createState() => _ParcelListWidgetState();
}

class _ParcelListWidgetState extends State<ParcelListWidget> {
  int pageIndex = 0;
  final controller = Get.find<BeeOrderIndexLogic>();

  loadList({type}) async {
    pageIndex = 0;
    controller.allParcels.clear();
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await ParcelService.getList({
      'status': widget.status,
      'page': (++pageIndex),
      'keyword': controller.keyword,
    });
    if (data['dataList'] is List) {
      controller.allParcels.addAll((data['dataList'] as List<ParcelModel>));
    }
    return data;
  }

  // 删除包裹
  onDeleteParcel(int id, int index) async {
    controller.showLoading();
    var res = await ParcelService.delete(id);
    controller.hideLoading();
    if (res) {
      controller.showToast('删除包裹成功');
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'delete', index: index));
      Get.find<AppStore>().getBaseCountInfo();
    } else {
      controller.showToast('删除包裹失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshView(
      renderItem: renderItem,
      refresh: loadList,
      more: loadMoreList,
      emptyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LoadAssetImage(
            'Transport/parcel_empty',
            fit: BoxFit.fitWidth,
            width: 200.w,
          ),
          10.verticalSpaceFromWidth,
          Container(
            constraints: BoxConstraints(maxWidth: 270.w),
            child: AppText(
              str: '订单支付成功后，订单将进入我的包裹，我们将安排运输您的产品。自行购物的商品，给我们提供快递单号，后续将由我们为您服务。'
                  .inte,
              fontSize: 12,
              color: AppStyles.textGrayC9,
              alignment: TextAlign.center,
              lineHeight: 1.8,
              lines: 10,
            ),
          ),
          25.verticalSpaceFromWidth,
          SizedBox(
            height: 35.h,
            width: 265.w,
            child: BeeButton(
              text: '立即预报',
              onPressed: () {
                GlobalPages.redirect(GlobalPages.forecast);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget renderItem(index, ParcelModel model) {
    return BeePackageItem(
      model: model,
      index: index,
      checkedIds: controller.checkedIds,
      onChecked: controller.onChecked,
      localModel: controller.localModel,
      onDeleteParcel: () {
        onDeleteParcel(model.id!, index);
      },
    );
  }
}
