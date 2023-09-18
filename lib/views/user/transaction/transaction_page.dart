import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/order_transaction_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/user/transaction/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '财务流水'.ts,
          color: AppColors.textBlack,
          fontSize: 18,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: ListRefresh(
        renderItem: renderItem,
        refresh: controller.loadList,
        more: controller.loadMoreList,
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
                AppText(
                  str: model.createdAt,
                ),
                AppGaps.vGap15,
                Container(
                  alignment: Alignment.center,
                  child: AppText(
                    str: '金额'.ts,
                    fontSize: 18,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: AppText(
                    str: model.amount.rate(),
                    fontSize: 18,
                    color: AppColors.textRed,
                  ),
                ),
                AppGaps.vGap15,
                AppText(
                  str: '类型'.ts + '：' + controller.getType(model.type).ts,
                ),
                AppGaps.vGap10,
                ([1, 3].contains(model.type) && model.order != null)
                    ? AppText(
                        str: '相关订单'.ts + '：' + (model.orderSn ?? ''),
                      )
                    : AppText(
                        str: '流水号'.ts + '：' + model.serialNo,
                      ),
              ],
            ),
          ),
          ([1, 3].contains(model.type) && model.order != null)
              ? GestureDetector(
                  onTap: () {
                    Routers.push(Routers.orderDetail, {'id': model.order!.id});
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.line),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str: '查看详情'.ts,
                          fontSize: 14,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                )
              : AppGaps.empty,
        ],
      ),
    );
  }
}
