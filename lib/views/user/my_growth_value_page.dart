/*
  成长值
 */
/*
  成长值
*/

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/user_point_item_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/point_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyGrowthValuePage extends StatefulWidget {
  const MyGrowthValuePage({Key? key}) : super(key: key);

  @override
  GrowthValuePageState createState() => GrowthValuePageState();
}

class GrowthValuePageState extends State<MyGrowthValuePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

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
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorConfig.textDark,
        elevation: 0.5,
        centerTitle: true,
        title: const Caption(
          str: '成长值',
          color: ColorConfig.white,
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
              child: Caption(
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
              child: Caption(
                str: model.type == 1
                    ? '+' + model.value.toString()
                    : '-' + model.value.toString(),
                fontSize: 13,
                color: model.isValid == 0
                    ? ColorConfig.textGrayC
                    : model.type == 1
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
    num firstNum = (vipDataModel?.profile.nextGrowthValue == null
        ? 0
        : (vipDataModel!.profile.nextGrowthValue -
                    vipDataModel!.profile.currentGrowthValue <=
                0
            ? 0
            : vipDataModel!.profile.currentGrowthValue));

    var headerView = SizedBox(
      height: 230,
      child: Stack(
        children: <Widget>[
          Container(
            color: ColorConfig.textDark,
            //设置背景图片
          ),
          Positioned(
            top: 20,
            left: 30,
            right: 30,
            bottom: 50,
            child: Container(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              width: ScreenUtil().screenWidth,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/images/AboutMe/Mask矩形@3x.png'),
                    fit: BoxFit.cover),
                gradient: LinearGradient(
                  colors: [
                    HexToColor('#F7DBA9'),
                    HexToColor('#FFE7BB'),
                    HexToColor('#E5C17E'),
                  ],
                  transform: const GradientRotation(131), //渐变角度
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 60,
                    child: Caption(
                      str: vipDataModel!.profile.currentGrowthValue.toString(),
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 40,
                    child: Caption(
                      str: '距离下一等级还差：' + firstNum.toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 175,
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
