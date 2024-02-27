import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/empty_app_bar.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/user/me/me_controller.dart';

/*
  我的
*/

class BeeCenterPage extends GetView<BeeCenterLogic> {
  const BeeCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const EmptyAppBar(),
      primary: false,
      backgroundColor: AppColors.bgGray,
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        color: AppColors.textRed,
        child: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: LoadAssetImage('Center/bg', fit: BoxFit.fitWidth),
                  ),
                  userInfo(),
                ],
              ),
              10.verticalSpaceFromWidth,
              toolList(),
              30.verticalSpaceFromWidth,
            ],
          ),
        ),
      ),
    );
  }

  Widget toolList() {
    List<Map<String, dynamic>> list1 = [
      {
        'name': '地址簿',
        'icon': 'Center/ico_dzb',
        'route': BeeNav.addressList,
        'params': {'select': 0},
      },
      {
        'name': '推广联盟',
        'icon': 'Center/ico_tglm',
        'route': BeeNav.agentApplyInstruct,
      },
      {
        'name': '余额',
        'icon': 'Center/ico_ye',
        'route': BeeNav.recharge,
      },
      {
        'name': '我的积分',
        'icon': 'Center/ico_jf',
        'route': BeeNav.vip,
      },
      {
        'name': '我的评论',
        'icon': 'Center/ico_pl',
        'route': BeeNav.comment,
      },
      {
        'name': '我的咨询',
        'icon': 'Center/ico_zx',
        'route': BeeNav.shopOrderChat,
      },
      {
        'name': '帮助中心',
        'icon': 'Center/ico_bzzx',
        'route': BeeNav.help,
      },
      {
        'name': '账号安全',
        'icon': 'Center/ico_zhaq',
        'route': BeeNav.profile,
      },
      {
        'name': '退出登录',
        'icon': 'Center/ico_tc',
      },
    ];
    return buildListView(
      list1,
      iconWidth: 30.w,
    );
  }

  Widget buildListView(
    List<Map<String, dynamic>> list, {
    int? crossAxisCount,
    double? childAspectRatio,
    double? iconWidth,
  }) {
    var listView = Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  if (list[index]['route'] == BeeNav.agentApplyInstruct) {
                    if (controller.agentStatus.value?.id == 2) return;
                    if (controller.agentStatus.value?.id == 1) {
                      BeeNav.push(BeeNav.agentCenter);
                    } else {
                      BeeNav.push(list[index]['route']);
                    }
                  } else if (list[index]['route'] != null) {
                    BeeNav.push(list[index]['route'],
                        arg: list[index]['params']);
                  } else {
                    var res = await BaseDialog.cupertinoConfirmDialog(
                        context, '确认退出登录吗'.ts + '？');
                    if (res == true) {
                      controller.onLogout();
                    }
                  }
                },
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 20.h),
                  child: Row(
                    children: [
                      ImgItem(
                        list[index]['icon'],
                        width: 18.w,
                        height: 18.w,
                      ),
                      14.horizontalSpace,
                      Expanded(
                        child: Obx(
                          () => AppText(
                            str: (list[index]['name']! as String).ts,
                            fontSize: 14,
                            color: AppColors.textNormal,
                            lines: 2,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      if (list[index]['route'] != null)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: AppColors.textNormal,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    return listView;
  }

  Widget userInfo() {
    var headerView = Obx(() {
      UserModel? userModel = controller.userInfoModel.userInfo.value;
      List<Map<String, String>> list = [
        {
          'label': '问题订单',
          'icon': 'Center/ico_wtdd',
          'route': BeeNav.probleShopOrder,
        },
        {
          'label': '购物车',
          'icon': 'Center/ico_gwc',
          'route': BeeNav.cart,
        },
        {
          'label': '异常件认领',
          'icon': 'Center/ico_ycjrl',
          'route': BeeNav.noOwnerList,
        },
      ];
      List<Map<String, String>> list2 = [
        {
          'label': '我的订单',
          'icon': 'Center/ico_wddd',
          'route': BeeNav.shopOrderList,
        },
        {
          'label': '我的仓库',
          'icon': 'Center/ico_wdck',
          'route': BeeNav.warehouse,
        },
        {
          'label': '运费试算',
          'icon': 'Center/ico_yfss',
          'route': BeeNav.lineQuery,
        },
        {
          'label': '我的包裹',
          'icon': 'Center/ico_wdbg',
          'route': BeeNav.orderCenter,
        },
      ];

      return Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                18.w, ScreenUtil().statusBarHeight + 30.h, 28.w, 20.h),
            child: Row(
              children: [
                SizedBox(
                  width: 70.w,
                  height: 70.w,
                  child: ClipOval(
                    child: ImgItem(
                      userModel?.avatar ?? '',
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              str: userModel?.name ?? '',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      AppText(
                        alignment: TextAlign.center,
                        str: 'ID: ${userModel?.id ?? ''}',
                        fontSize: 12,
                        color: const Color(0xFF888888),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: list
                  .map(
                    (e) => Flexible(
                      child: GestureDetector(
                        onTap: () {
                          BeeNav.push(e['route']!);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              if (e['route'] == BeeNav.cart)
                                Obx(() {
                                  var cartCount =
                                      Get.find<AppStore>().cartCount.value;
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      LoadAssetImage(
                                        e['icon']!,
                                        width: 40.w,
                                        height: 40.w,
                                      ),
                                      if (cartCount != 0)
                                        Positioned(
                                          right: -5.w,
                                          top: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.themeRed,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 2.w),
                                            child: AppText(
                                              str: cartCount.toString(),
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                })
                              else
                                LoadAssetImage(
                                  e['icon']!,
                                  width: 40.w,
                                  height: 40.w,
                                ),
                              4.verticalSpace,
                              AppText(
                                str: e['label']!.ts,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          10.verticalSpaceFromWidth,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: list2
                  .map(
                    (e) => Flexible(
                      child: GestureDetector(
                        onTap: () {
                          BeeNav.push(e['route']!);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              LoadAssetImage(
                                e['icon']!,
                                width: 34.w,
                                height: 34.w,
                              ),
                              4.verticalSpace,
                              AppText(
                                str: e['label']!.ts,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
    });
    return headerView;
  }
}
