/*
  申请提现
 */

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/agent_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ApplyWithDrawPage extends StatefulWidget {
  const ApplyWithDrawPage({Key? key}) : super(key: key);

  @override
  ApplyWithDrawPageState createState() => ApplyWithDrawPageState();
}

class ApplyWithDrawPageState extends State<ApplyWithDrawPage> {
  List<WithdrawalModel> selModelList = [];
  List<WithdrawalModel> allModelList = [];

  int selectNum = 0;
  AgentModel? agentModel;

  @override
  void initState() {
    super.initState();
  }

  // 申请提现
  onApply() async {
    List<int> ids = [];
    for (var item in selModelList) {
      ids.add(item.id);
    }
    if (ids.isEmpty) {
      Util.showToast(Translation.t(context, '请选择要提现的订单'));
      return;
    }
    Routers.push('/WithdrawlInfoPage', context, {'ids': ids});
  }

  @override
  Widget build(BuildContext context) {
    LocalizationModel? localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '我要结算'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBar: SafeArea(
          child: SizedBox(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Gaps.line,
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
                            Caption(
                              str: Translation.t(context, '共计') + '：',
                            ),
                            Caption(
                              str: localizationInfo?.currencySymbol ?? '',
                              fontSize: 12,
                              color: ColorConfig.textRed,
                            ),
                            Caption(
                              str: (selectNum / 100).toStringAsFixed(2),
                              color: ColorConfig.textRed,
                            ),
                          ],
                        ),
                        Caption(
                          str:
                              '( ${Translation.t(context, '{count}条记录', value: {
                                'count': selModelList.length
                              })} )',
                          color: ColorConfig.textGray,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onApply,
                    child: Container(
                      color: ColorConfig.primary,
                      alignment: Alignment.center,
                      child: Caption(
                        str: Translation.t(context, '提交'),
                        color: Colors.white,
                        fontSize: 18,
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
            child: PrepaidList(
              params: {'selectType': '1', 'selList': selModelList},
              onChanged: (WithdrawalModel number) {
                if (number.settled == 0) return;
                if (selModelList.contains(number)) {
                  selModelList.remove(number);
                } else {
                  selModelList.add(number);
                }
                int totalMoney = 0;
                for (WithdrawalModel item in selModelList) {
                  totalMoney += item.commissionAmount;
                }
                setState(() {
                  selectNum = totalMoney;
                });
              },
              onChangedDtatList: (List<WithdrawalModel> data) {
                if (data.isEmpty) {
                  allModelList.clear();
                } else {
                  allModelList.addAll(data);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Container(
      color: ColorConfig.bgGray,
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
              color: ColorConfig.white,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: ColorConfig.line, width: 1),
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
                          color: ColorConfig.textGrayC,
                        )
                      : widget.params['selList'].contains(model)
                          ? const Icon(
                              Icons.check_circle,
                              color: ColorConfig.green,
                            )
                          : const Icon(
                              Icons.radio_button_off,
                              color: ColorConfig.bgGray,
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
                              Caption(
                                str: model.createdAt,
                                fontSize: 13,
                                color: model.settled == 0
                                    ? ColorConfig.textGray
                                    : Colors.black,
                              ),
                              Gaps.hGap5,
                              model.settled == 0
                                  ? const Caption(
                                      str: '等待确认',
                                      fontSize: 13,
                                      color: ColorConfig.textRed,
                                    )
                                  : Gaps.empty,
                            ],
                          ),
                          Caption(
                            str: localizationInfo!.currencySymbol +
                                (model.orderAmount / 100).toStringAsFixed(2),
                            fontSize: 13,
                          ),
                        ],
                      ),
                      Gaps.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Caption(
                            str: Translation.t(context, '转运单号') +
                                '：' +
                                model.orderNumber,
                            fontSize: 13,
                            color: model.settled == 0
                                ? ColorConfig.textGray
                                : Colors.black,
                          ),
                          Row(
                            children: [
                              Caption(
                                str: Translation.t(context, '佣金') + '：',
                                fontSize: 13,
                              ),
                              Caption(
                                str: '+' +
                                    localizationInfo!.currencySymbol +
                                    (model.commissionAmount / 100)
                                        .toStringAsFixed(2),
                                fontSize: 13,
                                color: ColorConfig.textRed,
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
