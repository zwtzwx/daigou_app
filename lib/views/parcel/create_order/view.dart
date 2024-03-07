import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/insurance_item_model.dart';
import 'package:huanting_shop/models/parcel_model.dart';
import 'package:huanting_shop/models/tariff_item_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/line/widget/line_item_widget.dart';
import 'package:huanting_shop/views/parcel/create_order/controller.dart';

class BeePackingView extends GetView<BeePackingLogic> {
  const BeePackingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: controller.pageTitle.value,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(14.w, 15.h, 14.w, 10.h),
                child: AppText(
                  str: '您本次选择{count}个包裹'
                      .tsArgs({'count': controller.packageList.length}),
                  fontSize: 14,
                ),
              ),
              Obx(() => parcelList()),
              5.verticalSpaceFromWidth,
              addressInfo(),
              15.verticalSpaceFromWidth,
              lineInfo(),
              15.verticalSpaceFromWidth,
              Obx(() => (controller.serviceList.isNotEmpty ||
                          (controller.shipLineModel.value?.region?.services ??
                                  [])
                              .isNotEmpty) ||
                      (controller.insuranceModel.value?.enabled == 1 &&
                          controller.insuranceModel.value!.enabledLineIds
                              .contains(controller.shipLineModel.value?.id)) ||
                      (controller.tariffModel.value?.enabled == 1 &&
                          controller.tariffModel.value!.enabledLineIds
                              .contains(controller.shipLineModel.value?.id))
                  ? serviceList(context)
                  : AppGaps.empty),
              remarkInfo(),
              30.verticalSpaceFromWidth,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                height: 38.h,
                width: double.infinity,
                child: BeeButton(
                  text: '提交',
                  onPressed: controller.onSubmit,
                ),
              ),
              30.verticalSpaceFromWidth,
            ],
          ),
        ),
      ),
    );
  }

  // 包裹列表
  Widget parcelList() {
    List<Widget> viewList = [];
    for (var i = 0; i < controller.packageList.length; i++) {
      ParcelModel model = controller.packageList[i];
      var view = Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AppText(
                        fontSize: 14,
                        str: model.expressNum ?? '',
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        fontSize: 14,
                        str: model.country?.name ?? '',
                      ),
                    ],
                  ),
                ),
                10.verticalSpaceFromWidth,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AppText(
                      str: model.prop?.map((e) => e.name).join(' ') ?? '',
                      fontSize: 14,
                    ),
                    Row(
                      children: <Widget>[
                        AppText(
                          str: (model.packageValue ?? 0).rate(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        AppGaps.hGap10,
                        AppText(
                          str: ((model.packageWeight ?? 0) / 1000)
                                  .toStringAsFixed(2) +
                              controller.localModel!.weightSymbol,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      );
      viewList.add(view);
    }
    return Column(
      children: viewList,
    );
  }

  // 收货地址
  Widget addressInfo() {
    return GestureDetector(
      onTap: controller.onAddress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.only(right: 15.w, bottom: 15.h),
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            5.verticalSpaceFromWidth,
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(999)),
                    color: AppColors.primary,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  child: AppText(
                    str: '收货地址'.ts,
                    fontSize: 12,
                  ),
                ),
                Obx(() => controller.selectedAddressModel.value != null
                    ? Expanded(
                        child: AppText(
                          str: controller.selectedAddressModel.value!
                                      .addressType ==
                                  1
                              ? '送货上门'.ts
                              : '自提收货'.ts,
                          fontSize: 13,
                          alignment: TextAlign.right,
                        ),
                      )
                    : AppGaps.empty)
              ],
            ),
            10.verticalSpaceFromWidth,
            Obx(
              () => controller.selectedAddressModel.value == null
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 22.sp,
                          ),
                          2.horizontalSpace,
                          AppText(
                            str: '请选择收货地址'.ts,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  str: controller.selectedAddressModel.value!
                                          .receiverName +
                                      '  ' +
                                      controller.selectedAddressModel.value!
                                          .timezone +
                                      '-' +
                                      controller
                                          .selectedAddressModel.value!.phone,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  lines: 2,
                                ),
                                6.verticalSpaceFromWidth,
                                if (controller.selectedAddressModel.value!
                                        .addressType ==
                                    2) ...[
                                  AppText(
                                    str: controller.selectedAddressModel.value!
                                            .station?.name ??
                                        '',
                                    fontSize: 14,
                                    lines: 2,
                                  ),
                                  6.verticalSpaceFromWidth,
                                ],
                                AppText(
                                  str: controller.selectedAddressModel.value!
                                      .getContent(),
                                  fontSize: 14,
                                  lines: 10,
                                ),
                              ],
                            ),
                          ),
                          10.horizontalSpace,
                          if (!controller.isGroup.value)
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 渠道
  Widget lineInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.onLine,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      str: '物流方案'.ts,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!controller.isGroup.value)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                    ),
                ],
              ),
            ),
          ),
          Obx(() => controller.shipLineModel.value != null
              ? Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.line)),
                  ),
                  padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                  child: LineItemWidget(
                    model: controller.shipLineModel.value!,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    showLineType: false,
                  ),
                )
              : AppGaps.empty)
        ],
      ),
    );
  }

  // 增值服务
  Widget serviceList(BuildContext context) {
    if (controller.insuranceModel.value?.enabled == 1) {
      for (InsuranceItemModel item in controller.insuranceModel.value!.items) {
        if (item.start < controller.totalValue.value) {
          // print(item.start.toString());
          controller.firstMust.value = (item.isForce == 1);
          if (item.insuranceType == 1) {
            var tempValue = (controller.totalValue.value / 100) *
                (item.insuranceProportion / 100);
            var maxValue = (item.max ?? 0) / 100;
            controller.firstStr.value =
                (tempValue > maxValue && maxValue != 0 ? maxValue : tempValue)
                    .toStringAsFixed(2);
          } else {
            controller.firstStr.value =
                item.insuranceProportion.toStringAsFixed(2);
          }
        }
      }
    }
    if (controller.tariffModel.value?.enabled == 1) {
      for (TariffItemModel item in controller.tariffModel.value!.items) {
        if (item.amount < controller.totalValue.value) {
          controller.secondMust.value = (item.enforce == 1);
          if (item.type == 1) {
            controller.secondStr.value =
                ((controller.totalValue.value / 100) * (item.amount / 10000))
                    .toStringAsFixed(2);
          } else {
            controller.secondStr.value = item.amount.toStringAsFixed(2);
          }
        }
      }
    }

    var bottomView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: AppText(
              str: '增值服务'.ts,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGaps.line,
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 0, 10.w, 15.h),
            child: Column(
              children: [
                if ((controller.insuranceModel.value?.enabled == 1 &&
                    controller.insuranceModel.value!.enabledLineIds
                        .contains(controller.shipLineModel.value?.id)))
                  serviceItem(
                    checked: controller.firstMust.value
                        ? controller.firstMust.value
                        : controller.insuranceServices.value,
                    onChecked: (value) {
                      controller.insuranceServices.value = value!;
                    },
                    name: '保险服务'.ts,
                    price: num.parse(controller.firstStr.value)
                        .rate(needFormat: false),
                    remark: controller.insuranceModel.value!.explanation,
                  ),
                if ((controller.tariffModel.value?.enabled == 1 &&
                    controller.tariffModel.value!.enabledLineIds
                        .contains(controller.shipLineModel.value?.id)))
                  serviceItem(
                    checked: controller.secondMust.value
                        ? controller.secondMust.value
                        : controller.customsService.value,
                    onChecked: (value) {
                      controller.customsService.value = value!;
                    },
                    name: '关税服务'.ts,
                    price: num.parse(controller.secondStr.value)
                        .rate(needFormat: false),
                    remark: controller.tariffModel.value!.explanation,
                  ),
                // 订单增值服务
                ...controller.serviceList.map(
                  (service) => serviceItem(
                    checked: controller.orderServiceId.contains(service.id),
                    onChecked: (value) {
                      if (value!) {
                        controller.orderServiceId.add(service.id);
                      } else {
                        controller.orderServiceId.remove(service.id);
                      }
                    },
                    name: service.name!,
                    price: service.price!.rate(),
                    remark: service.remark,
                  ),
                ),
                // 渠道增值服务
                ...(controller.shipLineModel.value?.region?.services ?? [])
                    .map((lineService) {
                  String price = controller.getLineServiceType(lineService);
                  return serviceItem(
                    checked: controller.lineServiceId.contains(lineService.id),
                    onChecked: (value) {
                      if (lineService.isForced == 1) return;
                      if (value!) {
                        controller.lineServiceId.add(lineService.id);
                      } else {
                        controller.lineServiceId.remove(lineService.id);
                      }
                    },
                    name: lineService.name,
                    price: price,
                    remark: lineService.remark,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
    return bottomView;
  }

  Widget serviceItem({
    required bool checked,
    required Function(bool? value) onChecked,
    required String name,
    required String price,
    String? remark,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox.adaptive(
              value: checked,
              onChanged: onChecked,
              activeColor: AppColors.primary,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14.sp,
                ),
                children: [
                  TextSpan(
                    text: name,
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: AppText(
                        str: price,
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  if ((remark ?? '').isNotEmpty)
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          controller.showRemark(name, remark!);
                        },
                        child: Icon(
                          Icons.help,
                          color: AppColors.green,
                          size: 18.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 备注
  Widget remarkInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            str: '备注'.ts,
            fontWeight: FontWeight.bold,
          ),
          10.verticalSpaceFromWidth,
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgGray,
              borderRadius: BorderRadius.circular(8.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: BaseInput(
              controller: controller.remarkController,
              focusNode: null,
              board: true,
              maxLines: 5,
              minLines: 5,
              maxLength: 200,
              autoRemoveController: false,
              keyboardType: TextInputType.multiline,
              hintText: '请输入打包备注'.ts,
              contentPadding: EdgeInsets.all(10.w),
            ),
          ),
        ],
      ),
    );
  }
}
