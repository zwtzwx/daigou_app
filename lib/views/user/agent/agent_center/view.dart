import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/user/agent/agent_center/controller.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class AgentCenterView extends GetView<AgentCenterController> {
  const AgentCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: const Color(0xFFE8FBFF),
      body: Stack(
        children: [
          const Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: LoadAssetImage(
              'Transport/agent-bg',
              fit: BoxFit.fitWidth,
            ),
          ),
          ListView(
            controller: controller.scrollerController,
            children: [
              StickyHeader(
                header: Obx(
                  () => Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    color: controller.headerBgShow.value
                        ? const Color(0xFF0791FF)
                        : Colors.transparent,
                    padding: EdgeInsets.only(
                      left: 12.w,
                      top: ScreenUtil().statusBarHeight + 10.h,
                      bottom: 5.h,
                    ),
                    child: const BackButton(color: Colors.white),
                  ),
                ),
                content: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 14.w),
                              padding:
                                  EdgeInsets.fromLTRB(18.w, 25.h, 18.w, 15.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.r),
                                  topRight: Radius.circular(24.r),
                                ),
                                gradient: const RadialGradient(
                                  radius: 2,
                                  center: Alignment.topLeft,
                                  colors: [
                                    Color(
                                      0xFFE3FFF4,
                                    ),
                                    Colors.white,
                                    Color(0xFFE4FFF5)
                                  ],
                                  stops: [0.3, 0.8, 1],
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: ImgItem(
                                      controller.userInfo.value?.avatar ?? '',
                                      fit: BoxFit.fitWidth,
                                      width: 65.w,
                                      height: 65.w,
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          str:
                                              controller.userInfo.value?.name ??
                                                  '',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        5.verticalSpace,
                                        Row(
                                          children: [
                                            AppText(
                                              alignment: TextAlign.center,
                                              str:
                                                  '${'邀请码'.inte}: ${controller.userInfo.value?.id ?? ''}',
                                              fontSize: 14,
                                              color: const Color(0xFF444444),
                                            ),
                                            10.horizontalSpace,
                                            GestureDetector(
                                              onTap: () {
                                                controller.onCopyData(controller
                                                        .userInfo.value?.id ??
                                                    '');
                                              },
                                              child: LoadAssetImage(
                                                'Transport/ico_fz',
                                                width: 15.w,
                                                height: 15.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, -5.h),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 20.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.r)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xC4BFECF6),
                                      offset: const Offset(0, -2),
                                      blurRadius: 14.r,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      str: '已提现金额'.inte,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    10.verticalSpaceFromWidth,
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFEEE4B2)),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFBFFCF),
                                            Color(0xFFFCFFEA)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 14.h),
                                      child: Column(
                                        children: [
                                          Obx(
                                            () => AppText(
                                              str: controller
                                                  .withdrawedAmount.value
                                                  .priceConvert(
                                                      showPriceSymbol: false),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          8.verticalSpaceFromWidth,
                                          GestureDetector(
                                            onTap: () {
                                              GlobalPages.push(
                                                  GlobalPages.agentCommission);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppText(
                                                  str: '交易记录'.inte,
                                                  fontSize: 14,
                                                  color: AppStyles.textNormal,
                                                ),
                                                3.horizontalSpace,
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: AppStyles.textNormal,
                                                  size: 13.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    24.verticalSpaceFromWidth,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Obx(
                                                () => AppText(
                                                  str: (controller.countModel
                                                              .value?.all ??
                                                          0)
                                                      .toString(),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              6.verticalSpaceFromWidth,
                                              GestureDetector(
                                                onTap: () {
                                                  GlobalPages.push(
                                                      GlobalPages.agentMember);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AppText(
                                                      str: '已注册好友'.inte,
                                                      fontSize: 14,
                                                      color:
                                                          AppStyles.textNormal,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color:
                                                          AppStyles.textNormal,
                                                      size: 13.sp,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Obx(
                                                () => AppText(
                                                  str: (controller
                                                              .countModel
                                                              .value
                                                              ?.hasOrder ??
                                                          0)
                                                      .toString(),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              6.verticalSpaceFromWidth,
                                              GestureDetector(
                                                onTap: () {
                                                  GlobalPages.push(
                                                      GlobalPages.agentMember,
                                                      arg: 2);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AppText(
                                                      str: '已下单好友'.inte,
                                                      fontSize: 14,
                                                      color:
                                                          AppStyles.textNormal,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color:
                                                          AppStyles.textNormal,
                                                      size: 13.sp,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    28.verticalSpaceFromWidth,
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          20.w, 10.h, 14.w, 15.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F7FA),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  str: '可领取奖金'.inte,
                                                  fontSize: 14,
                                                  color: AppStyles.textNormal,
                                                ),
                                                10.verticalSpaceFromWidth,
                                                Obx(
                                                  () => AppText(
                                                    str: controller
                                                        .withdrawalAmount.value
                                                        .priceConvert(
                                                            showPriceSymbol:
                                                                false),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Container(
                                            height: 35.h,
                                            constraints: BoxConstraints(
                                              minWidth: 90.w,
                                            ),
                                            child: BeeButton(
                                              text: '提现',
                                              fontWeight: FontWeight.bold,
                                              onPressed: () {
                                                GlobalPages.push(GlobalPages
                                                    .agentCommissionList);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    5.verticalSpaceFromWidth,
                    stepInfo(),
                    20.verticalSpaceFromWidth,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget stepInfo() {
    List<Map<String, String>> stepList = [
      {'icon': 'ico_sqdl', 'label': '申请成为代理'},
      {'icon': 'ico_fx', 'label': '在社交媒体分享邀请码/链接'},
      {'icon': 'ico_zc', 'label': '新用户注册输入邀请码/点击链接注册登录'},
      {'icon': 'ico_xyh', 'label': '新用户下单并收到包裹'},
      {'icon': 'ico_yj', 'label': '获得佣金'},
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          18.verticalSpaceFromWidth,
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -2.w,
                bottom: -3.h,
                child: LoadAssetImage(
                  'Transport/bottom_line',
                  fit: BoxFit.fitWidth,
                  width: 100.w,
                ),
              ),
              AppText(
                str: '返佣流程'.inte,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          ...stepList.map(
            (e) => Padding(
              padding: EdgeInsets.only(top: 18.h),
              child: Row(
                children: [
                  LoadAssetImage(
                    'Transport/${e['icon']}',
                    width: 30.w,
                    height: 30.w,
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: AppText(
                      str: (e['label'] as String).inte,
                      fontSize: 14,
                      lines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
