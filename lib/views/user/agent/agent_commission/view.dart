import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/user/agent/agent_commission/controller.dart';

class AgentCommissionPage extends GetView<AgentCommissionController> {
  const AgentCommissionPage({Key? key}) : super(key: key);

  // 主视图
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '我要结算'.ts,
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
      ))),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(
              () => PrepaidList(
                params: {
                  'selectType': '1',
                  'selList': controller.selModelList.value
                },
                onChanged: (WithdrawalModel number) {
                  if (number.settled == 0) return;
                  if (controller.selModelList.contains(number)) {
                    controller.selModelList.remove(number);
                  } else {
                    controller.selModelList.add(number);
                  }
                  int totalMoney = 0;
                  for (WithdrawalModel item in controller.selModelList) {
                    totalMoney += item.commissionAmount;
                  }
                  controller.selectNum.value = totalMoney;
                },
                onChangedDtatList: (List<WithdrawalModel> data) {
                  if (data.isEmpty) {
                    controller.allModelList.clear();
                  } else {
                    controller.allModelList.addAll(data);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
  可提现列表
 */
class PrepaidList extends StatefulWidget {
  final ValueChanged<WithdrawalModel>? onChanged;
  final ValueChanged<List<WithdrawalModel>>? onChangedDtatList;
  final Map<String, dynamic> params;

  const PrepaidList({
    Key? key,
    required this.params,
    this.onChanged,
    this.onChangedDtatList,
  }) : super(key: key);

  @override
  PrepaidListState createState() => PrepaidListState();
}

class PrepaidListState extends State<PrepaidList> {
  final GlobalKey<PrepaidListState> key = GlobalKey();

  int pageIndex = 0;
  List<int> selectList = [];
  List<WithdrawalModel> selectModelList = [];

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await AgentService.getAvailableWithDrawList(
        {'is_withdraw_list': '1', 'page': (++pageIndex), 'size': 20});
    if (pageIndex == 1 && widget.onChangedDtatList != null) {
      widget.onChangedDtatList!([]);
    }
    if (widget.onChangedDtatList != null && data['total'] > 0) {
      widget.onChangedDtatList!(data['dataList']);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgGray,
      child: ListRefresh(
        renderItem: bottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget bottomListCell(index, WithdrawalModel model) {
    var container = GestureDetector(
        onTap: () {
          widget.onChanged!(model);
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: AppColors.line, width: 1),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  alignment: Alignment.centerLeft,
                  child: model.settled == 0
                      ? const Icon(
                          Icons.circle,
                          color: AppColors.textGrayC,
                        )
                      : widget.params['selList'].contains(model)
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.green,
                            )
                          : const Icon(
                              Icons.radio_button_off,
                              color: AppColors.bgGray,
                            ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              AppText(
                                str: model.createdAt,
                                fontSize: 13,
                                color: model.settled == 0
                                    ? AppColors.textGray
                                    : Colors.black,
                              ),
                              AppGaps.hGap5,
                              model.settled == 0
                                  ? AppText(
                                      str: '等待确认'.ts,
                                      fontSize: 13,
                                      color: AppColors.textRed,
                                    )
                                  : AppGaps.empty,
                            ],
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
                            str: '转运单号'.ts + '：' + model.orderNumber,
                            fontSize: 13,
                            color: model.settled == 0
                                ? AppColors.textGray
                                : Colors.black,
                          ),
                          Row(
                            children: [
                              AppText(
                                str: '佣金'.ts + '：',
                                fontSize: 13,
                              ),
                              AppText(
                                str: '+' + model.commissionAmount.rate(),
                                fontSize: 13,
                                color: AppColors.textRed,
                              ),
                            ],
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
