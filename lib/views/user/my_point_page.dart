// ignore_for_file: unnecessary_new

/*
  我的积分
 */

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_point_item_model.dart';
import 'package:jiyun_app_client/models/user_point_model.dart';
import 'package:jiyun_app_client/services/point_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

class MyPointPage extends StatefulWidget {
  final Map? arguments;

  const MyPointPage({Key? key, required this.arguments}) : super(key: key);

  @override
  MyPointPageState createState() => MyPointPageState();
}

class MyPointPageState extends State<MyPointPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      primary: false,
      appBar: const EmptyAppBar(),
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
                    : ColorConfig.textRed,
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
      child: Stack(
        children: <Widget>[
          SizedBox(
            child: LoadImage(
              'AboutMe/jifen-bg',
              fit: BoxFit.fitWidth,
              width: ScreenUtil().screenWidth,
            ),
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 15,
            child: const BackButton(
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 70,
            //设置背景图片
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().screenWidth,
              child: Column(
                children: <Widget>[
                  Caption(
                    str: (userPointModel?.point ?? 0).toString(),
                    fontSize: 30,
                    color: ColorConfig.vipNormal,
                    fontWeight: FontWeight.bold,
                  ),
                  Gaps.vGap5,
                  Caption(
                    str: Translation.t(context, '可用积分'),
                    color: ColorConfig.vipNormal,
                  ),
                  Gaps.vGap15,
                  Caption(
                    str: Translation.t(context, '使用规则') +
                        '：' +
                        (userPointModel?.configPoint ?? 0).toString() +
                        '${Translation.t(context, '积分')}=' +
                        (userPointModel?.configAmount ?? 0).toString(),
                    fontSize: 14,
                    color: ColorConfig.vipNormal,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
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
                          child: Caption(
                            str: Translation.t(context, '类型'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Caption(
                            str: Translation.t(context, '时间'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Caption(
                              str: Translation.t(context, '明细'),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
  }) : super(key: key);
  final ValueChanged<int> onChanged;
  final Map<String, dynamic> params;
  @override
  IntegralListState createState() => IntegralListState();
}

class IntegralListState extends State<IntegralList> {
  final GlobalKey<IntegralListState> key = GlobalKey();
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
