// ignore_for_file: unnecessary_const

/*
  会员中心
*/

import 'package:jiyun_app_client/common/hex_to_color.dart';
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
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    var token = await UserStorage.getToken();
    if (token.isNotEmpty) {
      await getUserVipInfo();
      userVipModel = await UserService.getVipMemberData();

      setState(() {
        isloading = true;
      });

      EasyLoading.dismiss();
    }
  }

  // 用户会员信息
  Future<void> getUserVipInfo() async {
    var data = await UserService.getOrderDataCount();
    if (data != null) {
      setState(() {
        userOrderModel = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    userInfo = Provider.of<Model>(context, listen: false).userInfo;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: ColorConfig.textDark,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: pageTitle,
            color: ColorConfig.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        bottomNavigationBar: isloading
            ? Container(
                height: 70,
                width: ScreenUtil().screenWidth,
                color: ColorConfig.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(children: <Widget>[
                          const Caption(
                            str: '合计：',
                          ),
                          Caption(
                              color: ColorConfig.textRed,
                              str: selectButton == 999
                                  ? localizationInfo!.currencySymbol + '0'
                                  : localizationInfo!.currencySymbol +
                                      (userVipModel!.priceList[selectButton]
                                                  .price /
                                              100)
                                          .toString())
                        ]),
                        Caption(
                          str: selectButton == 999
                              ? '+ 0 成长值'
                              : '+' +
                                  userVipModel!
                                      .priceList[selectButton].growthValue
                                      .toString() +
                                  '成长值',
                          fontSize: 14,
                          color: ColorConfig.textGray,
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () async {
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
                            // getLocalization();
                            getUserVipInfo();
                            setState(() {
                              selectButton = 999;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  HexToColor('#F5DBAA'),
                                  HexToColor('#E6C17F'),
                                ],
                                //渐变角度
                              ),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(20))),
                          margin: const EdgeInsets.only(right: 15, left: 25),
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          height: 40,
                          child: const Caption(str: '立即支付'),
                        ))
                  ],
                ),
              )
            : Container(),
        body: isloading
            ? SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  headerCardView(context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60,
                        color: ColorConfig.white,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 3,
                              width: 60,
                              margin:
                                  const EdgeInsets.only(right: 15, bottom: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  HexToColor('#FFFFFF'),
                                  HexToColor('#E4C79E'),
                                ],
                                transform: const GradientRotation(131), //渐变角度
                              )),
                            ),
                            const SizedBox(
                              height: 40,
                              child: Caption(
                                str: '购买会员 享折扣',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                                height: 3,
                                width: 60,
                                margin:
                                    const EdgeInsets.only(left: 15, bottom: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    HexToColor('#E4C79E'),
                                    HexToColor('#FFFFFF'),
                                  ],
                                  transform: const GradientRotation(131), //渐变角度
                                ))),
                          ],
                        ),
                      ),
                      buyVipPriceView(context),
                      Container(
                        color: ColorConfig.white,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        height: 520,
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              color: ColorConfig.white,
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 3,
                                    width: 60,
                                    margin: const EdgeInsets.only(
                                        right: 15, bottom: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        HexToColor('#FFFFFF'),
                                        HexToColor('#E4C79E'),
                                      ],
                                      transform:
                                          const GradientRotation(131), //渐变角度
                                    )),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                    child: Caption(
                                      str: '成长值说明',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                      height: 3,
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          left: 15, bottom: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        colors: [
                                          HexToColor('#E4C79E'),
                                          HexToColor('#FFFFFF'),
                                        ],
                                        transform:
                                            const GradientRotation(131), //渐变角度
                                      ))),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 250, // 190+ 20 +20
                              width: ScreenUtil().screenWidth - 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: buildListView(),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 15),
                                height: 200, // 190+ 20 +20
                                width: ScreenUtil().screenWidth - 30,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Caption(
                                      str: '成长值说明：',
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 15, left: 15),
                                      child: Caption(
                                        lines: 99,
                                        str: userVipModel!.levelRemark!,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            : Container());
  }

  buildListView() {
    List<Widget> listV = [];
    for (var i = 0; i < userVipModel!.levelList.length; i++) {
      UserVipLevel memModel = userVipModel!.levelList[i];
      var view = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 0, bottom: 10),
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexToColor('#F5DBAA'),
                    HexToColor('#E6C17F'),
                  ],
                  //渐变角度
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10))),
            height: 20,
            alignment: Alignment.center,
            child: Caption(
              str: memModel.growthValue.toString(),
              fontSize: 8,
              fontWeight: FontWeight.w300,
              color: ColorConfig.textBlack,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 0),
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, right: 3, left: 3),
            height: 190 * (i + 1) / userVipModel!.levelList.length,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexToColor('#D4B69F'),
                    HexToColor('#AE886D'),
                  ],
                  //渐变角度
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10))),
          ),
          Container(
            margin: const EdgeInsets.only(left: 0),
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
            height: 20,
            alignment: Alignment.bottomCenter,
            child: Caption(
              str: memModel.name,
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: ColorConfig.textBlack,
            ),
          ),
        ],
      );
      listV.add(view);
    }
    return listV;
  }

  /*
    购买会员价格区域
   */
  Widget buyVipPriceView(BuildContext context) {
    return Container(
      color: ColorConfig.white,
      padding: const EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 20.0, //水平子Widget之间间距
          mainAxisSpacing: 10.0, //垂直子Widget之间间距
          crossAxisCount: 3, //一行的Widget数量
          childAspectRatio: 1,
        ), // 宽高比例
        itemCount: userVipModel!.priceList.length,
        itemBuilder: _buildGrideBtnView(),
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
                      ? ColorConfig.warningTextDark50
                      : ColorConfig.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: selectButton == index ? 0.5 : 0.3,
                    color: selectButton == index
                        ? ColorConfig.textBlack
                        : ColorConfig.textGrayC,
                  )),
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
                            height: 17,
                            alignment: Alignment.topRight,
                            width: (ScreenUtil().screenWidth - 70) / 3,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular((15))),
                            ),
                            child: model.type == 2
                                ? Container(
                                    height: 17,
                                    alignment: Alignment.center,
                                    width:
                                        (ScreenUtil().screenWidth - 70) / 3 / 3,
                                    decoration: const BoxDecoration(
                                      color: ColorConfig.textRed,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular((15)),
                                          bottomLeft:
                                              const Radius.circular((15))),
                                    ),
                                    child: const Caption(
                                      str: '活动',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConfig.white,
                                    ),
                                  )
                                : Container(),
                          ),
                          Caption(
                            // 会员价格
                            str: localizationInfo!.currencySymbol +
                                (model.price / 100).toString(),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ColorConfig.textRed,
                          ),
                          Stack(
                            children: [
                              Caption(
                                str: model.type != 1
                                    ? localizationInfo.currencySymbol +
                                        (model.basePrice / 100).toString()
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
                          Caption(
                            str: model.name,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ColorConfig.textBlack,
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        width: (ScreenUtil().screenWidth - 70) / 3,
                        decoration: BoxDecoration(
                            color: ColorConfig.warningTextDark,
                            borderRadius: const BorderRadius.vertical(
                                bottom: const Radius.circular((15))),
                            border: Border.all(
                              width: 0.5,
                              color: ColorConfig.warningText,
                            )),
                        child: Caption(
                          str: model.illustrate,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
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
    num secondNum = userVipModel!.profile.nextGrowthValue;
    var headerView = SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          Container(
            color: ColorConfig.textDark,
            //设置背景图片
          ),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            bottom: 0,
            child: RoundPathWidget(
              pathShape: PathShapeEnum.partRoundRect,
              leftTopRadius: 40,
              rightTopRadius: 40,
              child: ClipPath(
                //路径剪裁组件
                clipper: TrapezoidPath(),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HexToColor('#F7F7F7'),
                        HexToColor('#F7F7F7'),
                      ],
                      transform: const GradientRotation(131), //渐变角度
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Container(
                    height: 8,
                    width: ScreenUtil().screenWidth - 40,
                    decoration: const BoxDecoration(
                        color: ColorConfig.textGray,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(4),
                            left: Radius.circular(4))),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 30,
            right: 30,
            bottom: 11,
            child: Container(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              width: ScreenUtil().screenWidth - 30,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
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
                                  userInfo!.avatar,
                                  fit: BoxFit.fitWidth,
                                  holderImg: "PackageAndOrder/defalutIMG@3x",
                                  format: "png",
                                ),
                              ))),
                      Gaps.hGap4,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: ScreenUtil().screenWidth / 2,
                                // height: 20,
                                child: Caption(
                                  alignment: TextAlign.center,
                                  str: userInfo!.name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConfig.textDark,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                padding: const EdgeInsets.only(
                                    top: 2, bottom: 2, right: 5, left: 5),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        HexToColor('#D4B69F'),
                                        HexToColor('#AE886D'),
                                      ],
                                      //渐变角度
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                height: 20,
                                alignment: Alignment.bottomCenter,
                                child: Caption(
                                  str: userVipModel == null ||
                                          userVipModel!
                                              .profile.levelName.isEmpty
                                      ? 'V0'
                                      : userVipModel!.profile.levelName,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: ColorConfig.white,
                                ),
                              ),
                            ],
                          ),
                          Gaps.vGap10,
                          SizedBox(
                            height: 24,
                            child: Caption(
                              alignment: TextAlign.center,
                              str: 'ID:' + userInfo!.id.toString(),
                              fontSize: 15,
                              color: ColorConfig.textDark,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Routers.push('/MyGrowthValuePage', context);
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      height: 40,
                      child: Row(
                        children: const <Widget>[
                          Caption(
                            str: '成长值',
                            fontSize: 15,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: ColorConfig.textDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomLeft,
                      height: 20,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              top: 7.5,
                              right: 0,
                              left: 0,
                              bottom: 7.5,
                              child: Container(
                                height: 5,
                                decoration: const BoxDecoration(
                                    color: ColorConfig.textGray,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.5))),
                              )),
                          Positioned(
                              top: 7.5,
                              right: secondNum == 0
                                  ? (ScreenUtil().screenWidth - 90)
                                  : (ScreenUtil().screenWidth - 90) *
                                      firstNum /
                                      secondNum, //ScreenUtil().screenWidth - 90 平均分成100份
                              left: 0,
                              bottom: 7.5,
                              child: Container(
                                height: 5,
                                decoration: const BoxDecoration(
                                    color: ColorConfig.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.5))),
                              ))
                        ],
                      )),
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Caption(
                          str: '距离下一等级还差：' + firstNum.toString(),
                          fontSize: 12,
                        ),
                        Caption(
                          str: userVipModel!.profile.currentGrowthValue
                                  .toString() +
                              '/' +
                              secondNum.toString(),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
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
