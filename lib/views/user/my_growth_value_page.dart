/*
  成长值
 */
/*
  成长值
*/

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/user_point_item_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/point_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyGrowthValuePage extends StatefulWidget {
  const MyGrowthValuePage({Key? key}) : super(key: key);

  @override
  GrowthValuePageState createState() => GrowthValuePageState();
}

class GrowthValuePageState extends State<MyGrowthValuePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LocalizationModel? localizationInfo;
  bool isloading = false;
  int pageIndex = 0;
  List<UserPointItemModel> dataList = [];
  UserVipModel? vipDataModel;

  @override
  void initState() {
    super.initState();

    created();
  }

  created({type}) async {
    var _vipDataModel = await UserService.getVipMemberData();

    setState(() {
      vipDataModel = _vipDataModel;

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
      'size': 20,
    };
    var data = await PointService.getGrowthValueList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
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
              child: ZHTextLine(
                str: model.ruleName,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: model.isValid == 0
                    ? ColorConfig.textGrayC
                    : ColorConfig.textBlack,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: ZHTextLine(
                alignment: TextAlign.center,
                str: model.createdAt,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: model.isValid == 0
                    ? ColorConfig.textGrayC
                    : ColorConfig.textBlack,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: ZHTextLine(
                str: model.type == 1
                    ? '+' + model.value.toString()
                    : '-' + model.value.toString(),
                fontSize: 13,
                color: model.isValid == 0
                    ? ColorConfig.textGrayC
                    : model.type == 1
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
              'AboutMe/growth-bg',
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: ScreenUtil().screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ZHTextLine(
                    str: vipDataModel!.profile.currentGrowthValue.toString(),
                    color: ColorConfig.vipNormal,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  Gaps.vGap5,
                  ZHTextLine(
                    str: Translation.t(context, '成长值'),
                    color: ColorConfig.vipNormal,
                  ),
                  Gaps.vGap15,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ZHTextLine(
                        str: Translation.t(context, '当前等级') +
                            '：' +
                            vipDataModel!.profile.levelName,
                        color: ColorConfig.vipNormal,
                      ),
                      ZHTextLine(
                        str: Translation.t(context, '下一等级成长值') +
                            '：' +
                            vipDataModel!.profile.nextGrowthValue.toString(),
                        color: ColorConfig.vipNormal,
                      ),
                    ],
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
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: ColorConfig.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 54,
                      decoration: const BoxDecoration(
                        color: ColorConfig.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      width: ScreenUtil().screenWidth - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: ZHTextLine(
                                str: Translation.t(context, '类型'),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: ZHTextLine(
                                str: Translation.t(context, '时间'),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                                alignment: Alignment.center,
                                child: ZHTextLine(
                                  str: Translation.t(context, '明细'),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      )),
                  Gaps.line,
                  Gaps.line
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return headerView;
  }
}
