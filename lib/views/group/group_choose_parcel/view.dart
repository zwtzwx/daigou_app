import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/parcel_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/group/group_choose_parcel/controller.dart';
import 'package:huanting_shop/views/parcel/widget/parcel_item_cell.dart';

class BeeGroupParcelSelectView extends GetView<BeeGroupParcelSelectController> {
  const BeeGroupParcelSelectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const BackButton(color: Colors.black),
          title: AppText(
            str: '选择包裹'.ts,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.bgGray,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.line))),
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
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                controller.onAllChecked();
                              },
                            ),
                          ),
                          2.horizontalSpace,
                          AppText(
                            str: '全选'.ts,
                          ),
                        ],
                      ),
                      2.verticalSpace,
                      AppText(
                        str: '已选{count}件'.tsArgs({
                              'count': controller.selectedParcelList.length,
                            }) +
                            '，${'预估'.ts} ${(controller.selectedWeight / 1000).toStringAsFixed(2)}${controller.localModel?.weightSymbol}',
                        color: AppColors.textGray,
                        fontSize: 14,
                      ),
                    ],
                  )),
                  10.horizontalSpace,
                  BeeButton(
                    text: '加入拼团',
                    onPressed: controller.onAddGroup,
                    borderRadis: 999,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshView(
            renderItem: renderItem,
            refresh: controller.loadList,
            more: controller.loadMoreList));
  }

  Widget renderItem(index, ParcelModel model) {
    return BeePackageItem(
      model: model,
      index: index,
      checkedIds: controller.selectedParcelList,
      onChecked: controller.onChecked,
      localModel: controller.localModel,
    );
  }
}
