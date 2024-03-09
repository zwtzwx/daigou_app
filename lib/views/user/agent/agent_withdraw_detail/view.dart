import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/withdrawal_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/user/agent/agent_withdraw_detail/controller.dart';

class AgentWithdrawDetailPage extends GetView<AgentWithdrawDetailController> {
  const AgentWithdrawDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: AppText(
          str: '结算详情'.inte,
          fontSize: 17,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildDetailTitle(),
            AppGaps.vGap15,
            buildCommissionList(),
          ],
        ),
      ),
    );
  }

  Widget buildDetailTitle() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: AppText(
                fontSize: 22,
                str: (controller.detailModel.value?.amount ?? 0).priceConvert(),
                color: AppStyles.textRed,
              ),
            ),
            AppGaps.vGap20,
            AppText(
              str: '流水号'.inte +
                  '：${controller.detailModel.value?.serialNo ?? ''}',
            ),
            AppGaps.vGap5,
            AppText(
              str: '收款方式'.inte +
                  '：${controller.detailModel.value?.withdrawTypeName ?? ''}',
            ),
            AppGaps.vGap5,
            AppText(
              str: '收款账户'.inte +
                  '：${controller.detailModel.value?.user?.name ?? ''}',
            ),
            AppGaps.vGap5,
            AppText(
              str: '结算状态'.inte +
                  '：' +
                  (controller.detailModel.value?.status == 0
                      ? '审核中'.inte
                      : (controller.detailModel.value?.status == 1
                              ? '审核通过'
                              : '审核拒绝')
                          .inte),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommissionList() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: AppText(
              str: '结算明细'.inte,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.detailModel.value?.commissions?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: buildCommissionItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommissionItem(BuildContext context, int index) {
    WithdrawalModel model = controller.detailModel.value!.commissions![index];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppStyles.line),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                str: model.createdAt,
                fontSize: 14,
              ),
              AppText(
                str: model.orderAmount.priceConvert(),
                fontSize: 14,
              ),
            ],
          ),
          AppGaps.vGap5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                str: '转运单号'.inte + '：' + model.orderNumber,
                fontSize: 14,
              ),
              AppText(
                str: '佣金'.inte + '：+' + model.commissionAmount.priceConvert(),
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
