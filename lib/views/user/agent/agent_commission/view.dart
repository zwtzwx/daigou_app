import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/withdrawal_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/user/agent/agent_commission/controller.dart';

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
          str: '提现'.inte,
          color: AppStyles.textBlack,
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
                                  str: '共计'.inte + '：',
                                ),
                                Obx(
                                  () => AppText(
                                    str: controller.selectNum.value
                                        .priceConvert(),
                                    color: AppStyles.textRed,
                                  ),
                                )
                              ],
                            ),
                            Obx(
                              () => AppText(
                                str: '( ${'{count}条记录'.inArgs({
                                      'count': controller.selModelList.length
                                    })} )',
                                color: AppStyles.textGray,
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
                          color: AppStyles.primary,
                          alignment: Alignment.center,
                          child: AppText(
                            str: '提交'.inte,
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
              color: AppStyles.white,
              border: Border(
                bottom: BorderSide(color: AppStyles.line),
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
                //           color: AppStyles.textGrayC,
                //         )
                //       : widget.params['selList'].contains(model)
                //           ? const Icon(
                //               Icons.check_circle,
                //               color: AppStyles.green,
                //             )
                //           : const Icon(
                //               Icons.radio_button_off,
                //               color: AppStyles.bgGray,
                //             ),
                // ),
                Opacity(
                  opacity: model.settled == 0 ? 0.3 : 1,
                  child: Obx(
                    () => Checkbox.adaptive(
                      activeColor: AppStyles.primary,
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
                                      ? AppStyles.textGray
                                      : Colors.black,
                                ),
                                5.horizontalSpace,
                                model.settled == 0
                                    ? Flexible(
                                        child: AppText(
                                          str: '等待确认'.inte,
                                          fontSize: 13,
                                          color: AppStyles.textRed,
                                        ),
                                      )
                                    : AppGaps.empty,
                              ],
                            ),
                          ),
                          AppText(
                            str: model.orderAmount.priceConvert(),
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
                                ? AppStyles.textGray
                                : Colors.black,
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: AppText(
                                    str: '佣金'.inte + '：',
                                    fontSize: 13,
                                  ),
                                ),
                                AppText(
                                  str: '+' +
                                      model.commissionAmount.priceConvert(),
                                  fontSize: 13,
                                  color: AppStyles.textRed,
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
