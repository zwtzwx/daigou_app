import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/common/util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/pay_type_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/group/widget/countdown_widget.dart';
import 'package:huanting_shop/views/payment/shop_pay/shop_order_pay_conctroller.dart';

class ShopOrderPayView extends GetView<ShopOrderPayController> {
  const ShopOrderPayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '订单支付'.ts,
          fontSize: 17,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 5.r, color: const Color(0x0D000000)),
          ],
        ),
        child: SafeArea(
            child: Row(
          children: [
            Obx(
              () => Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textDark,
                        ),
                        children: [
                          TextSpan(text: '总计'.ts + '：'),
                          TextSpan(
                            text:
                                controller.totalAmount.rate(needFormat: false),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    2.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.textGrayC9,
                          size: 18.sp,
                        ),
                        2.horizontalSpace,
                        AppText(
                          str: '不含国际运费'.ts,
                          color: AppColors.textGrayC9,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BeeButton(
              text: '确认支付',
              borderRadis: 999,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              onPressed: () {
                controller.onPay(context);
              },
            ),
          ],
        )),
      ),
      backgroundColor: AppColors.bgGray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                () => Container(
                  margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ImgItem(
                        'Shop/order_pay',
                        width: 150.w,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: controller.currencyModel.value?.symbol ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              color: AppColors.textDark,
                            ),
                          ),
                          TextSpan(
                            text: controller.problemOrder.value != null
                                ? num.parse(
                                        controller.problemOrder.value!.amount ??
                                            '0')
                                    .rate(
                                        showPriceSymbol: false,
                                        needFormat: false)
                                : controller.totalAmount.rate(
                                    showPriceSymbol: false, needFormat: false),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36.sp,
                              color: AppColors.textDark,
                            ),
                          ),
                        ]),
                      ),
                      5.verticalSpace,
                      controller.problemOrder.value == null
                          ? CountdownWidget(
                              total: controller.endUtil.value,
                              orderPay: true,
                            )
                          : AppGaps.empty,
                      10.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AppText(
                            str: '${'余额'.ts}：' +
                                controller.myBalance.value
                                    .rate(needFormat: false),
                          ),
                          GestureDetector(
                            onTap: () {
                              BeeNav.push(BeeNav.recharge, context);
                            },
                            child: Row(
                              children: <Widget>[
                                AppText(
                                  str: '充值'.ts,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Container(
                    height: (controller.payTypeList.length * 50).toDouble(),
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 14.w),
                    child: showPayTypeView()),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // 支付方式列表
  Widget showPayTypeView() {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: payTypeCell,
      itemCount: controller.payTypeList.length,
    );
    return listView;
  }

  Widget payTypeCell(BuildContext context, int index) {
    PayTypeModel typeMap = controller.payTypeList[index];

    return GestureDetector(
        onTap: () {
          if (controller.selectedPayType.value == typeMap) return;
          controller.selectedPayType.value = typeMap;
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(right: 15, left: 15),
          height: 50,
          width: ScreenUtil().screenWidth,
          child: Row(
            children: [
              ImgItem(
                controller.getPayTypeIcon(typeMap.name),
                height: 30.w,
                width: 30.w,
              ),
              15.horizontalSpace,
              Expanded(
                child: AppText(
                  str: CommonMethods.getPayTypeName(typeMap.name).ts,
                ),
              ),
              Obx(() => controller.selectedPayType.value == typeMap
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.green,
                    )
                  : const Icon(Icons.radio_button_unchecked,
                      color: AppColors.textGray)),
            ],
          ),
        ));
  }
}
