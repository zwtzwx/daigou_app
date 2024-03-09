import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_recharge_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/payment/recharge_history/controller.dart';

class RechargeHistoryPage extends GetView<RechargeHistoryController> {
  const RechargeHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: AppText(
          str: '充值记录'.inte,
          fontSize: 17,
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: RefreshView(
        renderItem: renderItem,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
  }

  Widget renderItem(index, UserRechargeModel model) {
    return cellViews(model);
  }

  Widget cellViews(UserRechargeModel model) {
    var creatView = Container(
        margin: EdgeInsets.only(top: 10.h, left: 14.w, right: 14.w),
        decoration: BoxDecoration(
          color: AppStyles.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 15, top: 15),
                alignment: Alignment.topCenter,
                width: 30,
                child: model.payType.contains('支付宝')
                    ? Image.asset(
                        'assets/images/Center/alipay.png',
                      )
                    : model.payType.contains('微信')
                        ? Image.asset(
                            'assets/images/Center/wechat_pay.png',
                          )
                        : model.payType.contains('银行')
                            ? Image.asset(
                                'assets/images/Center/transfer.png',
                              )
                            : Image.asset(
                                'assets/images/Center/balance_pay.png',
                              )),
            Container(
                width: 1.sw - 100,
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              alignment: TextAlign.left,
                              str: '充值金额'.inte,
                              color: AppStyles.textDark,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: AppText(
                              str: model.confirmAmount.priceConvert(),
                              color: AppStyles.textBlack,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              alignment: TextAlign.left,
                              str: model.payType,
                              color: AppStyles.textGray,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0, right: 0),
                            alignment: Alignment.centerRight,
                            child: AppText(
                              alignment: TextAlign.center,
                              str: model.status == 0
                                  ? '等待客服确认支付'.inte
                                  : model.status == 1
                                      ? '审核通过'.inte
                                      : '审核失败'.inte,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            child: AppText(
                              alignment: TextAlign.left,
                              str: model.createdAt,
                              color: AppStyles.textGray,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    model.status == 2
                        ? SizedBox(
                            child: AppText(
                              str: '${'备注'.inte}：${model.customerRemark}',
                              lines: 20,
                            ),
                          )
                        : AppGaps.empty,
                  ],
                ))
          ],
        ));
    return creatView;
  }
}
