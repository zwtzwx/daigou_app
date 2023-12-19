import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/agent_commission_record_model.dart';
import 'package:jiyun_app_client/models/agent_commissions_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/user/agent/agent_withdraw_record/controller.dart';

class AgentWithdrawRecordPage extends GetView<AgentWithdrawRecordController> {
  const AgentWithdrawRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: AppText(
          str: '成交记录'.ts,
          fontSize: 18,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: AppColors.bgGray,
      body: RefreshView(
        renderItem: renderItem,
        refresh: controller.loadData,
        more: controller.loadMoreData,
      ),
    );
  }

  renderItem(int index, AgentCommissionRecordModel model) {
    return Container(
      color: Colors.white,
      child: Obx(
        () => ExpansionPanelList(
          elevation: 0,
          dividerColor: AppColors.line,
          expansionCallback: (index, open) {
            if (open) {
              controller.dataList.remove(model.createdAt);
            } else {
              controller.dataList.add(model.createdAt);
            }
          },
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Container(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        str: model.createdAt.split(' ')[0],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            str: model.orderAmount.rate(),
                            color: AppColors.textGray,
                          ),
                          AppText(
                            str: '佣金'.ts + '：+' + model.commissionAmount.rate(),
                            color: AppColors.textGray,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              body: Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                color: const Color(0xFFE9E9E9),
                child: ListView.builder(
                  itemCount: model.data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    AgentCommissionsModel commissionModel = model.data[index];
                    return buildCommissionList(commissionModel);
                  },
                ),
              ),
              isExpanded: controller.dataList.contains(model.createdAt),
              canTapOnHeader: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommissionList(AgentCommissionsModel model) {
    return Column(
      children: [
        AppGaps.vGap5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              str: model.createdAt.split(' ')[1],
              fontSize: 13,
            ),
            AppText(
              str: model.orderAmount.rate(),
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              str: '转运单号'.ts + '：' + model.orderNumber,
              fontSize: 13,
            ),
            AppText(
              str: '佣金'.ts + '：+' + model.commissionAmount.rate(),
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ],
        ),
      ],
    );
  }
}
