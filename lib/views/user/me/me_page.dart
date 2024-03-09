import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_model.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/user/me/me_controller.dart';

class BeeCenterPage extends GetView<BeeCenterLogic> {
  const BeeCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const EmptyAppBar(),
      primary: false,
      backgroundColor: AppStyles.bgGray,
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        color: AppStyles.textRed,
        child: Obx(
          () => Stack(
            children: [
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                children: [
                  Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child:
                            LoadAssetImage('Center/bg', fit: BoxFit.fitWidth),
                      ),
                      userInfo(),
                    ],
                  ),
                  12.verticalSpaceFromWidth,
                  toolList(),
                  30.verticalSpaceFromWidth,
                ],
              ),
              if (controller.showMiniHeader.value)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        16.w, kToolbarHeight + 5.h, 16.w, 5.h),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDEEEC),
                    ),
                    child: SizedBox(
                      height: 25.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText(
                              str: controller
                                      .userInfoModel.userInfo.value?.name ??
                                  '',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          10.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              GlobalPages.push(GlobalPages.customer);
                            },
                            child: LoadAssetImage(
                              'Center/ico_kf',
                              width: 28.w,
                              height: 28.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toolList() {
    List<List<Map<String, dynamic>>> list = [
      [
        {
          'name': '语言/币种',
          'icon': 'Center/ico_yy',
          'route': GlobalPages.localeSetting,
        },
        {
          'name': '地址簿',
          'icon': 'Center/ico_dzb',
          'route': GlobalPages.addressList,
          'params': {'select': 0},
        },
        {
          'name': '余额',
          'icon': 'Center/ico_ye',
          'route': GlobalPages.recharge,
        },
        {
          'name': '我的积分',
          'icon': 'Center/ico_jf',
          'route': GlobalPages.vip,
        },
        {
          'name': '我的评论',
          'icon': 'Center/ico_pl',
          'route': GlobalPages.comment,
        },
        {
          'name': '我的咨询',
          'icon': 'Center/ico_zx',
          'route': GlobalPages.shopOrderChat,
        },
        {
          'name': '推广联盟',
          'icon': 'Center/ico_tglm',
          'route': GlobalPages.agentApplyInstruct,
        },
      ],
      [
        {
          'name': '中国仓库',
          'icon': 'Center/ico_ck',
          'route': GlobalPages.warehouse,
        },
        {
          'name': '邮寄其他包裹',
          'icon': 'Center/ico_bg',
          'route': GlobalPages.forecast,
        },
      ],
      [
        {
          'name': '帮助中心',
          'icon': 'Center/ico_bzzx',
          'route': GlobalPages.help,
        },
        {
          'name': '账号安全',
          'icon': 'Center/ico_zhaq',
          'route': GlobalPages.profile,
        },
        {
          'name': '退出登录',
          'icon': 'Center/ico_tc',
        },
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list
          .map(
            (e) => buildListView(
              e,
              iconWidth: 30.w,
            ),
          )
          .toList(),
    );
  }

  Widget buildListView(
    List<Map<String, dynamic>> list, {
    int? crossAxisCount,
    double? childAspectRatio,
    double? iconWidth,
  }) {
    var listView = Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
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
                  if (list[index]['route'] == GlobalPages.agentApplyInstruct) {
                    if (controller.agentStatus.value?.id == 2) return;
                    if (controller.agentStatus.value?.id == 1) {
                      GlobalPages.push(GlobalPages.agentCenter);
                    } else {
                      GlobalPages.push(list[index]['route']);
                    }
                  } else if (list[index]['route'] != null) {
                    GlobalPages.push(list[index]['route'],
                        arg: list[index]['params']);
                  } else {
                    var res = await BaseDialog.cupertinoConfirmDialog(
                        context, '确认退出登录吗'.inte + '？');
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
                            str: (list[index]['name']! as String).inte,
                            fontSize: 14,
                            lines: 2,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      if (list[index]['route'] != null)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13.sp,
                          color: AppStyles.textNormal,
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

      List<Map<String, String>> list2 = [
        {
          'label': '我的订单',
          'icon': 'Center/ico_wddd',
          'route': GlobalPages.shopOrderList,
        },
        {
          'label': '运费试算',
          'icon': 'Center/ico_yfss',
          'route': GlobalPages.lineQuery,
        },
        {
          'label': '我的包裹',
          'icon': 'Center/ico_wdbg',
          'route': GlobalPages.orderCenter,
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
                10.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    GlobalPages.push(GlobalPages.customer);
                  },
                  child: LoadAssetImage(
                    'Center/ico_kf',
                    width: 28.w,
                    height: 28.w,
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
              children: list2
                  .map(
                    (e) => Flexible(
                      child: GestureDetector(
                        onTap: () {
                          GlobalPages.push(e['route']!);
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
                                str: e['label']!.inte,
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
