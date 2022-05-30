/*
  成为代理后的界面
 */

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/agent_refresh_event.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/models/agent_commissions_model.dart';
import 'package:jiyun_app_client/models/agent_data_count_model.dart';
import 'package:jiyun_app_client/models/agent_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/models/user_point_model.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({Key? key}) : super(key: key);

  @override
  AgentPageState createState() => AgentPageState();
}

class AgentPageState extends State<AgentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  String pageTitle = '';

  LocalizationModel? localizationInfo;

  late UserPointModel userPointModel;

  late UserModel userModel;

  UserOrderCountModel? userDataCountModel;

  // late AgentModel agentModel;
  late AgentDataCountModel agentDataCountModel;

  bool isloading = false;
  int pageIndex = 0;
  String commissionSum = '';

  @override
  void initState() {
    super.initState();
    pageTitle = '合伙人';
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    created();

    ApplicationEvent.getInstance()
        .event
        .on<AgentRefreshEvent>()
        .listen((event) {
      created();
    });
  }

  created() async {
    EasyLoading.show();
    // var _agentModel = await AgentService.getProfile();

    var _userModel = await UserService.getProfile();

    var _userDataCountModel = await UserService.getOrderDataCount();

    var _agentDataCountModel = await AgentService.getDataCount();
    EasyLoading.dismiss();
    setState(() {
      // agentModel = _agentModel!;
      userModel = _userModel!;
      userDataCountModel = _userDataCountModel;
      agentDataCountModel = _agentDataCountModel!;
      if (_userDataCountModel != null) {
        commissionSum = localizationInfo!.currencySymbol +
            (_userDataCountModel.commissionSum! / 100).toStringAsFixed(2);
      }
      isloading = true;
    });
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
      "is_withdraw_list": 1,
    };
    var data = await AgentService.getAvailableWithDrawList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
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
      body: isloading
          ? ListRefresh(
              renderItem: buildCellFotCommissionsList,
              refresh: loadList,
              more: loadMoreList,
            )
          : Gaps.empty,
      // body: isloading
      //     ? (
      //         // shrinkWrap: true,
      //         // physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
      //         children: <Widget>[
      //             // Column(
      //             //   mainAxisSize: MainAxisSize.min,
      //             //   children: <Widget>[
      //             //   ],
      //             // ),

      //             buildCustomViews(context),
      //             ListRefresh(
      //               renderItem: buildCellFotCommissionsList,
      //               refresh: loadList,
      //               shrinkWrap: true,
      //               physics: true,
      //               more: loadMoreList,
      //             ),
      //             // ListView.builder(
      //             //   shrinkWrap: true,
      //             //   physics: const NeverScrollableScrollPhysics(),
      //             //   itemBuilder: buildCellFotCommissionsList,
      //             //   controller: _scrollController,
      //             //   itemCount: agentModel.commissions!.length,
      //             // ),
      //           ])
      //     : Container(),
    );
  }

  Widget buildCellFotCommissionsList(int index, WithdrawalModel model) {
    var container = GestureDetector(
      onTap: () {},
      child: Container(
        color: ColorConfig.white,
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
        height: 100,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child: Caption(
                    fontSize: 13,
                    str: '订单号：' + model.orderNumber,
                    fontWeight: FontWeight.w400,
                    color: ColorConfig.textGray,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  height: 30,
                  child: Caption(
                      fontSize: 13,
                      str: model.createdAt,
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.textGray),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: LoadImage(
                            model.customer!.avatar,
                            fit: BoxFit.fitWidth,
                            holderImg: "PackageAndOrder/defalutIMG@3x",
                            format: "png",
                          ),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 25,
                          child: Caption(
                              str: model.customer!.name,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 25,
                          child: Caption(
                              str: '金额：' +
                                  localizationInfo!.currencySymbol +
                                  (model.orderAmount / 100).toStringAsFixed(2),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      height: 25,
                      child: Caption(
                          str: model.settled != 1 ? '待审核' : '',
                          fontWeight: FontWeight.w300,
                          color: ColorConfig.warningTextDark),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 25,
                          child: const Caption(
                              str: '收益：', fontWeight: FontWeight.w300),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 25,
                          child: Caption(
                            str: localizationInfo!.currencySymbol +
                                (model.commissionAmount / 100)
                                    .toStringAsFixed(2),
                            fontWeight: FontWeight.w300,
                            color: ColorConfig.textRed,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
    if (index == 0) {
      return Column(
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
      height: 225,
      width: ScreenUtil().screenWidth,
      child: Stack(
        children: <Widget>[
          Container(
              width: ScreenUtil().screenWidth,
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              color: ColorConfig.warningText,
              constraints: const BoxConstraints.expand(
                height: 200.0,
              ),
              //设置背景图片
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                          onDoubleTap: () async {},
                          child: Container(
                              decoration: const BoxDecoration(
                                color: ColorConfig.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: LoadImage(
                                  userModel.avatar,
                                  fit: BoxFit.fitWidth,
                                  holderImg: "PackageAndOrder/defalutIMG@3x",
                                  format: "png",
                                ),
                              ))),
                      Gaps.hGap16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                            width: ScreenUtil().screenWidth - 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  height: 24,
                                  child: Caption(
                                    alignment: TextAlign.left,
                                    str: userModel.name,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConfig.textDark,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Routers.push(
                                        '/WithdrawHistoryPage', context);
                                  },
                                  child: Container(
                                    height: 24,
                                    color: ColorConfig.warningText,
                                    child: const Caption(
                                      alignment: TextAlign.left,
                                      str: '提现记录',
                                      fontSize: 15,
                                      color: ColorConfig.textGray,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Gaps.vGap10,
                          GestureDetector(
                            onTap: () {
                              Routers.push('/WithdrawlUserInfoPage', context);
                            },
                            child: Container(
                              height: 24,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                  right: 5, left: 5, top: 5, bottom: 5),
                              decoration: const BoxDecoration(
                                  color: ColorConfig.textGrayCS,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: const Caption(
                                alignment: TextAlign.center,
                                str: '更改绑定',
                                fontSize: 10,
                                color: ColorConfig.textDark,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            height: 45,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Caption(
                                  str: commissionSum,
                                ),
                                const Caption(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  str: '累计收益',
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            height: 45,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Caption(
                                  str:
                                      agentDataCountModel.orderCount.toString(),
                                ),
                                const Caption(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  str: '订单数',
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Routers.push(
                                '/AgentMemberPage',
                                context,
                              );
                            },
                            child: Container(
                              height: 45,
                              width: 100,
                              color: ColorConfig.warningText,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Caption(
                                    str: agentDataCountModel.all.toString(),
                                  ),
                                  const Caption(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    str: '好友',
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              )),
          Positioned(
              top: 165,
              right: 15,
              left: 15,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                color: ColorConfig.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Caption(
                        str: '可提现：' +
                            localizationInfo!.currencySymbol +
                            (int.parse(agentDataCountModel.withdrableAmount) /
                                    100)
                                .toStringAsFixed(2),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Routers.push('/ApplyWithDrawPage', context);
                        },
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.only(right: 15),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: ColorConfig.warningText,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: const Caption(
                            str: '提现',
                          ),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
    return headerView;
  }
}
