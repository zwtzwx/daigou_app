import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/home/home_page.dart';
import 'package:jiyun_app_client/views/notice/notice_page.dart';
import 'package:jiyun_app_client/views/order/center/order_center_page.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_controller.dart';
import 'package:jiyun_app_client/views/user/me/me_page.dart';

class TabbarView extends GetView<TabbarController> {
  const TabbarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.scaffoldKey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageSelect,
          children: const <Widget>[
            HomeView(),
            NoticePage(),
            OrderCenterView(),
            MeView(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Obx(
            () => BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: controller.onTap,
              selectedItemColor: BaseStylesConfig.primary,
              unselectedItemColor: BaseStylesConfig.textDark,
              currentIndex: controller.selectIndex.value,
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/home-uns.png',
                    width: 26,
                    height: 26,
                  ),
                  label: '首页'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/home.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        'assets/images/TabbarIcon/notice-uns.png',
                        width: 26,
                        height: 26,
                      ),
                      controller.noticeUnRead.value
                          ? Positioned(
                              right: 4,
                              child: ClipOval(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  color: BaseStylesConfig.textRed,
                                ),
                              ),
                            )
                          : Sized.empty,
                    ],
                  ),
                  label: '消息'.ts,
                  activeIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        'assets/images/TabbarIcon/notice.png',
                        width: 26,
                        height: 26,
                      ),
                      controller.noticeUnRead.value
                          ? Positioned(
                              right: 4,
                              child: ClipOval(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  color: BaseStylesConfig.textRed,
                                ),
                              ),
                            )
                          : Sized.empty,
                    ],
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/order-uns.png',
                    width: 26,
                    height: 26,
                  ),
                  label: '我的包裹'.ts,
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
                  label: '我的'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/center.png',
                    width: 26,
                    height: 26,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
