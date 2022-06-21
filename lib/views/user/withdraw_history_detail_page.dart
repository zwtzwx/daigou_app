import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/withdrawal_item_model.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:provider/provider.dart';

/*
  佣金报表详情
 */
class WithdrawHistoryDetailPage extends StatefulWidget {
  final Map arguments;
  const WithdrawHistoryDetailPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<WithdrawHistoryDetailPage> createState() =>
      _WithdrawHistoryDetailPageState();
}

class _WithdrawHistoryDetailPageState extends State<WithdrawHistoryDetailPage> {
  WithdrawalItemModel? detailModel;
  LocalizationModel? localModel;

  @override
  void initState() {
    super.initState();
    localModel = Provider.of<Model>(context, listen: false).localizationInfo;
    getDetail();
  }

  getDetail() async {
    EasyLoading.show();
    var data = await AgentService.getWithdrawDetail(widget.arguments['id']);
    EasyLoading.dismiss();
    setState(() {
      detailModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Caption(
          str: '结算详情',
          fontSize: 18,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildDetailTitle(),
            Gaps.vGap15,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            child: Caption(
              fontSize: 22,
              str: localModel!.currencySymbol +
                  ((detailModel?.amount ?? 0) / 100).toStringAsFixed(2),
              color: ColorConfig.textRed,
            ),
          ),
          Gaps.vGap20,
          Caption(
            str: '流水号：${detailModel?.serialNo ?? ''}',
          ),
          Gaps.vGap5,
          Caption(
            str: '收款方式：${detailModel?.withdrawTypeName ?? ''}',
          ),
          Gaps.vGap5,
          Caption(
            str: '收款账户：${detailModel?.user?.name ?? ''}',
          ),
          Gaps.vGap5,
          Caption(
            str: '结算状态：' +
                (detailModel?.status == 0
                    ? '审核中'
                    : (detailModel?.status == 1 ? '审核通过' : '审核拒绝')),
          ),
        ],
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
            child: const Caption(
              str: '结算明细',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: detailModel?.commissions?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: buildCommissionItem,
          ),
        ],
      ),
    );
  }

  Widget buildCommissionItem(BuildContext context, int index) {
    WithdrawalModel model = detailModel!.commissions![index];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorConfig.line),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Caption(
                str: model.createdAt,
                fontSize: 14,
              ),
              Caption(
                str: (model.orderAmount / 100).toStringAsFixed(2) + '元',
                fontSize: 14,
              ),
            ],
          ),
          Gaps.vGap5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Caption(
                str: '转运单号：' + model.orderNumber,
                fontSize: 14,
              ),
              Caption(
                str: '佣金：+' +
                    (model.commissionAmount / 100).toStringAsFixed(2) +
                    '元',
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
