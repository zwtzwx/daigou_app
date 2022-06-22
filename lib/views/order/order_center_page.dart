import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiyun_app_client/views/order/widget/order_item_cell.dart';

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

    ApplicationEvent.getInstance().event.on<ListRefreshEvent>().listen((event) {
      if (event.type == 'refresh') {
        _handleRefresh();
      }
    });
  }

  /*
    加载更多数据
   */
  _getMoreData() async {
    if (!isShowLoading) {
      var result = await OrderService.getList({
        'status': selectTab == 0
            ? '1'
            : selectTab == 1
                ? '2'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '包裹&订单', listen: false),
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
                    holderImg: "Home/empty",
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
    return OrderItemCell(
      orderModel: orderModel,
    );
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
      '待处理',
      '待支付',
      '待发货',
      '已发货',
      '已签收',
      '异常件认领',
    ];
    List<String> listImg = [
      'PackageAndOrder/undone-icon',
      'PackageAndOrder/done-icon',
      'PackageAndOrder/process-icon',
      'PackageAndOrder/unpaid-icon',
      'PackageAndOrder/unship-icon',
      'PackageAndOrder/ship-icon',
      'PackageAndOrder/sign-icon',
      'PackageAndOrder/abnormal-icon',
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
            Routers.push('/OrderListPage', context, {'index': 1});
          } else if (index == 3) {
            Routers.push('/OrderListPage', context, {'index': 2});
          } else if (index == 4) {
            Routers.push('/OrderListPage', context, {'index': 3});
          } else if (index == 5) {
            Routers.push('/OrderListPage', context, {'index': 4});
          } else if (index == 6) {
            Routers.push('/OrderListPage', context, {'index': 5});
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
      '待处理',
      '待支付',
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
                    ? ColorConfig.primary
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
