import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
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
    // LocalizationModel? localizationInfo =
    //     Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '我要结算'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 17,
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: SizedBox(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Sized.line,
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
                            ZHTextLine(
                              str: '共计'.ts + '：',
                            ),
                            Obx(
                              () => ZHTextLine(
                                str: controller.selectNum.value.rate(),
                                color: BaseStylesConfig.textRed,
                              ),
                            )
                          ],
                        ),
                        Obx(
                          () => ZHTextLine(
                            str: '( ${'{count}条记录'.tsArgs({
                                  'count': controller.selModelList.length
                                })} )',
                            color: BaseStylesConfig.textGray,
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
                      color: BaseStylesConfig.primary,
                      alignment: Alignment.center,
                      child: ZHTextLine(
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
  LocalizationModel? localizationInfo;

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
    localizationInfo = Get.find<LocalizationModel?>();
    return Container(
      color: BaseStylesConfig.bgGray,
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
              color: BaseStylesConfig.white,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: BaseStylesConfig.line, width: 1),
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
                          color: BaseStylesConfig.textGrayC,
                        )
                      : widget.params['selList'].contains(model)
                          ? const Icon(
                              Icons.check_circle,
                              color: BaseStylesConfig.green,
                            )
                          : const Icon(
                              Icons.radio_button_off,
                              color: BaseStylesConfig.bgGray,
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
                              ZHTextLine(
                                str: model.createdAt,
                                fontSize: 13,
                                color: model.settled == 0
                                    ? BaseStylesConfig.textGray
                                    : Colors.black,
                              ),
                              Sized.hGap5,
                              model.settled == 0
                                  ? ZHTextLine(
                                      str: '等待确认'.ts,
                                      fontSize: 13,
                                      color: BaseStylesConfig.textRed,
                                    )
                                  : Sized.empty,
                            ],
                          ),
                          ZHTextLine(
                            str: model.orderAmount.rate(),
                            fontSize: 13,
                          ),
                        ],
                      ),
                      Sized.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ZHTextLine(
                            str: '转运单号'.ts + '：' + model.orderNumber,
                            fontSize: 13,
                            color: model.settled == 0
                                ? BaseStylesConfig.textGray
                                : Colors.black,
                          ),
                          Row(
                            children: [
                              ZHTextLine(
                                str: '佣金'.ts + '：',
                                fontSize: 13,
                              ),
                              ZHTextLine(
                                str: '+' + model.commissionAmount.rate(),
                                fontSize: 13,
                                color: BaseStylesConfig.textRed,
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
