import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/withdrawal_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/user/agent/agent_commission/controller.dart';

class AgentCommissionPage extends GetView<AgentCommissionController> {
  const AgentCommissionPage({Key? key}) : super(key: key);

  // 主视图
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.1,
        centerTitle: true,
        title: AppText(
          str: '提现'.ts,
          color: AppColors.textBlack,
          fontSize: 17,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppGaps.line,
              Container(
                height: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppText(
                                  str: '共计'.ts + '：',
                                ),
                                Obx(
                                  () => AppText(
                                    str: controller.selectNum.value.rate(),
                                    color: AppColors.textRed,
                                  ),
                                )
                              ],
                            ),
                            Obx(
                              () => AppText(
                                str: '( ${'{count}条记录'.tsArgs({
                                      'count': controller.selModelList.length
                                    })} )',
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.onApply,
                        child: Container(
                          color: AppColors.primary,
                          alignment: Alignment.center,
                          child: AppText(
                            str: '提交'.ts,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshView(
        renderItem: apllyOrderItem,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
      // body: Column(
      //   children: <Widget>[
      //     Expanded(
      //       child: PrepaidList(

      //           onChanged: (WithdrawalModel number) {
      //             if (number.settled == 0) return;
      //             if (controller.selModelList.contains(number)) {
      //               controller.selModelList.remove(number);
      //             } else {
      //               controller.selModelList.add(number);
      //             }
      //             controller.selModelList.refresh();
      //             int totalMoney = 0;
      //             for (WithdrawalModel item in controller.selModelList) {
      //               totalMoney += item.commissionAmount;
      //             }
      //             controller.selectNum.value = totalMoney;
      //           },
      //           onChangedDtatList: (List<WithdrawalModel> data) {
      //             if (data.isEmpty) {
      //               controller.allModelList.clear();
      //             } else {
      //               controller.allModelList.addAll(data);
      //             }
      //           },
      //         ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget apllyOrderItem(index, WithdrawalModel model) {
    var container = GestureDetector(
        onTap: () {
          // widget.onChanged!(model);
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.line),
              ),
            ),
            child: Row(
              children: <Widget>[
                // Container(
                //   width: 40,
                //   alignment: Alignment.centerLeft,
                //   child: model.settled == 0
                //       ? const Icon(
                //           Icons.circle,
                //           color: AppColors.textGrayC,
                //         )
                //       : widget.params['selList'].contains(model)
                //           ? const Icon(
                //               Icons.check_circle,
                //               color: AppColors.green,
                //             )
                //           : const Icon(
                //               Icons.radio_button_off,
                //               color: AppColors.bgGray,
                //             ),
                // ),
                Opacity(
                  opacity: model.settled == 0 ? 0.3 : 1,
                  child: Obx(
                    () => Checkbox.adaptive(
                      activeColor: AppColors.primary,
                      value: controller.selModelList.contains(model),
                      shape: const CircleBorder(),
                      onChanged: (value) {
                        if (value == null || model.settled == 0) return;
                        if (controller.selModelList.contains(model)) {
                          controller.selModelList.remove(model);
                        } else {
                          controller.selModelList.add(model);
                        }
                        controller.selModelList.refresh();
                        int totalMoney = 0;
                        for (WithdrawalModel item in controller.selModelList) {
                          totalMoney += item.commissionAmount;
                        }
                        controller.selectNum.value = totalMoney;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: [
                                AppText(
                                  str: model.createdAt,
                                  fontSize: 13,
                                  color: model.settled == 0
                                      ? AppColors.textGray
                                      : Colors.black,
                                ),
                                5.horizontalSpace,
                                model.settled == 0
                                    ? Flexible(
                                        child: AppText(
                                          str: '等待确认'.ts,
                                          fontSize: 13,
                                          color: AppColors.textRed,
                                        ),
                                      )
                                    : AppGaps.empty,
                              ],
                            ),
                          ),
                          AppText(
                            str: model.orderAmount.rate(),
                            fontSize: 13,
                          ),
                        ],
                      ),
                      AppGaps.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AppText(
                            str: model.orderNumber,
                            fontSize: 13,
                            color: model.settled == 0
                                ? AppColors.textGray
                                : Colors.black,
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: AppText(
                                    str: '佣金'.ts + '：',
                                    fontSize: 13,
                                  ),
                                ),
                                AppText(
                                  str: '+' + model.commissionAmount.rate(),
                                  fontSize: 13,
                                  color: AppColors.textRed,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
    return container;
  }
}

/*
  可提现列表
 */
