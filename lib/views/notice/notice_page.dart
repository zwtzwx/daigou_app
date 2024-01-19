import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/text_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/notice_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/notice/notice_controller.dart';

class InformationView extends GetView<InformationLogic> {
  const InformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '通知'.ts,
          fontSize: 18,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: AppColors.bgGray,
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
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: index == 0
                ? BorderSide.none
                : const BorderSide(color: AppColors.line),
          ),
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
                      Text(
                        model.title ?? '',
                        style: AppTextStyles.textBoldDark14,
                      ),
                      model.read == 0
                          ? Positioned(
                              right: -8,
                              child: ClipOval(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  color: AppColors.textRed,
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
                  color: AppColors.textGray,
                  fontSize: 12,
                )
              ],
            ),
            AppGaps.vGap10,
            Text(
              model.content ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
