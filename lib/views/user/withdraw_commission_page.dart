import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/agent_commission_record_model.dart';
import 'package:jiyun_app_client/models/agent_commissions_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';

/*
  佣金成交记录
 */

class WithdrawCommissionPage extends StatefulWidget {
  const WithdrawCommissionPage({Key? key}) : super(key: key);

  @override
  State<WithdrawCommissionPage> createState() => _WithdrawCommissionPageState();
}

class _WithdrawCommissionPageState extends State<WithdrawCommissionPage> {
  int pageIndex = 0;

  loadData({type = ''}) async {
    pageIndex = 0;
    return loadMoreData();
  }

  loadMoreData() async {
    var data = await AgentService.getCommissionList({'page': (++pageIndex)});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '成交记录'),
          fontSize: 18,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListRefresh(
        renderItem: renderItem,
        refresh: loadData,
        more: loadMoreData,
      ),
    );
  }

  renderItem(int index, AgentCommissionRecordModel model) {
    return Container(
      color: Colors.white,
      child: ExpansionPanelList(
        elevation: 0,
        dividerColor: ColorConfig.line,
        expansionCallback: (index, open) {
          setState(() {
            model.isOpen = !open;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return Container(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Caption(
                      str: model.createdAt.split(' ')[0],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Caption(
                          str: Translation.t(context, '{count}元', value: {
                            'count':
                                (model.orderAmount / 100).toStringAsFixed(2)
                          }),
                          color: ColorConfig.textGray,
                        ),
                        Caption(
                          str: Translation.t(context, '佣金') +
                              '：+' +
                              Translation.t(context, '{count}元', value: {
                                'count': (model.commissionAmount / 100)
                                    .toStringAsFixed(2)
                              }),
                          color: ColorConfig.textGray,
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
            isExpanded: model.isOpen,
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }

  Widget buildCommissionList(AgentCommissionsModel model) {
    return Column(
      children: [
        Gaps.vGap5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Caption(
              str: model.createdAt.split(' ')[1],
              fontSize: 13,
            ),
            Caption(
              str: (model.orderAmount / 100).toStringAsFixed(2) + '元',
              fontSize: 13,
              color: ColorConfig.textGray,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Caption(
              str: Translation.t(context, '转运单号') + '：' + model.orderNumber,
              fontSize: 13,
            ),
            Caption(
              str: Translation.t(context, '佣金') +
                  '：+' +
                  Translation.t(context, '{count}元', value: {
                    'count': (model.commissionAmount / 100).toStringAsFixed(2)
                  }),
              fontSize: 13,
              color: ColorConfig.textGray,
            ),
          ],
        ),
      ],
    );
  }
}
