import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/order_transaction_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int pageIndex = 0;
  LocalizationModel? localModel;

  @override
  initState() {
    super.initState();
    localModel = Provider.of<Model>(context, listen: false).localizationInfo;
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    return BalanceService.getTransactionList({
      "page": (++pageIndex),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Caption(
          str: '财务流水',
          color: ColorConfig.textBlack,
          fontSize: 18,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListRefresh(
        renderItem: renderItem,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget renderItem(int index, OrderTransactionModel model) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Caption(
                  str: model.createdAt,
                ),
                Gaps.vGap15,
                Container(
                  alignment: Alignment.center,
                  child: const Caption(
                    str: '金额',
                    fontSize: 18,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Caption(
                    str: localModel!.currencySymbol +
                        (model.amount / 100).toStringAsFixed(2),
                    fontSize: 18,
                    color: ColorConfig.textRed,
                  ),
                ),
                Gaps.vGap15,
                Caption(
                  str: '类型：' + getType(model.type),
                ),
                Gaps.vGap10,
                ([1, 3].contains(model.type) && model.order != null)
                    ? Caption(
                        str: '相关订单：' + (model.orderSn ?? ''),
                      )
                    : Caption(
                        str: '流水号：' + model.serialNo,
                      ),
              ],
            ),
          ),
          ([1, 3].contains(model.type) && model.order != null)
              ? GestureDetector(
                  onTap: () {
                    Routers.push(
                        '/OrderDetailPage', context, {'id': model.order!.id});
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: ColorConfig.line),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Caption(
                          str: '查看详情',
                          fontSize: 14,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                )
              : Gaps.empty,
        ],
      ),
    );
  }

  // 交易类型
  String getType(int type) {
    String typeName = '';
    switch (type) {
      case 1:
        typeName = '消费';
        break;
      case 2:
        typeName = '充值';
        break;
      case 3:
        typeName = '退款';
        break;
      case 4:
        typeName = '提现';
        break;
      case 6:
        typeName = '充值赠送';
        break;
    }
    return typeName;
  }
}
