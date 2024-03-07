import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/line/query/line_query_controller.dart';

class LineQueryView extends GetView<LineQueryController> {
  const LineQueryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          title: AppText(
            str: '运费估算'.ts,
            fontSize: 17,
            color: Colors.white,
          ),
          leading: const BackButton(color: Colors.white),
        ),
        bottomNavigationBar: SafeArea(
            child: Container(
          height: 38.h,
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: BeeButton(
            text: '立即查询',
            onPressed: controller.onSubmit,
          ),
        )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              shipInfo(context),
              queryItemCell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget queryTitle(String title, {bool isRequired = true}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: title,
          ),
          if (isRequired)
            const TextSpan(
              text: '*',
              style: TextStyle(
                color: AppColors.textRed,
              ),
            ),
        ],
      ),
    );
  }

  Widget queryItemCell() {
    var mainView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          queryTitle('重量'.ts + '(${controller.localModel?.weightSymbol})'),
          BaseInput(
            isCollapsed: true,
            autoShowRemove: false,
            controller: controller.weightController,
            focusNode: controller.weightNode,
            hintText: '请输入包裹重量'.ts,
            hintStyle: TextStyle(color: AppColors.textGrayC9, fontSize: 12.sp),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          15.verticalSpaceFromWidth,
          queryTitle('包裹尺寸'.ts + '(${controller.localModel?.lengthSymbol})',
              isRequired: false),
          15.verticalSpaceFromWidth,
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: const Color(0xFFEDEDED)),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 14.w),
                  child: BaseInput(
                    textAlign: TextAlign.center,
                    controller: controller.longController,
                    focusNode: controller.longNode,
                    autoShowRemove: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    hintStyle:
                        TextStyle(color: AppColors.textGrayC9, fontSize: 12.sp),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    hintText: '长'.ts,
                  ),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: const Color(0xFFEDEDED)),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 14.w),
                  child: BaseInput(
                    textAlign: TextAlign.center,
                    controller: controller.wideController,
                    focusNode: controller.wideNode,
                    autoShowRemove: false,
                    hintStyle:
                        TextStyle(color: AppColors.textGrayC9, fontSize: 12.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    hintText: '宽'.ts,
                  ),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: const Color(0xFFEDEDED)),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 14.w),
                  child: BaseInput(
                    textAlign: TextAlign.center,
                    controller: controller.highController,
                    focusNode: controller.highNode,
                    autoShowRemove: false,
                    hintStyle:
                        TextStyle(color: AppColors.textGrayC9, fontSize: 12.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    hintText: '高'.ts,
                  ),
                ),
              ),
            ],
          ),
          20.verticalSpaceFromWidth,
          queryTitle('物品分类'.ts),
          15.verticalSpaceFromWidth,
          GestureDetector(
            onTap: () async {
              var s =
                  await BeeNav.push(BeeNav.goodsCategory, arg: {'props': true});
              if (s != null) {
                controller.category.value = s;
              }
              // Get.bottomSheet(
              //   PropSheetCell(
              //     goodsPropsList: controller.propList,
              //     propSingle: false,
              //     prop: controller.selectPropList,
              //     onConfirm: (data) {
              //       controller.selectPropList.value = data;
              //     },
              //   ),
              //   backgroundColor: Colors.white,
              // );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => AppText(
                        str: controller.category.value != null
                            ? controller.category.value!.name
                            : '请选择物品分类'.ts,
                        fontSize: 14,
                        color: controller.category.value != null
                            ? AppColors.textDark
                            : AppColors.textGrayC9,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textNormal,
                    size: 12.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return mainView;
  }

  Widget selectItem(
    String label, {
    Widget? rightItem,
    String? value,
    Function? onSelect,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: AppText(
                    str: label.ts,
                    lines: 3,
                  ),
                ),
                AppGaps.hGap5,
                Flexible(
                  child: AppText(
                    str: '必填'.ts,
                    color: const Color(0xFFF68456),
                    fontSize: 14,
                    lines: 3,
                  ),
                ),
              ],
            ),
          ),
          rightItem ??
              GestureDetector(
                onTap: () {
                  onSelect!();
                },
                child: Row(
                  children: [
                    AppText(
                      str: value ?? '请选择'.ts,
                      color: (value != null && value.isNotEmpty)
                          ? AppColors.textDark
                          : AppColors.textGray,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget shipInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(14.w, 25.h, 14.w, 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Picker(
                  adapter:
                      PickerDataAdapter(data: controller.getWarehousePicker()),
                  cancelText: '取消'.ts,
                  confirmText: '确认'.ts,
                  selectedTextStyle:
                      const TextStyle(color: Colors.blue, fontSize: 12),
                  onCancel: () {},
                  onConfirm: (Picker picker, List value) {
                    controller.selectWareHouse.value =
                        controller.list[value.first];
                  },
                ).showModal(context);
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Obx(
                      () => AppText(
                        str: controller.selectWareHouse.value != null
                            ? controller.selectWareHouse.value!.warehouseName!
                            : '请选择'.ts,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    5.verticalSpaceFromWidth,
                    AppText(
                      str: '出发地'.ts,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          15.horizontalSpace,
          LoadAssetImage(
            'Home/ship',
            width: 90.w,
            fit: BoxFit.fitWidth,
            color: Colors.white,
          ),
          15.horizontalSpace,
          Flexible(
            child: GestureDetector(
              onTap: controller.onCountry,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Obx(
                      () => AppText(
                        str: controller.selectCountry.value != null
                            ? controller.selectCountry.value!.name!
                            : '请选择'.ts,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    5.verticalSpaceFromWidth,
                    AppText(
                      str: '收货地'.ts,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
