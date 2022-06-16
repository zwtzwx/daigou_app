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
    订单详情
   */
  loadOrderData() async {
    EasyLoading.show();
    var data = await OrderService.getDetail(orderId);
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        model = data;
        statusStr = Util.getOrderStatusName(data.status, data.stationOrder);
        isLoading = true;
      });
    }
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
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    firstView(),
                    Gaps.vGap10,
                    addressView(),
                    Gaps.vGap10,
                    model!.remark.isNotEmpty ? remarkView() : Gaps.empty,
                    baseInfoView(),
                  ],
                  // children: returnSubView(),
                ),
              )
            : Container());
  }

  // 地址信息
  Widget addressView() {
    String reciverStr =
        '${model!.address.receiverName} ${model!.address.timezone}${model!.address.phone}';
    String addressStr = (model!.address.area?.name ?? '') +
        (model!.address.subArea != null
            ? ' ${model!.address.subArea!.name}'
            : '') +
        (model!.address.street.isNotEmpty ? ' ${model!.address.street}' : '') +
        (model!.address.doorNo.isNotEmpty ? ' ${model!.address.doorNo}' : '') +
        (model!.address.postcode.isNotEmpty
            ? ' ${model!.address.postcode}'
            : '') +
        (model!.address.city.isNotEmpty ? ' ${model!.address.city}' : '');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LoadImage(
                'PackageAndOrder/address-icon',
                width: 24,
                height: 24,
              ),
              Gaps.hGap10,
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: HexToColor('#eceeff'),
                  child: Caption(
                    str: model!.address.countryName,
                    color: ColorConfig.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap15,
          Gaps.line,
          Gaps.vGap15,
          const Caption(
            str: '收货地址',
            fontSize: 13,
            color: ColorConfig.textGray,
          ),
          Gaps.vGap5,
          Caption(
            str: reciverStr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          Gaps.vGap5,
          Caption(
            str: addressStr,
            lines: 3,
          ),
          Gaps.vGap5,
          Caption(
            str: model!.station != null
                ? '自提收货-${model!.station!.name}'
                : '送货上门',
          ),
        ],
      ),
    );
  }

  // 客服备注
  Widget remarkView() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Caption(
            str: '客服备注',
            color: ColorConfig.textGray,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Caption(
              str: model!.remark,
              lines: 10,
            ),
          ),
        ],
      ),
    );
  }

  // 基础订单信息
  Widget baseInfoView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          baseInfoItem('提交时间', model!.createdAt),
          baseInfoItem('快递类型', model!.expressName),
          model!.status > 2
              ? baseInfoItem('物流单号', model!.logisticsSn)
              : Gaps.empty,
          model!.status > 1 ? packInfoView() : Gaps.empty,
        ],
      ),
    );
  }

  // 打包信息
  Widget packInfoView() {
    String actualWeight = (model!.actualWeight / 1000).toStringAsFixed(2) +
        localizationInfo!.weightSymbol;
    String outVolumnSum = (model!.boxType == 1
            ? ((model!.length / 100).toString() +
                '*' +
                (model!.width / 100).toString() +
                '*' +
                (model!.height / 100).toString() +
                '/' +
                (model!.factor ?? 0).toString() +
                '=' +
                (model!.volumeWeight / 1000).toStringAsFixed(2))
            : (model!.volumeWeight / 1000).toStringAsFixed(2)) +
        localizationInfo!.weightSymbol;
    String inVolumnSum = ((model!.volumeSum ?? 0) / 1000).toStringAsFixed(2) +
        localizationInfo!.weightSymbol;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        baseInfoItem('称重重量', actualWeight),
        baseInfoItem('出库体积重量', outVolumnSum),
        baseInfoItem('入库体积重量', inVolumnSum),
        // baseInfoItem('留仓物品', model.in),
      ],
    );
  }

  Widget baseInfoItem(String label, String? content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Caption(
            str: label,
            color: ColorConfig.textGray,
          ),
          Caption(
            str: content ?? '无',
          ),
        ],
      ),
    );
  }

  bottomButton() {
    List<Widget> buttonList = [];
    num realAmount = model?.actualPaymentFee ?? 0;
    if (selectCoupon != null) {
      realAmount = (model!.actualPaymentFee - selectCoupon!.coupon!.amount);
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

  // 订单号、包裹列表
  Widget secondView() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 25),
      width: ScreenUtil().screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        // border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Caption(
            str: '转运订单号',
            fontSize: 13,
            color: ColorConfig.textGray,
          ),
          Gaps.vGap10,
          Row(
            children: [
              Caption(
                str: model?.orderSn ?? '',
              ),
              Gaps.hGap15,
              GestureDetector(
                child: const LoadImage(
                  'PackageAndOrder/copy-icon',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          const Caption(
            str: '包含的包裹',
            fontSize: 13,
            color: ColorConfig.textGray,
          ),
          Gaps.vGap10,
          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: model!.packages.map((e) {
              return GestureDetector(
                onTap: () {
                  Routers.push('/PackageDetailPage', context, {
                    "edit": false,
                    'id': e.id,
                  });
                },
                child: Row(
                  children: [
                    const LoadImage(
                      'PackageAndOrder/package',
                      width: 24,
                      height: 24,
                    ),
                    Gaps.hGap10,
                    Caption(
                      str: e.expressNum ?? '',
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget firstView() {
    return Container(
        color: ColorConfig.primary,
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              padding: const EdgeInsets.only(top: 30, left: 15),
              width: ScreenUtil().screenWidth,
              child: Caption(
                str: statusStr,
                color: ColorConfig.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            secondView(),
          ],
        ));
  }
}
