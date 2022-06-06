import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

/*
  包裹&订单
  订单中心
*/
class OrderCenterPage extends StatefulWidget {
  const OrderCenterPage({Key? key, arguments}) : super(key: key);

  @override
  OrderCenterState createState() => OrderCenterState();
}

class OrderCenterState extends State<OrderCenterPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //各类包裹统计
  UserOrderCountModel? userOrderCountModel;

  List<OrderModel> bottomOrdersList = [];
  int selectTab = 0;
  int pageIndex = 1;
  int totalPage = 999;
  bool isShowLoading = false;
  bool isloading = false;
  bool hasMoreDate = true;
  @override
  void initState() {
    super.initState();
    created();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (hasMoreDate) {
          _getMoreData(); // 当滑到最底部时调用
        }
      }
    });
    _getMoreData();
  }

  /*
    加载更多数据
   */
  _getMoreData() async {
    if (!isShowLoading) {
      var result = await OrderService.getList({
        'status': selectTab == 0
            ? '2'
            : selectTab == 1
                ? '4'
                : '51', // 待支付订单  4已发货 5已签收
        'page': (pageIndex),
        'size': '10',
      });
      setState(() {
        isShowLoading = true;
        if (pageIndex == 1) {
          bottomOrdersList.clear();
          totalPage = result['total'];
          bottomOrdersList = result['dataList'];
        } else {
          bottomOrdersList = bottomOrdersList + result['dataList'];
        }
        pageIndex++;
        isShowLoading = false;
        if (pageIndex > totalPage) {
          hasMoreDate = false;
        } else {
          hasMoreDate = true;
        }
      });
    }
  }

  /*
    初始化数据
   */
  created() async {
    EasyLoading.show();
    var token = await UserStorage.getToken();
    if (token.isNotEmpty) {
      userOrderCountModel = await UserService.getOrderDataCount();
      EasyLoading.dismiss();
    }
  }

  // 评价
  onComment(OrderModel model) async {
    var s = Routers.push('/OrderCommentPage', context, {'order': model});
    if (s != null) {
      _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Caption(
          str: '包裹&订单',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: RefreshIndicator(
        color: ColorConfig.themeRed,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: buildCellForFirstListView,
          controller: _scrollController,
          itemCount: 3,
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    created();
    setState(() {
      pageIndex = 1;
      isShowLoading = false;
      // gethomeData();
      _getMoreData();
    });
  }

  // ignore: missing_return
  Widget buildCellForFirstListView(BuildContext context, int index) {
    if (index == 0) {
      return buildButtonList(context);
    } else if (index == 1) {
      return buildSecondButtonList(context);
    } else if (index == 2) {
      return bottomOrdersList.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  height: 140,
                  width: 140,
                  child: LoadImage(
                    '',
                    fit: BoxFit.contain,
                    holderImg: "PackageAndOrder/暂无内容@3x",
                    format: "png",
                  ),
                ),
                Caption(
                  str: '目前还没有数据',
                  color: ColorConfig.textGrayC,
                )
              ],
            ))
          : buildBottomGrideView(bottomOrdersList);
    } else {
      return bottomOrdersList.isEmpty ? Container() : _buildProgressIndicator();
    }
  }

  Widget buildBottomGrideView(List date) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: date.length,
      itemBuilder: (context, index) => _getListData2(date, index),
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

  Widget _getListData2(List orderList, index) {
    OrderModel orderModel = orderList[index];
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
        if (orderModel.address.address != null &&
            orderModel.address.address!.isNotEmpty) {
          contentStr += ' ' + orderModel.address.address!;
        }
      } else {
        contentStr = orderModel.address.countryName +
            ' ' +
            orderModel.address.province +
            ' ' +
            orderModel.address.city;
        if (orderModel.address.address != null &&
            orderModel.address.address!.isNotEmpty) {
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
        statusStr = '待处理';
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
          if (orderModel.stationOrder!.status == 1) {
            statusStr = '已到自提点';
          } else if (orderModel.stationOrder!.status == 3) {
            statusStr = '自提点出库';
          } else if (orderModel.stationOrder!.status == 4) {
            statusStr = '自提签收';
          }
        }
        break;
      case 5:
        if (orderModel.stationOrder == null) {
          statusStr = '已签收';
        } else {
          if (orderModel.stationOrder!.status == 1) {
            statusStr = '已到自提点';
          } else if (orderModel.stationOrder!.status == 3) {
            statusStr = '自提点出库';
          } else if (orderModel.stationOrder!.status == 4) {
            statusStr = '自提签收';
          }
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

    LocalizationModel? localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return GestureDetector(
      onTap: () {
        //处理点击事件
        Routers.push('/OrderDetailPage', context, {'id': orderModel.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(width: 1, color: ColorConfig.line),
        ),
        margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
        padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
        height:
            selectTab == 0 && orderModel.status != 2 && orderModel.status != 12
                ? 165
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
                  color: selectTab == 0
                      ? ColorConfig.textRed
                      : selectTab == 1
                          ? ColorConfig.warningText
                          : ColorConfig.warningText,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
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
                          )
                          // RichText(
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //     text: TextSpan(children: <TextSpan>[
                          //       TextSpan(
                          //         text: orderModel.address.receiverName,
                          //         style: TextStyle(
                          //           color: ColorConfig.textBlack,
                          //           fontSize: 18.0,
                          //         ),
                          //       ),
                          //       TextSpan(
                          //         text: ' ',
                          //         style: TextStyle(
                          //           color: ColorConfig.textBlack,
                          //           fontSize: 18.0,
                          //         ),
                          //       ),
                          //       TextSpan(
                          //         text: orderModel.address.timezone +
                          //             '-' +
                          //             orderModel.address.phone,
                          //         style: TextStyle(
                          //           color: ColorConfig.textGray,
                          //           fontSize: 14.0,
                          //         ),
                          //       ),
                          //     ])),
                          ),
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
                                      (localizationInfo?.currencySymbol ?? '') +
                                      (totalValue / 100).toStringAsFixed(2)),
                              selectTab != 0
                                  ? Caption(
                                      fontSize: 16,
                                      color: ColorConfig.textRed,
                                      str: (localizationInfo?.currencySymbol ??
                                              '') +
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
            Container(
                margin: const EdgeInsets.only(top: 0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ([4, 5].contains(orderModel.status) &&
                            orderModel.isInvoice == 0)
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
                              margin: const EdgeInsets.only(right: 5, left: 5),
                              padding: const EdgeInsets.only(
                                  right: 0, left: 0, top: 5, bottom: 5),
                              child: const Caption(
                                  str: '申请开票', color: ColorConfig.textGrayC),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          selectTab == 0 &&
                                  (orderModel.status == 2 ||
                                      orderModel.status == 12)
                              ? GestureDetector(
                                  onTap: () {
                                    Routers.push('/OrderDetailPage', context,
                                        {'id': orderModel.id});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: ColorConfig.warningText,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 5, bottom: 5),
                                    child: Caption(
                                      str: orderModel.status == 2
                                          ? '去付款'
                                          : '重新付款',
                                    ),
                                  ),
                                )
                              : Container(),
                          selectTab == 1
                              ? GestureDetector(
                                  onTap: () {
                                    if (orderModel.boxes.isNotEmpty) {
                                      changeLoginType(orderModel);
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
                                    decoration: BoxDecoration(
                                        color: ColorConfig.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        border: Border.all(
                                            width: 0.3,
                                            color: ColorConfig.textGray)),
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 5, bottom: 5),
                                    child: const Caption(
                                      str: '查看物流',
                                    ),
                                  ),
                                )
                              : Container(),
                          selectTab == 1
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('请确认您已经收到货'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('取消'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('确定'),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  //签收包裹
                                                  bool signed =
                                                      await OrderService.signed(
                                                          orderModel.id);
                                                  if (signed) {
                                                    Util.showToast("签收成功");
                                                    _handleRefresh();
                                                    Routers.push(
                                                        '/SignSuccessPage',
                                                        context,
                                                        {'model': orderModel});
                                                  }
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
                                          Radius.circular(20.0)),
                                    ),
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 5, bottom: 5),
                                    child: const Caption(
                                      str: '确认收货',
                                    ),
                                  ),
                                )
                              : Container(),
                          selectTab == 2
                              ? Container(
                                  height: 40,
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: PlainButton(
                                    text: '评价有奖',
                                    borderColor: ColorConfig.warningText,
                                    onPressed: () {
                                      onComment(orderModel);
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  changeLoginType(OrderModel model) async {
    String result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: buildSubList(model),
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

  buildSubList(OrderModel model) {
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

  /*
  订单包裹等按钮列表
  */
  Widget buildButtonList(BuildContext context) {
    return Container(
      color: ColorConfig.white,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 4, //一行的Widget数量
            // childAspectRatio: 3 / 4,
          ), // 宽高比例
          itemCount: 8,
          itemBuilder: _buildGrideBtnViewFirst()),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnViewFirst() {
    List<String> listDesTitle = [
      '未入库',
      '已入库',
      '打包中',
      '待支付',
      '待发货',
      '已发货',
      '待评价',
      '异常件认领',
    ];
    List<String> listImg = [
      'PackageAndOrder/未入库@3x',
      'PackageAndOrder/已入库@3x',
      'PackageAndOrder/打包中@3x',
      'PackageAndOrder/待付款@3x',
      'PackageAndOrder/待发货@3x',
      'PackageAndOrder/已发货@3x',
      'PackageAndOrder/待评价@3x',
      'PackageAndOrder/异常件认领@3x',
    ];
    return (context, index) {
      String tipStr = '';
      switch (index) {
        case 0:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.waitStorage.toString()
              : '';
          break;
        case 1:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.alreadyStorage.toString()
              : '';
          break;
        case 2:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.waitPack.toString()
              : '';
          break;
        case 3:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.waitPay.toString()
              : '';
          break;
        case 4:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.waitTran.toString()
              : '';
          break;
        case 5:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.shipping.toString()
              : '';
          break;
        case 6:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.waitComment.toString()
              : '';
          break;
        case 7:
          tipStr = '';
          break;
        default:
      }
      return GestureDetector(
        onTap: () {
          if (index == 0) {
            Routers.push('/ForcastParcelListPage', context);
          } else if (index == 1) {
            Routers.push('/InWarehouseParcelListPage', context);
          } else if (index == 2) {
            Routers.push('/InPackParcelListPage', context);
          } else if (index == 3) {
            Routers.push('/OrderListPage', context, {'index': 1});
          } else if (index == 4) {
            Routers.push('/OrderListPage', context, {'index': 2});
          } else if (index == 5) {
            Routers.push('/OrderListPage', context, {'index': 3});
          } else if (index == 6) {
            Routers.push('/OrderListPage', context, {'index': 4});
          } else if (index == 7) {
            Routers.push('/NoOwnerParcelPage', context);
          }
        },
        child: Container(
          color: ColorConfig.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: 45,
                  width: 50,
                  alignment: Alignment.center,
                  child: LoadImage(
                    '',
                    fit: BoxFit.fitWidth,
                    width: 40,
                    height: 40,
                    holderImg: listImg[index],
                    format: "png",
                  ),
                ),
                tipStr.isNotEmpty && tipStr != '0'
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: ColorConfig.textRed,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 20,
                          width: 20,
                          child: Caption(
                            alignment: TextAlign.center,
                            str: tipStr,
                            fontSize: tipStr.length == 1 ? 14 : 12,
                            fontWeight: FontWeight.bold,
                            color: ColorConfig.white,
                          ),
                        ))
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: Container(),
                      )
              ]),
              Text(
                listDesTitle[index],
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      );
    };
  }

  /*
  待付款/已发货/待评价
  */
  Widget buildSecondButtonList(BuildContext context) {
    return Container(
      color: ColorConfig.bgGray,
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 3, //一行的Widget数量
            childAspectRatio: 3,
          ), // 宽高比例
          itemCount: 3,
          itemBuilder: _buildGrideBtnView()),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    List<String> listDesTitle = [
      '待付款',
      '已发货',
      '待评价',
    ];
    return (context, index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            bottomOrdersList.clear();
            selectTab = index;
            _handleRefresh();
          });
        },
        child: Container(
          color: ColorConfig.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Caption(
                str: listDesTitle[index],
              ),
              Gaps.vGap8,
              Container(
                height: 3,
                color: selectTab == index
                    ? ColorConfig.warningText
                    : ColorConfig.white,
                margin: const EdgeInsets.only(right: 30, left: 30),
              )
            ],
          ),
        ),
      );
    };
  }

  /*
  标题Cell
  */
  Widget buildTitleCell(BuildContext context) {
    return Container(
      height: 0,
    );
  }

  // 加载更多 Widget
  Widget _buildProgressIndicator() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
        child: Opacity(
            opacity: 1.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                hasMoreDate
                    ? const SpinKitChasingDots(
                        color: Colors.blueAccent, size: 26.0)
                    : Container(),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: hasMoreDate
                        ? const Text('正在加载中...')
                        : const Text('到底了~~'))
              ],
            )));
  }
}
