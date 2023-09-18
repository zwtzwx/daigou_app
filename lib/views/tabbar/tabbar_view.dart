import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/home/home_page.dart';
import 'package:jiyun_app_client/views/shop/cart/cart_view.dart';
import 'package:jiyun_app_client/views/shop/platform_center/platform_shop_center_view.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_controller.dart';
import 'package:jiyun_app_client/views/transport/transport_center/transport_center_view.dart';
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
            TransportCenterView(),
            PlatformShopCenterView(),
            CartView(),
            MeView(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Obx(
            () => BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: controller.onTap,
              selectedItemColor: AppColors.textDark,
              unselectedItemColor: AppColors.textGrayC9,
              currentIndex: controller.selectIndex.value,
              backgroundColor: Colors.white,
              selectedFontSize: 12,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/home-uns.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '首页'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/home.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/transport-uns.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '集运'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/transport.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/shop-uns.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '商城'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/shop.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/images/TabbarIcon/cart-uns.png',
                          width: 26.w,
                          height: 26.w,
                        ),
                        Obx(() => controller.cartCount.value != 0
                            ? Positioned(
                                top: -4.w,
                                right: -4.w,
                                child: ClipOval(
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: AppColors.textRed,
                                    height: ScreenUtil().setWidth(15),
                                    width: ScreenUtil().setWidth(15),
                                    child: AppText(
                                      alignment: TextAlign.center,
                                      str: '${controller.cartCount.value}',
                                      fontSize: controller.cartCount.value > 9
                                          ? 14
                                          : 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : AppGaps.empty),
                      ],
                    ),
                    label: '购物车'.ts,
                    activeIcon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/images/TabbarIcon/cart.png',
                          width: 26.w,
                          height: 26.w,
                        ),
                        Obx(() => controller.cartCount.value != 0
                            ? Positioned(
                                top: -4.w,
                                right: -4.w,
                                child: ClipOval(
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: AppColors.textRed,
                                    height: ScreenUtil().setWidth(15),
                                    width: ScreenUtil().setWidth(15),
                                    child: AppText(
                                      alignment: TextAlign.center,
                                      str: '${controller.cartCount.value}',
                                      fontSize: controller.cartCount.value > 9
                                          ? 14
                                          : 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : AppGaps.empty),
                      ],
                    )),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/center-uns.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '我的'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/center.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
