// ignore_for_file: unnecessary_new

/*
  我的积分
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_point_item_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/user/vip/point/point_controller.dart';

class IntergralPage extends GetView<IntergralLogic> {
  const IntergralPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: false,
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '我的积分'.inte,
          fontSize: 17,
          color: Color(0xff333333),
        ),
        backgroundColor: Color(0xff120909),
        leading: const BackButton(color: Colors.black),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF4ED), Color(0xFFE8F0F8)],
                stops: [0.0, 1],
              )
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    GlobalPages.push(GlobalPages.vip);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: AppText(
                      str: '成长等级'.inte,
                      fontSize: 14,
                      color: Color(0xff333333),
                    ),
                  ))
            ],
          )
        ],
      ),
      backgroundColor: AppStyles.bgGray,
      body: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
              image:AssetImage('assets/images/Center/point-bk.png')
          ),
        ),
        child: RefreshView(
          renderItem: buildCellForFirstListView,
          refresh: controller.loadList,
          more: controller.loadMoreList,
        ),
      ),
    );
  }

  Widget buildCellForFirstListView(int index, UserPointItemModel model) {
    var container = Container(
      // height: 55,
        margin: const EdgeInsets.only(right: 15, left: 15),
        padding: EdgeInsets.symmetric(horizontal: 9),
        width: ScreenUtil().screenWidth - 30,
        decoration: BoxDecoration(
          color: AppStyles.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.r),bottomRight: Radius.circular(8.r)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color:Color(0xffF4F8F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:8,
                      child:
                      Container(
                        // alignment: Alignment.center,
                        child: AppText(
                          str: model.ruleName.inte,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: model.isValid == 0
                              ? AppStyles.textGrayC
                              : AppStyles.textBlack,
                        ),
                      ),),
                    Expanded(
                        flex: 4,
                        child:
                        Container(
                          alignment: Alignment.centerRight,
                          child: AppText(
                            str: model.type == 1
                                ? '+' + model.value.toString()
                                : '-' + model.value.toString(),
                            fontSize: 13,
                            color: model.isValid == 0
                                ? AppStyles.textGrayC
                                : model.type == 1
                                ? AppStyles.textDark
                                : AppStyles.textRed,
                          ),
                        )),
                    Expanded(
                        child: SizedBox())
                  ],
                ),
              ),
              5.verticalSpace,
              Container(
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: AppText(
                        alignment: TextAlign.center,
                        str: model.createdAt,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: model.isValid == 0
                            ? AppStyles.textGrayC
                            : AppStyles.textBlack,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
    if (index == 0) {
      return Column(
        children: [
          buildCustomViews(),
          Container(
              padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
              margin: EdgeInsets.only(left: 14,right: 14,top: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r),topRight: Radius.circular(8.r)),
                color: Colors.white,
              ),
              child:Row(
                children: [
                  AppText(
                    str: '积分明细'.inte,
                    color: AppStyles.textBlack,
                    fontSize: 14,
                  ),
                ],
              )
          ),
          container,
        ],
      );
    }
    return container;
  }

  Widget buildCustomViews() {
    var headerView = SizedBox(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 33,horizontal: 30),
        width: ScreenUtil().screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        str: (controller.userPointModel.value?.point ?? 0)
                            .toString(),
                        fontSize: 30,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.bold,
                      ),
                      12.horizontalSpace,
                      AppText(
                        str: '积分'.inte,
                        fontSize: 14,
                        color: Color(0xff444444),
                      )
                    ],
                  ),
            ),
            AppGaps.vGap15,
            AppText(
              str: '使用规则'.inte +
                  '：' +
                  (controller.userPointModel.value?.configPoint ?? 0)
                      .toString() +
                  '${'积分'.inte}=' +
                  num.parse((controller
                      .userPointModel.value?.configAmount ??
                      '0'))
                      .priceConvert(needFormat: false)
                      .toString(),
              fontSize: 12,
              color: Color(0xff888888),
            ),
          ],
        ),
      )
    );
    return headerView;
  }
}
