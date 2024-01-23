import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/localization_model.dart';
import 'package:huanting_shop/models/user_coupon_model.dart';
import 'package:huanting_shop/services/coupon_service.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/user/coupon/controller.dart';

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
          str: '优惠券'.ts,
          fontSize: 17,
        ),
        bottom: TabBar(
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            controller: controller.tabController,
            onTap: (int index) {
              controller.pageController.jumpToPage(index);
            },
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AppText(
                  str: '可用'.ts,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AppText(
                  str: '不可用'.ts,
                ),
              ),
            ]),
      ),
      bottomNavigationBar: Obx(
        () => controller.canSelect.value
            ? Container(
                color: AppColors.white,
                padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      AppText(str: '可抵扣'.ts + '：'),
                      AppText(
                          color: AppColors.textRed,
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
                      10.horizontalSpace,
                      SizedBox(
                        height: 30.h,
                        child: BeeButton(
                          text: '确认',
                          onPressed: () {
                            BeeNav.pop({
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
      backgroundColor: AppColors.bgGray,
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
    return RefreshView(
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
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
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
                      Expanded(
                        flex: 4,
                        child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: widget.params['selectType'] == 1
                                    ? const ColorFilter.mode(
                                        Color(0xFFBFBFBF), BlendMode.color)
                                    : null,
                                image: const AssetImage(
                                    "assets/images/Center/coupon-new.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Column(
                              children: [
                                10.verticalSpaceFromWidth,
                                model.coupon?.discountType == 2
                                    ? RichText(
                                        text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ((model.coupon?.weight ?? 0) /
                                                    1000)
                                                .rate(
                                              showInt: true,
                                              showPriceSymbol: false,
                                              needFormat: false,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ' +
                                                (localizationInfo
                                                        ?.weightSymbol ??
                                                    ''),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ))
                                    : RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.white,
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
                                              ),
                                            ),
                                            TextSpan(
                                              text: (model.coupon?.amount ?? 0)
                                                  .rate(
                                                      showInt: true,
                                                      showPriceSymbol: false),
                                            ),
                                          ],
                                        ),
                                      ),
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: 30.h,
                                  ),
                                  child: AppText(
                                    str: '满{price}可用'.tsArgs({
                                      'price': model.coupon?.discountType == 2
                                          ? ((model.coupon?.minWeight ?? 0) /
                                                      1000)
                                                  .rate(
                                                      showInt: true,
                                                      showPriceSymbol: false,
                                                      needFormat: false) +
                                              (localizationInfo?.weightSymbol ??
                                                  '')
                                          : (model.coupon?.threshold ?? 0)
                                              .rate()
                                    }),
                                    color: AppColors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                10.verticalSpaceFromWidth,
                                AppText(
                                  str: model.coupon?.discountType == 0
                                      ? '抵现券'.ts
                                      : '抵重券'.ts,
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                                8.verticalSpaceFromWidth,
                              ],
                            )),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 35.h,
                              ),
                              child: AppText(
                                str: model.coupon?.name ?? '',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.verticalSpaceFromWidth,
                            AppText(
                              str: model.coupon != null
                                  ? model.coupon!.effectedAt.substring(0, 10) +
                                      '-' +
                                      model.coupon!.expiredAt.substring(0, 10)
                                  : '',
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                            5.verticalSpaceFromWidth,
                            AppText(
                              str: '适用范围'.ts +
                                  '：' +
                                  ((model.coupon?.scope ?? 0) == 1
                                      ? '部分线路'.ts
                                      : '全部范围'.ts),
                              fontSize: 12,
                              lines: 2,
                              // fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      model.isOpen = !model.isOpen;
                    });
                  },
                  child: Icon(
                    model.isOpen
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 30.sp,
                  ),
                ),
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
                    : '全部范围'.ts),
                fontSize: 12,
                lines: 10,
                // fontWeight: FontWeight.bold,
              ),
              5.verticalSpace,
              (model.remark ?? '').isNotEmpty
                  ? AppText(
                      str: '说明'.ts + '：' + model.remark!,
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
