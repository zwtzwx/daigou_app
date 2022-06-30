/*
  提现记录
 */
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/withdrawal_item_model.dart';
import 'package:jiyun_app_client/models/agent_data_count_model.dart';
import 'package:jiyun_app_client/models/agent_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/models/user_point_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
  佣金报表
 */
class WithdrawHistoryPage extends StatefulWidget {
  const WithdrawHistoryPage({Key? key}) : super(key: key);

  @override
  WithdrawHistoryPageState createState() => WithdrawHistoryPageState();
}

class WithdrawHistoryPageState extends State<WithdrawHistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String pageTitle = '';

  //用户积分
  UserPointModel? userPoint;
  //各类统计
  UserOrderCountModel? userDataModel;
  //用户基础信息
  UserModel? userDetailInfomodel;

  int pageIndex = 0;
  AgentModel? agentProfile;
  AgentDataCountModel? agentInfoSubCount;

  LocalizationModel? localizationInfo;
  //提现记录列表
  List<WithdrawalItemModel> dataList = [];

  String commissionSum = '';

  @override
  void initState() {
    super.initState();
    pageTitle = '提现记录';
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
    };

    var data = await AgentService.getCheckoutWithDrawList(dic);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '佣金报表'),
          color: ColorConfig.textBlack,
          fontSize: 18,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      bottomNavigationBar: bottomListBtn(),
      body: ListRefresh(
        renderItem: renderItem,
        refresh: loadList,
        more: loadMoreList,
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
              Routers.push('/ApplyWithDrawPage', context);
            },
            child: Container(
              height: 65,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              color: ColorConfig.primary,
              child: Caption(
                str: Translation.t(context, '我要提现'),
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Routers.push('/WithdrawCommissionPage', context);
            },
            child: Container(
              height: 65,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              color: Colors.white,
              child: Caption(
                str: Translation.t(context, '成交记录'),
                color: ColorConfig.primary,
                fontSize: 18,
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
        color: ColorConfig.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Caption(
              str: model.serialNo,
              fontSize: 14,
              color: ColorConfig.textGray,
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Caption(
              str: localizationInfo!.currencySymbol +
                  (model.amount / 100).toStringAsFixed(2),
              fontSize: 22,
              color: ColorConfig.textRed,
            ),
          ),
          Gaps.vGap15,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Caption(
                  str: Translation.t(context, '收款账号') + '：',
                  color: ColorConfig.textGray,
                ),
                Caption(
                  str: model.user?.name ?? '',
                ),
              ],
            ),
          ),
          Gaps.vGap4,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Caption(
                  str: Translation.t(context, '收款方式') + '：',
                  color: ColorConfig.textGray,
                ),
                Caption(
                  str: model.withdrawTypeName,
                ),
              ],
            ),
          ),
          Gaps.vGap4,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Caption(
                  str: Translation.t(context, '结算状态') + '：',
                  color: ColorConfig.textGray,
                ),
                Caption(
                  str: Translation.t(
                      context,
                      model.status == 0
                          ? '审核中'
                          : (model.status == 1 ? '审核通过' : '审核拒绝')),
                  color: model.status == 0
                      ? ColorConfig.primary
                      : (model.status == 2
                          ? ColorConfig.textRed
                          : Colors.black),
                ),
              ],
            ),
          ),
          Gaps.vGap5,
          Gaps.line,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: GestureDetector(
              onTap: () {
                Routers.push(
                    '/WithdrawHistoryDetailPage', context, {"id": model.id});
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Caption(
                      str: Translation.t(context, '查看详情'),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: ColorConfig.textGray,
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
