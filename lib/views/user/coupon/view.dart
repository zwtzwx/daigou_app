import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/localization_model.dart';
import 'package:shop_app_client/models/user_coupon_model.dart';
import 'package:shop_app_client/services/coupon_service.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/user/coupon/controller.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';

class CouponPage extends GetView<CouponController> {
  const CouponPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '优惠券'.inte,
          fontSize: 17,
        ),
        bottom: TabBar(
            padding: EdgeInsets.only(left: 60.w, right: 60.w),
            labelColor: AppStyles.primary,
            indicatorColor: AppStyles.primary,
            indicatorWeight: 4,
            indicatorPadding: EdgeInsets.symmetric(vertical: 8.w),
            // indicatorPadding: EdgeInsets.symmetric(horizontal: 50.w),
            controller: controller.tabController,
            onTap: (int index) {
              controller.pageController.jumpToPage(index);
            },
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AppText(
                  str: '可用'.inte,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AppText(
                  str: '不可用'.inte,
                ),
              ),
            ]),
      ),
      bottomNavigationBar: Obx(
        () => controller.canSelect.value
            ? Container(
                color: AppStyles.white,
                padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      AppText(str: '可抵扣'.inte + '：'),
                      AppText(
                          color: AppStyles.textRed,
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
                                  .priceConvert()),
                      10.horizontalSpace,
                      SizedBox(
                        height: 30.h,
                        child: BeeButton(
                          text: '确认',
                          onPressed: () {
                            GlobalPages.pop({
                              'confirm': true,
                              'selectCoupon': controller.selectCoupon.value,
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AppGaps.empty,
      ),
      backgroundColor: AppStyles.bgGray,
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
    };

    if ((widget.params['lineId'] ?? '').isNotEmpty) {
      params1.addAll({
        "express_line_id": widget.params['lineId'], // 线路ID
        "amount": widget.params['amount'], // 现金
      });
    }

    var data = await CouponService.getList(params1);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: RefreshView(
                renderItem: renderItem,
                refresh: loadList,
                more: loadMoreList,
                isCoupoun: true)),
        widget.params['selectType'] == 0?Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38.h,
                  child: BeeButton(
                    onPressed: () async {
                      await BaseDialog.typeDialog(Get.context!, 1, (params) {
                        CouponService.exchangeCoupon(
                            {'code': params['exchange']}, (msg) {
                          //   刷新优惠券列表

                        }, (err) {});
                      }, {'avatar': '', 'name': ''});
                    },
                    text: '兑换',
                  ),
                ),
              ),
            ],
          ),
        ):AppGaps.empty,
      ],
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
        // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: widget.params['selectType'] == 1
                ? AssetImage('assets/images/Home/yhq-none.png')
                : AssetImage('assets/images/Home/yhq.png'),
            fit: BoxFit.fill, // 完全填充
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      10.horizontalSpace,
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            10.verticalSpace,
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              constraints: BoxConstraints(
                                minHeight: 20.h,
                              ),
                              child: AppText(
                                str: model.coupon?.name ?? '',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            5.verticalSpaceFromWidth,
                            // 时间
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: AppText(
                                str: model.coupon != null
                                    ? model.coupon!.effectedAt
                                            .substring(0, 10) +
                                        '-' +
                                        model.coupon!.expiredAt.substring(0, 10)
                                    : '',
                                fontSize: 12,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.verticalSpaceFromWidth,
                            // 适用范围
                            // AppText(
                            //   str: '适用范围'.inte +
                            //       '：' +
                            //       ((model.coupon?.scope ?? 0) == 1
                            //           ? '部分线路'.inte
                            //           : '全部范围'.inte),
                            //   fontSize: 12,
                            //   color: Colors.white,
                            //   lines: 2,
                            //   // fontWeight: FontWeight.bold,
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            // 原来
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            10.verticalSpaceFromWidth,
                            10.verticalSpaceFromWidth,
                            model.coupon?.discountType == 2
                                ? RichText(
                                    text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      color: widget.params['selectType'] == 1
                                          ? Color(0xff959595)
                                          : Color(0xffE55152),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            ((model.coupon?.weight ?? 0) / 1000)
                                                .priceConvert(
                                          showInt: true,
                                          showPriceSymbol: false,
                                          needFormat: false,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ' +
                                            (localizationInfo?.weightSymbol ??
                                                ''),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color:
                                              widget.params['selectType'] == 1
                                                  ? Color(0xff959595)
                                                  : Color(0xffE55152),
                                        ),
                                      ),
                                    ],
                                  ))
                                : RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        color: widget.params['selectType'] == 1
                                            ? Color(0xff959595)
                                            : Color(0xffE55152),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: (localizationInfo
                                                      ?.currencySymbol ??
                                                  '') +
                                              ' ',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color:
                                                widget.params['selectType'] == 1
                                                    ? Color(0xff959595)
                                                    : Color(0xffE55152),
                                          ),
                                        ),
                                        TextSpan(
                                          text: (model.coupon?.amount ?? 0)
                                              .priceConvert(
                                                  showInt: true,
                                                  showPriceSymbol: false),
                                        ),
                                      ],
                                    ),
                                  ),
                            Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  // minHeight: 20.h,
                                maxWidth: 100.w
                                  ),
                              child: Text(
                                '满{price}可用'.inArgs({
                                  'price': model.coupon?.discountType == 2
                                      ? ((model.coupon?.minWeight ?? 0) / 1000)
                                      .priceConvert(
                                      showInt: true,
                                      showPriceSymbol: false,
                                      needFormat: false) +
                                      (localizationInfo?.weightSymbol ?? '')
                                      : (model.coupon?.threshold ?? 0)
                                      .priceConvert()
                                }),
                                softWrap: true,
                                textAlign:TextAlign.center,
                                style: TextStyle(
                                  color: widget.params['selectType'] == 1
                                      ? Color(0xff959595)
                                      : Color(0xffE55152),
                                  fontSize: 10,
                                ),
                              )
                            ),
                            10.verticalSpaceFromWidth,
                            // AppText(
                            //   str: model.coupon?.discountType == 0
                            //       ? '抵现券'.inte
                            //       : '抵重券'.inte,
                            //   color: Color(0xffE55152),
                            //   fontSize: 14,
                            // ),
                            8.verticalSpaceFromWidth,
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       model.isOpen = !model.isOpen;
                //     });
                //   },
                //   child: Icon(
                //     model.isOpen
                //         ? Icons.keyboard_arrow_down
                //         : Icons.keyboard_arrow_up,
                //     size: 30.sp,
                //   ),
                // ),
              ],
            ),
            8.verticalSpaceFromWidth,
            if (model.isOpen) ...[
              AppText(
                str: ((model.coupon?.scope ?? 0) == 1
                    ? model.coupon?.usableLines
                            .map((e) => e['name'])
                            .join(',') ??
                        ''
                    : '全部范围'.inte),
                fontSize: 12,
                lines: 10,
                // fontWeight: FontWeight.bold,
              ),
              5.verticalSpace,
              (model.remark ?? '').isNotEmpty
                  ? AppText(
                      str: '说明'.inte + '：' + model.remark!,
                      fontSize: 12,
                      lines: 5,
                      // fontWeight: FontWeight.bold,
                    )
                  : AppGaps.empty,
            ]
          ],
        ),
      ),
    );
  }
}
