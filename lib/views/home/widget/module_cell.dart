// ignore_for_file: non_constant_identifier_names

/*
  专属收货员、包裹、订单入口
  */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class ModuleCell extends StatefulWidget {
  const ModuleCell({Key? key}) : super(key: key);

  @override
  State<ModuleCell> createState() => _ModuleCellState();
}

class _ModuleCellState extends State<ModuleCell> {
  // 专属收货人
  String? receiver;
  UserOrderCountModel? userOrderCountModel;

  @override
  void initState() {
    super.initState();
    getWarehouse();
    getOrderCount();
    ApplicationEvent.getInstance().event.on<HomeRefreshEvent>().listen((event) {
      getWarehouse();
      getOrderCount();
    });
    ApplicationEvent.getInstance()
        .event
        .on<OrderCountRefreshEvent>()
        .listen((event) {
      getOrderCount();
    });
  }

  // 默认仓库
  void getWarehouse() async {
    var data = await WarehouseService.getDefaultWarehouse();
    setState(() {
      receiver = data?.receiverName;
    });
  }

  // 包裹、订单数量
  void getOrderCount() async {
    var token = await UserStorage.getToken();
    if (token.isNotEmpty) {
      var data = await UserService.getOrderDataCount();
      setState(() {
        userOrderCountModel = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildReceiverView(),
        Gaps.vGap15,
        buildOrderView(),
      ],
    );
  }

  // 收货员
  buildReceiverView() {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: 10, top: ScreenUtil().setHeight(145)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const LoadImage(
                'Help/home-user',
                width: 33,
                height: 33,
              ),
              Gaps.hGap10,
              Caption(
                str: Translation.t(context, '专属收货员', listen: true) +
                    '：${receiver ?? ''}',
              )
            ],
          ),
          MainButton(
            text: Translation.t(context, '开始集运'),
            backgroundColor: const Color(0xFFF74055),
            onPressed: () {
              ApplicationEvent.getInstance()
                  .event
                  .fire(ChangePageIndexEvent(pageName: 'middle'));
            },
          ),
        ],
      ),
    );
  }

  /*
  订单包裹等按钮列表
  */
  Widget buildOrderView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0.0, //水平子Widget之间间距
          mainAxisSpacing: 0.0, //垂直子Widget之间间距
          crossAxisCount: 4, //一行的Widget数量
          // childAspectRatio: 3 / 4,
        ), // 宽高比例
        itemCount: 8,
        itemBuilder: _buildGrideBtnViewFirst());
  }

  IndexedWidgetBuilder _buildGrideBtnViewFirst() {
    List<String> listDesTitle = [
      '未入库包裹',
      '已入库包裹',
      '待处理订单',
      '待支付订单',
      '待发货订单',
      '已发货订单',
      '已签收订单',
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
}
