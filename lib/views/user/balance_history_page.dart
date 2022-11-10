/*
  充值记录页面
 */

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_recharge_model.dart';
import 'package:jiyun_app_client/services/balance_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BalanceHistoryPage extends StatefulWidget {
  const BalanceHistoryPage({Key? key}) : super(key: key);

  @override
  BalanceHistoryPageState createState() => BalanceHistoryPageState();
}

class BalanceHistoryPageState extends State<BalanceHistoryPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int pageIndex = 0;

  int selectNum = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: Translation.t(context, '充值记录'),
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: const LineItem());
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// 充值列表
class LineItem extends StatefulWidget {
  const LineItem({
    Key? key,
  }) : super(key: key);

  @override
  LineItemState createState() => LineItemState();
}

class LineItemState extends State<LineItem> {
  final GlobalKey<LineItemState> key = GlobalKey();

  int pageIndex = 0;

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
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
    };
    var data = await BalanceService.getRechargeList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return ListRefresh(
      renderItem: renderItem,
      refresh: loadList,
      more: loadMoreList,
    );
  }

  Widget renderItem(index, UserRechargeModel model) {
    return cellViews(model);
  }

  Widget cellViews(UserRechargeModel model) {
    var creatView = Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        // height: 110,
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.white),
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
                        'assets/images/AboutMe/支付宝支付@3x.png',
                      )
                    : model.payType.contains('微信')
                        ? Image.asset(
                            'assets/images/AboutMe/微信支付@3x.png',
                          )
                        : model.payType.contains('银行')
                            ? Image.asset(
                                'assets/images/AboutMe/银行卡转账@3x.png',
                              )
                            : Image.asset(
                                'assets/images/AboutMe/好评Dis@3x.png',
                              )),
            Container(
                width: ScreenUtil().screenWidth - 100,
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
                            child: Caption(
                              alignment: TextAlign.left,
                              str: Translation.t(context, '充值金额'),
                              color: ColorConfig.textDark,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Caption(
                              str: (model.confirmAmount / 100)
                                  .toStringAsFixed(2),
                              color: ColorConfig.textBlack,
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
                            child: Caption(
                              alignment: TextAlign.left,
                              str: model.payType,
                              color: ColorConfig.textGray,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0, right: 0),
                            alignment: Alignment.centerRight,
                            child: Caption(
                              alignment: TextAlign.center,
                              str: model.status == 0
                                  ? Translation.t(context, '等待客服确认支付')
                                  : model.status == 1
                                      ? Translation.t(context, '审核通过')
                                      : Translation.t(context, '审核失败'),
                              color: ColorConfig.primary,
                              fontSize: 14,
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
                            child: Caption(
                              alignment: TextAlign.left,
                              str: model.createdAt,
                              color: ColorConfig.textGray,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    model.status == 2
                        ? SizedBox(
                            child: Caption(
                              str: '备注：${model.customerRemark}',
                              lines: 20,
                            ),
                          )
                        : Gaps.empty,
                  ],
                ))
          ],
        ));
    return creatView;
  }
}
