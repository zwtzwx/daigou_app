import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/group/group_member_detail/controller.dart';
import 'package:jiyun_app_client/views/group/widget/member_avatar_widget.dart';

class GroupMemberDetailPage extends GetView<GroupMemberDetailController> {
  const GroupMemberDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: AppText(
          str: '参团详情'.ts,
          fontSize: 17,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: Obx(() => controller.groupModel.value != null
          ? SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str: controller.groupModel.value!.orderSn!,
                        ),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              color: AppColors.textBlack,
                            ),
                            children: [
                              TextSpan(
                                text: '已提交'.ts + ' ',
                              ),
                              TextSpan(
                                text:
                                    '${controller.groupModel.value!.membersSubmittedCount ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '/${controller.groupModel.value!.membersCount ?? 0}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppGaps.vGap15,
                    AppGaps.line,
                    ...controller.groupModel.value!.members!
                        .map((e) => memberItemCell(e))
                        .toList(),
                    AppGaps.vGap10,
                    infoItemCell(
                      '全团已入库包裹数量',
                      '${controller.groupModel.value!.packagesCount!}${'个'.ts}',
                      isWeight: false,
                    ),
                    infoItemCell(
                        '全团已入库包裹重量',
                        (controller.groupModel.value!.packageWeight! / 1000)
                            .toStringAsFixed(2)),
                    infoItemCell(
                        '全团已入库包裹体积重量',
                        (controller.groupModel.value!.packageVolumeWeight! /
                                1000)
                            .toStringAsFixed(2)),
                  ],
                ),
              ),
            )
          : AppGaps.empty),
    );
  }

  Widget infoItemCell(String label, String content, {bool isWeight = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: label.ts + '*：',
            style: const TextStyle(
              color: AppColors.textGray,
            ),
          ),
          TextSpan(
            text: content +
                (isWeight ? (controller.localModel?.weightSymbol ?? '') : ''),
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }

  Widget memberItemCell(GroupMemberModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.line),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MemberAvatarWidget(
            member: model,
            right: -30,
            leaderFirst: true,
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  str: model.name ?? '',
                ),
                AppGaps.vGap10,
                model.isSubmitted == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...model.packages!
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: AppText(
                                    str: e,
                                  ),
                                ),
                              )
                              .toList(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: AppText(
                              str: '拼团订单号'.ts + '：' + (model.ordern ?? ''),
                              lines: 2,
                              color: AppColors.textGray,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: AppText(
                              str: '入库重量'.ts +
                                  '：' +
                                  ((model.weight ?? 0) / 1000)
                                      .toStringAsFixed(2) +
                                  (controller.localModel?.weightSymbol ?? ''),
                              lines: 2,
                              color: AppColors.textGray,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: AppText(
                              str: '入库体积重量'.ts +
                                  '：' +
                                  ((model.volumeWeight ?? 0) / 1000)
                                      .toStringAsFixed(2) +
                                  (controller.localModel?.weightSymbol ?? ''),
                              lines: 2,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      )
                    : AppText(
                        str: '还未提交包裹'.ts,
                        color: AppColors.textGray,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
