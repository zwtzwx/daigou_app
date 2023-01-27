import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/order_model.dart';
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
        Routers.push(Routers.orderDetail, {'id': orderModel.id});
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
                    Sized.hGap5,
                    ZHTextLine(
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
                              child: ZHTextLine(
                                str: '订单异常'.ts,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Sized.empty,
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
                      Sized.vGap20,
                      ZHTextLine(
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
                        Sized.vGap4,
                        ZHTextLine(
                          str: Util.getOrderStatusName(
                              orderModel.status, orderModel.stationOrder),
                          color: BaseStylesConfig.primary,
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
                      Sized.vGap20,
                      ZHTextLine(
                        str: orderModel.address.countryName,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Sized.line,
            Sized.vGap15,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str:
                        '${orderModel.address.receiverName} ${orderModel.address.timezone} ${orderModel.address.phone}',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Sized.vGap4,
                ZHTextLine(
                  str: (orderModel.address.address != null &&
                          orderModel.address.address!.isNotEmpty)
                      ? orderModel.address.address!
                      : '${orderModel.address.area != null ? '${orderModel.address.area!.name} ' : ''}${orderModel.address.subArea != null ? '${orderModel.address.subArea!.name} ' : ''}${orderModel.address.street} ${orderModel.address.doorNo} ${orderModel.address.city}',
                  lines: 4,
                ),
                Sized.vGap4,
                ZHTextLine(
                  str: orderModel.station != null
                      ? '${'自提收货'.ts}-${orderModel.station!.name}'
                      : '送货上门'.ts,
                  fontSize: 14,
                ),
                Sized.vGap4,
                [3, 4, 5].contains(orderModel.status)
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ZHTextLine(
                              str: '${'物流单号'.ts}：${orderModel.logisticsSn}',
                            ),
                            Sized.hGap10,
                            orderModel.logisticsSn.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                              text: orderModel.logisticsSn))
                                          .then((value) =>
                                              EasyLoading.showSuccess(
                                                  '复制成功'.ts));
                                    },
                                    child: ZHTextLine(
                                      str: '复制'.ts,
                                      color: BaseStylesConfig.primary,
                                    ),
                                  )
                                : Sized.empty
                          ],
                        ),
                      )
                    : Sized.empty,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ZHTextLine(
                      str: '${'提交时间'.ts}：${orderModel.createdAt}',
                      fontSize: 13,
                      color: BaseStylesConfig.textGray,
                    ),
                    ZHTextLine(
                      str: orderModel.paymentTypeName,
                      fontSize: 13,
                      color: orderModel.onDeliveryStatus != 0
                          ? BaseStylesConfig.textRed
                          : BaseStylesConfig.textBlack,
                    )
                  ],
                )
              ],
            ),
            Sized.vGap10,
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
        [4, 5].contains(orderModel.status)
            ? PlainButton(
                text: '查看物流',
                onPressed: () {
                  if (orderModel.boxes.isNotEmpty) {
                    BaseDialog.showBoxsTracking(context, orderModel);
                  } else {
                    Routers.push(Routers.orderTracking,
                        {"order_sn": orderModel.orderSn});
                  }
                },
              )
            : Sized.empty,
        orderModel.status == 4
            ? Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: MainButton(
                    text: '确认收货',
                    onPressed: () {
                      onSign(context);
                    },
                  ),
                ),
              )
            : Sized.empty,
      ],
    );
  }

  // 异常件说明
  void onExceptional(context) async {
    var result = await OrderService.getOrderExceptional(orderModel.id);
    if (result != null) {
      BaseDialog.normalDialog(
        context,
        title: '异常说明'.ts,
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
                  : Sized.empty,
            ],
          ),
        ),
      );
    }
  }

  // 签收
  void onSign(BuildContext context) async {
    var data = await BaseDialog.confirmDialog(context, '${'您确定要签收吗'.ts}？');
    if (data != null) {
      int id = orderModel.id;
      EasyLoading.show();
      var result = await OrderService.signed(id);
      EasyLoading.dismiss();
      if (result['ok']) {
        Util.showToast('签收成功'.ts);
        ApplicationEvent.getInstance()
            .event
            .fire(ListRefreshEvent(type: 'refresh'));
      } else {
        Util.showToast(result['msg']);
      }
    }
  }
}
