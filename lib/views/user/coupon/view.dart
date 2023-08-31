import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/user_coupon_model.dart';
import 'package:jiyun_app_client/services/coupon_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/user/coupon/controller.dart';

class CouponPage extends GetView<CouponController> {
  const CouponPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '优惠券'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
        ),
        bottom: TabBar(
            labelColor: BaseStylesConfig.primary,
            indicatorColor: BaseStylesConfig.primary,
            controller: controller.tabController,
            onTap: (int index) {
              controller.pageController.jumpToPage(index);
            },
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ZHTextLine(
                  str: '可用'.ts,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ZHTextLine(
                  str: '不可用'.ts,
                ),
              ),
            ]),
      ),
      bottomNavigationBar: Obx(
        () => controller.canSelect.value
            ? Container(
                color: BaseStylesConfig.white,
                padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ZHTextLine(str: '可抵扣'.ts + '：'),
                      ZHTextLine(
                          color: BaseStylesConfig.textRed,
                          str: controller.selectCoupon.value?.coupon
                                      ?.discountType ==
                                  2
                              ? ((controller.selectCoupon.value?.coupon
                                                  ?.weight ??
                                              0) /
                                          1000)
                                      .toStringAsFixed(2) +
                                  (controller.localModel?.weightSymbol ?? '')
                              : (controller
                                          .selectCoupon.value?.coupon?.amount ??
                                      0)
                                  .rate()),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 40,
                        width: 80,
                        child: MainButton(
                          text: '确认',
                          borderRadis: 20.0,
                          onPressed: () {
                            // Navigator.of(context).pop({
                            //   'confirm': true,
                            //   'selectCoupon': selectCoupon,
                            // });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Sized.empty,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: PageView.builder(
          itemCount: 2,
          controller: controller.pageController,
          onPageChanged: controller.onPageChange,
          itemBuilder: (context, int index) {
            return CouponsList(
              params: {
                'selectType': index,
                'lineId': controller.lineId,
                'amount': controller.amount.value,
                'selectCoupon': controller.selectCoupon.value,
                'localizationInfo': controller.localModel,
              },
              onSelected: controller.onSelected,
            );
          }),
    );
  }
}

// 优惠券列表
class CouponsList extends StatefulWidget {
  const CouponsList({
    Key? key,
    required this.params,
    required this.onSelected,
  }) : super(key: key);

  final Map<String, dynamic> params;
  final Function onSelected;

  @override
  CouponsListState createState() => CouponsListState();
}

class CouponsListState extends State<CouponsList> {
  final GlobalKey<CouponsListState> key = GlobalKey();
  int pageIndex = 0;

  LocalizationModel? localizationInfo;

  List<UserCouponModel> selectList = [];

  @override
  void initState() {
    super.initState();
    localizationInfo = widget.params['localizationInfo'];
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params1 = {
      "page": (++pageIndex),
      "available": widget.params['selectType'] == 0 ? '1' : '0', // 1可用 0不可用
      "express_line_id": widget.params['lineId'], // 线路ID
      "amount": widget.params['amount'], // 现金
    };

    var data = await CouponService.getList(params1);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ListRefresh(
      renderItem: renderItem,
      refresh: loadList,
      more: loadMoreList,
    );
  }

  Widget renderItem(index, UserCouponModel model) {
    return cellViews(index, model);
  }

  Widget cellViews(int index, UserCouponModel model) {
    return GestureDetector(
        onTap: () {
          if (widget.params['selectType'] == 0) {
            // if (widget.params['selectType'] == '0') {
            //   Navigator.of(context).pop(model);
            // }
            widget.onSelected(model);
          }
        },
        child: Container(
            margin: EdgeInsets.only(top: 10.h, left: 14.w, right: 14.w),
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.params['selectType'] == 0
                      ? const AssetImage(
                          "assets/images/AboutMe/youhuiquan@3x.png")
                      : const AssetImage(
                          "assets/images/AboutMe/youhuiquandiss@3x.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 1.sw - 60.w,
                    margin: EdgeInsets.only(top: 15.h),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: ZHTextLine(
                              str: model.coupon?.discountType == 2
                                  ? ((model.coupon?.weight ?? 0) / 1000)
                                          .toStringAsFixed(2) +
                                      (localizationInfo?.weightSymbol ?? '')
                                  : (model.coupon?.amount ?? 0).rate(),
                              color: BaseStylesConfig.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 8,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ZHTextLine(
                                    alignment: TextAlign.left,
                                    str: '满{price}可用'.tsArgs({
                                      'price': model.coupon?.discountType == 2
                                          ? ((model.coupon?.minWeight ?? 0) /
                                                      1000)
                                                  .toStringAsFixed(2) +
                                              (localizationInfo?.weightSymbol ??
                                                  '')
                                          : (model.coupon?.threshold ?? 0)
                                              .rate()
                                    }),
                                    color: BaseStylesConfig.white,
                                    fontSize: 17,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  ZHTextLine(
                                    alignment: TextAlign.left,
                                    str: model.coupon != null
                                        ? model.coupon!.effectedAt
                                                .substring(0, 10) +
                                            '-' +
                                            model.coupon!.expiredAt
                                                .substring(0, 10)
                                        : '',
                                    color: BaseStylesConfig.white,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenUtil().screenWidth - 60.w,
                    alignment: Alignment.center,
                    child: ZHTextLine(
                      alignment: TextAlign.left,
                      str: '适用范围'.ts +
                          '：' +
                          ((model.coupon?.scope ?? 0) == 1
                              ? model.coupon?.usableLines
                                      .map((e) => e['name'])
                                      .join(',') ??
                                  ''
                              : '全部范围'.ts),
                      color: BaseStylesConfig.white,
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: ScreenUtil().screenWidth - 120.w,
                        decoration: BoxDecoration(
                          color: widget.params['selectType'] == 0
                              ? const Color(0xFFffcc7e)
                              : BaseStylesConfig.textGray,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(17.5)),
                          // border: new Border.all(width: 1, color: Colors.white),
                        ),
                        child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                            ),
                            onPressed: () {},
                            child: ZHTextLine(
                              str: (widget.params['selectCoupon'] != null &&
                                      widget.params['selectCoupon'].id ==
                                          model.id)
                                  ? '取消使用'.ts
                                  : model.coupon?.name ?? '',
                              color: widget.params['selectType'] == 0
                                  ? BaseStylesConfig.textRed
                                  : BaseStylesConfig.white,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
