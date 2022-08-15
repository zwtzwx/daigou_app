// ignore_for_file: unnecessary_const

/*
  会员中心
*/

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/models/user_vip_level_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/models/user_vip_price_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/*
  会员中心
 */
class VipCenterPage extends StatefulWidget {
  final Map? arguments;

  const VipCenterPage({Key? key, required this.arguments}) : super(key: key);

  @override
  VipCenterPageState createState() => VipCenterPageState();
}

class VipCenterPageState extends State<VipCenterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String pageTitle = '';
  bool isloading = false;

  //各种统计，包括余额
  UserOrderCountModel? userOrderModel;

  //会员中心基础信息
  UserVipModel? userVipModel;

  LocalizationModel? localizationInfo;

  UserModel? userInfo;

  int selectButton = 999;

  @override
  void initState() {
    super.initState();
    pageTitle = '会员中心';

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});

    created();
    // ApplicationEvent.getInstance().event.on<DelegateRefresh>().listen((event) {
    //   created();
    // });
  }

  created() async {
    EasyLoading.show();
    var data = await UserService.getVipMemberData();
    EasyLoading.dismiss();
    setState(() {
      userVipModel = data;
      isloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    userInfo = Provider.of<Model>(context, listen: false).userInfo;

    return Scaffold(
        key: _scaffoldKey,
        primary: false,
        appBar: const EmptyAppBar(),
        backgroundColor: ColorConfig.bgGray,
        bottomNavigationBar: isloading
            ? Container(
                decoration: const BoxDecoration(
                  color: ColorConfig.white,
                  border: Border(
                    top: BorderSide(
                      color: ColorConfig.line,
                    ),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Caption(
                              str: Translation.t(context, '合计') + '：',
                              fontWeight: FontWeight.bold,
                            ),
                            Caption(
                              color: ColorConfig.textRed,
                              str: selectButton == 999
                                  ? '0.00'
                                  : (userVipModel!
                                              .priceList[selectButton].price /
                                          100)
                                      .toString(),
                              fontWeight: FontWeight.bold,
                            ),
                          ]),
                          Caption(
                            str: selectButton == 999
                                ? '+ 0 ' + Translation.t(context, '成长值')
                                : '+' +
                                    userVipModel!
                                        .priceList[selectButton].growthValue
                                        .toString() +
                                    Translation.t(context, '成长值'),
                            fontSize: 14,
                            color: ColorConfig.textGray,
                          ),
                        ],
                      ),
                      MainButton(
                        text: '立即支付',
                        fontWeight: FontWeight.bold,
                        backgroundColor: HexToColor('#d1bb7f'),
                        onPressed: () async {
                          var a = await Navigator.pushNamed(
                              context, '/OrderPayPage', arguments: {
                            'model': userVipModel!.priceList[selectButton],
                            'payModel': 0
                          });
                          if (a == null) {
                            return;
                          }
                          String content = a.toString();
                          if (content == 'succeed') {
                            created();
                            setState(() {
                              selectButton = 999;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        body: isloading
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    headerCardView(context),
                    Gaps.vGap15,
                    buildGrowthValueView(),
                    Gaps.vGap15,
                    buyVipPriceView(context),
                    Gaps.vGap15,
                  ],
                ),
              )
            : Container());
  }

  // 成长值
  Widget buildGrowthValueView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConfig.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Caption(
              str: '成长值说明',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Caption(
              lines: 99,
              str: userVipModel!.levelRemark!,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
            child: Column(
              children: buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  // 成长值列表
  buildListView() {
    List<Widget> listV = [];
    listV.add(buildGrowthValueRow(
        Translation.t(context, '等级'), Translation.t(context, '成长值'),
        isTitle: true));
    for (var i = 0; i < userVipModel!.levelList.length; i++) {
      UserVipLevel memModel = userVipModel!.levelList[i];
      listV.add(buildGrowthValueRow(
        memModel.name,
        memModel.growthValue.toString(),
      ));
    }
    return listV;
  }

  buildGrowthValueRow(String label, String content, {bool isTitle = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 33,
              alignment: Alignment.center,
              color:
                  isTitle ? const Color(0xFFf2edde) : const Color(0xFFf9f8f4),
              child: Caption(
                str: label,
                color: ColorConfig.vipNormal,
              ),
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 33,
              alignment: Alignment.center,
              color:
                  isTitle ? const Color(0xFFf2edde) : const Color(0xFFf9f8f4),
              child: Caption(
                str: content,
                color: ColorConfig.vipNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
    购买会员价格区域
   */
  Widget buyVipPriceView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConfig.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Caption(
              str: Translation.t(context, '购买会员'),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gaps.line,
          Padding(
            padding: const EdgeInsets.all(30),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.0, //水平子Widget之间间距
                mainAxisSpacing: 10.0, //垂直子Widget之间间距
                crossAxisCount: 3, //一行的Widget数量
                childAspectRatio: 0.8,
              ), // 宽高比例
              itemCount: userVipModel!.priceList.length,
              itemBuilder: _buildGrideBtnView(),
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    LocalizationModel? localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return (context, index) {
      UserVipPriceModel model = userVipModel!.priceList[index];
      return GestureDetector(
          onTap: () {
            setState(() {
              selectButton = index;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  color: selectButton == index
                      ? const Color(0xFFf9f8f4)
                      : ColorConfig.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectButton == index
                        ? ColorConfig.vipNormal
                        : const Color(0xFFd9c58d),
                  ),
                  boxShadow: selectButton == index
                      ? [
                          const BoxShadow(
                            blurRadius: 6,
                            color: const Color(0x6B4A3808),
                          ),
                        ]
                      : null),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: const Color(0xFFd9c48c),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Caption(
                              str: model.name,
                              color: Colors.white,
                            ),
                          ),
                          // Container(
                          //   height: 17,
                          //   alignment: Alignment.topRight,
                          //   width: (ScreenUtil().screenWidth - 70) / 3,
                          //   decoration: const BoxDecoration(
                          //     color: Colors.transparent,
                          //     borderRadius: BorderRadius.vertical(
                          //         top: Radius.circular((15))),
                          //   ),
                          //   child: model.type == 2
                          //       ? Container(
                          //           height: 17,
                          //           alignment: Alignment.center,
                          //           width:
                          //               (ScreenUtil().screenWidth - 70) / 3 / 3,
                          //           decoration: const BoxDecoration(
                          //             color: ColorConfig.textRed,
                          //             borderRadius: BorderRadius.only(
                          //                 topRight: Radius.circular((15)),
                          //                 bottomLeft:
                          //                     const Radius.circular((15))),
                          //           ),
                          //           child:  Caption(
                          //             str: Translation.t(context, '活动'),
                          //             fontSize: 9,
                          //             fontWeight: FontWeight.w400,
                          //             color: ColorConfig.white,
                          //           ),
                          //         )
                          //       : Container(),
                          // ),
                          Caption(
                            // 会员价格
                            str: (model.price / 100).toString(),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ColorConfig.textRed,
                          ),
                          Stack(
                            children: [
                              Caption(
                                str: model.type != 1
                                    ? (model.basePrice / 100).toString()
                                    : '',
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: ColorConfig.textGray,
                              ),
                              Positioned(
                                  top: 7,
                                  bottom: 8,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    height: 1,
                                    color: ColorConfig.textGray,
                                  ))
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        width: (ScreenUtil().screenWidth - 70) / 3,
                        child: Caption(
                          str: model.illustrate,
                          fontSize: 14,
                        ),
                      )),
                ],
              )));
    };
  }

  /*
    头部分卡片区
   */
  Widget headerCardView(BuildContext context) {
    num nextLevelGrowthValue = userVipModel!.profile.nextGrowthValue;
    num growthValue = userVipModel!.profile.currentGrowthValue;
    num firstNum = nextLevelGrowthValue - growthValue;
    double widthFactor = growthValue / nextLevelGrowthValue;
    if (widthFactor > 1) {
      widthFactor = 1;
    }
    var headerView = SizedBox(
      height: ScreenUtil().setHeight(190) + 30,
      child: Stack(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(180),
            alignment: Alignment.topLeft,
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
            bottom: 0,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 7, bottom: 13, left: 15, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Caption(
                        str: Translation.t(context, '成长值'),
                        fontSize: 13,
                        color: ColorConfig.vipNormal,
                      ),
                      Gaps.hGap10,
                      Flexible(
                        child: GestureDetector(
                          child: Caption(
                            str: Translation.t(context, '距离下一等级还差{count}成长值',
                                    value: {
                                      'count': firstNum < 0 ? 0 : firstNum
                                    }) +
                                ' >',
                            color: ColorConfig.vipNormal,
                            lines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.vGap15,
                  Row(
                    children: [
                      Caption(
                        str: growthValue.toString(),
                        color: ColorConfig.vipNormal,
                        fontWeight: FontWeight.bold,
                      ),
                      Gaps.hGap10,
                      Expanded(
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: ColorConfig.orderLine,
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                alignment: Alignment.topLeft,
                                heightFactor: 1,
                                widthFactor: widthFactor,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: HexToColor('#DAB85C'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gaps.hGap10,
                      Caption(
                        str: nextLevelGrowthValue.toString(),
                        color: ColorConfig.vipNormal,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(90),
            left: 15,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: LoadImage(
                      userInfo!.avatar,
                      fit: BoxFit.fitWidth,
                      holderImg: "AboutMe/about-logo",
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Caption(
                      str: userInfo!.name,
                      fontSize: 16,
                      color: ColorConfig.vipNormal,
                      fontWeight: FontWeight.bold,
                    ),
                    Gaps.vGap4,
                    Caption(
                      str: 'ID：${userInfo!.id}',
                      color: ColorConfig.vipNormal,
                    ),
                    Gaps.vGap4,
                    GestureDetector(
                      onTap: () {
                        Routers.push('/MyPointPage', context);
                      },
                      child: Row(
                        children: [
                          Caption(
                            str: Translation.t(context, '积分'),
                            color: ColorConfig.vipNormal,
                          ),
                          Gaps.hGap10,
                          Caption(
                            str: (userVipModel?.profile.point ?? 0).toString(),
                            color: ColorConfig.vipNormal,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return headerView;
  }
}

class RoundPathWidget extends StatelessWidget {
  final Widget child;
  final double leftTopRadius;
  final double rightTopRadius;
  final double leftBottomRadius;
  final double rightBottomRadius;

  final PathShapeEnum pathShape;
  final double radius;

  const RoundPathWidget(
      {Key? key,
      required this.child,
      this.radius = 0,
      this.pathShape = PathShapeEnum.circlePath,
      this.leftTopRadius = 0,
      this.rightTopRadius = 0,
      this.leftBottomRadius = 0,
      this.rightBottomRadius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RoundPathClipper(
          leftTopRadius: leftTopRadius,
          rightTopRadius: rightTopRadius,
          leftBottomRadius: leftBottomRadius,
          rightBottomRadius: rightBottomRadius,
          pathShape: pathShape,
          radius: radius),
      child: child,
    );
  }
}

///枚举定义展示样式：圆形，圆角矩形，不同角不同圆角设置
enum PathShapeEnum { circlePath, roundRect, partRoundRect }

class RoundPathClipper extends CustomClipper<Path> {
  final double leftTopRadius;
  final double rightTopRadius;
  final double leftBottomRadius;
  final double rightBottomRadius;

  final PathShapeEnum pathShape;
  final double radius;

  RoundPathClipper(
      {required this.pathShape,
      required this.radius,
      required this.leftTopRadius,
      required this.rightTopRadius,
      required this.leftBottomRadius,
      required this.rightBottomRadius});

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final path = Path();
    double pi = 3.14;
    if (PathShapeEnum.circlePath == pathShape) {
      path.addOval(Rect.fromLTRB(0, 0, width, height));
    } else if (PathShapeEnum.roundRect == pathShape) {
      path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, width, height), Radius.circular(radius)));
    } else {
      final leftTopRect =
          Rect.fromLTRB(0, 0, leftTopRadius * 2, leftTopRadius * 2);
      final leftBottomRect = Rect.fromLTRB(
          0, height - leftBottomRadius * 2, leftBottomRadius * 2, height);
      final rightTopRect = Rect.fromLTRB(
          width - 2 * rightTopRadius, 0, width, rightTopRadius * 2);
      final rightBottomRect = Rect.fromLTRB(width - 2 * rightBottomRadius,
          height - rightBottomRadius * 2, width, height);
      //左上角 圆弧
      path.arcTo(leftTopRect, 180 / 180 * pi, 90 / 180 * pi, false);
      //右上角圆弧
      path.lineTo(width - rightTopRadius, 0);
      path.arcTo(rightTopRect, 270 / 180 * pi, 90 / 180 * pi, false);
      //右下角
      path.lineTo(width, height - rightBottomRadius);
      path.arcTo(rightBottomRect, 0, 90 / 180 * pi, false);
      //左下角
      path.lineTo(leftBottomRadius, height);
      path.arcTo(leftBottomRect, 90 / 180 * pi, 90 / 180 * pi, false);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TrapezoidPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height); //x,y坐标
    path.lineTo(20, 0);
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
