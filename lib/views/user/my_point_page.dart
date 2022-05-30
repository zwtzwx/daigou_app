// ignore_for_file: unnecessary_new

/*
  我的积分
 */

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_point_item_model.dart';
import 'package:jiyun_app_client/models/user_point_model.dart';
import 'package:jiyun_app_client/services/point_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyPointPage extends StatefulWidget {
  final Map? arguments;

  const MyPointPage({Key? key, required this.arguments}) : super(key: key);

  @override
  MyPointPageState createState() => MyPointPageState();
}

class MyPointPageState extends State<MyPointPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  //会员中心基础信息

  LocalizationModel? localizationInfo;

  UserModel? userInfo;

  UserPointModel? userPointModel;
  int pageIndex = 0;
  bool isloading = false;
  List<UserPointItemModel> userPointList = [];

  @override
  void initState() {
    super.initState();
    created();
    loadList();
  }

  created() async {
    var token = await UserStorage.getToken();
    if (token.isNotEmpty) {
      userPointModel = await PointService.getSummary();
    }
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {"page": (++pageIndex), 'size': 20};
    var data = await PointService.getList(dic);
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
        title: const Caption(
          str: '我的积分',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListRefresh(
        renderItem: buildCellForFirstListView,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget buildCellForFirstListView(int index, UserPointItemModel model) {
    var container = Container(
      height: 55,
      margin: const EdgeInsets.only(right: 15, left: 15),
      width: ScreenUtil().screenWidth - 30,
      color: ColorConfig.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Caption(
                str: model.ruleName,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Caption(
                alignment: TextAlign.center,
                str: model.createdAt,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Caption(
                str: model.type == 1
                    ? '+' + model.value.toString()
                    : '-' + model.value.toString(),
                fontSize: 15,
                color: model.type == 1
                    ? ColorConfig.textDark
                    : ColorConfig.warningText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
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
      height: 200,
      child: Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              color: ColorConfig.warningText,
              constraints: const BoxConstraints.expand(
                height: 200.0,
              ),
              //设置背景图片
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Caption(
                          str: '可用积分',
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onDoubleTap: () async {},
                          child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 200,
                              child: Caption(
                                str: userPointModel!.point.toString(),
                                fontSize: 20,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Caption(
                          str: '累计积分：' + userPointModel!.allPoint,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Routers.push('/PrepaidRecord', context);
                          },
                          child: Caption(
                            str: userPointModel!.configPoint.toString() +
                                '积分=' +
                                localizationInfo!.currencySymbol +
                                userPointModel!.configAmount,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
              top: 145,
              left: 15,
              right: 15,
              bottom: 0,
              child: Container(
                  height: 55,
                  width: ScreenUtil().screenWidth - 30,
                  color: ColorConfig.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Caption(
                            str: '类型',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Caption(
                            str: '时间',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: const Caption(
                              str: '明细',
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

// 订单列表
class IntegralList extends StatefulWidget {
  const IntegralList({
    Key? key,
    required this.params,
    required this.onChanged,
  });
  final ValueChanged<int> onChanged;
  final Map<String, dynamic> params;
  @override
  IntegralListState createState() => IntegralListState();
}

class IntegralListState extends State<IntegralList> {
  final GlobalKey<IntegralListState> key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 0;
  bool isloading = false;
  List<bool> selectList = [];

  @override
  void initState() {
    super.initState();
    loadList();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
          renderItem: renderItem, refresh: loadList, more: loadMoreList),
    );
  }

  Widget renderItem(index, Map orderModel) {
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        // Routers.push('/goodsDetailPage', context, {"goodsId": productGoods.id});
      },
      child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            border: new Border.all(width: 1, color: ColorConfig.line),
          ),
          margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
          padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
          height: 55,
          child: Container()),
    );
  }

  double calculateTextHeight(String value, fontSize, FontWeight fontWeight,
      double maxWidth, int maxLines) {
    // value = filterText(value);
    TextPainter painter = TextPainter(
        // ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        // locale: Localizations.localeOf(GlobalStatic.context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }
}
