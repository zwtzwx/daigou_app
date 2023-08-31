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
        title: ZHTextLine(
          str: '成交记录'.ts,
          fontSize: 18,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: ListRefresh(
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
          dividerColor: BaseStylesConfig.line,
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
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ZHTextLine(
                        str: model.createdAt.split(' ')[0],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ZHTextLine(
                            str: '{count}元'.tsArgs({
                              'count':
                                  model.orderAmount.rate(showPriceSymbol: false)
                            }),
                            color: BaseStylesConfig.textGray,
                          ),
                          ZHTextLine(
                            str: '佣金'.ts +
                                '：+' +
                                '{count}元'.tsArgs({
                                  'count': model.commissionAmount
                                      .rate(showPriceSymbol: false)
                                }),
                            color: BaseStylesConfig.textGray,
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
        Sized.vGap5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZHTextLine(
              str: model.createdAt.split(' ')[1],
              fontSize: 13,
            ),
            ZHTextLine(
              str: model.orderAmount.rate(showPriceSymbol: false) + '元',
              fontSize: 13,
              color: BaseStylesConfig.textGray,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZHTextLine(
              str: '转运单号'.ts + '：' + model.orderNumber,
              fontSize: 13,
            ),
            ZHTextLine(
              str: '佣金'.ts +
                  '：+' +
                  '{count}元'.tsArgs({
                    'count': model.commissionAmount.rate(showPriceSymbol: false)
                  }),
              fontSize: 13,
              color: BaseStylesConfig.textGray,
            ),
          ],
        ),
      ],
    );
  }
}
