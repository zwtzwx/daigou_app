/*
  代理邀请的好友
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AgentMemberPage extends StatefulWidget {
  const AgentMemberPage({Key? key}) : super(key: key);

  @override
  AgentMemberPageState createState() => AgentMemberPageState();
}

class AgentMemberPageState extends State<AgentMemberPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String pageTitle = '';
  int pageIndex = 0;

  LocalizationModel? localizationInfo;

  @override
  void initState() {
    super.initState();
    pageTitle = '好友';

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
      "has_order": 1,
    };
    var data = await AgentService.getSubList(dic);
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
          str: pageTitle,
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListRefresh(
        renderItem: buildAgentUserView,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget buildAgentUserView(int index, UserModel model) {
    return GestureDetector(
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
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   height: 30,
                    //   child: Caption(
                    //     fontSize: 13,
                    //     str: '订单号：' + commissonsModel.orderNumber,
                    //     fontWeight: FontWeight.w400,
                    //     color: ColorConfig.textGray,
                    //   ),
                    // ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: LoadImage(
                                model.avatar,
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
                                  str: model.name, fontWeight: FontWeight.w400),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 25,
                              // @todo BUG!
                              child: Caption(
                                  str: '下单数: ' + (model.orderCount).toString(),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // Container(
                        //   alignment: Alignment.centerRight,
                        //   height: 25,
                        //   child: Caption(
                        //       str: commissonsModel.settled != 1 ? '待审核' : '',
                        //       fontWeight: FontWeight.w300,
                        //       color: ColorConfig.warningTextDark),
                        // ),
                        Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 25,
                              child: const Caption(
                                  str: '总收益：', fontWeight: FontWeight.w300),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 25,
                              child: Caption(
                                str: localizationInfo!.currencySymbol +
                                    ((model.profit ?? 0) / 100)
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
            )));
  }
}
