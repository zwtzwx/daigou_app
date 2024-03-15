import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_point_item_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/user/vip/growth_value/growth_value_controller.dart';

class BeeValuesPage extends GetView<BeeValuesLogic> {
  const BeeValuesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: false,
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '成长值明细'.inte,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: AppStyles.bgGray,
      body: RefreshView(
        renderItem: buildCellForFirstListView,
        refresh: controller.loadList,
        more: controller.loadMoreList,
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
                      str: model.ruleName,
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
                  str: '成长值明细'.inte,
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
    var headerView = Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: AssetImage('assets/images/Center/growth-bg.png'),
            fit: BoxFit.cover,
          )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12,top: 2),
                child: AppText(
                  str: (controller
                      .vipDataModel.value?.profile.levelName ??
                      ''),
                  color: AppStyles.white,
                ),
              )
            ],
          ),
          14.verticalSpace,
          Row(
            children: [
              24.horizontalSpace,
              Obx(
                    () => AppText(
                  str: controller
                      .vipDataModel.value?.profile.currentGrowthValue
                      .toString() ??
                      '',
                  color: AppStyles.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              12.horizontalSpace,
              AppText(
                str: '成长值'.inte,
                color: AppStyles.white,
                fontSize: 14,
              )
            ],
          ),
          6.verticalSpace,
          Row(
            children: [
              26.horizontalSpace,
              AppText(
                str: '下一等级成长值'.inte+'：'+'123',
                color: Color(0xffB9B9B9),
                fontSize: 12,
              )
            ],
          )
        ],
      ),
    );
    return headerView;
  }
}
