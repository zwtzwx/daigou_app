import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/firebase/notification.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/express/express_query_page.dart';
import 'package:jiyun_app_client/views/order/order_center_page.dart';
import 'package:jiyun_app_client/views/user/me_page.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:provider/provider.dart';
import 'home/home_page.dart';

Color bgcolor = Color(int.parse("0xff151823"));

/*
 首页TAB BAR选项
 */
class MainController extends StatefulWidget {
  const MainController({Key? key}) : super(key: key);

  @override
  TabBarState createState() => TabBarState();
}

class TabBarState extends State<MainController> {
  final _pageController = PageController(initialPage: 0);
  var _selectIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //选择每一页
  void _onPageSelect(int indexSelect) {
    setState(() {
      _selectIndex = indexSelect;
    });
  }

  Widget _buildPageView() {
    return Scaffold(
        // drawer: new Drawer(
        //   child: new HomePageInfo(),
        // ),
        key: _scaffoldKey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageSelect,
          children: const <Widget>[
            //在这里定义TAB栏目对应的页
            HomePage(),
            ExpressQueryPage(),
            OrderCenterPage(),
            MePage()
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: onTap,
              selectedItemColor: ColorConfig.primary,
              unselectedItemColor: ColorConfig.textDark,
              currentIndex: _selectIndex,
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/home-uns.png',
                    width: 26,
                    height: 26,
                  ),
                  label: Translation.t(context, '首页', listen: true),
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/home.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/TabbarIcon/wuliu-uns.png',
                      width: 26,
                      height: 26,
                    ),
                    label: Translation.t(context, '快递跟踪', listen: true),
                    activeIcon: Image.asset(
                      'assets/images/TabbarIcon/wuliu.png',
                      width: 26,
                      height: 26,
                    )),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/order-uns.png',
                    width: 26,
                    height: 26,
                  ),
                  label: Translation.t(context, '我的包裹', listen: true),
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/order.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/TabbarIcon/center-uns.png',
                      width: 26,
                      height: 26,
                    ),
                    label: Translation.t(context, '我的', listen: true),
                    activeIcon: Image.asset(
                      'assets/images/TabbarIcon/center.png',
                      width: 26,
                      height: 26,
                    )),
              ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageView();
  }

  @override
  void initState() {
    super.initState();
    // 初始化 notification
    Notifications.initialized(context);
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      Util.showToast(Translation.t(context, '登录凭证已失效'));
      pushToLogin();
    });

    ApplicationEvent.getInstance()
        .event
        .on<ChangePageIndexEvent>()
        .listen((event) {
      int index = jumpToIndex(event.pageName);
      _onPageSelect(index);
      _pageController.jumpToPage(index);
    });
  }

  pushToLogin() async {
    var token = await UserStorage.getToken();
    if (token != '') {
      await UserStorage.clearToken();
      Provider.of<Model>(context, listen: false).setToken('');
    }
    // Routers.push('/LoginPage', context);
    jumpToIndex('home');
  }

  int jumpToIndex(String pageName) {
    int index = 0;
    switch (pageName) {
      case 'home':
        index = 0;
        break;
      case 'express':
        index = 1;
        break;
      case 'orders':
        index = 2;
        break;
    }

    return index;
  }

  void onTap(int index) async {
    //Token存在Model状态管理器中的
    if (Provider.of<Model>(context, listen: false).token.isEmpty &&
        index != 1 &&
        index != 0) {
      Routers.push('/LoginPage', context);
      return;
    }
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
