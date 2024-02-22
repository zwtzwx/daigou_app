import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/home/home_page.dart';
import 'package:huanting_shop/views/tabbar/tabbar_controller.dart';
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
          BeeCenterPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1.h),
              color: const Color(0x171D4E96),
              blurRadius: 20.r,
            ),
          ],
        ),
        child: SafeArea(
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
                    'assets/images/TabbarIcon/home_nor.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '首页'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/home_sel.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/TabbarIcon/my_nor.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                  label: '个人中心'.ts,
                  activeIcon: Image.asset(
                    'assets/images/TabbarIcon/my_sel.png',
                    width: 26.w,
                    height: 26.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
