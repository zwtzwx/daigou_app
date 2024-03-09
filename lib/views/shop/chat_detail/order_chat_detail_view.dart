import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/shop/consult_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/shop/chat_detail/order_chat_detail_controller.dart';

class ShopChatDetailView extends GetView<ShopOrderChatDetailController> {
  const ShopChatDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: '订单'.inte + (controller.order.value?.orderSn ?? ''),
            fontSize: 17,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: const Color(0xfff9f9f9),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: BaseInput(
                  isCollapsed: true,
                  controller: controller.messageController,
                  focusNode: controller.messageNode,
                  autoShowRemove: false,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  autoRemoveController: false,
                  hintText: '发消息'.inte + '...',
                  maxLength: 300,
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  textInputAction: TextInputAction.newline,
                ),
              ),
              10.horizontalSpace,
              GestureDetector(
                onTap: controller.onSendMessage,
                child: Icon(
                  Icons.send_rounded,
                  color: AppStyles.textDark,
                  size: 30.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () => ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.messageList.keys.length,
            itemBuilder: (context, index) {
              var key = controller.messageList.keys.toList()[index];
              return messageItemCell(key, controller.messageList[key]!);
            }),
      ),
    );
  }

  Widget messageItemCell(String time, List<ConsultContentModel> message) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: AppText(
            str: time,
            fontSize: 10,
            color: AppStyles.textGrayC9,
          ),
        ),
        ...message.map(
          (e) => Container(
            margin: EdgeInsets.only(bottom: 10.h, left: 14.w, right: 14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  e.isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: e.isRight
                  ? [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            str: e.nickName ?? '',
                            fontSize: 14,
                          ),
                          2.verticalSpace,
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 0.6.sw,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 9.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: const Color(0xFFFFF9DB),
                              ),
                              child: Text(
                                e.content ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      10.horizontalSpace,
                      ClipOval(
                        child: ImgItem(
                          controller.userInfoModel.userInfo.value?.avatar ?? '',
                          width: 40.w,
                          height: 40.w,
                        ),
                      ),
                    ]
                  : [
                      ClipOval(
                        child: ImgItem(
                          'Home/contact',
                          width: 40.w,
                          height: 40.w,
                        ),
                      ),
                      10.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            str: e.nickName ?? '',
                            fontSize: 14,
                          ),
                          2.verticalSpace,
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 0.6.sw,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 9.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppStyles.bgGray,
                              ),
                              child: Text(
                                e.content ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
            ),
          ),
        )
      ],
    );
  }
}
