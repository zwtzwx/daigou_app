import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class OrderItemCell extends StatelessWidget {
  const OrderItemCell({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
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
                    const LoadImage(
                      'PackageAndOrder/process',
                      width: 25,
                      height: 25,
                    ),
                    Gaps.hGap5,
                    Caption(
                      str: orderModel.orderSn,
                    ),
                  ],
                ),
                Row(
                  children: [
                    orderModel.exceptional == 1 && orderModel.status != 5
                        ? GestureDetector(
                            onTap: () {
                              onExceptional(context);
                            },
                            child: Container(
                              color: Colors.red[700],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              child: const Caption(
                                str: '订单异常',
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Gaps.empty,
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ),
                  ],
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
                [3, 4, 5].contains(orderModel.status)
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Caption(
                              str: '物流单号：${orderModel.logisticsSn}',
                            ),
                            Gaps.hGap10,
                            orderModel.logisticsSn.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                              text: orderModel.logisticsSn))
                                          .then((value) =>
                                              EasyLoading.showSuccess('复制成功'));
                                    },
                                    child: const Caption(
                                      str: '复制',
                                      color: ColorConfig.primary,
                                    ),
                                  )
                                : Gaps.empty
                          ],
                        ),
                      )
                    : Gaps.empty,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Caption(
                      str: '提交时间：${orderModel.createdAt}',
                      fontSize: 13,
                      color: ColorConfig.textGray,
                    ),
                    Caption(
                      str: orderModel.paymentTypeName,
                      fontSize: 13,
                      color: orderModel.onDeliveryStatus != 0
                          ? ColorConfig.textRed
                          : ColorConfig.textBlack,
                    )
                  ],
                )
              ],
            ),
            Gaps.vGap10,
            _buildOrderBtns(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderBtns(BuildContext context) {
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
                  text: (orderModel.status == 2 ||
                          orderModel.onDeliveryStatus == 1)
                      ? '去付款'
                      : '重新支付',
                  onPressed: () {
                    var s = Routers.push('/OrderPayPage', context, {
                      'id': orderModel.id,
                      'payModel': 1,
                      'deliveryStatus': orderModel.onDeliveryStatus,
                    });
                    if (s != null) {
                      ApplicationEvent.getInstance()
                          .event
                          .fire(ListRefreshEvent(type: 'refresh'));
                    }
                  },
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
                  MainButton(
                    text: '去付款',
                    onPressed: () {
                      Routers.push(
                          '/OrderPayPage', context, {'id': orderModel.id});
                    },
                  ),
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
                    _boxsTracking(context);
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
                child: MainButton(
                  text: '确认收货',
                  onPressed: () {
                    onSign(context);
                  },
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

  // 异常件说明
  void onExceptional(context) async {
    var result = await OrderService.getOrderExceptional(orderModel.id);
    if (result != null) {
      BaseDialog.normalDialog(
        context,
        title: '异常说明',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.remark,
              ),
              result.images.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: LoadImage(
                        result.images[0],
                        fit: BoxFit.fitWidth,
                        width: 100,
                      ),
                    )
                  : Gaps.empty,
            ],
          ),
        ),
      );
    }
  }

  // 签收
  void onSign(BuildContext context) async {
    var data = await BaseDialog.confirmDialog(context, '您确定要签收吗？');
    if (data != null) {
      int id = orderModel.id;
      EasyLoading.show();
      var result = await OrderService.signed(id);
      EasyLoading.dismiss();
      if (result['ok']) {
        Util.showToast("签收成功");
        ApplicationEvent.getInstance()
            .event
            .fire(ListRefreshEvent(type: 'refresh'));
      } else {
        Util.showToast(result['msg']);
      }
    }
  }

// 多箱物流
  void _boxsTracking(BuildContext context) async {
    String result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: _buildSubList(context),
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
      Routers.push(
          '/TrackingDetailPage', context, {"order_sn": orderModel.orderSn});
    } else {
      Routers.push('/TrackingDetailPage', context, {"order_sn": result});
    }
  }

  _buildSubList(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < orderModel.boxes.length; i++) {
      ParcelBoxModel boxModel = orderModel.boxes[i];
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
}
