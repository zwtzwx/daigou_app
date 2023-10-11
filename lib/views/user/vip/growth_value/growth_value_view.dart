import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_point_item_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/user/vip/growth_value/growth_value_controller.dart';

class BeeValuesPage extends GetView<BeeValuesLogic> {
  const BeeValuesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      body: RefreshView(
        renderItem: buildCellForFirstListView,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
  }

  Widget buildCellForFirstListView(int index, UserPointItemModel model) {
    var container = Container(
      height: 55,
      margin: const EdgeInsets.only(right: 15, left: 15),
      width: ScreenUtil().screenWidth - 30,
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: AppText(
                str: model.ruleName,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: model.isValid == 0
                    ? AppColors.textGrayC
                    : AppColors.textBlack,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: AppText(
                alignment: TextAlign.center,
                str: model.createdAt,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: model.isValid == 0
                    ? AppColors.textGrayC
                    : AppColors.textBlack,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: AppText(
                str: model.type == 1
                    ? '+' + model.value.toString()
                    : '-' + model.value.toString(),
                fontSize: 13,
                color: model.isValid == 0
                    ? AppColors.textGrayC
                    : model.type == 1
                        ? AppColors.textDark
                        : AppColors.textRed,
              ),
            ),
          ),
        ],
      ),
    );
    if (index == 0) {
      return Column(
        children: [
          buildCustomViews(),
          container,
        ],
      );
    }
    return container;
  }

  Widget buildCustomViews() {
    var headerView = SizedBox(
      child: Stack(
        children: <Widget>[
          SizedBox(
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
            bottom: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: ScreenUtil().screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(
                    () => AppText(
                      str: controller
                              .vipDataModel.value?.profile.currentGrowthValue
                              .toString() ??
                          '',
                      color: AppColors.vipNormal,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  AppGaps.vGap5,
                  AppText(
                    str: '成长值'.ts,
                    color: AppColors.vipNormal,
                  ),
                  AppGaps.vGap15,
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str: '当前等级'.ts +
                              '：' +
                              (controller
                                      .vipDataModel.value?.profile.levelName ??
                                  ''),
                          color: AppColors.vipNormal,
                        ),
                        AppText(
                          str: '下一等级成长值'.ts +
                              '：' +
                              (controller.vipDataModel.value?.profile
                                      .nextGrowthValue
                                      .toString() ??
                                  ''),
                          color: AppColors.vipNormal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 54,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      width: ScreenUtil().screenWidth - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: AppText(
                                str: '类型'.ts,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: AppText(
                                str: '时间'.ts,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                                alignment: Alignment.center,
                                child: AppText(
                                  str: '明细'.ts,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      )),
                  AppGaps.line,
                  AppGaps.line
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return headerView;
  }
}
