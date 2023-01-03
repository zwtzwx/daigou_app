import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/events/profile_updated_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
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

  bool isloading = false;

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
        appBar: const EmptyAppBar(),
        primary: false,
        body: RefreshIndicator(
            onRefresh: created,
            color: ColorConfig.textRed,
            child: Container(
              color: ColorConfig.bgGray,
              child: ListView.builder(
                itemBuilder: buildCellForFirstListView,
                controller: _scrollController,
                itemCount: 3,
              ),
            )));
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    List<Map> list1 = [
      {
        'name': '个人信息',
        'icon': 'AboutMe/info-icon',
        'route': '/MyProfilePage',
      },
      {
        'name': '更改手机号',
        'icon': 'AboutMe/phone-icon',
        'route': '/ChangeMobileEmailPage',
        'params': {'type': 1},
      },
      {
        'name': '更改邮箱',
        'icon': 'AboutMe/emai-icon',
        'route': '/ChangeMobileEmailPage',
        'params': {'type': 2},
      },
      {
        'name': '收货地址',
        'icon': 'AboutMe/adress-icon',
        'route': '/ReceiverAddressListPage',
        'params': {'select': 0},
      },
      {
        'name': '交易记录',
        'icon': 'AboutMe/pay-record-icon',
        'route': '/TransactionPage',
      },
    ];
    List<Map> list2 = [
      {
        'name': '修改密码',
        'icon': 'AboutMe/password',
        'route': '/ChangePasswordPage',
      },
      {
        'name': '关于我们',
        'icon': 'AboutMe/about-me-icon',
        'route': '/AboutMePage',
      },
      {
        'name': '退出登录',
        'icon': 'AboutMe/logout-icon',
      },
    ];
    if (index == 1) {
      return buildListView(context, list1);
    } else if (index == 2) {
      return buildListView(context, list2);
    }
    return buildCustomViews(context);
  }

  Widget buildListView(BuildContext context, List<Map> list) {
    var listView = Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildBottomListCell(context, list[index]),
            ),
          ),
        ],
      ),
    );
    return listView;
  }

  Widget buildBottomListCell(BuildContext context, Map item) {
    return GestureDetector(
      onTap: () async {
        if (item['route'] != null) {
          Routers.push(item['route'], context, item['params']);
        } else {
          onLogout();
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            LoadImage(
              item['icon'],
              width: 24,
              height: 24,
            ),
            Gaps.hGap10,
            ZHTextLine(
              str: Translation.t(context, item['name']),
              lines: 2,
              alignment: TextAlign.center,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: ColorConfig.textGray,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /* 注销登录 */
  void onLogout() async {
    var res = await BaseDialog.cupertinoConfirmDialog(
        context, Translation.t(context, '确认退出登录吗') + '？');
    if (res == true) {
      await UserStorage.clearToken();
      //清除TOKEN
      Provider.of<Model>(context, listen: false).loginOut();
      ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent());
      ApplicationEvent.getInstance()
          .event
          .fire(ChangePageIndexEvent(pageName: 'home'));
    }
  }

  Widget buildCustomViews(BuildContext context) {
    //从状态管理中读取
    UserModel? userModel = Provider.of<Model>(context, listen: true).userInfo;
    var headerView = Stack(
      children: [
        const LoadImage(
          'Home/bg',
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          left: 20,
          top: ScreenUtil().statusBarHeight + 40,
          child: Row(
            children: [
              ClipOval(
                child: LoadImage(
                  userModel?.avatar ?? '',
                  fit: BoxFit.fitWidth,
                  holderImg: "AboutMe/u",
                  format: "png",
                  width: 80,
                  height: 80,
                ),
              ),
              Gaps.hGap16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ZHTextLine(
                    str: userModel?.name ?? '',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  Gaps.vGap5,
                  ZHTextLine(
                    alignment: TextAlign.center,
                    str: 'ID: ${userModel?.id ?? ''}',
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        (userVipModel?.pointStatus == 1 || userVipModel?.growthValueStatus == 1)
            ? Positioned(
                left: 30,
                right: 30,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFf3e4bb), Color(0xFFd1bb7f)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
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
                                      ZHTextLine(
                                        str: Translation.t(context, '等级'),
                                        color: ColorConfig.vipNormal,
                                      ),
                                      Gaps.hGap15,
                                      ZHTextLine(
                                        str: userVipModel?.profile.levelName ??
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
                                      ZHTextLine(
                                        str: Translation.t(context, '积分'),
                                        color: ColorConfig.vipNormal,
                                      ),
                                      Gaps.hGap15,
                                      ZHTextLine(
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
                ))
            : Gaps.empty,
      ],
    );
    return headerView;
  }
}
