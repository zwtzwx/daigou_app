import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

// ignore: non_constant_identifier_names
Widget OrderItemCell(BuildContext context, OrderModel orderModel) {
  return GestureDetector(
    onTap: () {
      Routers.push('/OrderDetailPage', context, {'id': orderModel.id});
    },
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Caption(
                    str: orderModel.orderSn,
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Container(
                        color: const Color(0xFF9bbf4d),
                        width: 8,
                        height: 8,
                      ),
                    ),
                    Gaps.vGap20,
                    Caption(
                      str: orderModel.warehouse.warehouseName!,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                  ),
                  child: Column(
                    children: [
                      const LoadImage(
                        'PackageAndOrder/fly',
                        width: 24,
                        height: 24,
                      ),
                      Gaps.vGap4,
                      Caption(
                        str: Util.getOrderStatusName(
                            orderModel.status, orderModel.stationOrder),
                        color: ColorConfig.primary,
                        fontSize: 14,
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    ClipOval(
                      child: Container(
                        color: const Color(0xFFff4326),
                        width: 8,
                        height: 8,
                      ),
                    ),
                    Gaps.vGap20,
                    Caption(
                      str: orderModel.address.countryName,
                    )
                  ],
                ),
              ],
            ),
          ),
          Gaps.line,
          Gaps.vGap15,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Caption(
                  str:
                      '${orderModel.address.receiverName} ${orderModel.address.timezone} ${orderModel.address.phone}',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Gaps.vGap4,
              Caption(
                str:
                    '${orderModel.address.area != null ? '${orderModel.address.area!.name} ' : ''}${orderModel.address.subArea != null ? '${orderModel.address.subArea!.name} ' : ''}${orderModel.address.street} ${orderModel.address.doorNo} ${orderModel.address.city}',
                lines: 2,
              ),
              Gaps.vGap4,
              Caption(
                str: orderModel.station != null
                    ? '自提收货-${orderModel.station!.name}'
                    : '送货上门',
                fontSize: 14,
              ),
              Gaps.vGap4,
              Caption(
                str: '提交时间：${orderModel.createdAt}',
                fontSize: 13,
                color: ColorConfig.textGray,
              ),
            ],
          ),
          Gaps.vGap10,
          _buildOrderBtns(context, orderModel),
        ],
      ),
    ),
  );
}

Widget _buildOrderBtns(BuildContext context, OrderModel orderModel) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      orderModel.status == 11
          ? const Caption(
              str: '等待客服确认支付',
              fontSize: 14,
              color: ColorConfig.textRed,
            )
          : Gaps.empty,
      [2, 12].contains(orderModel.status) &&
              orderModel.onDeliveryStatus != 11 &&
              orderModel.groupMode == 0
          ? Container(
              margin: const EdgeInsets.only(left: 10),
              child: MainButton(
                text:
                    (orderModel.status == 2 || orderModel.onDeliveryStatus == 1)
                        ? '去付款'
                        : '重新支付',
              ),
            )
          : Gaps.empty,
      [2, 12].contains(orderModel.status) &&
              orderModel.groupMode != 0 &&
              orderModel.isLeaderOrder
          ? Expanded(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Caption(
                  str: '该团购单为团长代款,请您及时付款',
                  fontSize: 14,
                  color: ColorConfig.textRed,
                ),
                MainButton(text: '去付款'),
              ],
            ))
          : Gaps.empty,
      [2, 12].contains(orderModel.status) &&
              orderModel.groupMode != 0 &&
              !orderModel.isLeaderOrder
          ? const Caption(
              str: '该团购单为团长代款,您无需支付',
              fontSize: 14,
              color: ColorConfig.textRed,
            )
          : Gaps.empty,
      [4, 5].contains(orderModel.status)
          ? PlainButton(
              text: '查看物流',
              onPressed: () {
                if (orderModel.boxes.isNotEmpty) {
                  _boxsTracking(context, orderModel);
                } else {
                  Routers.push('/TrackingDetailPage', context,
                      {"order_sn": orderModel.orderSn});
                }
              },
            )
          : Gaps.empty,
      orderModel.status == 4
          ? Container(
              padding: const EdgeInsets.only(left: 10),
              child: const MainButton(
                text: '确认收货',
                onPressed: onSign,
              ),
            )
          : Gaps.empty,
      orderModel.status == 5 && orderModel.evaluated == 0
          ? Container(
              padding: const EdgeInsets.only(left: 10),
              child: MainButton(
                text: '我要评价',
                onPressed: () {
                  var s = Routers.push(
                      '/OrderCommentPage', context, {'order': orderModel});
                  if (s != null) {
                    ApplicationEvent.getInstance()
                        .event
                        .fire(ListRefreshEvent(type: 'refresh'));
                  }
                },
              ),
            )
          : Gaps.empty,
      orderModel.status == 5 && orderModel.evaluated == 1
          ? Container(
              padding: const EdgeInsets.only(left: 10),
              child: MainButton(
                text: '查看评价',
                onPressed: () {
                  Routers.push('/OrderCommentPage', context,
                      {'order': orderModel, 'detail': true});
                },
              ),
            )
          : Gaps.empty,
    ],
  );
}

// 签收
void onSign(BuildContext context, int id) async {
  if (await OrderService.signed(id)) {
    Util.showToast("签收成功");
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
  } else {
    Util.showToast("签收失败");
  }
}

// 多箱物流
void _boxsTracking(BuildContext context, OrderModel model) async {
  String result = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: _buildSubList(context, model),
          cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop('cancel');
            },
          ),
        );
      });
  if (result == 'cancel') {
    return;
  }
  if (result.isEmpty) {
    Routers.push('/TrackingDetailPage', context, {"order_sn": model.orderSn});
  } else {
    Routers.push('/TrackingDetailPage', context, {"order_sn": result});
  }
}

_buildSubList(BuildContext context, OrderModel model) {
  List<Widget> list = [];
  for (var i = 0; i < model.boxes.length; i++) {
    ParcelBoxModel boxModel = model.boxes[i];
    var view = CupertinoActionSheetAction(
      child: Caption(
        str: '子订单-' '${i + 1}',
      ),
      onPressed: () {
        Navigator.of(context)
            .pop(boxModel.logisticsSn.isEmpty ? '' : boxModel.logisticsSn);
      },
    );
    list.add(view);
  }
  return list;
}
