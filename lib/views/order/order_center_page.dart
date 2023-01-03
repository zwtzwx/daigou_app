import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    getDatas();

    ApplicationEvent.getInstance().event.on<ListRefreshEvent>().listen((event) {
      if (event.type == 'refresh') {
        _handleRefresh();
      }
    });
  }

  getDatas() async {
    EasyLoading.show();
    var token = await UserStorage.getToken();
    EasyLoading.dismiss();
    if (token.isNotEmpty) {
      var countData = await UserService.getOrderDataCount();
      setState(() {
        userOrderCountModel = countData;
      });
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
        title: ZHTextLine(
          str: Translation.t(context, '我的包裹', listen: false),
          color: ColorConfig.textBlack,
          fontSize: 18,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: RefreshIndicator(
        color: ColorConfig.themeRed,
        child: buildButtonList(),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    getDatas();
  }

  /*
  订单包裹等按钮列表
  */
  Widget buildButtonList() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConfig.white,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 3, //一行的Widget数量
            childAspectRatio: 5 / 4,
          ), // 宽高比例
          itemCount: 6,
          itemBuilder: _buildGrideBtnViewFirst()),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnViewFirst() {
    List<String> listDesTitle = [
      '未入库',
      '已入库',
      '待发货',
      '已发货',
      '已签收',
      '异常件认领',
    ];
    List<String> listImg = [
      'PackageAndOrder/wrk-icon',
      'PackageAndOrder/yiruku-icon',
      'PackageAndOrder/daifahuo-icon',
      'PackageAndOrder/yifahuo-icon',
      'PackageAndOrder/yiqianshou-icon',
      'PackageAndOrder/yicj-icon',
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
              ? userOrderCountModel!.waitTran.toString()
              : '';
          break;
        case 3:
          tipStr = userOrderCountModel != null
              ? userOrderCountModel!.shipping.toString()
              : '';
          break;
        case 4:
        case 5:
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
            Routers.push('/OrderListPage', context, {'index': 3});
          } else if (index == 3) {
            Routers.push('/OrderListPage', context, {'index': 4});
          } else if (index == 4) {
            Routers.push('/OrderListPage', context, {'index': 5});
          } else if (index == 5) {
            Routers.push('/NoOwnerParcelPage', context);
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  LoadImage(
                    listImg[index],
                    fit: BoxFit.fitWidth,
                    width: 50,
                    height: 50,
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
                            child: ZHTextLine(
                              alignment: TextAlign.center,
                              str: tipStr,
                              fontSize: tipStr.length == 1 ? 14 : 12,
                              fontWeight: FontWeight.bold,
                              color: ColorConfig.white,
                            ),
                          ))
                      : Gaps.empty,
                ],
              ),
              ZHTextLine(
                str: Translation.t(context, listDesTitle[index]),
                lines: 5,
                alignment: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    };
  }
}
