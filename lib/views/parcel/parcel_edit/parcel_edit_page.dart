/*
  未入库包裹修改页面
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/express_company_model.dart';
import 'package:shop_app_client/models/warehouse_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/parcel/parcel_edit/parcel_edit_controller.dart';
import 'package:shop_app_client/views/parcel/widget/prop_sheet_cell.dart';

class BeePackageUpdatePage extends GetView<BeePackageUpdateLogic> {
  const BeePackageUpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '修改包裹'.inte,
          fontSize: 17,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Obx(() => controller.isLoadingLocal.value
                ? Column(
                    children: [
                      goodsCell(context),
                      15.verticalSpaceFromWidth,
                      parcelCell(context),
                      50.verticalSpaceFromWidth,
                      Container(
                        height: 38.h,
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: BeeButton(
                          text: '确认',
                          onPressed: controller.onSubmit,
                        ),
                      ),
                      20.verticalSpaceFromWidth,
                    ],
                  )
                : AppGaps.empty)),
      ),
    );
  }

  // 选择快递公司
  onPickerExpressName(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(
          data: getExpressItem(controller.expressCompanyList)),
      cancelText: '取消'.inte,
      confirmText: '确认'.inte,
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        controller.expressCompany.value =
            controller.expressCompanyList[value.first];
      },
    ).showModal(context);
  }

  // 快递单号、快递公司
  Widget goodsCell(BuildContext context) {
    return Container(
      color: AppStyles.white,
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AppText(
              fontWeight: FontWeight.bold,
              str: '商品信息'.inte,
            ),
          ),
          AppGaps.line,
          goodsOtherCell(),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '物品属性'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          // 属性选择框
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Obx(
                                  () => PropSheetCell(
                                    goodsPropsList: controller.propList,
                                    propSingle: controller.propSingle.value,
                                    prop: controller.selectedProps,
                                    onConfirm: (data) {
                                      controller.selectedProps.value = data;
                                    },
                                  ),
                                );
                              });
                        },
                        child: Container(
                          color: AppStyles.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Obx(
                                  () => AppText(
                                    str: controller.selectedProps
                                        .map((e) => e.name)
                                        .join(' '),
                                    lines: 2,
                                    alignment: TextAlign.right,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: AppStyles.textGray,
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '商品备注'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Expanded(
                    child: BaseInput(
                  hintText: '请输入备注'.inte,
                  controller: controller.remarkController,
                  focusNode: controller.remarkNode,
                  contentPadding: const EdgeInsets.all(0),
                  isCollapsed: true,
                  autoShowRemove: false,
                  maxLines: 5,
                  minLines: 2,
                  textAlign: TextAlign.right,
                  maxLength: 200,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 没有商品详细清单
  Widget goodsOtherCell() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '物品名称'.inte,
                  color: AppStyles.textNormal,
                ),
              ),
              Expanded(
                  child: BaseInput(
                hintText: '请输入物品名称'.inte,
                controller: controller.packgeNameController,
                focusNode: controller.packageNameNode,
                contentPadding: const EdgeInsets.all(0),
                isCollapsed: true,
                autoShowRemove: false,
                textAlign: TextAlign.right,
                maxLines: 1,
              )),
            ],
          ),
        ),
        AppGaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '物品总价'.inte,
                  color: AppStyles.textNormal,
                ),
              ),
              Expanded(
                  child: BaseInput(
                hintText: '请输入物品总价'.inte,
                controller: controller.packgeValueController,
                focusNode: controller.packageValueNode,
                contentPadding: const EdgeInsets.all(0),
                isCollapsed: true,
                textAlign: TextAlign.right,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autoShowRemove: false,
                maxLines: 1,
              )),
              // AppText(
              //     str: (packageModel.packageValue! / 100).toStringAsFixed(2))
            ],
          ),
        ),
        AppGaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '物品数量'.inte,
                  color: AppStyles.textNormal,
                ),
              ),
              Expanded(
                  child: BaseInput(
                hintText: '请输入物品数量'.inte,
                controller: controller.packgeQtyController,
                focusNode: controller.packageQtyNode,
                contentPadding: const EdgeInsets.all(0),
                isCollapsed: true,
                keyboardType: TextInputType.number,
                autoShowRemove: false,
                textAlign: TextAlign.right,
                maxLines: 1,
              )),
              // AppText(
              //   str: packageModel.qty.toString(),
              // )
            ],
          ),
        ),
      ],
    );
  }

  // 发往国家、发往仓库
  Widget parcelCell(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AppText(
              fontWeight: FontWeight.bold,
              str: '包裹信息'.inte,
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '快递名称'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          onPickerExpressName(context);
                        },
                        child: Container(
                          color: AppStyles.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              AppText(
                                str: controller.expressCompany.value == null
                                    ? controller.packageModel.value.expressName!
                                    : controller.expressCompany.value!.name,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: AppStyles.textGray,
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '快递单号'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                AppText(
                  str: controller.packageModel.value.expressNum!,
                )
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '发往国家'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.goCountry();
                        },
                        child: Container(
                          color: AppStyles.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              AppText(
                                  str: controller.countryModel.value == null
                                      ? (controller
                                                  .packageModel.value.country !=
                                              null
                                          ? controller
                                              .packageModel.value.country!.name!
                                          : '')
                                      : controller.countryModel.value!.name!),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: AppStyles.textGray,
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '发往仓库'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if ((controller.packageModel.value.status == 2 &&
                              controller.packageModel.value.warehouse !=
                                  null)) {
                            return;
                          }
                          Picker(
                            adapter: PickerDataAdapter(
                                data:
                                    getWarehouseItem(controller.wareHouseList)),
                            cancelText: '取消'.inte,
                            confirmText: '确认'.inte,
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                            onCancel: () {},
                            onConfirm: (Picker picker, List value) {
                              controller.packageModel.value.warehouse =
                                  controller.wareHouseList[value.first];
                            },
                          ).showModal(context);
                        },
                        child: Container(
                          color: AppStyles.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              AppText(
                                  str: controller.packageModel.value.warehouse
                                          ?.warehouseName ??
                                      ''),
                              (controller.packageModel.value.status == 1 ||
                                      (controller.packageModel.value.status ==
                                              2 &&
                                          controller.packageModel.value
                                                  .warehouse ==
                                              null))
                                  ? const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppStyles.textGray,
                                    )
                                  : Container()
                            ],
                          ),
                        )))
              ],
            ),
          ),
        ],
      ),
    );
  }

  getExpressItem(List<ExpressCompanyModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: AppText(
          fontSize: 24,
          str: item.name,
        ),
      );
      data.add(containe);
    }
    return data;
  }

  getWarehouseItem(List<WareHouseModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: AppText(
          fontSize: 24,
          str: item.warehouseName!,
        ),
      );
      data.add(containe);
    }
    return data;
  }
}
