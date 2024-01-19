import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/home/home_page.dart';
import 'package:huanting_shop/views/shop/cart/cart_view.dart';
import 'package:huanting_shop/views/shop/platform_center/platform_shop_center_view.dart';
import 'package:huanting_shop/views/tabbar/tabbar_controller.dart';
import 'package:huanting_shop/views/transport/transport_center/transport_center_view.dart';
import 'package:huanting_shop/views/user/me/me_page.dart';

class BeeBottomNavPage extends GetView<BeeBottomNavLogic> {
  const BeeBottomNavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.scaffoldKey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageSelect,
          children: const <Widget>[
            IndexPage(),
            TransportCenterView(),
            PlatformShopCenterView(),
            CartView(),
            BeeCenterPage(),
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
                    'assets/images/TabbarIcon/1.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '首页'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/1-1.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/2.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '集运'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/2-1.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/3.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '商城'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/3-1.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/images/TabbarIcon/4.png',
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
                          'assets/images/TabbarIcon/4-1.png',
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
                    'assets/images/TabbarIcon/5.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '我的'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/5-1.png',
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
