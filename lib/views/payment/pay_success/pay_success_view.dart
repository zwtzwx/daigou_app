import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/payment/pay_success/pay_success_controller.dart';

class PaySuccessView extends GetView<PaySuccessController> {
  const PaySuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '支付成功'.ts,
          fontSize: 17,
        ),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              20.verticalSpace,
              ImgItem(
                'Shop/pay_success',
                width: 150.w,
              ),
              10.verticalSpace,
              AppText(
                str: '支付成功'.ts,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              20.verticalSpace,
              Obx(
                () => SizedBox(
                  width: 150.w,
                  height: 32.h,
                  child: HollowButton(
                    borderRadis: 999,
                    textColor: AppColors.textDark,
                    text: controller.isShopOrder.value ? '继续逛逛' : '返回',
                    onPressed: controller.onShopCenter,
                  ),
                ),
              ),
              10.verticalSpace,
              SizedBox(
                width: 150.w,
                height: 32.h,
                child: BeeButton(
                  text: '查看订单',
                  borderRadis: 999,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  onPressed: controller.onOrderDetail,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
