import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/events/profile_updated_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_agent_status_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/*
  我的
*/
class MePage extends StatefulWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //会员中心基础信息
  UserVipModel? userVipModel;

  //各种统计，包括余额
  UserOrderCountModel? userOrderModel;

  bool isloading = false;
  //是否代理的一个身份
  UserAgentStatusModel? agentStatus = UserAgentStatusModel(id: 0, name: '');

  @override
  void initState() {
    super.initState();
    ApplicationEvent.getInstance()
        .event
        .on<ProfileUpdateEvent>()
        .listen((event) {
      created();
    });
    created();
  }

  /*
    用户基础数据统计
    余额，收益，积分
    个人基础信息
   */
  Future<void> created() async {
    var token = await UserStorage.getToken();
    if (token.isNotEmpty) {
      userVipModel = await UserService.getVipMemberData();
      agentStatus = (await UserService.getAgentStatus());
      userOrderModel = await UserService.getOrderDataCount();
      setState(() {
        isloading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConfig.bgGray,
        body: RefreshIndicator(
            onRefresh: created,
            color: ColorConfig.textRed,
            child: Container(
              color: ColorConfig.warningText,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: buildCellForFirstListView,
                controller: _scrollController,
                itemCount: 4,
              ),
            )));
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    if (index == 1) {
      return buildExampleCell(context);
    } else if (index == 2) {
      return buildListView(context);
    } else if (index == 3) {
      return buildFooter(context);
    }
    return buildCustomViews(context);
  }

  Widget buildFooter(BuildContext context) {
    return Container(
      color: ColorConfig.bgGray,
      width: ScreenUtil().screenWidth,
      height: 200,
    );
  }

  Widget buildListView(BuildContext context) {
    var listView = Container(
      decoration: BoxDecoration(
          color: ColorConfig.bgGray,
          border: Border.all(width: 1, color: ColorConfig.line),
          boxShadow: const [
            BoxShadow(
                color: ColorConfig.bgGray,
                offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                blurRadius: 2.0, //阴影模糊程度
                spreadRadius: 2.0 //阴影扩散程度
                )
          ]),
      child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          decoration: const BoxDecoration(
            color: ColorConfig.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: buildBottomListCell,
            controller: _scrollController,
            itemCount: 7,
          )),
    );
    return listView;
  }

  Widget buildBottomListCell(BuildContext context, int index) {
    List<String> titleList = [
      '个人信息',
      '成为合伙人',
      '公告中心',
      '用户评价',
      '投诉建议',
      '关于我们',
      '退出登录',
    ];
    List<ImageIcon> iconList = [
      const ImageIcon(
        AssetImage("assets/images/AboutMe/个人信息@3x.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
      const ImageIcon(
        AssetImage("assets/images/AboutMe/成为代理@3x.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
      const ImageIcon(
        AssetImage("assets/images/AboutMe/公告中心@3x.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
      const ImageIcon(
        AssetImage("assets/images/AboutMe/客户评价@3x.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
      const ImageIcon(
        AssetImage("assets/images/AboutMe/suggest.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
      const ImageIcon(
        AssetImage("assets/images/AboutMe/关于我们@3x.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
      const ImageIcon(
        AssetImage("assets/images/AboutMe/退出登录@3x.png"),
        color: ColorConfig.textDark,
        size: 20,
      ),
    ];
    return GestureDetector(
        onTap: () async {
          if (index == 7) {
            return;
          }
          if (index == 0) {
            // 个人
            Routers.push('/MyProfilePage', context);
          } else if (index == 1) {
            // 合伙人
            if (agentStatus?.id == 2) {
              return;
            }
            if (agentStatus?.id == 3 || agentStatus?.id == 0) {
              Routers.push('/RegisterAgentPage', context);
            } else {
              Routers.push('/AgentPage', context);
            }
          } else if (index == 2) {
            // 公告中心
            Routers.push('/HelpSupportPage', context);
          } else if (index == 3) {
            // 用户评价
            Routers.push('/CommentListPage', context);
          } else if (index == 4) {
            // 投诉建议
            Routers.push('/SuggestTypePage', context);
          } else if (index == 5) {
            // 关于我们
            Routers.push('/AboutMePage', context);
          } else if (index == 6) {
            // 退出登录
            showActionSheet(context);
          } else if (index == 7) {
          } else if (index == 8) {
            // Routers.push(
            //     '/HelpSecondListPage', context, {'type': index.toString()});
          } else if (index == 9) {}
        },
        child: Container(
            decoration: BoxDecoration(
              color: index == 7 ? ColorConfig.bgGray : ColorConfig.white,
              border: const Border(
                  bottom: BorderSide(
                      width: 0.5,
                      color: ColorConfig.line,
                      style: BorderStyle.solid)),
            ),
            padding: const EdgeInsets.only(left: 5, right: 15),
            margin: const EdgeInsets.only(right: 10, left: 10),
            height: index == 7 ? 10 : 55,
            child: index == 7
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: iconList[index],
                              onPressed: () {
                                // Routers.push(
                                //     '/CreatAddress', context, {'content': 'des'});
                              }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Caption(
                                        str: titleList[index],
                                        // fontSize: 18,
                                        color: ColorConfig.textBlack,
                                      ))),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          index != 1
                              ? Container()
                              : Caption(str: agentStatus?.name ?? ''),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: ColorConfig.textGray,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  )));
  }

  /* 注销登录 */
  void showActionSheet(context) {
    showCupertinoDialog<int>(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: const Text("提示"),
            content: const Text('确认退出登录吗？'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("取消"),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              ),
              CupertinoDialogAction(
                child: const Text("确认"),
                onPressed: () {
                  Navigator.pop(cxt, 1);
                },
              ),
            ],
          );
        }).then((value) {
      // 点击确定
      if (value == 1) {
        UserStorage.clearToken();
        //清除TOKEN
        Provider.of<Model>(context, listen: false).loginOut();
        // ApplicationEvent.getInstance().event.fire(HomeRefreshEvent());
        ApplicationEvent.getInstance()
            .event
            .fire(ChangePageIndexEvent(pageName: 'home'));
      }
    });
  }

  // 中间四个大类按钮
  Widget buildMoreSupportType(BuildContext context) {
    return Container(
      color: ColorConfig.white,
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 4, //一行的Widget数量
            childAspectRatio: 1,
          ), // 宽高比例
          itemCount: 4,
          itemBuilder: _buildGrideBtnView()),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    List<String> listDesTitle = [
      '收货地址',
      '我的积分',
      '余额充值',
      '会员中心',
    ];
    List<String> listImg = [
      'AboutMe/收货地址@3x',
      'AboutMe/我的积分@3x',
      'AboutMe/充值余额@3x',
      'AboutMe/会员中心@3x',
    ];
    return (context, index) {
      return GestureDetector(
        onTap: () {
          if (index == 0) {
            // 地址
            Routers.push('/ReceiverAddressListPage', context, {'select': 0});
          } else if (index == 1) {
            // 我的积分
            Routers.push(
              '/MyPointPage',
              context,
            );
          } else if (index == 2) {
            // 余额充值
            // Routers.push('/CommissionReportPage', context);
            Routers.push('/RechargePage', context);
          } else if (index == 3) {
            // 我的推广
            // Routers.push('/MyPromotionPage', context);
            // 会员中心
            Routers.push('/VipCenterPage', context);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: LoadImage(
                '',
                fit: BoxFit.contain,
                width: 30,
                height: 30,
                holderImg: listImg[index],
                format: "png",
              ),
            ),
            Caption(
              str: listDesTitle[index],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      );
    };
  }

  Widget buildCustomViews(BuildContext context) {
    //从状态管理中读取
    UserModel userModel = Provider.of<Model>(context, listen: false).userInfo!;

    var headerView = Container(
        padding: const EdgeInsets.only(left: 15, top: 50, right: 15),
        color: ColorConfig.warningText,
        constraints: const BoxConstraints.expand(
          height: 200.0,
        ),
        //设置背景图片
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                    onDoubleTap: () async {
                      // setURLType();
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                          width: 200,
                          child: Caption(
                            alignment: TextAlign.center,
                            str: userModel.name,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConfig.textDark,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          height: 20,
                          alignment: Alignment.bottomCenter,
                          //显示会员等级
                          child: Caption(
                            str: isloading
                                ? userVipModel?.profile.levelName == null ||
                                        userVipModel!.profile.levelName.isEmpty
                                    ? 'V0'
                                    : userVipModel!.profile.levelName
                                : '',
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
                        str: 'ID: ${userModel.id}',
                        fontSize: 17,
                        color: ColorConfig.textDark,
                      ),
                    ),
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
                    onTap: () {
                      // 我的余额
                      Routers.push('/RechargePage', context);
                    },
                    child: SizedBox(
                      height: 45,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Caption(
                            str: isloading && userOrderModel != null
                                ? (userOrderModel!.balance! / 100)
                                    .toStringAsFixed(2)
                                : '0.00',
                          ),
                          const Caption(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            str: '余额',
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // 合伙人
                      if (agentStatus?.id == 2) {
                        return;
                      }
                      if (agentStatus?.id == 3 || agentStatus?.id == 0) {
                        Routers.push('/RegisterAgentPage', context);
                      } else {
                        if (agentStatus?.id == 1) {
                          Routers.push('/WithdrawHistoryPage', context);
                        } else {
                          Routers.push('/RegisterAgentPage', context);
                        }
                      }
                    },
                    child: SizedBox(
                      height: 45,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Caption(
                            str: isloading && userOrderModel != null
                                ? userOrderModel!.commissionSum!
                                    .toStringAsFixed(2)
                                : '0.00',
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
                      onTap: () {
                        // 优惠券
                        Routers.push('/CouponPage', context,
                            {'select': false, 'lineid': '', 'amount': ''});
                      },
                      child: SizedBox(
                        height: 45,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Caption(
                              str: isloading && userOrderModel != null
                                  ? userOrderModel!.couponCount!.toString()
                                  : '0',
                            ),
                            const Caption(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              str: '优惠券',
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
    return headerView;
  }

  /*
  开始集运演示Cell
  */
  Widget buildExampleCell(BuildContext context) {
    return Container(
        height: 30 + ((ScreenUtil().screenWidth - 20) / 4).toDouble() + 10,
        color: ColorConfig.bgGray,
        child: Stack(
          children: <Widget>[
            Container(
              height: 50,
              color: ColorConfig.warningText,
            ),
            Positioned(
                top: 10,
                left: 0,
                right: 0,
                bottom: 10,
                child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      // border: new Border.all(width: 1, color: Colors.white),
                    ),
                    child: Column(
                      children: <Widget>[
                        buildMoreSupportType(context),
                      ],
                    )))
          ],
        ));
  }
}
