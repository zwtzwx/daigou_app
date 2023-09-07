import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/consult_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/shop/order_chat/shop_order_chat_controller.dart';

class ShopOrderChatView extends GetView<ShopOrderChatController> {
  const ShopOrderChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ZHTextLine(
          str: '我的咨询'.ts,
          fontSize: 17,
        ),
        elevation: 0,
        backgroundColor: BaseStylesConfig.bgGray,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: SafeArea(
        child: ListRefresh(
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
        margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ZHTextLine(
                    str: '订单'.ts + (model.orderSn ?? ''),
                    color: BaseStylesConfig.textGrayC9,
                    fontSize: 12,
                  ),
                ),
                5.horizontalSpace,
                ZHTextLine(
                  str: (model.createdAt ?? '').split(' ').first,
                  color: BaseStylesConfig.textGrayC9,
                  fontSize: 12,
                )
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ZHTextLine(
                    str: model.content ?? '',
                    fontSize: 14,
                  ),
                ),
                model.hasNewMessage
                    ? ClipOval(
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          color: BaseStylesConfig.textRed,
                        ),
                      )
                    : Sized.empty,
              ],
            )
          ],
        ),
      ),
    );
  }
}
