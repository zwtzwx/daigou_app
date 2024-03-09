import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/shop/consult_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/shop/order_chat/shop_order_chat_controller.dart';

class ShopOrderChatView extends GetView<ShopOrderChatController> {
  const ShopOrderChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '我的咨询'.inte,
          fontSize: 17,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: AppStyles.bgGray,
      body: SafeArea(
        child: RefreshView(
          renderItem: consultCell,
          refresh: controller.loadData,
          more: controller.loadMoreData,
        ),
      ),
    );
  }

  Widget consultCell(int index, ConsultModel model) {
    return GestureDetector(
      onTap: () {
        controller.onDetail(model);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AppText(
                    str: '订单'.inte + (model.orderSn ?? ''),
                    color: AppStyles.textGrayC9,
                    fontSize: 12,
                  ),
                ),
                5.horizontalSpace,
                AppText(
                  str: (model.createdAt ?? '').split(' ').first,
                  color: AppStyles.textGrayC9,
                  fontSize: 12,
                )
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppText(
                    str: model.content ?? '',
                    fontSize: 14,
                  ),
                ),
                model.hasNewMessage
                    ? ClipOval(
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          color: AppStyles.textRed,
                        ),
                      )
                    : AppGaps.empty,
              ],
            )
          ],
        ),
      ),
    );
  }
}
