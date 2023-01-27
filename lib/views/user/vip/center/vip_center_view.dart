// ignore_for_file: unnecessary_const

/*
  会员中心
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_vip_level_model.dart';
import 'package:jiyun_app_client/models/user_vip_price_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/user/vip/center/vip_center_controller.dart';

/*
  会员中心
 */

class VipCenterView extends GetView<VipCenterController> {
  const VipCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: BaseStylesConfig.bgGray,
      // bottomNavigationBar: Obx(
      //   () => Offstage(
      //     offstage: !controller.isloading.value,
      //     child: Container(
      //       decoration: const BoxDecoration(
      //         color: BaseStylesConfig.white,
      //         border: Border(
      //           top: BorderSide(
      //             color: BaseStylesConfig.line,
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
      //                     ZHTextLine(
      //                       str: '合计'.ts + '：',
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                     ZHTextLine(
      //                       color: BaseStylesConfig.textRed,
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
      //                 ZHTextLine(
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
      //                   color: BaseStylesConfig.textGray,
      //                 ),
      //               ],
      //             ),
      //             MainButton(
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
                  Sized.vGap15,
                  buildGrowthValueView(),
                  Sized.vGap15,
                  buyVipPriceView(context),
                  Sized.vGap15,
                ],
              )
            : Sized.empty),
      ),
    );
  }

  // 成长值
  Widget buildGrowthValueView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: BaseStylesConfig.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ZHTextLine(
              str: '成长值说明'.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ZHTextLine(
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
              child: ZHTextLine(
                str: label,
                color: BaseStylesConfig.vipNormal,
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
              child: ZHTextLine(
                str: content,
                color: BaseStylesConfig.vipNormal,
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
        color: BaseStylesConfig.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ZHTextLine(
              str: '购买会员'.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Sized.line,
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
                    : BaseStylesConfig.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: controller.selectButton.value == index
                      ? BaseStylesConfig.vipNormal
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
                          child: ZHTextLine(
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
                        //             color: BaseStylesConfig.textRed,
                        //             borderRadius: BorderRadius.only(
                        //                 topRight: Radius.circular((15)),
                        //                 bottomLeft:
                        //                     const Radius.circular((15))),
                        //           ),
                        //           child:  ZHTextLine(
                        //             str: Translation.t(context, '活动'),
                        //             fontSize: 9,
                        //             fontWeight: FontWeight.w400,
                        //             color: BaseStylesConfig.white,
                        //           ),
                        //         )
                        //       : Container(),
                        // ),
                        ZHTextLine(
                          // 会员价格
                          str: (controller.localModel?.currencySymbol ?? '') +
                              (model.price / 100).toString(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: BaseStylesConfig.textRed,
                        ),
                        Stack(
                          children: [
                            ZHTextLine(
                              str: model.type != 1
                                  ? (controller.localModel?.currencySymbol ??
                                          '') +
                                      (model.basePrice / 100).toString()
                                  : '',
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: BaseStylesConfig.textGray,
                            ),
                            Positioned(
                                top: 7,
                                bottom: 8,
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: 1,
                                  color: BaseStylesConfig.textGray,
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
                    child: ZHTextLine(
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
            child: LoadImage(
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
                      ZHTextLine(
                        str: '成长值'.ts,
                        fontSize: 13,
                        color: BaseStylesConfig.vipNormal,
                      ),
                      Sized.hGap10,
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Routers.push(Routers.growthValue);
                          },
                          child: ZHTextLine(
                            str: '距离下一等级还差{count}成长值'.tsArgs(
                                    {'count': firstNum < 0 ? 0 : firstNum}) +
                                ' >',
                            color: BaseStylesConfig.vipNormal,
                            lines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Sized.vGap15,
                  Row(
                    children: [
                      ZHTextLine(
                        str: growthValue.toString(),
                        color: BaseStylesConfig.vipNormal,
                        fontWeight: FontWeight.bold,
                      ),
                      Sized.hGap10,
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
                                    color: BaseStylesConfig.orderLine,
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
                      Sized.hGap10,
                      ZHTextLine(
                        str: nextLevelGrowthValue.toString(),
                        color: BaseStylesConfig.vipNormal,
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
                    child: LoadImage(
                      controller.userInfo!.avatar,
                      fit: BoxFit.fitWidth,
                      holderImg: "AboutMe/about-logo",
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZHTextLine(
                      str: controller.userInfo!.name,
                      fontSize: 16,
                      color: BaseStylesConfig.vipNormal,
                      fontWeight: FontWeight.bold,
                    ),
                    Sized.vGap4,
                    ZHTextLine(
                      str: 'ID：${controller.userInfo!.id}',
                      color: BaseStylesConfig.vipNormal,
                    ),
                    Sized.vGap4,
                    GestureDetector(
                      onTap: () {
                        Routers.push(Routers.point);
                      },
                      child: Row(
                        children: [
                          ZHTextLine(
                            str: '积分'.ts,
                            color: BaseStylesConfig.vipNormal,
                          ),
                          Sized.hGap10,
                          ZHTextLine(
                            str:
                                (controller.userVipModel.value?.profile.point ??
                                        0)
                                    .toString(),
                            color: BaseStylesConfig.vipNormal,
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
