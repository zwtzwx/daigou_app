import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/text_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/notice_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/notice/notice_controller.dart';

class InformationView extends GetView<InformationLogic> {
  const InformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '我的消息'.inte,
          fontSize: 18,
        ),
        // elevation: 0.5,
        backgroundColor: AppStyles.bgGray,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: AppStyles.bgGray,
      body: RefreshView(
        renderItem: noticeItemCell,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
  }

  Widget noticeItemCell(int index, NoticeModel model) {
    return GestureDetector(
      onTap: () {
        controller.onDetail(model, index);
      },
      child: Container(
        margin:EdgeInsets.symmetric(horizontal: 14,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // border: Border(
          //   top: index == 0
          //       ? BorderSide.none
          //       : const BorderSide(color: AppStyles.line),
          // ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppText(
                        str: model.title ?? '',
                        fontSize: 12,
                        color: Color(0xff999999),
                      ),
                      model.read == 0
                          ? Positioned(
                              right: -8,
                              child: ClipOval(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  color: AppStyles.textRed,
                                ),
                              ),
                            )
                          : AppGaps.empty,
                    ],
                  ),
                ),
                AppGaps.hGap5,
                AppText(
                  str: model.createdAt ?? '',
                  color: AppStyles.textGray,
                  fontSize: 10,
                )
              ],
            ),
            AppGaps.vGap10,
            AppText(
              str: model.content ?? '',
              fontSize: 14,
              color: Color(0xff333333),
            )
          ],
        ),
      ),
    );
  }
}
