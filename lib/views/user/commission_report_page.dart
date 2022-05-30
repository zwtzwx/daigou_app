/*
  佣金报表
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/withdrawal_item_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommissionReportPage extends StatefulWidget {
  const CommissionReportPage({Key? key}) : super(key: key);

  @override
  CommissionReportPageState createState() => CommissionReportPageState();
}

class CommissionReportPageState extends State<CommissionReportPage> {
  bool isloading = false;
  int pageIndex = 0;

  LocalizationModel? localizationInfo;

  @override
  void initState() {
    super.initState();

    loadList();
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
    setState(() {
      isloading = true;
    });
    return data;
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
            str: '佣金报表',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBar: SafeArea(
            child: Material(
                //底部栏整体的颜色
                color: ColorConfig.warningText,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().screenWidth / 2,
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () {
                          Routers.push('/ApplyWithDrawPage', context);
                        },
                        child: const Caption(
                          str: '我要提现',
                          color: ColorConfig.white,
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtil().screenWidth / 2,
                      color: ColorConfig.white,
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        child: const Caption(
                          str: '成交记录',
                          color: ColorConfig.warningText,
                        ),
                        onPressed: () async {
                          Routers.push('/WithdrawHistoryPage', context);
                        },
                      ),
                    )
                  ],
                ))),
        body: isloading
            ? Container(
                color: ColorConfig.bgGray,
                child: ListRefresh(
                  renderItem: renderItem,
                  refresh: loadList,
                  more: loadMoreList,
                ),
              )
            : Container());
  }

  Widget renderItem(index, WithdrawalItemModel model) {
    return GestureDetector(
        onTap: () {
          Routers.push('/CommissionDetailPage', context, {'model': model});
        },
        child: cellViews(index, model));
  }

  Widget cellViews(int index, WithdrawalItemModel model) {
    var creatView = Container(
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        height: 250,
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: const BorderRadius.all(Radius.circular(17.5)),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Caption(
                alignment: TextAlign.left,
                str: model.serialNo,
                color: ColorConfig.textGray,
                fontSize: 17,
              ),
            ),
            Caption(
              alignment: TextAlign.left,
              str: localizationInfo!.currencySymbol +
                  (model.amount / 100).toStringAsFixed(2),
              color: ColorConfig.textDark,
              fontSize: 24,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  const Caption(
                    alignment: TextAlign.left,
                    str: '收款方：',
                    color: ColorConfig.textGray,
                    fontSize: 20,
                  ),
                  Caption(
                    alignment: TextAlign.left,
                    str: model.user!.name,
                    color: ColorConfig.textDark,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  const Caption(
                    alignment: TextAlign.left,
                    str: '收款方式：',
                    color: ColorConfig.textGray,
                    fontSize: 20,
                  ),
                  Caption(
                    alignment: TextAlign.left,
                    str: model.withdrawTypeName,
                    color: ColorConfig.textDark,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  const Caption(
                    alignment: TextAlign.left,
                    str: '结算状态：',
                    color: ColorConfig.textGray,
                    fontSize: 20,
                  ),
                  Caption(
                    alignment: TextAlign.left,
                    str: model.status == 0
                        ? '待审核'
                        : model.status == 1
                            ? '审核通过'
                            : '审核失败',
                    color: ColorConfig.textDark,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            Gaps.line,
            Container(
              height: 49.5,
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Caption(
                    alignment: TextAlign.left,
                    str: '查看详情',
                    color: ColorConfig.textDark,
                    fontSize: 18,
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: ColorConfig.textGray)
                ],
              ),
            ),
          ],
        ));
    return creatView;
  }
}
