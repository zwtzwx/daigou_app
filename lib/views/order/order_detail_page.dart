/*
  订单详细
 */
import 'package:flick_video_player/flick_video_player.dart';
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/models/user_coupon_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart' as caption;
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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

  // 打包视频
  List<FlickManager> packVideoManager = [];

  LocalizationModel? localizationInfo;

  String statusStr = '';

  UserCouponModel? selectCoupon;

  @override
  void initState() {
    super.initState();
    orderId = widget.arguments['id'];
    getVideoList();
    loadOrderData();
  }

  @override
  void dispose() {
    for (var item in packVideoManager) {
      item.dispose();
    }
    super.dispose();
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

  // 订单打包视频
  getVideoList() async {
    var videos = await OrderService.getOrderPackVideo(orderId);
    setState(() {
      for (var item in videos) {
        packVideoManager.add(
          FlickManager(
            autoPlay: false,
            videoPlayerController: VideoPlayerController.network(item),
          ),
        );
      }
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
          title: caption.Caption(
            str: Translation.t(context, '订单详情'),
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        bottomNavigationBar: bottomButton(),
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
                    Gaps.vGap10,
                    valueInfoView(),
                    Gaps.vGap10,
                    model!.status > 2 ? payInfoView() : Gaps.empty,
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
                  child: caption.Caption(
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
          caption.Caption(
            str: Translation.t(context, '收货地址'),
            fontSize: 13,
            color: ColorConfig.textGray,
          ),
          Gaps.vGap5,
          caption.Caption(
            str: reciverStr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          Gaps.vGap5,
          caption.Caption(
            str: addressStr,
            lines: 3,
          ),
          Gaps.vGap5,
          caption.Caption(
            str: model!.station != null
                ? '${Translation.t(context, '自提收货')}-${model!.station!.name}'
                : Translation.t(context, '送货上门'),
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
          caption.Caption(
            str: Translation.t(context, '客服备注'),
            color: ColorConfig.textGray,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: caption.Caption(
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
          baseInfoItem('提交时间', text: model!.createdAt),
          baseInfoItem('快递类型', text: model!.expressName),
          model!.status > 2
              ? baseInfoItem('物流单号', text: model!.logisticsSn)
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
      mainAxisSize: MainAxisSize.min,
      children: [
        model!.boxes.isNotEmpty
            ? SizedBox(
                height: model!.boxes.length * 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model!.boxes.length,
                  itemBuilder: boxItem,
                ))
            : Gaps.empty,
        baseInfoItem('称重重量', text: actualWeight),
        baseInfoItem('出库体积重量', text: outVolumnSum),
        baseInfoItem('入库体积重量', text: inVolumnSum),
        baseInfoItem('留仓物品', text: model!.inWarehouseItem),
        packVideoManager.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  caption.Caption(
                    str: Translation.t(context, '打包视频'),
                    color: ColorConfig.textGray,
                  ),
                  Gaps.vGap10,
                  ...packVideoManager.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FlickVideoPlayer(
                        flickManager: e,
                      ),
                    );
                  }).toList(),
                ],
              )
            : Gaps.empty,
        Gaps.line,
        Gaps.vGap10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  caption.Caption(
                    str: Translation.t(context, '打包照片'),
                    color: ColorConfig.textGray,
                  ),
                  Gaps.vGap10,
                  model!.packPictures.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: model!.packPictures.length,
                          itemBuilder: (context, index) {
                            return _buildImageItem(
                                context, model!.packPictures[index], index);
                          })
                      : Gaps.empty,
                ],
              ),
            ),
            Gaps.hGap15,
            Expanded(
              child: Column(
                children: [
                  caption.Caption(
                    str: Translation.t(context, '物品照片'),
                    color: ColorConfig.textGray,
                  ),
                  Gaps.vGap10,
                  model!.inWarehousePictures.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: model!.packPictures.length,
                          itemBuilder: (context, index) {
                            return _buildImageItem(context,
                                model!.inWarehousePictures[index], index);
                          })
                      : Gaps.empty,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 多箱称重
  Widget boxItem(context, int index) {
    ParcelBoxModel boxModel = model!.boxes[index];
    String volumnSum = ((boxModel.length ?? 0) / 100).toString() +
        '*' +
        ((boxModel.width ?? 0) / 100).toString() +
        '*' +
        ((boxModel.height ?? 0) / 100).toString() +
        '/' +
        (model!.factor ?? 0).toString() +
        '=' +
        ((boxModel.volumeWeight ?? 0) / 1000).toStringAsFixed(2) +
        localizationInfo!.weightSymbol;
    return baseInfoItem(
      '${Translation.t(context, '包裹')} ${index + 1}',
      labelColor: Colors.black,
      leftFlex: 0,
      // bottom: index == model!.boxes.length - 1 ? 0 : 15,
      content: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: caption.Caption(
                    str: Translation.t(context, '实重'),
                  ),
                ),
                caption.Caption(
                  str: ((boxModel.weight ?? 0) / 1000).toStringAsFixed(2) +
                      localizationInfo!.weightSymbol,
                ),
              ],
            ),
            Gaps.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: caption.Caption(
                    str: Translation.t(context, '体积重'),
                  ),
                ),
                caption.Caption(
                  str: volumnSum,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 订单价格
  Widget valueInfoView() {
    // 订单增值服务列表
    num valueAddAmount = num.parse(model!.valueAddedAmount ?? '0');
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          model!.status != 1
              ? baseInfoItem(
                  '合计运费',
                  content: Row(
                    children: [
                      model!.price != null &&
                              num.parse(model!.price!.discount) != 1
                          ? caption.Caption(
                              str: getPriceStr(model!.price!.originPrice),
                              color: ColorConfig.textGray,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                            )
                          : Gaps.empty,
                      Gaps.hGap10,
                      caption.Caption(
                        str: getPriceStr(model!.allFreightFee),
                      ),
                    ],
                  ),
                )
              : Gaps.empty,
          model!.status != 1
              ? baseInfoItem('帮您运费节省',
                  text: getPriceStr(model!.thriftFreightFee))
              : Gaps.empty,
          model!.insuranceFee > 0
              ? baseInfoItem('保险费',
                  text: '+${getPriceStr(model!.insuranceFee)}')
              : Gaps.empty,
          model!.tariffFee > 0
              ? baseInfoItem('关税', text: '+${getPriceStr(model!.tariffFee)}')
              : Gaps.empty,
          baseInfoItem(
            '订单增值服务',
            crossAxisAlignment: CrossAxisAlignment.start,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                caption.Caption(
                  str: model!.valueAddedService.isNotEmpty
                      ? '+${getPriceStr(valueAddAmount)}'
                      : Translation.t(context, '无'),
                ),
                ...model!.valueAddedService.map((e) {
                  return caption.Caption(
                    str: e.name! + '(${getPriceStr(e.price)})',
                  );
                }).toList(),
              ],
            ),
          ),
          model!.lineRuleFee > 0
              ? baseInfoItem('渠道规则费',
                  text: '+${getPriceStr(model!.lineRuleFee)}')
              : Gaps.empty,
          model!.lineServices.isNotEmpty
              ? baseInfoItem(
                  '渠道增值服务',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      model!.status != 1
                          ? caption.Caption(
                              str: '+${getPriceStr(model!.lineServiceFee)}',
                            )
                          : Gaps.empty,
                      ...model!.lineServices.map((e) {
                        return Row(
                          children: [
                            e.remark.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      BaseDialog.normalDialog(
                                        context,
                                        title: e.name,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 20),
                                          child: Text(e.remark),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: ColorConfig.green,
                                      size: 18,
                                    ),
                                  )
                                : Gaps.empty,
                            Gaps.hGap10,
                            caption.Caption(
                              str: e.name +
                                  (model!.status != 1
                                      ? '(${getPriceStr(e.price)})'
                                      : ''),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                )
              : Gaps.empty,
          model!.status > 2 && model!.couponDiscountFee > 0
              ? baseInfoItem(
                  '优惠券',
                  text: '-' + getPriceStr(model!.couponDiscountFee),
                )
              : Gaps.empty,
          (model!.status > 2 &&
                  model!.transaction.isNotEmpty &&
                  model!.transaction[0].isUsePoint == 1)
              ? baseInfoItem(
                  '积分',
                  text: '-' + getPriceStr(model!.transaction[0].pointAmount),
                )
              : Gaps.empty,
          model!.status != 1
              ? baseInfoItem(
                  '订单总价',
                  text: getPriceStr(model!.actualPaymentFee),
                )
              : Gaps.empty,
        ],
      ),
    );
  }

  // 支付信息
  Widget payInfoView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          baseInfoItem('实际支付',
              text: getPriceStr(model!.discountPaymentFee) +
                  ((model!.transaction.isNotEmpty &&
                          (model!.transaction[0].showTrans ?? false))
                      ? '/${model!.transaction[0].currency}${model!.transaction[0].currencySymbol}' +
                          getPriceStr(model!.discountPaymentFee *
                              num.parse(model!.transaction[0].transRate))
                      : ''),
              redText: true),
          baseInfoItem(
            '支付方式',
            text: model!.transaction.isNotEmpty
                ? model!.transaction[0].payName
                : '',
          ),
          baseInfoItem(
            '支付状态',
            text: model!.transaction.isNotEmpty
                ? (model!.transaction[0].type == 1
                    ? Translation.t(context, '支付成功')
                    : (model!.transaction[0].type == 2
                        ? Translation.t(context, '退款成功')
                        : ''))
                : '',
          ),
          baseInfoItem(
            '支付单号',
            text: model!.transaction.isNotEmpty
                ? model!.transaction[0].serialNo
                : '',
          ),
          baseInfoItem(
            '支付时间',
            text: model!.transaction.isNotEmpty
                ? model!.transaction[0].createdAt
                : '',
          ),
          model!.status == 5
              ? baseInfoItem(
                  '签收时间',
                  text: model!.updatedAt,
                )
              : Gaps.empty,
        ],
      ),
    );
  }

  Widget baseInfoItem(
    String label, {
    double? bottom,
    String? text,
    Widget? content,
    Color? labelColor,
    int? leftFlex,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool redText = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Flexible(
            flex: leftFlex ?? 1,
            child: caption.Caption(
              str: Translation.t(context, label),
              color: labelColor ?? ColorConfig.textGray,
              lines: 2,
            ),
          ),
          content ??
              caption.Caption(
                str: text ?? Translation.t(context, '无'),
                color: redText ? ColorConfig.textRed : ColorConfig.textBlack,
              ),
        ],
      ),
    );
  }

  String getPriceStr(num? price) {
    return ((price ?? 0) / 100).toStringAsFixed(2);
  }

  // 底部按钮
  bottomButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: ColorConfig.line),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: PlainButton(
                text: '联系客服',
                onPressed: () async {
                  var showWechat = await fluwx.isWeChatInstalled;
                  BaseDialog.customerDialog(context, showWechat);
                },
              ),
            ),
            Gaps.hGap10,
            [4, 5].contains(model?.status)
                ? PlainButton(
                    text: Translation.t(context, '查看物流'),
                    onPressed: () {
                      if (model!.boxes.isNotEmpty) {
                        BaseDialog.showBoxsTracking(context, model!);
                      } else {
                        Routers.push('/TrackingDetailPage', context,
                            {"order_sn": model!.orderSn});
                      }
                    },
                  )
                : Gaps.empty,
            Gaps.hGap10,
            [2, 12].contains(model?.status)
                ? MainButton(
                    text: model?.status == 2 ? '去付款' : '重新支付',
                    onPressed: () {
                      var s = Routers.push('/OrderPayPage', context, {
                        'id': model?.id,
                        'payModel': 1,
                        'deliveryStatus': model?.onDeliveryStatus,
                      });
                      if (s != null) {
                        onRefresh();
                      }
                    },
                  )
                : Gaps.empty,
            model?.status == 4
                ? Flexible(
                    child: MainButton(
                      text: '确认收货',
                      onPressed: onSign,
                    ),
                  )
                : Gaps.empty,
            model?.status == 5
                ? MainButton(
                    text: model?.evaluated == 1 ? '查看评价' : '我要评价',
                    onPressed: onComment,
                  )
                : Gaps.empty,
          ],
        ),
      ),
    );
  }

  // 签收
  void onSign() async {
    var data = await BaseDialog.confirmDialog(
        context, Translation.t(context, '请确认您已收到货'));
    if (data != null) {
      EasyLoading.show();
      var result = await OrderService.signed(orderId);
      EasyLoading.dismiss();
      if (result['ok']) {
        EasyLoading.showSuccess(Translation.t(context, '签收成功'));
        onRefresh();
      } else {
        EasyLoading.showError(result['msg']);
      }
    }
  }

  // 评价
  void onComment() async {
    if (model!.evaluated == 1) {
      Routers.push(
          '/OrderCommentPage', context, {'order': model, 'detail': true});
    } else {
      var s = Routers.push('/OrderCommentPage', context, {'order': model});
      if (s != null) {
        onRefresh();
      }
    }
  }

  void onRefresh() {
    loadOrderData();
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
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
          alignment: Alignment.center,
          child: LoadImage(
            picMap['full_path'],
            fit: BoxFit.fitWidth,
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
          caption.Caption(
            str: Translation.t(context, '转运订单号'),
            fontSize: 13,
            color: ColorConfig.textGray,
          ),
          Gaps.vGap10,
          Row(
            children: [
              caption.Caption(
                str: model?.orderSn ?? '',
              ),
              Gaps.hGap15,
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: model?.orderSn)).then(
                      (value) => {
                            EasyLoading.showSuccess(
                                Translation.t(context, '复制成功'))
                          });
                },
                child: const LoadImage(
                  'PackageAndOrder/copy-icon',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          caption.Caption(
            str: Translation.t(context, '包含的包裹'),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LoadImage(
                      'PackageAndOrder/package',
                      width: 24,
                      height: 24,
                    ),
                    Gaps.hGap10,
                    caption.Caption(
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
              child: caption.Caption(
                str: Translation.t(context, statusStr),
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
