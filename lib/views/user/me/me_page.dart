import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
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
      backgroundColor: AppColors.bgGray,
      appBar: const EmptyAppBar(),
      primary: false,
      body: RefreshIndicator(
        onRefresh: controller.created,
        color: AppColors.textRed,
        child: ListView.builder(
          itemBuilder: (context, index) =>
              Obx(() => buildCellForFirstListView(context, index)),
          controller: controller.scrollController,
          itemCount: 5,
        ),
      ),
    );
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    List<Map<String, dynamic>> amountList = [
      {
        'name': '我的余额',
        'icon': 'AboutMe/center-yue',
        'route': BeeNav.recharge,
      },
      {
        'name': '优惠券',
        'icon': 'AboutMe/center-coupon',
        'route': BeeNav.coupon,
      },
    ];
    if (controller.agentStatus.value?.id == 1) {
      amountList.add({
        'name': '佣金收入',
        'icon': 'AboutMe/center-yj',
        'route': BeeNav.agentCommission,
      });
    }
    if (controller.userVipModel.value?.pointStatus == 1) {
      amountList.add({
        'name': '我的积分',
        'icon': 'AboutMe/center-point',
        'route': BeeNav.point,
      });
    }
    List<Map<String, dynamic>> orderList = [
      {
        'name': '代购/商城订单',
        'icon': 'AboutMe/order',
        'route': BeeNav.shopOrderList,
      },
      {
        'name': '代购问题商品',
        'icon': 'AboutMe/wtsp',
        'route': BeeNav.probleShopOrder,
      },
      {
        'name': '集运/转运包裹',
        'icon': 'AboutMe/parcel',
        'route': BeeNav.orderCenter,
      },
    ];
    List<Map<String, dynamic>> list1 = [
      {
        'name': '地址簿',
        'icon': 'AboutMe/address-icon',
        'route': BeeNav.addressList,
        'params': {'select': 0},
      },
      {
        'name': '个人资料',
        'icon': 'AboutMe/info-icon',
        'route': BeeNav.profile,
      },
      {
        'name': '交易记录',
        'icon': 'AboutMe/pay-record-icon',
        'route': BeeNav.transaction,
      },
      {
        'name': '一键预报',
        'icon': 'AboutMe/chorme',
        'route': BeeNav.chromeLogin,
      },
      // {
      //   'name': '取件列表',
      //   'icon': 'AboutMe/smqj',
      //   'route': BeeNav.transaction,
      // },
      {
        'name': '我的咨询',
        'icon': 'AboutMe/kefu',
        'route': BeeNav.shopOrderChat,
      },
      {
        'name': '代理',
        'icon': 'AboutMe/proxy-icon',
        'route': BeeNav.agentApply,
      },
      {
        'name': '更改手机号',
        'icon': 'AboutMe/phone-icon',
        'route': BeeNav.changeMobileAndEmail,
        'params': {'type': 1},
      },
      {
        'name': '更改邮箱',
        'icon': 'AboutMe/emai-icon',
        'route': BeeNav.changeMobileAndEmail,
        'params': {'type': 2},
      },
      {
        'name': '关于我们',
        'icon': 'AboutMe/about-me-icon',
        'route': BeeNav.abountMe,
      },
      {
        'name': '修改密码',
        'icon': 'AboutMe/password',
        'route': BeeNav.password,
      },
      {
        'name': '退出登录',
        'icon': 'AboutMe/logout-icon',
      },
    ];
    if (index == 1) {
      return buildListView(
        '我的资产',
        amountList,
      );
    } else if (index == 2) {
      return buildListView(
        '我的订单',
        orderList,
        crossAxisCount: 3,
        childAspectRatio: 6 / 5,
        iconWidth: 30.w,
      );
    } else if (index == 3) {
      return buildListView(
        '我的功能',
        list1,
        iconWidth: 30.w,
      );
    } else if (index == 4) {
      return 20.verticalSpaceFromWidth;
    }
    return buildCustomViews(context);
  }

  Widget buildListView(
    String title,
    List<Map<String, dynamic>> list, {
    int? crossAxisCount,
    double? childAspectRatio,
    double? iconWidth,
  }) {
    var listView = Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 9.h),
            child: Obx(
              () => AppText(
                str: title.ts,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount ?? 4,
              crossAxisSpacing: 15.w,
              childAspectRatio: childAspectRatio ?? 5 / 6,
            ),
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
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      ImgItem(
                        list[index]['icon'],
                        width: iconWidth ?? 38.w,
                        height: iconWidth ?? 38.w,
                      ),
                      2.verticalSpace,
                      Obx(
                        () => AppText(
                          str: (list[index]['name']! as String).ts,
                          fontSize: 12,
                          color: AppColors.textNormal,
                          lines: 2,
                          alignment: TextAlign.center,
                        ),
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

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFFFF8E3), Colors.white, AppColors.bgGray],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.8, 1]),
      ),
      child: Column(
        children: [
          const LanguageCell(),
          Obx(() {
            UserModel? userModel = controller.userInfoModel.userInfo.value;
            return Container(
              margin: EdgeInsets.fromLTRB(18.w, 20.w, 14.w, 14.w),
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
                            5.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                BeeNav.push(BeeNav.notice);
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ImgItem(
                                    'Home/bell',
                                    width: 28.w,
                                    height: 28.w,
                                  ),
                                  Obx(() => controller.noticeUnRead.value
                                      ? ClipOval(
                                          child: Container(
                                            width: 6.w,
                                            height: 6.w,
                                            color: AppColors.textRed,
                                          ),
                                        )
                                      : AppGaps.empty)
                                ],
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
            );
          }),
          Obx(
            () => (controller.userVipModel.value?.pointStatus == 1 ||
                    controller.userVipModel.value?.growthValueStatus == 1)
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFf3e4bb), Color(0xFFd1bb7f)],
                        ),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          controller.userVipModel.value?.pointStatus == 1
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      BeeNav.push(BeeNav.vip);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          const ImgItem(
                                            'AboutMe/V',
                                            width: 28,
                                            height: 28,
                                          ),
                                          AppGaps.hGap15,
                                          AppText(
                                            str: '等级'.ts,
                                            color: AppColors.vipNormal,
                                          ),
                                          AppGaps.hGap15,
                                          AppText(
                                            str: controller.userVipModel.value
                                                    ?.profile.levelName ??
                                                '',
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.vipNormal,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : AppGaps.empty,
                          controller.userVipModel.value?.growthValueStatus == 1
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      BeeNav.push(BeeNav.point);
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
                                                    color:
                                                        HexToColor('#f3e4ba')),
                                              ),
                                            ),
                                          ),
                                          const ImgItem(
                                            'AboutMe/jf',
                                            width: 28,
                                            height: 28,
                                          ),
                                          AppGaps.hGap15,
                                          AppText(
                                            str: '积分'.ts,
                                            color: AppColors.vipNormal,
                                          ),
                                          AppGaps.hGap15,
                                          AppText(
                                            str:
                                                '${controller.userVipModel.value?.profile.point ?? ''}',
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.vipNormal,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : AppGaps.empty,
                        ],
                      ),
                    ))
                : AppGaps.empty,
          ),
        ],
      ),
    );
    return headerView;
  }
}
