/*
  订单详细
 */
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/invoice_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/user_coupon_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/services/coupon_service.dart';
import 'package:jiyun_app_client/services/invoice_service.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/icon_text.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  final Map arguments;

  const OrderDetailPage({Key? key, required this.arguments}) : super(key: key);

  @override
  OrderDetailPageState createState() => OrderDetailPageState();
}

class OrderDetailPageState extends State<OrderDetailPage> {
  OrderModel? model;
  late int orderId;
  bool isLoading = false;
  bool isShowCoupon = false;
  bool isShowJIFEN = false;
  bool userJiFen = false;
  bool invoiceType = false;

  // 会员信息
  UserVipModel? vipModel;

  // 是否展示费用详情
  bool isShowPayMentDetail = false;

  LocalizationModel? localizationInfo;

  String statusStr = '';

  UserCouponModel? selectCoupon;

  double picHeight = 0.0;

  @override
  void initState() {
    super.initState();
    orderId = widget.arguments['id'];
    loadOrderData();
    // loadCouponData();
  }

  /*
    会员等级
   */
  getVipInfo() async {
    var data = await UserService.getVipMemberData();
    if (data != null) {
      setState(() {
        vipModel = data;
      });
    }
  }

  /*
    加载优惠券
   */
  loadCouponData() async {
    Map<String, dynamic> map = {
      "page": 1,
      "size": '1000',
      "available": '1', // 1可用 0不可用
      "express_line_id": model?.expressLineId, // 线路ID
      "amount": model?.actualPaymentFee, // 现金
    };

    var data = await CouponService.getList(map);

    setState(() {
      isShowCoupon = data['total'] > 0;
    });
  }

