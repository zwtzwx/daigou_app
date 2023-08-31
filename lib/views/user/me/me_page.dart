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

class MeView extends GetView<MeController> {
  const MeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: BaseStylesConfig.bgGray,
      appBar: const EmptyAppBar(),
      primary: false,
      body: RefreshIndicator(
        onRefresh: controller.created,
        color: BaseStylesConfig.textRed,
        child: ListView.builder(
          itemBuilder: buildCellForFirstListView,
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
        'route': Routers.recharge,
      },
      {
        'name': '优惠券',
        'icon': 'AboutMe/center-coupon',
        'route': Routers.coupon,
      },
      {
        'name': '佣金收入',
        'icon': 'AboutMe/center-yj',
        'route': Routers.agentCommission,
      },
      {
        'name': '我的积分',
        'icon': 'AboutMe/center-point',
        'route': Routers.point,
      },
    ];
    List<Map<String, dynamic>> orderList = [
      {
        'name': '代购/商城订单',
        'icon': 'AboutMe/order',
        'route': Routers.shopOrderList,
      },
      {
        'name': '代购问题商品',
        'icon': 'AboutMe/wtsp',
        'route': Routers.probleShopOrder,
      },
      {
        'name': '集运/转运包裹',
        'icon': 'AboutMe/parcel',
        'route': Routers.orderCenter,
      },
    ];
    List<Map<String, dynamic>> list1 = [
      {
        'name': '地址簿',
        'icon': 'AboutMe/address-icon',
        'route': Routers.addressList,
        'params': {'select': 0},
      },
      {
        'name': '个人资料',
        'icon': 'AboutMe/info-icon',
        'route': Routers.profile,
      },
      {
        'name': '交易记录',
        'icon': 'AboutMe/pay-record-icon',
        'route': Routers.transaction,
      },
      // {
      //   'name': '一键预报',
      //   'icon': 'AboutMe/chorme',
      //   'route': Routers.transaction,
      // },
      // {
      //   'name': '取件列表',
      //   'icon': 'AboutMe/smqj',
      //   'route': Routers.transaction,
      // },
      {
        'name': '我的咨询',
        'icon': 'AboutMe/kefu',
        'route': Routers.shopOrderChat,
      },
      {
        'name': '代理',
        'icon': 'AboutMe/proxy-icon',
        'route': Routers.agentApply,
      },
      {
        'name': '更改手机号',
        'icon': 'AboutMe/phone-icon',
        'route': Routers.changeMobileAndEmail,
        'params': {'type': 1},
      },
      {
        'name': '更改邮箱',
        'icon': 'AboutMe/emai-icon',
        'route': Routers.changeMobileAndEmail,
        'params': {'type': 2},
      },
      {
        'name': '关于我们',
        'icon': 'AboutMe/about-me-icon',
        'route': Routers.abountMe,
      },
      {
        'name': '修改密码',
        'icon': 'AboutMe/password',
        'route': Routers.password,
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
        color: BaseStylesConfig.white,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 9.h),
            child: ZHTextLine(
              str: title.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
                onTap: () {
                  if (list[index]['route'] == Routers.agentApply) {
                    if (controller.agentStatus.value?.id == 1) {
                      // 代理
                      Routers.push(Routers.agentMember);
                    } else {
                      Routers.push(list[index]['route'], list[index]['params']);
                    }
                  } else {
                    Routers.push(list[index]['route'], list[index]['params']);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      LoadImage(
                        list[index]['icon'],
                        width: iconWidth ?? 38.w,
                        height: iconWidth ?? 38.w,
                      ),
                      2.verticalSpace,
                      ZHTextLine(
                        str: (list[index]['name']! as String).ts,
                        fontSize: 12,
                        color: BaseStylesConfig.textNormal,
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

  Widget buildBottomListCell(BuildContext context, Map item) {
    return GestureDetector(
      onTap: () async {
        if (item['route'] != null) {
          Routers.push(item['route'], item['params']);
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            LoadImage(
              item['icon'],
              width: 24,
              height: 24,
            ),
            Sized.hGap10,
            ZHTextLine(
              str: (item['name'] as String).ts,
              lines: 2,
              alignment: TextAlign.center,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: BaseStylesConfig.textGray,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFFFF8E3), Colors.white, BaseStylesConfig.bgGray],
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
                    child: LoadImage(
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
                              child: ZHTextLine(
                                str: userModel?.name ?? '',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.horizontalSpace,
                            GestureDetector(
                              child: LoadImage(
                                'Home/bell',
                                width: 28.w,
                                height: 28.w,
                              ),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        ZHTextLine(
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
                                      Routers.push(Routers.vip);
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
                                          Sized.hGap15,
                                          ZHTextLine(
                                            str: '等级'.ts,
                                            color: BaseStylesConfig.vipNormal,
                                          ),
                                          Sized.hGap15,
                                          ZHTextLine(
                                            str: controller.userVipModel.value
                                                    ?.profile.levelName ??
                                                '',
                                            fontWeight: FontWeight.bold,
                                            color: BaseStylesConfig.vipNormal,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Sized.empty,
                          controller.userVipModel.value?.growthValueStatus == 1
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Routers.push(Routers.point);
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
                                          const LoadImage(
                                            'AboutMe/jf',
                                            width: 28,
                                            height: 28,
                                          ),
                                          Sized.hGap15,
                                          ZHTextLine(
                                            str: '积分'.ts,
                                            color: BaseStylesConfig.vipNormal,
                                          ),
                                          Sized.hGap15,
                                          ZHTextLine(
                                            str:
                                                '${controller.userVipModel.value?.profile.point ?? ''}',
                                            fontWeight: FontWeight.bold,
                                            color: BaseStylesConfig.vipNormal,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Sized.empty,
                        ],
                      ),
                    ))
                : Sized.empty,
          ),
        ],
      ),
    );
    return headerView;
  }
}
