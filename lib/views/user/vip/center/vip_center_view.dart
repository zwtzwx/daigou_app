// ignore_for_file: unnecessary_const

/*
  会员中心
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_vip_level_model.dart';
import 'package:jiyun_app_client/models/user_vip_price_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/user/vip/center/vip_center_controller.dart';

/*
  会员中心
 */

class BeeSuperUserView extends GetView<BeeSuperUserLogic> {
  const BeeSuperUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      // bottomNavigationBar: Obx(
      //   () => Offstage(
      //     offstage: !controller.isloading.value,
      //     child: Container(
      //       decoration: const BoxDecoration(
      //         color: AppColors.white,
      //         border: Border(
      //           top: BorderSide(
      //             color: AppColors.line,
      //           ),
      //         ),
      //       ),
      //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //       child: SafeArea(
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               mainAxisSize: MainAxisSize.min,
      //               children: <Widget>[
      //                 Row(
      //                   children: <Widget>[
      //                     AppText(
      //                       str: '合计'.ts + '：',
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                     AppText(
      //                       color: AppColors.textRed,
      //                       str: controller.selectButton.value == 999
      //                           ? '0.00'
      //                           : (controller
      //                                       .userVipModel
      //                                       .value!
      //                                       .priceList[
      //                                           controller.selectButton.value]
      //                                       .price /
      //                                   100)
      //                               .toString(),
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ],
      //                 ),
      //                 AppText(
      //                   str: controller.selectButton.value == 999
      //                       ? '+ 0 ' + '成长值'.ts
      //                       : '+' +
      //                           controller
      //                               .userVipModel
      //                               .value!
      //                               .priceList[controller.selectButton.value]
      //                               .growthValue
      //                               .toString() +
      //                           '成长值'.ts,
      //                   fontSize: 14,
      //                   color: AppColors.textGray,
      //                 ),
      //               ],
      //             ),
      //             BeeButton(
      //               text: '立即支付',
      //               fontWeight: FontWeight.bold,
      //               backgroundColor: HexToColor('#d1bb7f'),
      //               onPressed: controller.onPay,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Obx(() => controller.isloading.value
            ? Column(
                children: <Widget>[
                  headerCardView(context),
                  15.verticalSpaceFromWidth,
                  buildGrowthValueView(),
                  // buyVipPriceView(context),
                  20.verticalSpaceFromWidth,
                ],
              )
            : AppGaps.empty),
      ),
    );
  }

  // 成长值
  Widget buildGrowthValueView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: AppText(
              str: '成长值说明'.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: AppText(
              lines: 99,
              str: controller.userVipModel.value!.levelRemark!,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
            child: Column(
              children: buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  // 成长值列表
  buildListView() {
    List<Widget> listV = [];
    listV.add(buildGrowthValueRow('等级'.ts, '成长值'.ts, isTitle: true));
    for (var i = 0; i < controller.userVipModel.value!.levelList.length; i++) {
      UserVipLevel memModel = controller.userVipModel.value!.levelList[i];
      listV.add(buildGrowthValueRow(
        memModel.name,
        memModel.growthValue.toString(),
      ));
    }
    return listV;
  }

  buildGrowthValueRow(String label, String content, {bool isTitle = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 33,
              alignment: Alignment.center,
              color:
                  isTitle ? const Color(0xFFf2edde) : const Color(0xFFf9f8f4),
              child: AppText(
                str: label,
                color: AppColors.vipNormal,
              ),
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 33,
              alignment: Alignment.center,
              color:
                  isTitle ? const Color(0xFFf2edde) : const Color(0xFFf9f8f4),
              child: AppText(
                str: content,
                color: AppColors.vipNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
    购买会员价格区域
   */
  Widget buyVipPriceView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: AppText(
              str: '购买会员'.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGaps.line,
          Padding(
            padding: const EdgeInsets.all(30),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.0, //水平子Widget之间间距
                mainAxisSpacing: 10.0, //垂直子Widget之间间距
                crossAxisCount: 3, //一行的Widget数量
                childAspectRatio: 0.8,
              ), // 宽高比例
              itemCount: controller.userVipModel.value!.priceList.length,
              itemBuilder: _buildGrideBtnView(),
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      UserVipPriceModel model = controller.userVipModel.value!.priceList[index];
      return GestureDetector(
        onTap: () {
          controller.selectButton.value = index;
        },
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
                color: controller.selectButton.value == index
                    ? const Color(0xFFf9f8f4)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: controller.selectButton.value == index
                      ? AppColors.vipNormal
                      : const Color(0xFFd9c58d),
                ),
                boxShadow: controller.selectButton.value == index
                    ? [
                        const BoxShadow(
                          blurRadius: 6,
                          color: const Color(0x6B4A3808),
                        ),
                      ]
                    : null),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: const Color(0xFFd9c48c),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: AppText(
                            str: model.name,
                            color: Colors.white,
                          ),
                        ),
                        // Container(
                        //   height: 17,
                        //   alignment: Alignment.topRight,
                        //   width: (ScreenUtil().screenWidth - 70) / 3,
                        //   decoration: const BoxDecoration(
                        //     color: Colors.transparent,
                        //     borderRadius: BorderRadius.vertical(
                        //         top: Radius.circular((15))),
                        //   ),
                        //   child: model.type == 2
                        //       ? Container(
                        //           height: 17,
                        //           alignment: Alignment.center,
                        //           width:
                        //               (ScreenUtil().screenWidth - 70) / 3 / 3,
                        //           decoration: const BoxDecoration(
                        //             color: AppColors.textRed,
                        //             borderRadius: BorderRadius.only(
                        //                 topRight: Radius.circular((15)),
                        //                 bottomLeft:
                        //                     const Radius.circular((15))),
                        //           ),
                        //           child:  AppText(
                        //             str: Translation.t(context, '活动'),
                        //             fontSize: 9,
                        //             fontWeight: FontWeight.w400,
                        //             color: AppColors.white,
                        //           ),
                        //         )
                        //       : Container(),
                        // ),
                        AppText(
                          // 会员价格
                          str: model.price.rate(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textRed,
                        ),
                        Stack(
                          children: [
                            AppText(
                              str:
                                  model.type != 1 ? model.basePrice.rate() : '',
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textGray,
                            ),
                            Positioned(
                                top: 7,
                                bottom: 8,
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: 1,
                                  color: AppColors.textGray,
                                ))
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: (ScreenUtil().screenWidth - 70) / 3,
                    child: AppText(
                      str: model.illustrate,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    };
  }

  /*
    头部分卡片区
   */
  Widget headerCardView(BuildContext context) {
    num nextLevelGrowthValue =
        controller.userVipModel.value!.profile.nextGrowthValue;
    num growthValue = controller.userVipModel.value!.profile.currentGrowthValue;
    num firstNum = nextLevelGrowthValue - growthValue;
    double widthFactor = growthValue / nextLevelGrowthValue;
    if (widthFactor > 1) {
      widthFactor = 1;
    }
    var headerView = SizedBox(
      height: ScreenUtil().setHeight(190) + 30,
      child: Stack(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(180),
            alignment: Alignment.topLeft,
            child: ImgItem(
              'AboutMe/growth-bg',
              fit: BoxFit.fitWidth,
              width: ScreenUtil().screenWidth,
            ),
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 15,
            child: const BackButton(
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 7, bottom: 13, left: 15, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        str: '成长值'.ts,
                        fontSize: 13,
                        color: AppColors.vipNormal,
                      ),
                      AppGaps.hGap10,
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            BeeNav.push(BeeNav.growthValue);
                          },
                          child: AppText(
                            str: '距离下一等级还差{count}成长值'.tsArgs(
                                    {'count': firstNum < 0 ? 0 : firstNum}) +
                                ' >',
                            color: AppColors.vipNormal,
                            lines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppGaps.vGap15,
                  Row(
                    children: [
                      AppText(
                        str: growthValue.toString(),
                        color: AppColors.vipNormal,
                        fontWeight: FontWeight.bold,
                      ),
                      AppGaps.hGap10,
                      Expanded(
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.orderLine,
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                alignment: Alignment.topLeft,
                                heightFactor: 1,
                                widthFactor: widthFactor,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: HexToColor('#DAB85C'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppGaps.hGap10,
                      AppText(
                        str: nextLevelGrowthValue.toString(),
                        color: AppColors.vipNormal,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(90),
            left: 15,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: ImgItem(
                      controller.userInfo!.avatar,
                      fit: BoxFit.fitWidth,
                      holderImg: "Center/logo",
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      str: controller.userInfo!.name,
                      fontSize: 16,
                      color: AppColors.vipNormal,
                      fontWeight: FontWeight.bold,
                    ),
                    AppGaps.vGap4,
                    AppText(
                      str: 'ID：${controller.userInfo!.id}',
                      color: AppColors.vipNormal,
                    ),
                    AppGaps.vGap4,
                    GestureDetector(
                      onTap: () {
                        BeeNav.push(BeeNav.point);
                      },
                      child: Row(
                        children: [
                          AppText(
                            str: '积分'.ts,
                            color: AppColors.vipNormal,
                          ),
                          AppGaps.hGap10,
                          AppText(
                            str:
                                (controller.userVipModel.value?.profile.point ??
                                        0)
                                    .toString(),
                            color: AppColors.vipNormal,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return headerView;
  }
}
