import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
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
import 'package:fluwx/fluwx.dart' as fluwx;
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
  UserAgentStatusModel? agentStatus;

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
              color: ColorConfig.bgGray,
              child: ListView.builder(
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
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Caption(
              str: '工具与服务',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: GridView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: buildBottomListCell,
            ),
          ),
        ],
      ),
    );
    return listView;
  }

  Widget buildBottomListCell(BuildContext context, int index) {
    List<String> titleList = [
      '运费试算',
      '我的客服',
      '地址簿',
      '个人资料',
      '更改手机号',
      '更改邮箱',
      '交易记录',
      agentStatus?.name ?? '申请代理',
      '关于我们',
      '退出登录',
    ];
    List<String> iconList = [
      'AboutMe/freight',
      'AboutMe/kefu',
      'AboutMe/adress-icon',
      'AboutMe/info-icon',
      'AboutMe/phone-icon',
      'AboutMe/emai-icon',
      'AboutMe/pay-record-icon',
      'AboutMe/proxy-icon',
      'AboutMe/about-me-icon',
      'AboutMe/logout-icon',
    ];
    return GestureDetector(
      onTap: () async {
        if (index == 0) {
          Routers.push('/LineQueryPage', context);
        } else if (index == 1) {
          // 客服
          fluwx.isWeChatInstalled.then((installed) {
            if (installed) {
              fluwx
                  .openWeChatCustomerServiceChat(
                      url:
                          'https://work.weixin.qq.com/kfid/kfcd1850645a45f5db4',
                      corpId: 'ww82affb1cf55e55e0')
                  .then((data) {});
            } else {
              Util.showToast("请先安装微信");
            }
          });
        } else if (index == 2) {
          // 收件地址
          Routers.push('/ReceiverAddressListPage', context, {'select': 0});
        } else if (index == 3) {
          // 个人资料
          Routers.push('/MyProfilePage', context);
        } else if (index == 4) {
          // 更改手机号
          Routers.push('/ChangeMobileEmailPage', context, {'type': 1});
        } else if (index == 5) {
          // 更改邮箱
          Routers.push('/ChangeMobileEmailPage', context, {'type': 2});
        } else if (index == 6) {
          // 交易记录
          Routers.push('/TransactionPage', context);
        } else if (index == 7) {
          // 代理
          if (agentStatus?.id == 2) {
            return;
          }
          if (agentStatus?.id == 3 || agentStatus?.id == 4) {
            Routers.push('/RegisterAgentPage', context);
          } else {
            Routers.push('/AgentMemberPage', context);
          }
        } else if (index == 8) {
          // 关于我们
          Routers.push('/AboutMePage', context);
        } else if (index == 9) {
          // 退出登录
          showActionSheet(context);
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            LoadImage(
              iconList[index],
              width: 24,
              height: 24,
            ),
            Gaps.vGap10,
            Caption(
              str: titleList[index],
            )
          ],
        ),
      ),
    );
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

  Widget buildCustomViews(BuildContext context) {
    //从状态管理中读取
    UserModel userModel = Provider.of<Model>(context, listen: false).userInfo!;

    var headerView = Container(
        padding: const EdgeInsets.only(left: 15, top: 50, right: 15),
        color: ColorConfig.bgGray,
        //设置背景图片
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: ColorConfig.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  height: 60,
                  width: 60,
                  margin: const EdgeInsets.only(left: 10),
                  child: ClipOval(
                    child: LoadImage(
                      userModel.avatar,
                      fit: BoxFit.fitWidth,
                      holderImg: "AboutMe/about-logo",
                      format: "png",
                    ),
                  ),
                ),
                Gaps.hGap16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          child: Caption(
                            alignment: TextAlign.center,
                            str: userModel.name,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConfig.textDark,
                          ),
                        ),
                        Gaps.hGap5,
                        [1, 4].contains(agentStatus?.id)
                            ? LoadImage(
                                agentStatus?.id == 1
                                    ? 'AboutMe/agent'
                                    : 'AboutMe/agent-disabled',
                                width: 20,
                                height: 20,
                              )
                            : Gaps.empty,
                      ],
                    ),
                    Gaps.vGap5,
                    SizedBox(
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
            Gaps.vGap20,
            (userVipModel?.pointStatus == 1 ||
                    userVipModel?.growthValueStatus == 1)
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFf3e4bb), Color(0xFFd1bb7f)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        userVipModel?.pointStatus == 1
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Routers.push('/VipCenterPage', context);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        const LoadImage(
                                          'AboutMe/V',
                                          width: 28,
                                          height: 28,
                                        ),
                                        Gaps.hGap15,
                                        const Caption(
                                          str: '等级',
                                          color: ColorConfig.vipNormal,
                                        ),
                                        Gaps.hGap15,
                                        Caption(
                                          str:
                                              userVipModel?.profile.levelName ??
                                                  '',
                                          fontWeight: FontWeight.bold,
                                          color: ColorConfig.vipNormal,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Gaps.empty,
                        userVipModel?.growthValueStatus == 1
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Routers.push('/MyPointPage', context);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                  color: HexToColor('#f3e4ba')),
                                            ),
                                          ),
                                        ),
                                        const LoadImage(
                                          'AboutMe/jf',
                                          width: 28,
                                          height: 28,
                                        ),
                                        Gaps.hGap15,
                                        const Caption(
                                          str: '积分',
                                          color: ColorConfig.vipNormal,
                                        ),
                                        Gaps.hGap15,
                                        Caption(
                                          str:
                                              '${userVipModel?.profile.point ?? ''}',
                                          fontWeight: FontWeight.bold,
                                          color: ColorConfig.vipNormal,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Gaps.empty,
                      ],
                    ),
                  )
                : Gaps.empty,
          ],
        ));
    return headerView;
  }

  /*
  开始集运演示Cell
  */
  Widget buildExampleCell(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Caption(
              str: '我的钱包',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Caption(
                          str: isloading && userOrderModel != null
                              ? (userOrderModel!.balance! / 100)
                                  .toStringAsFixed(2)
                              : '0.00',
                          fontSize: 22,
                        ),
                        Gaps.vGap15,
                        const Caption(
                          fontSize: 14,
                          str: '我的余额',
                        ),
                      ],
                    ),
                  ),
                ),
                agentStatus?.id == 1
                    ? GestureDetector(
                        onTap: () {
                          Routers.push('/WithdrawHistoryPage', context);
                        },
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                str: isloading && userOrderModel != null
                                    ? userOrderModel!.commissionSum!
                                        .toStringAsFixed(2)
                                    : '0.00',
                                fontSize: 22,
                              ),
                              Gaps.vGap15,
                              const Caption(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                str: '佣金收入',
                              ),
                            ],
                          ),
                        ),
                      )
                    : Gaps.empty,
                GestureDetector(
                    onTap: () {
                      // 优惠券
                      Routers.push('/CouponPage', context,
                          {'select': false, 'lineid': '', 'amount': ''});
                    },
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Caption(
                            str: isloading && userOrderModel != null
                                ? userOrderModel!.couponCount!.toString()
                                : '0',
                            fontSize: 22,
                          ),
                          Gaps.vGap15,
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
          ),
        ],
      ),
    );
  }
}
