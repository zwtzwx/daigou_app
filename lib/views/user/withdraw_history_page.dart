/*
  提现记录
 */
import 'package:jiyun_app_client/config/color_config.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

  int isloading = 0;
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
    created();
    // loadList();
  }

  created() async {
    EasyLoading.show(status: '加载中');

    // agentProfile = await AgentService.getProfile();

    agentInfoSubCount = await AgentService.getDataCount();
    EasyLoading.dismiss();
    setState(() {
      commissionSum = localizationInfo!.currencySymbol +
          (int.parse(agentInfoSubCount!.withdrawedAmount) / 100)
              .toStringAsFixed(2);
      isloading = isloading + 1;
    });
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
      if (isloading != 2) {
        isloading = isloading + 1;
      }
    });
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
        backgroundColor: ColorConfig.warningText,
        elevation: 0,
        centerTitle: true,
        title: Caption(
          str: pageTitle,
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: Container(
        color: ColorConfig.bgGray,
        child: ListRefresh(
          renderItem: bottomListCell,
          refresh: loadList,
          more: loadMoreList,
        ),
        // Column(
        //   children: <Widget>[
        //

        //   ],
        // ),
      ),
    );
  }

  Widget bottomListCell(index, WithdrawalItemModel model) {
    // if (index == 0) {
    //   return buildCustomViews(context);
    // }
    var container = Container(
        margin: const EdgeInsets.only(right: 15, left: 15, top: 10),
        padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
        decoration: BoxDecoration(
            color: ColorConfig.white,
            border: Border(
              bottom: Divider.createBorderSide(context,
                  color: ColorConfig.line, width: 1),
            )),
        height: 70,
        width: ScreenUtil().screenWidth - 60,
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: ScreenUtil().screenWidth - 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Caption(
                        alignment: TextAlign.left,
                        str: model.createdAt,
                        color: ColorConfig.textDark,
                        fontSize: 13,
                      ),
                      Caption(
                        alignment: TextAlign.left,
                        str: model.status == 0
                            ? '待审核'
                            : model.status == 1
                                ? '审核通过'
                                : '审核失败',
                        color: ColorConfig.warningTextDark,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: ScreenUtil().screenWidth - 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Caption(
                            alignment: TextAlign.left,
                            str: '卡号：',
                            color: ColorConfig.textDark,
                            fontSize: 14,
                          ),
                          Caption(
                            alignment: TextAlign.left,
                            str: model.bankNumber,
                            color: ColorConfig.textDark,
                            fontSize: 13,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Caption(
                            alignment: TextAlign.left,
                            str: '金额：',
                            color: ColorConfig.textBlack,
                            fontSize: 13,
                          ),
                          Caption(
                            alignment: TextAlign.left,
                            str: localizationInfo!.currencySymbol +
                                (model.amount / 100).toStringAsFixed(2),
                            color: ColorConfig.textRed,
                            fontSize: 13,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Container(
                //   height: 70,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           Caption(
                //             str: model.customer.name,
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Row(
                //             children: <Widget>[
                //               Caption(
                //                 str: '金额：',
                //               ),
                //               Caption(
                //                 str: localizationInfo!.currencySymbol +
                //                     (model.orderAmount / 100)
                //                         .toStringAsFixed(2),
                //                 color: ColorConfig.textBlack,
                //               )
                //             ],
                //           )
                //         ],
                //       ),
                //       SizedBox(
                //         width: 20,
                //       ),
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: <Widget>[
                //           Caption(
                //             str: '   ',
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Row(
                //             children: <Widget>[
                //               Caption(
                //                 str: '收益：',
                //               ),
                //               Caption(
                //                 str: localizationInfo!.currencySymbol +
                //                     (model.commissionAmount / 100)
                //                         .toStringAsFixed(2),
                //                 color: ColorConfig.textRed,
                //               )
                //             ],
                //           )
                //         ],
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ],
        ));

    if (index == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildCustomViews(context),
          container,
        ],
      );
    }
    return container;
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = SizedBox(
      height: 180,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            color: ColorConfig.warningText,
            constraints: const BoxConstraints.expand(
              height: 100.0,
            ),
          ),
          Positioned(
              top: 20,
              left: 15,
              right: 15,
              bottom: 0,
              child: Container(
                  height: 55,
                  width: ScreenUtil().screenWidth - 30,
                  color: ColorConfig.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: const Caption(
                            str: '可提现',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  alignment: Alignment.bottomCenter,
                                  child: Caption(
                                    str: localizationInfo!.currencySymbol,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConfig.textRed,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  alignment: Alignment.bottomCenter,
                                  child: Caption(
                                    str: agentInfoSubCount != null
                                        ? (int.parse(agentInfoSubCount!
                                                    .withdrableAmount) /
                                                100)
                                            .toStringAsFixed(2)
                                        : '0.00',
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConfig.textRed,
                                  ),
                                )
                              ],
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Caption(
                              str: '已提现：' + commissionSum,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ],
                  )))
        ],
      ),
    );
    return headerView;
  }
}