  /*
    订单详情
   */
  loadOrderData() async {
    EasyLoading.show();
    var data = await OrderService.getDetail(orderId);
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        model = data;
        getOrderStatus();
        isLoading = true;
        if (model!.status == 2 || model!.status == 12) {
          loadCouponData();
        }
      });
    }
  }

  /*
    订单状态
   */
  getOrderStatus() {
    // //1 待处理 2待付款 3待发货 4已发货5已签收11审核中12审核失败
    String str = '';
    switch (model!.status) {
      case 1:
        str = '打包中';
        break;
      case 2:
        str = '待支付';
        break;
      case 3:
        str = '待发货';
        break;
      case 4:
        if (model!.stationOrder == null) {
          str = '已发货';
        } else {
          if (model!.stationOrder!.status == 1) {
            str = '已到自提点';
          } else if (model!.stationOrder!.status == 3) {
            str = '自提点出库';
          } else if (model!.stationOrder!.status == 4) {
            str = '自提签收';
          }
        }
        break;
      case 5:
        if (model!.stationOrder == null) {
          str = '已签收';
        } else {
          if (model!.stationOrder!.status == 1) {
            str = '已到自提点';
          } else if (model!.stationOrder!.status == 3) {
            str = '自提点出库';
          } else if (model!.stationOrder!.status == 4) {
            str = '自提签收';
          }
        }
        break;
      case 11:
        str = '审核中';
        break;
      case 12:
        str = '审核失败';
        break;
      default:
    }
    setState(() {
      statusStr = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '订单详情',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isLoading
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                    child: Container(
                  color: ColorConfig.bgGray,
                  child: Column(
                    children: returnSubView(),
                  ),
                )))
            : Container());
  }

  returnSubView() {
    //1 待处理 2待付款 3待发货 4已发货5已签收11审核中12审核失败
    //  <Widget>[
    //
    //   eighthView(),
    //   Gaps.vGap10,
    //   seventhView(),
    //   Gaps.vGap10,
    //   bottomView()
    // ],
    List<Widget> subViewList = [];
    if (model?.status == 1) {
      subViewList.add(firstView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(thirdView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(orderNo());
      subViewList.add(packagesInfoForPacking());
      subViewList.add(Gaps.vGap10);
      subViewList.add(thirdViewPackIng());
    } else if (model?.status == 2 || model?.status == 12) {
      subViewList.add(firstView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(thirdView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(orderNo());
      if (model?.boxType == 2) {
        // for (var item in model.boxes) {
        for (var i = 0; i < model!.boxes.length; i++) {
          ParcelBoxModel model1 = model!.boxes[i];
          subViewList.add(Gaps.vGap10);
          subViewList.add(packagesForBoxesView(model1, i));
        }
        subViewList.add(Gaps.vGap10);
      } else {
        subViewList.add(packagesInfoView());
      }
      subViewList.add(Gaps.vGap10);
      subViewList.add(fifthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(seventhView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(selectInvoice());
      subViewList.add(Gaps.vGap10);
      subViewList.add(bottomView());
      subViewList.add(Gaps.vGap10);
    } else if (model?.status == 3) {
      subViewList.add(firstView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(eighthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(orderNo());
      if (model?.boxType == 2) {
        for (var i = 0; i < model!.boxes.length; i++) {
          ParcelBoxModel model1 = model!.boxes[i];
          subViewList.add(Gaps.vGap10);
          subViewList.add(packagesForBoxesView(model1, i));
        }
        subViewList.add(Gaps.vGap10);
      } else {
        subViewList.add(packagesInfoView());
      }
      subViewList.add(Gaps.vGap10);
      subViewList.add(fifthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(payMentDetail());
      subViewList.add(Gaps.vGap10);
      subViewList.add(bottomView());
      subViewList.add(Gaps.vGap10);
    } else if (model?.status == 4) {
      subViewList.add(firstView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(eighthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(orderNo());
      if (model?.boxType == 2) {
        for (var i = 0; i < model!.boxes.length; i++) {
          ParcelBoxModel model1 = model!.boxes[i];
          subViewList.add(Gaps.vGap10);
          subViewList.add(packagesForBoxesView(model1, i));
        }
        subViewList.add(Gaps.vGap10);
      } else {
        subViewList.add(packagesInfoView());
      }
      subViewList.add(fifthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(payMentDetail());
      subViewList.add(Gaps.vGap10);
      subViewList.add(bottomView());
      subViewList.add(Gaps.vGap10);
    } else if (model?.status == 5) {
      subViewList.add(firstViewSigned());
      subViewList.add(Gaps.line);
      subViewList.add(secondView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(eighthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(orderNo());
      if (model?.boxType == 2) {
        for (var i = 0; i < model!.boxes.length; i++) {
          ParcelBoxModel model1 = model!.boxes[i];
          subViewList.add(Gaps.vGap10);
          subViewList.add(packagesForBoxesView(model1, i));
        }
        subViewList.add(Gaps.vGap10);
      } else {
        subViewList.add(packagesInfoView());
      }
      subViewList.add(fifthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(payMentDetail());
      subViewList.add(Gaps.vGap10);
      subViewList.add(bottomView());
      subViewList.add(Gaps.vGap10);
    } else if (model?.status == 11) {
      subViewList.add(firstView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(eighthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(orderNo());
      if (model?.boxType == 2) {
        for (var i = 0; i < model!.boxes.length; i++) {
          ParcelBoxModel model1 = model!.boxes[i];
          subViewList.add(Gaps.vGap10);
          subViewList.add(packagesForBoxesView(model1, i));
        }
        subViewList.add(Gaps.vGap10);
      } else {
        subViewList.add(packagesInfoView());
      }
      subViewList.add(Gaps.vGap10);
      subViewList.add(fifthView());
      subViewList.add(Gaps.vGap10);
      subViewList.add(payMentDetail());
      subViewList.add(Gaps.vGap10);
      subViewList.add(selectInvoice());
      // if (model?.status == 12) {
      //   subViewList.add(Gaps.vGap10);
      //   subViewList.add(bottomView());
      //   subViewList.add(Gaps.vGap10);
      // }
    }
    return subViewList;
  }

  Widget signOrderView() {
    var signOrderView = Container(
      height: 86.5,
      padding: const EdgeInsets.only(top: 5, left: 15),
      width: ScreenUtil().screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        // border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
            width: 30,
            child: Image.asset(
              'assets/images/Home/签收包裹@3x.png',
            ),
          ),
          Gaps.hGap10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                width: ScreenUtil().screenWidth - 100,
                padding: const EdgeInsets.only(top: 15),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const <Widget>[
                    Caption(
                      str: '包裹已签收',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorConfig.textRed,
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                      height: 30,
                      padding: const EdgeInsets.only(bottom: 15),
                      width: ScreenUtil().screenWidth - 100,
                      alignment: Alignment.centerLeft,
                      child: Caption(
                        str: model?.updatedAt ?? '',
                        color: ColorConfig.textGray,
                      ))),
            ],
          ),
        ],
      ),
    );
    return signOrderView;
  }

  // 联系客服
  Widget bottomView() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: ColorConfig.white,
      height: 60,
      child: Row(
        mainAxisAlignment:
            model?.status == 3 || model?.status == 4 || model?.status == 5
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
        children: bottomButton(),
      ),
    );
  }

  bottomButton() {
    List<Widget> buttonList = [];
    num realAmount = model?.actualPaymentFee ?? 0;
    if (selectCoupon != null) {
      realAmount = (model!.actualPaymentFee - selectCoupon!.coupon.amount);
    }
    if (userJiFen) {
      realAmount = (realAmount - model!.pointamount);
    }
    if (realAmount < 0) {
      realAmount = 0;
    }
    var view1 = GestureDetector(
        onTap: () async {
          var s = await Navigator.pushNamed(context, '/InvoicePage',
              arguments: {'orderModel': model});
          if (s == null) {
            return;
          }
          if (s == 'confirm') {
            setState(() {
              model!.isInvoice = 1;
            });
          }
        },
        child: Container(
            height: 40,
            alignment: Alignment.center,
            child: const Caption(
              str: '申请开票',
              color: ColorConfig.textGray,
            )));
    var view = SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          builtTitleTotalView('合计：'),
          Row(children: <Widget>[
            Caption(
                str: localizationInfo!.currencySymbol +
                    (realAmount / 100).toStringAsFixed(2),
                color: ColorConfig.textRed),
          ]),
        ],
      ),
    );
    var button1 = TextButton(
      onPressed: () {
        isWeChatInstalled.then((installed) {
          if (installed) {
            openWeChatCustomerServiceChat(
                    url: 'https://work.weixin.qq.com/kfid/kfcd1850645a45f5db4',
                    corpId: 'ww82affb1cf55e55e0')
                .then((data) {
              print("---》$data");
            });
          } else {
            Util.showToast("请先安装微信");
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: ColorConfig.white,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 1, color: ColorConfig.textGray)),
        alignment: Alignment.center,
        height: 40,
        child: const Caption(str: '联系客服'),
      ),
    );
    var button2 = Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: 40,
      child: MainButton(
        text: model!.status == 2 ? '立即支付' : '重新支付',
        onPressed: () async {
          Map<String, dynamic> map = {
            'order_id': model!.id,
            'coupon_id': selectCoupon != null ? selectCoupon!.id : '',
            'is_use_point': userJiFen ? 1 : 0,
          };
          OrderService.updateReadyPay(map, (data) {
            if (data.ret) {
              OrderModel resultOrder = OrderModel.fromJson(data.data);
              Routers.push('/OrderPayPage', context,
                  {'model': resultOrder, 'payModel': 1});
            }
          }, (message) => EasyLoading.showError(message));
        },
      ),
    );
    var button3 = TextButton(
      onPressed: () {
        var s = Routers.push('/OrderCommentPage', context, {'order': model});
        if (s != null) {
          loadOrderData();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: ColorConfig.white,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 1, color: ColorConfig.warningText)),
        alignment: Alignment.center,
        height: 40,
        child: const Caption(str: '评价有奖', color: ColorConfig.textDark),
      ),
    );
    var button6 = TextButton(
      onPressed: () {
        Routers.push(
            '/OrderCommentPage', context, {'order': model, 'detail': true});
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: ColorConfig.white,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 1, color: ColorConfig.textGrayC)),
        alignment: Alignment.center,
        height: 40,
        child: const Caption(str: '查看评价', color: ColorConfig.textDark),
      ),
    );
    var button4 = TextButton(
      onPressed: () {
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
                      print('取消');
                    },
                  ),
                  TextButton(
                    child: const Text('确定'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      bool result = await OrderService.signed(model!.id);
                      if (result) {
                        Util.showToast("操作成功");
                        Routers.push(
                            '/SignSuccessPage', context, {'model': model});
                      }
                    },
                  )
                ],
              );
            });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: ColorConfig.warningText,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 1, color: ColorConfig.warningText)),
        alignment: Alignment.center,
        height: 40,
        child: const Caption(str: '确认收货'),
      ),
    );
    var button5 = TextButton(
      onPressed: () {
        if (model!.boxes.isNotEmpty) {
          viewTracking(model!);
        } else {
          Routers.push(
              '/TrackingDetailPage', context, {"order_sn": model!.orderSn});
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: ColorConfig.white,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 0.3, color: ColorConfig.textGray)),
        alignment: Alignment.center,
        height: 40,
        child: const Caption(str: '查看物流'),
      ),
    );
    if (model!.status == 1) {
    } else if (model!.status == 2) {
      buttonList.add(view);
      buttonList.add(button2);
    } else if (model!.status == 3) {
      if (model!.isInvoice == 0) {
        buttonList.add(view1);
      }
      buttonList.add(button1);
    } else if (model!.status == 4) {
      if (model!.isInvoice == 0) {
        buttonList.add(view1);
      }
      var subView = Row(
        children: <Widget>[button5, button4],
      );
      buttonList.add(subView);
    } else if (model!.status == 5) {
      if (model!.isInvoice == 0) {
        buttonList.add(view1);
      }
      if (model!.evaluated == 1) {
        buttonList.add(button6);
      } else {
        buttonList.add(button3);
      }
    } else if (model!.status == 12) {
      buttonList.add(view);
      buttonList.add(button2);
    }
    return buttonList;
  }

  viewTracking(OrderModel model) async {
    String result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: buildSubOrderView(model),
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

  buildSubOrderView(OrderModel model) {
    List<Widget> list = [];
    for (var i = 0; i < model.boxes.length; i++) {
      ParcelBoxModel boxModel = model.boxes[i];
      var view = CupertinoActionSheetAction(
        child: Caption(
          str: '子订单- $i',
        ),
        onPressed: () {
          Navigator.of(context).pop(boxModel.logisticsSn);
        },
      );
      list.add(view);
    }
    return list;
  }

  // 支付详情
  Widget eighthView() {
    List<String> titleList = [];
    if (model!.status == 4 || model!.status == 5) {
      titleList.add('国际单号：');
    }
    if (model!.status == 11 || model!.status == 12) {
      titleList.addAll([
        '提交时间：',
        '渠道名称：',
        '打包备注：',
      ]);
    } else {
      titleList.addAll([
        '支付时间：',
        '提交时间：',
        '渠道名称：',
        '打包备注：',
      ]);
    }

    List<Widget> widgetList = [];
    for (var i = 0; i < titleList.length; i++) {
      String titleContent = '';
      if (model!.status == 4 || model!.status == 5) {
        switch (i) {
          case 1:
            titleContent = model!.paidAt!;
            break;
          case 2:
            titleContent = model!.createdAt;
            break;
          case 3:
            titleContent = model!.expressName;
            break;
          case 4:
            titleContent = model!.vipRemark.isEmpty ? '' : model!.vipRemark;
            break;
          case 0:
            titleContent = model!.logisticsSn;
            break;
          default:
        }
      } else if (model!.status == 11 || model!.status == 12) {
        switch (i) {
          case 0:
            titleContent = model!.createdAt;
            break;
          case 1:
            titleContent = model!.expressName;
            break;
          case 2:
            titleContent = model!.vipRemark.isEmpty ? '' : model!.vipRemark;
            break;
          default:
        }
      } else {
        switch (i) {
          case 0:
            titleContent = model!.paidAt!;
            break;
          case 1:
            titleContent = model!.createdAt;
            break;
          case 2:
            titleContent = model!.expressName;
            break;
          case 3:
            titleContent = model!.vipRemark.isEmpty ? '' : model!.vipRemark;
            break;
          default:
        }
      }
      if ((model!.status == 4 || model!.status == 5) && i == 0) {
        var view = SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    builtTitleView(titleList[i]),
                    Caption(
                      str: titleContent,
                      color: ColorConfig.textBlack,
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: titleList[i]));
                      Util.showToast('复制单号成功');
                    },
                    child: Caption(
                      str: '复制',
                      color: HexToColor('#FFAB00'),
                    ))
              ],
            ));
        widgetList.add(view);
      } else {
        var view = SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              builtTitleView(titleList[i]),
              Caption(
                str: titleContent,
                color: ColorConfig.textBlack,
              ),
            ],
          ),
        );
        widgetList.add(view);
      }
    }
    var view = Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: ColorConfig.white,
      height: (widgetList.length * 40).toDouble(), // 待支付订单200  已签收高度240 多一个订单评价
      child: Column(children: widgetList),
    );
    return view;
  }

  // 发票
  Widget selectInvoice() {
    return Container(
        height: 40,
        padding: const EdgeInsets.only(left: 15, right: 15),
        color: ColorConfig.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            builtMoneyTitleView('发票', ''),
            GestureDetector(
              onTap: () async {
                // buildPointView();
                var s = await Navigator.pushNamed(context, '/InvoicePage',
                    arguments: {'orderModel': model});
                if (s == null) {
                  return;
                }
                if (s == 'confirm') {
                  setState(() {
                    model!.isInvoice = 1;
                  });
                }
              },
              child: Row(children: <Widget>[
                Caption(
                    str: model!.isInvoice == 1 ? '普通纸质发票' : '不开发票',
                    color: ColorConfig.textGray),
                const Icon(Icons.keyboard_arrow_right,
                    color: ColorConfig.textGray),
              ]),
            )
          ],
        ));
  }

  // 费用显示
  Widget seventhView() {
    List<String> titleList = [];
    titleList = [
      '运费',
      '关税费',
      '保险费',
      '订单增值费',
      '渠道规则',
    ];
    List<Widget> widgetList = [];
    for (var i = 0; i < titleList.length; i++) {
      String titleContent = '';
      String titleStr = titleList[i];
      num money = 0;
      if (i == 0) {
        titleContent = localizationInfo!.currencySymbol +
            (model!.price!.originPrice *
                    double.parse(model!.price!.discount) /
                    100)
                .toStringAsFixed(2);
        titleStr = titleStr +
            '(计费重：' +
            (model!.paymentWeight / 1000).toStringAsFixed(2) +
            localizationInfo!.weightSymbol +
            ')';
        money = model!.freightFee;
      } else if (i == 1) {
        // 申报价格 所有包裹价值总和
        double totalValue = 0.0;
        for (ParcelModel item in model!.packages) {
          totalValue += item.packageValue!;
        }
        titleStr = titleStr +
            '(申报价值：' +
            localizationInfo!.currencySymbol +
            (totalValue / 100).toStringAsFixed(2) +
            ')';
        titleContent = localizationInfo!.currencySymbol +
            (model!.tariffFee / 100).toStringAsFixed(2);
        money = model!.tariffFee;
      } else if (i == 2) {
        titleContent = localizationInfo!.currencySymbol +
            (model!.insuranceFee / 100).toStringAsFixed(2);
        money = model!.insuranceFee;
      } else if (i == 3) {
        titleContent = localizationInfo!.currencySymbol +
            (int.parse(model!.valueAddedAmount ?? '0') / 100)
                .toStringAsFixed(2);
        money = int.parse(model!.valueAddedAmount ?? '0');
      } else if (i == 4) {
        titleContent = localizationInfo!.currencySymbol +
            (model!.lineRuleFee / 100).toStringAsFixed(2);
        money = model!.lineRuleFee;
      }
      if (money != 0) {
        var view = SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  builtMoneyTitleView(titleStr, ''),
                ],
              ),
              Row(
                children: <Widget>[
                  i == 0 && double.parse(model!.price!.discount) != 1
                      ? Text(
                          localizationInfo!.currencySymbol +
                              (model!.price!.originPrice / 100)
                                  .toStringAsFixed(2),
                          style: const TextStyle(
                            color: ColorConfig.textGray,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: ColorConfig.textGray,
                            fontSize: 16.0,
                          ),
                        )
                      : Container(),
                  Caption(
                    str: titleContent,
                  ),
                ],
              ),
            ],
          ),
        );
        widgetList.add(view);
      }
    }
    if (model!.valueAddedService.isNotEmpty) {
      for (var item in model!.lineServices) {
        String titleContent = localizationInfo!.currencySymbol +
            (item.price / 100).toStringAsFixed(2);
        if (item.price != 0) {
          var view = SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtMoneyTitleView(item.name, item.remark),
                Caption(
                  str: titleContent,
                ),
              ],
            ),
          );
          widgetList.add(view);
        }
      }
    }
    if (model!.lineServices.isNotEmpty) {
      for (var item in model!.lineServices) {
        String titleContent = localizationInfo!.currencySymbol +
            (item.price / 100).toStringAsFixed(2);
        if (item.price != 0) {
          var view = SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtMoneyTitleView(item.name, item.remark),
                Caption(
                  str: titleContent,
                ),
              ],
            ),
          );
          widgetList.add(view);
        }
      }
    }
    List<String> secondTitleList = [
      '积分抵扣：',
      '优惠券',
    ];
    for (var i = 0; i < secondTitleList.length; i++) {
      String content = '';
      if (i == 1) {
        content = selectCoupon == null
            ? '不使用'
            : '-' +
                localizationInfo!.currencySymbol +
                (selectCoupon!.coupon.amount / 100).toStringAsFixed(2);
      } else if (i == 0) {
        content = userJiFen
            ? '-' +
                localizationInfo!.currencySymbol +
                (model!.pointamount / 100).toStringAsFixed(2)
            : '不使用';
      }
      var view = SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            builtMoneyTitleView(secondTitleList[i], ''),
            GestureDetector(
              onTap: () async {
                if (i == 1) {
                  var s = await Navigator.pushNamed(context, '/CouponPage',
                      arguments: {
                        'select': true,
                        'lineid': model!.expressLineId,
                        'amount': model!.actualPaymentFee,
                        'model': selectCoupon
                      });
                  if (s == null) {
                    return;
                  }
                  setState(() {
                    selectCoupon = s as UserCouponModel;
                  });
                } else {
                  buildPointView();
                }
              },
              child: Row(children: <Widget>[
                Caption(
                  str: content,
                  color: content == '不使用'
                      ? ColorConfig.textGray
                      : ColorConfig.textRed,
                ),
                const Icon(Icons.keyboard_arrow_right,
                    color: ColorConfig.textGray),
              ]),
            )
          ],
        ),
      );
      if (i == 1 && isShowCoupon) {
        widgetList.add(view);
      } else {
        if (model!.point != 0) {
          widgetList.add(view);
        }
      }
    }
    num realAmount = model!.actualPaymentFee;
    if (selectCoupon != null) {
      realAmount = (realAmount - selectCoupon!.coupon.amount);
    }
    if (userJiFen) {
      realAmount = (realAmount - model!.pointamount);
    }
    if (realAmount < 0) {
      realAmount = 0;
    }
    var view = SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          builtTitleTotalView('合计：'),
          Row(children: <Widget>[
            Caption(
                str: localizationInfo!.currencySymbol +
                    (realAmount / 100).toStringAsFixed(2),
                color: ColorConfig.textRed),
          ]),
        ],
      ),
    );
    widgetList.add(view);

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: ColorConfig.white,
      height: widgetList.length * 40.toDouble(),
      child: Column(children: widgetList),
    );
  }

  List<Widget> addService() {
    List<Widget> subList = [];
    if (model!.valueAddedService.isNotEmpty) {
      for (ValueAddedServiceModel item in model!.valueAddedService) {
        subList.add(Container(
            alignment: Alignment.centerRight,
            height: 30,
            child: Caption(
              lines: 10,
              str: item.name! +
                  '(' +
                  localizationInfo!.currencySymbol +
                  (item.price! / 100).toStringAsFixed(2) +
                  ")",
              color: ColorConfig.textDark,
            )));
      }
    } else {
      subList.add(const Caption(
        lines: 10,
        str: '',
        color: ColorConfig.textDark,
      ));
    }
    return subList;
  }

  // 客服备注
  Widget sixthView() {
    var view = Container(
      alignment: Alignment.center,
      color: ColorConfig.white,
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Caption(
            str: '客服备注',
            color: ColorConfig.textGray,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerRight,
              height: 100,
              child: Caption(
                lines: 10,
                str: model!.remark,
                color: ColorConfig.textDark,
              ),
            ),
          )
        ],
      ),
    );
    return view;
  }

  // 支付详情
  Widget payMentDetail() {
    List<Widget> widgetList = [];
    if (isShowPayMentDetail) {
      // 运费
      if (model!.freightFee != 0) {
        var freightView = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        child: Caption(
                          str: '运费 （计费重' +
                              (model!.paymentWeight / 1000).toStringAsFixed(2) +
                              localizationInfo!.weightSymbol +
                              '）',
                          color: ColorConfig.textDark,
                        )),
                    vipModel != null
                        ? Container(
                            margin: const EdgeInsets.only(left: 0),
                            padding: const EdgeInsets.only(
                                top: 2, bottom: 2, right: 5, left: 5),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    HexToColor('#D4B69F'),
                                    HexToColor('#AE886D'),
                                  ],
                                  //渐变角度
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            height: 20,
                            alignment: Alignment.bottomCenter,
                            child: Caption(
                              str: vipModel!.profile.levelName,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: ColorConfig.white,
                            ),
                          )
                        : Gaps.empty
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '+' +
                        localizationInfo!.currencySymbol +
                        (model!.freightFee / 100).toStringAsFixed(2),
                  ),
                )
              ]),
        );
        widgetList.add(freightView);
      }
      // 保险
      if (model!.insuranceFee != 0) {
        var insuranceFee = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView('保险'),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '+' +
                        localizationInfo!.currencySymbol +
                        (model!.insuranceFee / 100).toStringAsFixed(2),
                  ),
                )
              ]),
        );
        widgetList.add(insuranceFee);
      }
      // 关税
      if (model!.tariffFee != 0) {
        var tariffFee = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView('关税'),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '+' +
                        localizationInfo!.currencySymbol +
                        (model!.tariffFee / 100).toStringAsFixed(2),
                  ),
                )
              ]),
        );
        widgetList.add(tariffFee);
      }
      for (var item in model!.lineServices) {
        // 线路增值服务费
        var lineServiceView = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView(item.name),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '+' +
                        localizationInfo!.currencySymbol +
                        (item.price / 100).toStringAsFixed(2),
                  ),
                )
              ]),
        );
        widgetList.add(lineServiceView);
      }

      // 全局增值服务费
      for (var item in model!.valueAddedService) {
        var lineServiceView = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView(item.name!),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '+' +
                        localizationInfo!.currencySymbol +
                        (item.price! / 100).toStringAsFixed(2),
                  ),
                )
              ]),
        );
        widgetList.add(lineServiceView);
      }
      // 渠道规则费
      if (model!.lineRuleFee != 0) {
        var tariffFee = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView('渠道规则费'),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '+' +
                        localizationInfo!.currencySymbol +
                        (model!.lineRuleFee / 100).toStringAsFixed(2),
                  ),
                )
              ]),
        );
        widgetList.add(tariffFee);
      }

      // 积分减免
      if (model!.pointamount != 0 && model!.isusepoint == 1) {
        var tariffFee = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView('积分'),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '-' +
                        localizationInfo!.currencySymbol +
                        (model!.pointamount / 100).toStringAsFixed(2),
                    color: ColorConfig.textRed,
                  ),
                )
              ]),
        );
        widgetList.add(tariffFee);
      }
      // 优惠券减免
      if (model!.couponDiscountFee != 0) {
        var tariffFee = SizedBox(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                builtTitleView('优惠券'),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Caption(
                    str: '-' +
                        localizationInfo!.currencySymbol +
                        (model!.couponDiscountFee / 100).toStringAsFixed(2),
                    color: ColorConfig.textRed,
                  ),
                )
              ]),
        );
        widgetList.add(tariffFee);
      }
    }
    var view = SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          builtTitleTotalView('实付款：'),
          GestureDetector(
              onTap: () {
                setState(() {
                  isShowPayMentDetail = !isShowPayMentDetail;
                });
              },
              child: Row(children: <Widget>[
                Caption(
                    str: localizationInfo!.currencySymbol +
                        (model!.paymentFee / 100).toStringAsFixed(2),
                    color: ColorConfig.textRed),
                Icon(
                    isShowPayMentDetail
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: ColorConfig.bgGray)
              ]))
        ],
      ),
    );
    widgetList.add(view);

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      color: ColorConfig.white,
      height: isShowPayMentDetail
          ? (widgetList.length * 40).toDouble() + 10
          : 50, // 底部打包照片等 一起有150高度  240 + 150
      child: Column(children: widgetList),
    );
  }

  //  订单详细信息
  Widget fifthView() {
    int lines = 0;
    if (model!.packPictures.length % 3 == 0) {
      lines = model!.packPictures.length ~/ 3;
    } else {
      lines = model!.packPictures.length ~/ 3 + 1;
    }
    picHeight = (ScreenUtil().screenWidth - 170) / 3 * lines;
    double heigh = 0;
    if (model!.status < 3 || model!.status == 11 || model!.status == 12) {
      heigh = lines == 0 ? 210 : (170 + picHeight).toDouble();
    } else {
      heigh = lines == 0 ? 170 : (130 + picHeight).toDouble();
    }
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      color: ColorConfig.white,
      height: heigh, // 底部打包照片等 一起有150高度  240 + 150
      child: Column(children: cellList()),
    );
  }

  List<Widget> cellList() {
    List<String> titleList = [];
    if (model!.status == 3 || model!.status == 4 || model!.status == 5) {
      titleList = [
        '计费重：',
        '申报价值：',
        '打包照片：',
        '客服备注：',
      ];
    } else {
      titleList = [
        '计费重：',
        '申报价值：',
        '打包照片：',
        '客服备注：',
        '联系客服',
      ];
    }

    List<Widget> widgetList = [];
    for (var i = 0; i < titleList.length; i++) {
      String titleContent = '';
      switch (i) {
        case 0:
          titleContent = (model!.paymentWeight / 1000).toStringAsFixed(2) +
              localizationInfo!.weightSymbol;
          break;
        case 1:
          // 申报价格 所有包裹价值总和
          double totalValue = 0.0;
          for (ParcelModel item in model!.packages) {
            totalValue += item.packageValue!;
          }
          titleContent = localizationInfo!.currencySymbol +
              (totalValue / 100).toStringAsFixed(2);
          break;
        case 2:
          if (model!.actualWeight > 0) {
            titleContent = (model!.actualWeight / 1000).toStringAsFixed(2) +
                localizationInfo!.weightSymbol;
          } else {
            titleContent = '0' + localizationInfo!.weightSymbol;
          }
          break;
        case 3:
          titleContent = model!.remark.isEmpty ? '' : model!.remark;
          break;
        default:
      }

      if (i < 4) {
        var view = SizedBox(
          height: i != 2
              ? 40
              : model!.packPictures.isNotEmpty
                  ? picHeight.toDouble()
                  : 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              builtTitleView(titleList[i]),
              i != 2
                  ? Expanded(
                      child: Caption(
                        lines: 2,
                        str: titleContent,
                      ),
                    )
                  : model!.packPictures.isNotEmpty
                      ? uploadPhoto()
                      : const Expanded(
                          child: Caption(
                            lines: 2,
                            str: '',
                          ),
                        )
            ],
          ),
        );
        widgetList.add(view);
      } else {
        if (model!.status == 3 || model!.status == 4 || model!.status == 5) {
        } else {
          var view = SizedBox(
              height: 40,
              child: Column(
                children: <Widget>[
                  Gaps.line,
                  SizedBox(
                    height: 39.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                          width: 25,
                          child:
                              Image.asset('assets/images/AboutMe/联系客服@3x.png'),
                        ),
                        Gaps.hGap10,
                        Caption(
                          str: titleList[i],
                          color: HexToColor('#FFAB00'),
                        )
                      ],
                    ),
                  )
                ],
              ));
          widgetList.add(view);
        }
      }
    }

    return widgetList;
  }

  // 上传图片
  Widget uploadPhoto() {
    return Container(
        width: ScreenUtil().screenWidth - 130,
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
        alignment: Alignment.center,
        height: (ScreenUtil().screenWidth - 60) / 4,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //设置列数
              crossAxisCount: 3,
              //设置横向间距
              crossAxisSpacing: 5,
              //设置主轴间距
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            shrinkWrap: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: model!.packPictures.length,
            itemBuilder: _buildGrideBtnView()));
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      return _buildImageItem(context, model!.packPictures[index], index);
    };
  }

  Widget _buildImageItem(context, Map<String, dynamic> picMap, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: model!.packPictures, //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
          // NinePictureAllScreenShow(model.images, index);
        },
        child: Container(
          color: ColorConfig.bgGray,
          height: (ScreenUtil().screenWidth - 60 - 15) / 4,
          width: (ScreenUtil().screenWidth - 60 - 15) / 4,
          child: LoadImage(
            picMap['full_path'],
            fit: BoxFit.cover,
            holderImg: "PackageAndOrder/defalutIMG@3x",
            format: "png",
          ),
        ));
  }

  // 单独增值服务  待处理订单
  Widget fourthView() {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        color: ColorConfig.white,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Caption(
              str: '增值服务',
              color: ColorConfig.textGray,
            ),
            SizedBox(
              height: 80,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: addServerList()),
            )
          ],
        ));
  }

  addServerList() {
    List<Widget> service = [];
    for (var item in model!.addService) {
      service.add(Caption(
        str: item.toString(),
      ));
    }
    return service;
  }

  // 订单简单信息
  Widget thirdView() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: ColorConfig.white,
      height: 120,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                builtTitleView('提交时间：'),
                Caption(
                  str: model!.createdAt,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            width: ScreenUtil().screenWidth - 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                builtTitleView('快递类型：'),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: ScreenUtil().screenWidth - 110,
                  child: Caption(
                    str: model!.expressLine.name,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                builtTitleView('打包备注：'),
                Caption(
                  str: model!.vipRemark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 打包中信息
  Widget thirdViewPackIng() {
    num totalValue = 0.0;
    num totalWeight = 0.0;
    for (ParcelModel item in model!.packages) {
      totalValue += item.packageValue!;
      totalWeight += item.packageWeight!;
    }
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: ColorConfig.white,
      height: 80,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                builtTitleView('入库总重：'),
                Caption(
                  str: (totalWeight / 1000).toStringAsFixed(2) +
                      localizationInfo!.weightSymbol,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                builtTitleView('申报价值：'),
                Caption(
                  str: localizationInfo!.currencySymbol +
                      (totalValue / 100).toStringAsFixed(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget orderNo() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: ColorConfig.white,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              builtTitleView('订单号：'),
              Caption(
                str: model!.orderSn,
              ),
            ],
          ),
          GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: model!.orderSn));
                Util.showToast('复制单号成功');
              },
              child: Caption(
                str: '复制',
                color: HexToColor('#FFAB00'),
              )),
        ],
      ),
    );
  }

  // 打包中详情显示包裹信息
  Widget packagesInfoForPacking() {
    double packageList = model!.packages.length == 1
        ? 40
        : 30 + (25 * model!.packages.length - 25).toDouble();
    double totalHeight = packageList;
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        color: ColorConfig.white,
        // height: totalHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: packageList,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  builtTitleViewPackage('包裹单号：'),
                  Container(
                    height: 75,
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: packagesList(model!.packages),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // 多箱子出库
  Widget packagesForBoxesView(ParcelBoxModel boxModel, int index) {
    String titleContent = '';
    titleContent = (boxModel.length! / 100).toStringAsFixed(2) +
        '*' +
        (boxModel.width! / 100).toStringAsFixed(2) +
        '*' +
        (boxModel.height! / 100).toStringAsFixed(2) +
        '/' +
        model!.factor.toString() +
        '=' +
        (boxModel.volumeWeight! / 1000).toStringAsFixed(2) +
        localizationInfo!.weightSymbol;
    double packageList =
        boxModel.packages == null || boxModel.packages!.length <= 1
            ? 40
            : 30 + (25 * boxModel.packages!.length - 25).toDouble();
    double totalHeight = 160 + packageList;
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: const BoxDecoration(
            color: ColorConfig.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: totalHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    builtTitleView('子订单-${index + 1}：'),
                    Caption(
                      str: '${model!.orderSn}-${index + 1}',
                    ),
                  ],
                )),
            model!.status == 4 || model!.status == 5
                ? SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            builtTitleView('国际单号：'),
                            Caption(str: boxModel.logisticsSn)
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: boxModel.logisticsSn));
                              Util.showToast('复制单号成功');
                            },
                            child: Caption(
                              str: '复制',
                              color: HexToColor('#FFAB00'),
                            )),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: packageList,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  builtTitleView('包裹：'),
                  Container(
                    height: 75,
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: packagesList(boxModel.packages!),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    builtTitleView('实重：'),
                    Caption(
                        str: (model!.actualWeight / 1000).toStringAsFixed(2) +
                            localizationInfo!.weightSymbol)
                  ],
                )),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  builtTitleView('体积重：'),
                  Caption(
                    fontSize: 14,
                    str: titleContent,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // 单箱子出库
  Widget packagesInfoView() {
    String titleContent = '';
    titleContent = (model!.length / 100).toStringAsFixed(2) +
        '*' +
        (model!.width / 100).toStringAsFixed(2) +
        '*' +
        (model!.height / 100).toStringAsFixed(2) +
        '/' +
        model!.factor.toString() +
        '=' +
        (model!.volumeWeight / 1000).toStringAsFixed(2) +
        localizationInfo!.weightSymbol;
    double packageList = model!.packages.length == 1 || model!.packages.isEmpty
        ? 40
        : 30 + (25 * model!.packages.length - 25).toDouble();
    double totalHeight = model!.status == 4 || model!.status == 5
        ? 120 + packageList
        : 80 + packageList;
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        color: ColorConfig.white,
        height: totalHeight,
        child: Column(
          children: <Widget>[
            model!.status == 4 || model!.status == 5
                ? SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            builtTitleView('国际单号：'),
                            Caption(str: model!.logisticsSn)
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: model!.logisticsSn));
                              Util.showToast('复制单号成功');
                            },
                            child: Caption(
                              str: '复制',
                              color: HexToColor('#FFAB00'),
                            )),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: packageList,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  builtTitleView('包裹：'),
                  Container(
                    height: 75,
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: packagesList(model!.packages),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    builtTitleView('实重：'),
                    Caption(
                        str: (model!.actualWeight / 1000).toStringAsFixed(2) +
                            localizationInfo!.weightSymbol)
                  ],
                )),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  builtTitleView('体积重：'),
                  Caption(
                    fontSize: 14,
                    str: titleContent,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  packagesList(List<ParcelModel> packages) {
    List<Widget> listv = [];
    for (ParcelModel item in packages) {
      var title = GestureDetector(
          onTap: () {
            Routers.push('/PackageDetailPage', context, {
              "edit": false,
              'id': item.id,
            });
          },
          child: Container(
            padding: const EdgeInsets.only(right: 5, left: 5),
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
                color: ColorConfig.textGrayCS,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            height: 20,
            child: Caption(
              fontSize: 14,
              str: item.expressNum!,
            ),
          ));
      listv.add(title);
    }
    return listv;
  }

  // 订单地址 收件人信息
  Widget secondView() {
    // 名字
    String nameN = model!.address.receiverName == ""
        ? ''
        : model!.address.receiverName + ' ';
    String timezoneN =
        model!.address.timezone == "" ? '' : model!.address.timezone + '-';
    String phoneN = model!.address.phone == "" ? '' : model!.address.phone;
    String nameAll = timezoneN + phoneN;
    String contentStr = '';
    if (model!.address.id != null) {
      if (model!.address.area != null) {
        if (model!.address.area != null) {
          contentStr =
              model!.address.countryName + ' ' + model!.address.area!.name;
        }
        if (model!.address.subArea != null) {
          contentStr += ' ' + model!.address.subArea!.name;
        }
        if (model!.address.address != "") {
          contentStr += ' ' + (model!.address.address ?? '');
        }
      } else {
        contentStr = model!.address.countryName +
            ' ' +
            model!.address.province +
            ' ' +
            model!.address.city;
        if (model!.address.address != "") {
          contentStr += ' ' + (model!.address.address ?? '');
        }
      }
    }
    return Container(
        height: 86.5,
        padding: const EdgeInsets.only(top: 5, left: 15),
        width: ScreenUtil().screenWidth,
        decoration: model!.status != 5
            ? const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                // border: new Border.all(width: 1, color: Colors.white),
              )
            : const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0)),
                // border: new Border.all(width: 1, color: Colors.white),
              ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                'assets/images/Home/仓库地址@3x.png',
              ),
            ),
            Gaps.hGap10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Container(
                      width: ScreenUtil().screenWidth - 100,
                      padding: const EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Caption(
                            str: nameN,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          Caption(
                            str: nameAll,
                          )
                        ],
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(top: 5),
                        width: ScreenUtil().screenWidth - 100,
                        alignment: Alignment.topLeft,
                        child: Caption(
                          str: contentStr,
                          lines: 2,
                        ))),
              ],
            ),
          ],
        ));
  }

  Widget firstView() {
    return Container(
        height: 167,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              height: 100,
              padding: const EdgeInsets.only(top: 30, left: 15),
              width: ScreenUtil().screenWidth,
              decoration: const BoxDecoration(
                color: ColorConfig.warningText,
              ),
              child: Caption(
                str: statusStr,
                color: ColorConfig.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Positioned(
                top: 80, left: 0, right: 0, bottom: 0, child: secondView())
          ],
        ));
  }

  Widget firstViewSigned() {
    return Container(
        height: 167,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              height: 100,
              padding: const EdgeInsets.only(top: 30, left: 15),
              width: ScreenUtil().screenWidth,
              decoration: const BoxDecoration(
                color: ColorConfig.warningText,
              ),
              child: Caption(
                str: statusStr,
                color: ColorConfig.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Positioned(
                top: 80, left: 0, right: 0, bottom: 0, child: signOrderView())
          ],
        ));
  }

  Widget havePackages() {
    List<Widget> packageV = [];
    for (var item in model!.packages) {
      var view = SizedBox(
        height: 20,
        child: IconText(item.packageName,
            padding: const EdgeInsets.only(right: 10),
            style: const TextStyle(fontSize: 16),
            iconSize: 20,
            icon: const Icon(
              Icons.wallet_giftcard_outlined,
              color: ColorConfig.warningText,
            )),
      );
      packageV.add(view);
    }
    return Column(children: packageV);
  }

  Widget builtTitleView(String title) {
    return Container(
        alignment: Alignment.centerLeft,
        height: 40,
        width: 85,
        child: Caption(
          str: title,
          color: ColorConfig.textDark,
        ));
  }

  Widget builtTitleTotalView(String title) {
    return Container(
        alignment: Alignment.centerRight,
        height: 40,
        width: 80,
        child: Caption(
          str: title,
          color: ColorConfig.textDark,
        ));
  }

  Widget builtMoneyTitleView(String title, String content) {
    return Container(
        alignment: Alignment.centerLeft,
        height: 40,
        width: 180,
        child: Row(
          children: <Widget>[
            Caption(
              str: title,
              fontSize: 14,
              color: ColorConfig.textDark,
            ),
            content.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: IconButton(
                        icon: const Icon(
                          Icons.error_outline_outlined,
                          color: ColorConfig.warningText,
                          size: 25,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: ColorConfig.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    border: Border.all(
                                        width: 1, color: ColorConfig.white),
                                  ),
                                  padding: const EdgeInsets.only(top: 15),
                                  margin: EdgeInsets.only(
                                      right: 45,
                                      left: 45,
                                      top: ScreenUtil().screenHeight / 2 - 100,
                                      bottom:
                                          ScreenUtil().screenHeight / 2 - 100),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 50,
                                        child: Column(
                                          children: <Widget>[
                                            Caption(
                                              str: title,
                                              fontSize: 18,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Gaps.line,
                                          ],
                                        ),
                                      ),
                                      Container(
                                          height: 60,
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: Caption(
                                            str: content,
                                            lines: 10,
                                          )),
                                      SizedBox(
                                        height: 50,
                                        width: ScreenUtil().screenWidth - 90,
                                        child: Column(
                                          children: <Widget>[
                                            Gaps.line,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                    child: TextButton(
                                                        child: const Caption(
                                                          str: '确定',
                                                          color: ColorConfig
                                                              .warningText,
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }))
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        }),
                  )
                : Container(),
          ],
        ));
  }

  Widget builtTitleViewPackage(String title) {
    return Container(
        alignment: Alignment.centerLeft,
        height: 40,
        width: 100,
        child: Caption(
          str: title,
          color: ColorConfig.textDark,
        ));
  }

  // 积分抵扣
  buildPointView() {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (BuildContext context) {
          bool select = userJiFen;
          return StatefulBuilder(builder: (context1, setBottomSheetState) {
            return Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                margin: const EdgeInsets.only(top: 15),
                height: 270,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().screenWidth,
                          height: 40,
                          child: const Caption(
                            str: '积分抵扣',
                            fontSize: 20,
                            color: ColorConfig.textBlack,
                          ),
                        ),
                        Caption(
                          str: '账户目前剩余积分：' + model!.point.toString(),
                          fontSize: 14,
                        ),
                        Gaps.vGap10,
                        Gaps.line,
                      ],
                    ),
                    Gaps.vGap16,
                    GestureDetector(
                        onTap: () {
                          if (select) {
                            return;
                          }
                          setBottomSheetState(() {
                            select = true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Caption(
                                  str: '账户目前剩余积分：' +
                                      model!.point.toString() +
                                      ' 抵扣',
                                  fontSize: 14,
                                ),
                                Caption(
                                  str: localizationInfo!.currencySymbol +
                                      (model!.pointamount / 100)
                                          .toStringAsFixed(2),
                                  fontSize: 14,
                                  color: ColorConfig.textRed,
                                ),
                              ],
                            ),
                            select
                                ? const Icon(
                                    Icons.check_circle,
                                    color: ColorConfig.warningText,
                                  )
                                : const Icon(
                                    Icons.radio_button_unchecked,
                                  ),
                          ],
                        )),
                    Gaps.vGap16,
                    GestureDetector(
                        onTap: () {
                          if (!select) {
                            return;
                          }
                          setBottomSheetState(() {
                            select = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: const <Widget>[
                                Caption(
                                  str: '不使用积分抵扣',
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            !select
                                ? const Icon(
                                    Icons.check_circle,
                                    color: ColorConfig.warningText,
                                  )
                                : const Icon(
                                    Icons.radio_button_unchecked,
                                  ),
                          ],
                        )),
                    Container(
                      height: 50,
                    ),
                    SizedBox(
                        height: 50,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userJiFen = select;
                                  selectCoupon = null;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 15, left: 15, top: 10),
                                decoration: BoxDecoration(
                                    color: ColorConfig.warningText,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(
                                        width: 1,
                                        color: ColorConfig.warningText)),
                                alignment: Alignment.center,
                                height: 40,
                                child: const Caption(
                                  str: '确定',
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ));
          });
        });
  }
}
