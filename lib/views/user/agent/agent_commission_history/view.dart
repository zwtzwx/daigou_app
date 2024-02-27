import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/withdrawal_item_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/user/agent/agent_commission_history/controller.dart';

class AgentCommissionHistoryPage
    extends GetView<AgentCommissionHistoryController> {
  const AgentCommissionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '佣金报表'.ts,
          color: AppColors.textBlack,
          fontSize: 17,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      // bottomNavigationBar: bottomListBtn(),
      body: RefreshView(
        renderItem: renderItem,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
  }

  // 底部按钮
  // Widget bottomListBtn() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: GestureDetector(
  //           onTap: () {
  //             BeeNav.push(BeeNav.agentCommissionList);
  //           },
  //           child: Container(
  //             height: 65,
  //             alignment: Alignment.center,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 10,
  //             ),
  //             color: AppColors.primary,
  //             child: AppText(
  //               str: '我要提现'.ts,
  //               fontSize: 17,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: GestureDetector(
  //           onTap: () {
  //             BeeNav.push(BeeNav.agentWithdrawRecord);
  //           },
  //           child: Container(
  //             height: 65,
  //             alignment: Alignment.center,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 10,
  //             ),
  //             color: Colors.white,
  //             child: AppText(
  //               str: '成交记录'.ts,
  //               fontSize: 17,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget renderItem(index, WithdrawalItemModel model) {
    var container = Container(
      margin: const EdgeInsets.only(right: 15, left: 15, top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          5.verticalSpace,
          Center(
            child: AppText(
              str: model.serialNo,
              fontSize: 14,
            ),
          ),
          5.verticalSpace,
          Center(
            child: AppText(
              str: model.amount.rate(),
              fontSize: 22,
              color: AppColors.textRed,
            ),
          ),
          15.verticalSpaceFromWidth,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                AppText(
                  str: '收款账号'.ts + '：',
                  color: AppColors.textGrayC9,
                  fontSize: 14,
                ),
                AppText(
                  str: model.user?.name ?? '',
                ),
              ],
            ),
          ),
          5.verticalSpaceFromWidth,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                AppText(
                  str: '收款方式'.ts + '：',
                  color: AppColors.textGrayC9,
                  fontSize: 14,
                ),
                AppText(
                  str: model.withdrawTypeName,
                ),
              ],
            ),
          ),
          5.verticalSpaceFromWidth,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                AppText(
                  str: '结算状态'.ts + '：',
                  color: AppColors.textGrayC9,
                  fontSize: 14,
                ),
                AppText(
                  str: model.status == 0
                      ? '审核中'.ts
                      : (model.status == 1 ? '审核通过' : '审核拒绝').ts,
                  color: model.status == 0
                      ? AppColors.primary
                      : (model.status == 2 ? AppColors.textRed : Colors.black),
                ),
              ],
            ),
          ),
          5.verticalSpaceFromWidth,
          AppGaps.line,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: GestureDetector(
              onTap: () {
                BeeNav.push(BeeNav.agentWithdrawDetail, arg: {"id": model.id});
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      str: '查看详情'.ts,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textGray,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return container;
  }
}
