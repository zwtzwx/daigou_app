import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/group/widget/countdown_widget.dart';
import 'package:jiyun_app_client/views/payment/shop_pay/shop_order_pay_conctroller.dart';

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
        title: ZHTextLine(
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
                          color: BaseStylesConfig.textDark,
                        ),
                        children: [
                          TextSpan(text: '总计'.ts + '：'),
                          TextSpan(
                            text: controller.totalAmount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: BaseStylesConfig.textRed,
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
                          color: BaseStylesConfig.textGrayC9,
                          size: 18.sp,
                        ),
                        2.horizontalSpace,
                        ZHTextLine(
                          str: '不含国际运费'.ts,
                          color: BaseStylesConfig.textGrayC9,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MainButton(
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
      backgroundColor: BaseStylesConfig.bgGray,
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
                      LoadImage(
                        'Shop/order_pay',
                        width: 150.w,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: controller.problemOrder.value != null
                                ? controller.problemOrder.value!.amount
                                : controller.totalAmount.toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36.sp,
                              color: BaseStylesConfig.textDark,
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
                          : Sized.empty,
                      10.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ZHTextLine(
                            str: '${'余额'.ts}：' +
                                controller.myBalance.value.toStringAsFixed(2),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Routers.push('/RechargePage', context);
                            },
                            child: Row(
                              children: <Widget>[
                                ZHTextLine(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 30.w,
                    width: 30.w,
                    child: Image.asset(controller.getPayTypeIcon(typeMap.name)),
                  ),
                  ZHTextLine(
                    str: Util.getPayTypeName(typeMap.name),
                  ),
                ],
              ),
              Obx(() => controller.selectedPayType.value == typeMap
                  ? const Icon(
                      Icons.check_circle,
                      color: BaseStylesConfig.green,
                    )
                  : const Icon(Icons.radio_button_unchecked,
                      color: BaseStylesConfig.textGray)),
            ],
          ),
        ));
  }
}
