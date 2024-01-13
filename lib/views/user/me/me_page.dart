import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/user_order_count_model.dart';
import 'package:jiyun_app_client/models/user_vip_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/user/me/me_controller.dart';

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
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.created,
        color: AppColors.textRed,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            userInfo(),
            10.verticalSpaceFromWidth,
            toolList(),
            30.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  Widget toolList() {
    // if (controller.agentStatus.value?.id == 1) {
    //   amountList.add({
    //     'name': '佣金收入',
    //     'icon': 'AboutMe/center-yj',
    //     'route': BeeNav.agentCommission,
    //   });
    // }

    List<Map<String, dynamic>> list1 = [
      {
        'name': '个人信息',
        'icon': 'Center/ico_grxx',
        'route': BeeNav.profile,
      },
      {
        'name': '地址簿',
        'icon': 'Center/ico_dzb',
        'route': BeeNav.addressList,
        'params': {'select': 0},
      },
      {
        'name': '更改手机号',
        'icon': 'Center/ico_ggsjh',
        'route': BeeNav.changeMobileAndEmail,
        'params': {'type': 1},
      },
      {
        'name': '更改邮箱',
        'icon': 'Center/ico_ggyx',
        'route': BeeNav.changeMobileAndEmail,
        'params': {'type': 2},
      },
      {
        'name': '一键预报',
        'icon': 'Center/ico_yjyb',
        'route': BeeNav.chromeLogin,
      },
      {
        'name': '交易记录',
        'icon': 'Center/ico_jyjl',
        'route': BeeNav.transaction,
      },

      {
        'name': '我的咨询',
        'icon': 'Center/ico_wdzx',
        'route': BeeNav.shopOrderChat,
      },
      {
        'name': '代理',
        'icon': 'Center/ico_dl',
        'route': BeeNav.agentApply,
      },

      {
        'name': '关于我们',
        'icon': 'Center/ico_gywm',
        'route': BeeNav.abountMe,
      },
      // {
      //   'name': '修改密码',
      //   'icon': 'Center/password',
      //   'route': BeeNav.password,
      // },
      {
        'name': '退出登录',
        'icon': 'Center/ico_tcdl',
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
      margin: EdgeInsets.symmetric(horizontal: 30.w),
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
                  if (list[index]['route'] == BeeNav.agentApply) {
                    if (controller.agentStatus.value?.id == 1) {
                      // 代理
                      BeeNav.push(BeeNav.agentMember);
                    } else {
                      BeeNav.push(list[index]['route'], list[index]['params']);
                    }
                  } else if (list[index]['route'] != null) {
                    BeeNav.push(list[index]['route'], list[index]['params']);
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
                        width: 22.w,
                        height: 22.w,
                      ),
                      14.horizontalSpace,
                      Expanded(
                        child: Obx(
                          () => AppText(
                            str: (list[index]['name']! as String).ts,
                            fontSize: 12,
                            color: AppColors.textNormal,
                            lines: 2,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
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
    var headerView = Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Container(
            height: 190.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE067),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
          ),
        ),
        Obx(() {
          UserModel? userModel = controller.userInfoModel.userInfo.value;
          UserOrderCountModel? amount = Get.find<AppStore>().amountInfo.value;
          UserVipModel? vipModel = Get.find<AppStore>().vipInfo.value;
          List<Map<String, String>> list = [
            {
              'label': '余额',
              'value': (amount?.balance ?? 0).rate(showPriceSymbol: false),
              'route': BeeNav.recharge,
            },
            {
              'label': '优惠券',
              'value': (amount?.couponCount ?? 0).toString(),
              'route': BeeNav.coupon,
            },
          ];
          if (vipModel?.pointStatus == 1) {
            list.add({
              'label': '积分',
              'value': (vipModel?.profile.point ?? 0).toString(),
              'route': BeeNav.vip,
            });
          }
          return Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    18.w, ScreenUtil().statusBarHeight + 30.h, 28.w, 20.h),
                child: Row(
                  children: [
                    ClipOval(
                      child: ImgItem(
                        userModel?.avatar ?? '',
                        fit: BoxFit.fitWidth,
                        width: 70.w,
                        height: 70.w,
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
                              // 5.horizontalSpace,
                              // GestureDetector(
                              //   onTap: () {
                              //     BeeNav.push(BeeNav.notice);
                              //   },
                              //   child: Stack(
                              //     alignment: Alignment.topRight,
                              //     children: [
                              //       ImgItem(
                              //         'Home/bell',
                              //         width: 28.w,
                              //         height: 28.w,
                              //       ),
                              //       Obx(() => controller.noticeUnRead.value
                              //           ? ClipOval(
                              //               child: Container(
                              //                 width: 6.w,
                              //                 height: 6.w,
                              //                 color: AppColors.textRed,
                              //               ),
                              //             )
                              //           : AppGaps.empty)
                              // ],
                              // ),
                              // ),
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
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10.w),
                      color: const Color(0x0D000000),
                      blurRadius: 40.r,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
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
                                AppText(
                                  str: e['value']!,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                4.verticalSpace,
                                AppText(
                                  str: e['label']!.ts,
                                  fontSize: 14,
                                  color: const Color(0xFF888888),
                                ),
                              ],
                            ),
                          ),
                        )),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        }),
      ],
    );
    return headerView;
  }
}
