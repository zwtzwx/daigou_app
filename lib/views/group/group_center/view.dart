import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/group_model.dart';
import 'package:huanting_shop/views/components/button/plain_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/empty_app_bar.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/loading_cell.dart';
import 'package:huanting_shop/views/group/group_center/controller.dart';
import 'package:huanting_shop/views/group/widget/group_item_cell.dart';
import 'package:huanting_shop/views/group/widget/public_group_item_cell.dart';

class BeeGroupView extends GetView<BeeGroupController> {
  const BeeGroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      primary: false,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: AppColors.primary,
        child: ListView(
          controller: controller.loadingUtil.value.scrollController,
          children: [
            buildTopBox(),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(
                  () => Column(
                    children: [
                      searchCell(),
                      ...controller.loadingUtil.value.list
                          .map((e) => renderItem(e)),
                      LoadingCell(
                        util: controller.loadingUtil.value,
                        emptyText: '没有更多拼团了',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderItem(GroupModel groupModel) {
    if (controller.groupType.value == 1) {
      return Obx(
        () => PublicGroupItemCell(
          model: groupModel,
          coordinate: controller.coordinate.value,
        ),
      );
    } else {
      return GroupItemCell(
        groupModel: groupModel,
        localizationModel: controller.localModel,
        onConfirm: () {
          BeeNav.push(BeeNav.groupDetail, {'id': groupModel.id});
        },
      );
    }
  }

  Widget buildTopBox() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 260,
          ),
          child: Obx(
            () => ImgItem(
              controller.banner.value,
              width: 1.sw,
              // height: 300,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          top: ScreenUtil().statusBarHeight,
          left: 10.w,
          child: const BackButton(color: Colors.white),
        ),
        Positioned(
          bottom: 30.w,
          right: 20.w,
          left: 15.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ),
                    AppGaps.hGap5,
                    Expanded(
                      child: Obx(
                        () => AppText(
                          str: controller.locationStr.value ?? '',
                          color: Colors.white,
                          fontSize: 12,
                          lines: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppGaps.hGap10,
              HollowButton(
                text: '发起拼团',
                borderColor: Colors.white,
                textColor: Colors.white,
                onPressed: () async {
                  var s = await BeeNav.push(BeeNav.groupCreate);
                  if (s != null) {
                    controller.onRefresh();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget searchCell() {
    List<Map> groupStatusList = [
      {'name': '全部', 'value': 0},
      {'name': '拼团中', 'value': 1},
      {'name': '拼团结束', 'value': 2},
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                searchTitleCell('公开拼团', 1),
                searchTitleCell('我的拼团', 2),
                searchTitleCell('我的团单', 3),
              ],
            ),
          ),
          Obx(
            () => Offstage(
              offstage: controller.groupType.value == 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: searchContentCell(),
              ),
            ),
          ),
          Obx(
            () => Offstage(
              offstage: controller.groupType.value == 1,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  spacing: 10,
                  children: groupStatusList
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            if (controller.groupStatus.value == e['value']) {
                              return;
                            }

                            controller.groupStatus.value = e['value'];
                            controller.onRefresh();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            decoration: BoxDecoration(
                              color: controller.groupStatus.value == e['value']
                                  ? Colors.white
                                  : AppColors.bgGray,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      controller.groupStatus.value == e['value']
                                          ? AppColors.groupText
                                          : AppColors.bgGray),
                            ),
                            child: AppText(
                              str: e['name'],
                              fontSize: 13,
                              color: controller.groupStatus.value == e['value']
                                  ? AppColors.groupText
                                  : AppColors.textBlack,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchTitleCell(String title, int type) {
    return GestureDetector(
      onTap: () {
        if (type == 3) {
          BeeNav.push(BeeNav.groupOrder);
        } else {
          controller.groupType.value = type;

          controller.onRefresh();
        }
      },
      child: Obx(
        () => Container(
          margin: const EdgeInsets.only(right: 20, top: 20),
          padding: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: controller.groupType.value == type
                  ? const BorderSide(color: AppColors.primary, width: 3)
                  : BorderSide.none,
            ),
          ),
          child: AppText(
            str: title.ts,
            fontWeight: controller.groupType.value == type
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: controller.groupType.value == type ? 18 : 15,
          ),
        ),
      ),
    );
  }

  Widget searchContentCell() {
    List<String> sortList = ['截单时间最近', '截单时间最远', '离我最近'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: BaseInput(
                  controller: controller.keywordController,
                  focusNode: controller.keywordNode,
                  textInputAction: TextInputAction.search,
                  hintText: '请搜索拼团号/邮编/国家'.ts,
                  isCollapsed: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  onSubmitted: (value) {
                    controller.onRefresh();
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.onRefresh();
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppText(
                    str: '搜索'.ts,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            AppText(
              str: '排序'.ts,
              fontSize: 12,
            ),
            10.horizontalSpace,
            Expanded(
                child: SizedBox(
              height: 18.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...sortList.asMap().keys.map(
                        (e) => GestureDetector(
                          onTap: () {
                            controller.sortIndex.value = e;
                            controller.onRefresh();
                          },
                          child: Obx(
                            () => Container(
                              margin: EdgeInsets.only(right: 10.w),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: controller.sortIndex.value == e
                                    ? Colors.white
                                    : AppColors.bgGray,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                    width: 1,
                                    color: controller.sortIndex.value == e
                                        ? AppColors.groupText
                                        : AppColors.bgGray),
                              ),
                              child: Obx(
                                () => AppText(
                                  str: sortList[e].ts,
                                  fontSize: 10.sp,
                                  color: controller.sortIndex.value == e
                                      ? AppColors.groupText
                                      : AppColors.textBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ))
          ],
        ),
      ],
    );
  }
}
