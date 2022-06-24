import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/home/warehouse_page.dart';
import 'package:jiyun_app_client/views/order/order_center_page.dart';
import 'package:jiyun_app_client/views/parcel/forecast_parcel_page.dart';
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
            OrderCenterPage(),
            ForcastParcelPage(),
            WareHouseAddress(),
            MePage()
          ],
        ),
        floatingActionButton: GestureDetector(
            onTap: () {
              //如果没有登录成功
              if (Provider.of<Model>(context, listen: false).token.isEmpty) {
                Routers.push('/LoginPage', context);
                return;
              }
              _pageController.jumpToPage(2);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              height: 60,
              width: 60,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(40.0),
              //   border: Border.all(width: 8, color: ColorConfig.white),
              //   // boxShadow: [
              //   //   BoxShadow(
              //   //       color: Colors.black12,
              //   //       offset: Offset(0.0, 15.0), //阴影xy轴偏移量
              //   //       blurRadius: 15.0, //阴影模糊程度
              //   //       spreadRadius: 1.0 //阴影扩散程度
              //   //       )
              //   // ]
              // ),
              child: Image.asset(
                'assets/images/TabbarIcon/yb.png',
              ),
              // FloatingActionButton(
              //   onPressed: () {

              //   child: Image.asset(
              //     'assets/images/TabbarIcon/logo@3x.png',
              //   ),
              // ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: onTap,
              selectedItemColor: ColorConfig.textBlack,
              unselectedItemColor: Colors.grey,
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
                    'assets/images/TabbarIcon/home-s.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/TabbarIcon/box-uns.png',
                      width: 26,
                      height: 26,
                    ),
                    label: Translation.t(context, '包裹', listen: true),
                    activeIcon: Image.asset(
                      'assets/images/TabbarIcon/box-s.png',
                      width: 26,
                      height: 26,
                    )),
                BottomNavigationBarItem(
                  icon: const SizedBox(
                    width: 26,
                    height: 26,
                  ),
                  label: Translation.t(context, '包裹预报', listen: true),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/ck-uns.png',
                    width: 26,
                    height: 26,
                  ),
                  label: Translation.t(context, '仓库', listen: true),
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/ck-s.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/TabbarIcon/me-uns.png',
                      width: 26,
                      height: 26,
                    ),
                    label: Translation.t(context, '我的', listen: true),
                    activeIcon: Image.asset(
                      'assets/images/TabbarIcon/me-s.png',
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

    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
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
      Routers.push('/LoginPage', context);
    }
  }

  int jumpToIndex(String pageName) {
    int index = 0;
    switch (pageName) {
      case 'home':
        index = 0;
        break;
      case 'middle':
        index = 2;
        break;
      case 'warehouse':
        index = 3;
        break;
    }

    return index;
  }

  void onTap(int index) async {
    //Token存在Model状态管理器中的
    if (Provider.of<Model>(context, listen: false).token.isEmpty &&
        index != 0 &&
        index != 3) {
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
