import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/user/agent/agent_member/controller.dart';

class AgentMemberPage extends GetView<AgentMemberController> {
  const AgentMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: AppColors.bgGray,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '我的推广'.ts,
          fontSize: 17,
        ),
        // bottom: TabBar(
        //     labelColor: AppColors.primary,
        //     indicatorColor: AppColors.primary,
        //     controller: controller.tabController,
        //     onTap: (int index) {
        //       controller.pageController.jumpToPage(index);
        //     },
        //     tabs: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 10),
        //         child: Obx(
        //           () => AppText(
        //               str: '已注册好友'.ts +
        //                   '(${controller.countModel.value?.all ?? 0})'),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 10),
        //         child: Obx(
        //           () => AppText(
        //               str: '已下单好友'.ts +
        //                   '(${controller.countModel.value?.hasOrder ?? 0})'),
        //         ),
        //       ),
        //     ]),
      ),
      backgroundColor: AppColors.bgGray,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: const AspectRatio(
              aspectRatio: 29 / 12,
              child: ImgItem(
                  'https://api-jiyun-v3.haiouoms.com/storage/admin/20240111-fbyHV67E1n4LjKsS.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            child: Obx(
              () => Row(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          str: controller.userInfo.value?.name ?? '',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        5.verticalSpace,
                        AppText(
                          alignment: TextAlign.center,
                          str: 'ID: ${controller.userInfo.value?.id ?? ''}',
                          fontSize: 12,
                          color: const Color(0xFF888888),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  Icon(
                    Icons.qr_code_2,
                    color: const Color(0xFF444444),
                    size: 50.sp,
                  )
                ],
              ),
            ),
          ),
          commissionCell(),
          promotionCell(),
          20.verticalSpaceFromWidth,
        ],
      ),
    );
  }

  Widget commissionCell() {
    return Container(
      margin: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '佣金收入'.ts,
            fontSize: 18,
          ),
          25.verticalSpaceFromWidth,
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final amount = Get.find<AppStore>().amountInfo;
                  return AppText(
                    str: (amount.value?.commissionSum ?? 0)
                        .rate(showPriceSymbol: false),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  );
                }),
                Container(
                  height: 35.h,
                  constraints: BoxConstraints(
                    minWidth: 110.w,
                  ),
                  child: BeeButton(
                    text: '提现',
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      BeeNav.push(BeeNav.agentCommissionList);
                    },
                  ),
                )
              ],
            ),
          ),
          25.verticalSpaceFromWidth,
          GestureDetector(
            onTap: () {
              BeeNav.push(BeeNav.agentCommission);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4F9FF),
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.fromLTRB(12.w, 5.h, 20.w, 5.h),
              child: Row(
                children: [
                  ImgItem(
                    'Home/ico_jl',
                    fit: BoxFit.fitWidth,
                    width: 20.w,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: AppText(
                      str: '交易记录'.ts,
                      fontSize: 12,
                      color: AppColors.textNormal,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: AppColors.textNormal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget promotionCell() {
    List<String> list = ['已注册好友', '已下单好友'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: list
                    .asMap()
                    .keys
                    .map(
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 30.w),
                        child: GestureDetector(
                          onTap: () {
                            if (controller.promotionType.value == index + 1)
                              return;
                            controller.promotionType.value = index + 1;
                            controller.getList();
                          },
                          child: Obx(
                            () => AppText(
                              str: list[index],
                              fontSize:
                                  controller.promotionType.value == index + 1
                                      ? 16
                                      : 14,
                              fontWeight:
                                  controller.promotionType.value == index + 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
          Obx(
            () => controller.loading.value
                ? Container(
                    padding: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    child: const CupertinoActivityIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.userList
                        .map((e) => buildAgentUserView(e))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildAgentUserView(UserModel model) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            str: model.name,
            fontSize: 16,
          ),
          5.verticalSpaceFromWidth,
          AppText(
            str: '注册时间'.ts + '  ' + model.createdAt,
            fontSize: 12,
            color: AppColors.textNormal,
          ),
        ],
      ),
    );
  }
}
