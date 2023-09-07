import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/group/group_choose_parcel/controller.dart';
import 'package:jiyun_app_client/views/parcel/widget/parcel_item_cell.dart';

class GroupChooseParcelPage extends GetView<GroupChooseParcelController> {
  const GroupChooseParcelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const BackButton(color: Colors.black),
          title: ZHTextLine(
            str: '选择包裹'.ts,
            fontSize: 18,
          ),
        ),
        backgroundColor: BaseStylesConfig.bgGray,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: BaseStylesConfig.line))),
          child: SafeArea(
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: Checkbox(
                              value: controller.selectAll.value,
                              shape: const CircleBorder(),
                              activeColor: BaseStylesConfig.primary,
                              checkColor: Colors.black,
                              onChanged: (value) {
                                controller.onAllChecked();
                              },
                            ),
                          ),
                          2.horizontalSpace,
                          ZHTextLine(
                            str: '全选'.ts,
                          ),
                        ],
                      ),
                      2.verticalSpace,
                      ZHTextLine(
                        str: '已选{count}件'.tsArgs({
                              'count': controller.selectedParcelList.length,
                            }) +
                            '，${'预估'.ts} ${(controller.selectedWeight / 1000).toStringAsFixed(2)}${controller.localModel?.weightSymbol}',
                        color: BaseStylesConfig.textGray,
                        fontSize: 14,
                      ),
                    ],
                  )),
                  10.horizontalSpace,
                  MainButton(
                    text: '加入拼团',
                    onPressed: controller.onAddGroup,
                    borderRadis: 999,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListRefresh(
            renderItem: renderItem,
            refresh: controller.loadList,
            more: controller.loadMoreList));
  }

  Widget renderItem(index, ParcelModel model) {
    return ParcelItemCell(
      model: model,
      index: index,
      checkedIds: controller.selectedParcelList,
      onChecked: controller.onChecked,
      localModel: controller.localModel,
    );
  }
}
