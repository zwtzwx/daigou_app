import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/withdrawal_item_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission_history/controller.dart';

class AgentCommissionHistoryPage
    extends GetView<AgentCommissionHistoryController> {
  const AgentCommissionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '佣金报表'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 17,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: bottomListBtn(),
      body: ListRefresh(
        renderItem: renderItem,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
  }

  // 底部按钮
  Widget bottomListBtn() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Routers.push(Routers.agentCommissionList);
            },
            child: Container(
              height: 65,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              color: BaseStylesConfig.primary,
              child: ZHTextLine(
                str: '我要提现'.ts,
                fontSize: 17,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Routers.push(Routers.agentWithdrawRecord);
            },
            child: Container(
              height: 65,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              color: Colors.white,
              child: ZHTextLine(
                str: '成交记录'.ts,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget renderItem(index, WithdrawalItemModel model) {
    var container = Container(
      margin: const EdgeInsets.only(right: 15, left: 15, top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: BaseStylesConfig.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 30,
            alignment: Alignment.center,
            child: ZHTextLine(
              str: model.serialNo,
              fontSize: 14,
              color: BaseStylesConfig.textGray,
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            child: ZHTextLine(
              str: model.amount.rate(),
              fontSize: 22,
              color: BaseStylesConfig.textRed,
            ),
          ),
          Sized.vGap15,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                ZHTextLine(
                  str: '收款账号'.ts + '：',
                  color: BaseStylesConfig.textGray,
                ),
                ZHTextLine(
                  str: model.user?.name ?? '',
                ),
              ],
            ),
          ),
          Sized.vGap4,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                ZHTextLine(
                  str: '收款方式'.ts + '：',
                  color: BaseStylesConfig.textGray,
                ),
                ZHTextLine(
                  str: model.withdrawTypeName,
                ),
              ],
            ),
          ),
          Sized.vGap4,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                ZHTextLine(
                  str: '结算状态'.ts + '：',
                  color: BaseStylesConfig.textGray,
                ),
                ZHTextLine(
                  str: model.status == 0
                      ? '审核中'.ts
                      : (model.status == 1 ? '审核通过' : '审核拒绝').ts,
                  color: model.status == 0
                      ? BaseStylesConfig.primary
                      : (model.status == 2
                          ? BaseStylesConfig.textRed
                          : Colors.black),
                ),
              ],
            ),
          ),
          Sized.vGap5,
          Sized.line,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: GestureDetector(
              onTap: () {
                Routers.push(Routers.agentWithdrawDetail, {"id": model.id});
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ZHTextLine(
                      str: '查看详情'.ts,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: BaseStylesConfig.textGray,
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
