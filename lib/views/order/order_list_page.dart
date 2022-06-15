// ignore_for_file: unnecessary_new

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/provider/data_index_proivder.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/order/widget/order_item_cell.dart';
import 'package:provider/provider.dart';

/*
  订单列表
*/
class OrderListPage extends StatefulWidget {
  final Map arguments;

  const OrderListPage({Key? key, required this.arguments}) : super(key: key);

  @override
  OrderListPageState createState() => OrderListPageState();
}

class OrderListPageState extends State<OrderListPage> {
  LocalizationModel? localizationInfo;
  int pageIndex = 0;
  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    getPageTitle();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      'status': widget.arguments['index'], // 待处理订单
      'page': (++pageIndex),
    };
    var data = await OrderService.getList(dic);
    return data;
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
          str: pageTitle,
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SafeArea(
        child: ListRefresh(
          renderItem: renderItem,
          refresh: loadList,
          more: loadMoreList,
        ),
      ),
    );
  }

  Widget renderItem(int index, OrderModel orderModel) {
    return OrderItemCell(
      orderModel: orderModel,
    );
  }

  void getPageTitle() {
    String _pageTitle;
    switch (widget.arguments['index']) {
      case 1:
        _pageTitle = '待处理订单';
        break;
      case 2:
        _pageTitle = '待支付订单';
        break;
      case 3:
        _pageTitle = '待发货订单';
        break;
      case 4:
        _pageTitle = '已发货订单';
        break;
      default:
        _pageTitle = '已签收订单';
        break;
    }
    setState(() {
      pageTitle = _pageTitle;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// 订单列表
class OrderListItem extends StatefulWidget {
  final ValueChanged<int>? onChanged;
  final Map<String, dynamic> params;

  const OrderListItem({
    Key? key,
    required this.params,
    this.onChanged,
  }) : super(key: key);

  @override
  OrderListItemState createState() => OrderListItemState();
}

class OrderListItemState extends State<OrderListItem> {
  final GlobalKey<OrderListItemState> key = GlobalKey();

  int pageIndex = 0;
  int selectTab = 0;
  bool isloading = false;
  LocalizationModel? localizationInfo;
  List<bool> selectList = [];

  @override
  void initState() {
    super.initState();
    selectTab = widget.params['type'];
    // loadList();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    String status = '';
    switch (selectTab) {
      case 0:
        status = '';
        break;
      case 1:
        // 待付款
        status = OrderStatus.waitPay.id.toString();
        break;
      case 2:
        // 待发货
        status = OrderStatus.readyShip.id.toString();
        break;
      case 3:
        // 已发货
        status = OrderStatus.shipping.id.toString();
        break;
      case 4:
        // 待评价
        status = OrderStatus.waitComment.id.toString();
        break;
      default:
    }
    Map<String, dynamic> dic = {
      'status': status, // 待处理订单
      'page': (++pageIndex),
      'size': '10',
    };
    var data = await OrderService.getList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: renderItem,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  /*
    呈现行
   */
  Widget renderItem(index, OrderModel orderModel) {
    String contentStr = '';
    if (orderModel.address.id != null) {
      if (orderModel.address.area != null) {
        if (orderModel.address.area != null) {
          contentStr = orderModel.address.countryName +
              ' ' +
              orderModel.address.area!.name;
        }
        if (orderModel.address.subArea != null) {
          contentStr += ' ' + orderModel.address.subArea!.name;
        }
        if (orderModel.address.address != null) {
          contentStr += ' ' + orderModel.address.address!;
        }
      } else {
        contentStr = orderModel.address.countryName +
            ' ' +
            orderModel.address.province +
            ' ' +
            orderModel.address.city;
        if (orderModel.address.address != null) {
          contentStr += ' ' + orderModel.address.address!;
        }
      }
    }
    double addressHeight = calculateTextHeight(
        contentStr, 16.0, FontWeight.w400, ScreenUtil().screenWidth - 145, 2);
    String statusStr = '';
    //1 待处理 2待付款 3待发货 4已发货5已签收11审核中12审核失败
    switch (orderModel.status) {
      case 1:
        statusStr = '打包中';
        break;
      case 2:
        statusStr = '待支付';
        break;
      case 3:
        statusStr = '待发货';
        break;
      case 4:
        if (orderModel.stationOrder == null) {
          statusStr = '已发货';
        } else {
          if (orderModel.stationOrder?.status == 1) {
            statusStr = '已到自提点';
          } else if (orderModel.stationOrder?.status == 3) {
            statusStr = '自提点出库';
          } else if (orderModel.stationOrder?.status == 4) {
            statusStr = '自提签收';
          }
        }
        break;
      case 5:
        if (orderModel.stationOrder == null) {
          statusStr = '待评价';
        } else {
          if (orderModel.stationOrder?.status == 1) {
            statusStr = '已到自提点';
          } else if (orderModel.stationOrder?.status == 3) {
            statusStr = '自提点出库';
          } else if (orderModel.stationOrder?.status == 4) {
            statusStr = '自提签收';
          }
        }
        if (orderModel.evaluated == 1) {
          statusStr = '已完成';
        }
        break;
      case 11:
        statusStr = '审核中';
        break;
      case 12:
        statusStr = '审核失败';
        break;
      default:
    }
    // 申报价格 所有包裹价值总和
    double totalValue = 0.0;
    for (ParcelModel item in orderModel.packages) {
      totalValue += item.packageValue!;
    }
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        // Routers.push('/goodsDetailPage', context, {"goodsId": productGoods.id});
        Routers.push('/OrderDetailPage', context, {'id': orderModel.id});
      },
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          border: new Border.all(width: 1, color: ColorConfig.line),
        ),
        margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
        padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
        height: orderModel.status == 3 ||
                orderModel.status == 1 ||
                orderModel.status == 11
            ? 150
            : 205,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Caption(
                  str: '订单号：' + orderModel.orderSn,
                ),
                Caption(
                  str: statusStr,
                  color: ColorConfig.warningTextDark,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: 80,
                  width: 80,
                  color: Colors.white,
                  child: const LoadImage(
                    '',
                    fit: BoxFit.contain,
                    holderImg: "PackageAndOrder/defalutIMG@3x",
                    format: "png",
                  ),
                ),
                Container(
                  height: 110,
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(left: 5, top: 5),
                          height: 20,
                          alignment: Alignment.centerLeft,
                          width: ScreenUtil().screenWidth - 150,
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 80,
                                alignment: Alignment.bottomLeft,
                                child: Caption(
                                  str: orderModel.address.receiverName,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Gaps.hGap5,
                              Container(
                                height: 20,
                                width: ScreenUtil().screenWidth - 235,
                                alignment: Alignment.bottomLeft,
                                child: Caption(
                                  fontSize: 14,
                                  str: orderModel.address.timezone +
                                      '-' +
                                      orderModel.address.phone,
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, top: 5),
                          height: addressHeight,
                          alignment: Alignment.centerLeft,
                          width: ScreenUtil().screenWidth - 150,
                          child: Caption(
                            str: contentStr,
                            lines: 2,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, top: 5),
                          height: 20,
                          alignment: Alignment.centerLeft,
                          width: ScreenUtil().screenWidth - 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                  fontSize: 14,
                                  color: ColorConfig.textGray,
                                  str: '申报价值：' +
                                      localizationInfo!.currencySymbol +
                                      (totalValue / 100).toStringAsFixed(2)),
                              orderModel.status > 2
                                  ? Caption(
                                      fontSize: 16,
                                      color: ColorConfig.textRed,
                                      str: localizationInfo!.currencySymbol +
                                          (orderModel.discountPaymentFee / 100)
                                              .toStringAsFixed(2))
                                  : Container()
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
            orderModel.status != 3 && orderModel.status != 1
                ? Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        [4, 5].contains(orderModel.status) &&
                                orderModel.isInvoice == 0
                            ? GestureDetector(
                                onTap: () async {
                                  var s = await Navigator.pushNamed(
                                      context, '/InvoicePage',
                                      arguments: {'orderModel': orderModel});
                                  if (s == null) {
                                    return;
                                  }
                                  if (s == 'confirm') {
                                    setState(() {
                                      orderModel.isInvoice = 1;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.only(right: 5, left: 5),
                                  padding: const EdgeInsets.only(
                                      right: 0, left: 0, top: 5, bottom: 5),
                                  child: const Caption(
                                      str: '申请开票',
                                      color: ColorConfig.textGrayC),
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            orderModel.status == 2 || orderModel.status == 12
                                ? GestureDetector(
                                    onTap: () {
                                      Routers.push('/OrderDetailPage', context,
                                          {'id': orderModel.id});
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: new BoxDecoration(
                                          color: ColorConfig.warningText,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0)),
                                          border: new Border.all(
                                              width: 1,
                                              color: ColorConfig.warningText)),
                                      margin: const EdgeInsets.only(
                                          right: 0, left: 10),
                                      padding: const EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: Caption(
                                        str: orderModel.status == 2
                                            ? '去付款'
                                            : '重新付款',
                                      ),
                                    ),
                                  )
                                : Container(),
                            orderModel.status == 4
                                ? GestureDetector(
                                    onTap: () {
                                      if (orderModel.boxes.isNotEmpty) {
                                        viewTrackingHistory(orderModel);
                                      } else {
                                        Routers.push(
                                            '/TrackingDetailPage',
                                            context,
                                            {"order_sn": orderModel.orderSn});
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: new BoxDecoration(
                                          color: ColorConfig.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0)),
                                          border: new Border.all(
                                              width: 0.3,
                                              color: ColorConfig.textGray)),
                                      margin: const EdgeInsets.only(
                                          right: 0, left: 10),
                                      padding: const EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: const Caption(
                                        str: '查看物流',
                                      ),
                                    ),
                                  )
                                : Container(),
                            orderModel.status == 4
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('请确认您已经收到货'),
                                              actions: <Widget>[
                                                new TextButton(
                                                  child: const Text('取消'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    print('取消');
                                                  },
                                                ),
                                                new TextButton(
                                                  child: const Text('确定'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(
                                                        signPackage(
                                                            orderModel));
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          color: ColorConfig.warningText,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      margin: const EdgeInsets.only(
                                          right: 0, left: 10),
                                      padding: const EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: const Caption(
                                        str: '确认收货',
                                      ),
                                    ),
                                  )
                                : Container(),
                            orderModel.status == 5
                                ? orderModel.evaluated != 1
                                    ? Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: PlainButton(
                                          text: '评价有奖',
                                          borderColor: ColorConfig.warningText,
                                          onPressed: () {
                                            Routers.push('/OrderCommentPage',
                                                context, {'order': orderModel});
                                          },
                                        ),
                                      )
                                    : Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: PlainButton(
                                          text: '查看评价',
                                          onPressed: () {
                                            Routers.push(
                                                '/OrderCommentPage', context, {
                                              'order': orderModel,
                                              'detail': true
                                            });
                                          },
                                        ),
                                      )
                                : Container(),
                          ],
                        ),
                      ],
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  double calculateTextHeight(String value, fontSize, FontWeight fontWeight,
      double maxWidth, int maxLines) {
    // value = filterText(value);
    TextPainter painter = TextPainter(
        // ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        // locale: Localizations.localeOf(GlobalStatic.context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }

  /*
    签收包裹
   */
  signPackage(OrderModel orderModel) async {
    if (await OrderService.signed(orderModel.id)) {
      Util.showToast("签收成功");
      loadMoreList();
      Routers.push('/SignSuccessPage', context, {'model': orderModel});
    } else {
      Util.showToast("签收失败");
    }
  }

  /*
    查看物流轨迹
   */
  viewTrackingHistory(OrderModel model) async {
    String result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: buildSubOrderList(model),
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

  /*
    子订单选项
   */
  buildSubOrderList(OrderModel model) {
    List<Widget> list = [];
    for (var i = 0; i < model.boxes.length; i++) {
      ParcelBoxModel boxModel = model.boxes[i];
      var view = CupertinoActionSheetAction(
        child: Caption(
          str: '子订单-$i',
        ),
        onPressed: () {
          Navigator.of(context).pop(boxModel.logisticsSn);
        },
      );
      list.add(view);
    }
    return list;
  }
}
