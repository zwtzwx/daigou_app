import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/order_transaction_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/user/transaction/transaction_controller.dart';

class BeeTradePage extends GetView<BeeTradeLogic> {
  const BeeTradePage({Key? key}) : super(key: key);

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
      body: RefreshView(
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
                    BeeNav.push(BeeNav.orderDetail, {'id': model.order!.id});
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
