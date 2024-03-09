import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/config/text_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/country_model.dart';
import 'package:shop_app_client/models/ship_line_service_model.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/button/plain_button.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/components/input/input_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/models/express_company_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/parcel/forecast/forecast_controller.dart';
import 'package:shop_app_client/views/parcel/widget/prop_sheet_cell.dart';

/*
  包裹预报
*/
class BeeParcelCreatePage extends GetView<BeeParcelCreateLogic> {
  const BeeParcelCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: AppStyles.bgGray,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '提交转运'.inte,
          fontSize: 17,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              GlobalPages.push(GlobalPages.orderCenter);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 15.w),
              child: AppText(
                str: '到仓商品'.inte,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppStyles.bgGray,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            shipCountry(),
            Obx(() => controller.selectedWarehouseModel.value != null
                ? shipWarehouse()
                : AppGaps.empty),
            Obx(() => parcelListCell()),
            addedInfo(context),
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 30.h),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Obx(() => SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: Checkbox.adaptive(
                          value: controller.agreementBool.value,
                          activeColor: AppStyles.primary,
                          shape: const CircleBorder(),
                          onChanged: (value) {
                            if (value == null) return;
                            controller.agreementBool.value = value;
                          },
                        ),
                      )),
                  5.horizontalSpace,
                  AppText(
                    str: '已阅读并同意'.inte,
                    fontSize: 14,
                  ),
                  GestureDetector(
                    onTap: () {
                      showProtocol(context);
                    },
                    child: AppText(
                      str: '《${'转运协议'.inte}》',
                      color: const Color(0xFFFA9601),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            15.verticalSpaceFromWidth,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: HollowButton(
                        onPressed: controller.onBatchAdd,
                        text: '批量预报',
                        borderWidth: 2,
                        textFontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  15.horizontalSpace,
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: BeeButton(
                        onPressed: controller.onSubmit,
                        text: '提交预报',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  // 寄往国家
  Widget shipCountry() {
    return GestureDetector(
      onTap: () async {
        var tmp = await GlobalPages.push(GlobalPages.country);
        if (tmp == null) return;
        controller.selectedCountryModel.value = tmp as CountryModel;
        controller.getWarehouseList();
        controller.getProps();
      },
      child: decorateBox(
        child: Row(
          children: [
            AppText(
              str: '寄往国家'.inte,
              fontSize: 14,
            ),
            Expanded(
              child: Obx(
                () => AppText(
                  str: controller.selectedCountryModel.value == null
                      ? '请选择国家'.inte
                      : controller.selectedCountryModel.value!.name!,
                  color: controller.selectedCountryModel.value == null
                      ? AppStyles.textGrayC9
                      : AppStyles.textDark,
                  fontSize: 12,
                  alignment: TextAlign.right,
                ),
              ),
            ),
            8.horizontalSpace,
            Icon(
              Icons.arrow_forward_ios,
              size: 13.sp,
              color: AppStyles.textNormal,
            )
          ],
        ),
      ),
    );
  }

  // 寄往仓库
  Widget shipWarehouse() {
    return decorateBox(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  str: '仓库地址'.inte,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 30.h,
                child: BeeButton(
                  text: '复制',
                  onPressed: () {
                    String data =
                        '收件人：${controller.selectedWarehouseModel.value?.receiverName ?? ''}\n'
                        '手机号码：${controller.selectedWarehouseModel.value?.phone ?? ''}\n'
                        '邮编：${controller.selectedWarehouseModel.value?.postcode ?? ''}\n'
                        '收件地址：${controller.selectedWarehouseModel.value?.address ?? ''}';
                    controller.onCopyData(data);
                  },
                ),
              ),
            ],
          ),
          15.verticalSpaceFromWidth,
          Row(
            children: [
              AppText(
                str:
                    controller.selectedWarehouseModel.value?.receiverName ?? '',
                fontSize: 14,
              ),
              10.horizontalSpace,
              Expanded(
                child: AppText(
                  str: controller.selectedWarehouseModel.value?.phone ?? '',
                  fontSize: 14,
                ),
              ),
              AppText(
                str: controller.selectedWarehouseModel.value?.postcode ?? '',
                fontSize: 14,
              ),
            ],
          ),
          10.verticalSpaceFromWidth,
          AppText(
            str: controller.selectedWarehouseModel.value?.address ?? '',
            fontSize: 14,
            lineHeight: 1.4,
            lines: 5,
          ),
        ],
      ),
    );
  }

  Widget decorateBox({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 10.h, 14.w),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: child,
    );
  }

  Widget addedInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Offstage(
            offstage: controller.forecastType.value == 1,
            child: buildAddressInfoView(context),
          ),
        ),
        Obx(
          () => controller.valueAddedServiceList.isNotEmpty
              ? buildAddServiceListView()
              : AppGaps.empty,
        ),
      ],
    );
  }

  // 到件即发地址信息
  Widget buildAddressInfoView(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(13.w, 0, 13.w, 10.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '到件即发'.inte,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          GestureDetector(
            onTap: controller.onAddress,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppStyles.line)),
              ),
              padding: EdgeInsets.symmetric(vertical: 13.w),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xff3540a5),
                  ),
                  10.horizontalSpace,
                  Obx(
                    () => Expanded(
                      child: controller.addressModel.value == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  str: '收件人信息'.inte,
                                  fontSize: 13,
                                ),
                                2.verticalSpace,
                                AppText(
                                  str: '点击选择收件人信息'.inte,
                                  fontSize: 11,
                                  color: AppStyles.textGrayC,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppText(
                                      str: controller
                                          .addressModel.value!.receiverName,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    5.horizontalSpace,
                                    AppText(
                                      str: controller
                                              .addressModel.value!.timezone +
                                          '-' +
                                          controller.addressModel.value!.phone,
                                      fontSize: 13,
                                    ),
                                    5.verticalSpace,
                                  ],
                                ),
                                AppText(
                                  str: controller.addressModel.value!
                                      .getContent(),
                                  fontSize: 13,
                                  lines: 4,
                                ),
                              ],
                            ),
                    ),
                  ),
                  10.horizontalSpace,
                  AppText(
                    str: '地址簿'.inte,
                    color: AppStyles.textGrayC,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.onLine,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppStyles.line)),
              ),
              padding: EdgeInsets.symmetric(vertical: 13.w),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFF16F45),
                  ),
                  10.horizontalSpace,
                  Obx(
                    () => Expanded(
                      child: controller.lineModel.value == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  str: '运送方式'.inte,
                                  fontSize: 13,
                                ),
                                2.verticalSpace,
                                AppText(
                                  str: '点击选择运送方式'.inte,
                                  fontSize: 11,
                                  color: AppStyles.textGrayC,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  str: controller.lineModel.value!.name,
                                  fontSize: 13,
                                ),
                                2.verticalSpace,
                                AppText(
                                  str: '时效'.inte +
                                      '：' +
                                      (controller.lineModel.value!.region
                                              ?.referenceTime ??
                                          ''),
                                  fontSize: 13,
                                ),
                              ],
                            ),
                    ),
                  ),
                  10.horizontalSpace,
                  AppText(
                    str: '请选择'.inte,
                    color: AppStyles.textGrayC,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          Obx(
            () => controller.lineModel.value != null &&
                    (controller.lineModel.value!.region?.services ?? [])
                        .isNotEmpty
                ? buildLineServiceView(context)
                : AppGaps.empty,
          ),
          AppText(
            str: '下单备注'.inte,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          10.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: BaseInput(
              controller: controller.remarkController,
              focusNode: controller.remarkNode,
              board: true,
              contentPadding: EdgeInsets.all(10.w),
              hintText: '给打包小哥捎话'.inte,
              maxLines: 8,
              autoShowRemove: false,
              minLines: 3,
              maxLength: 500,
            ),
          )
        ],
      ),
    );
  }

  // 渠道增值服务
  Widget buildLineServiceView(BuildContext context) {
    List<Widget> listView = [];
    for (ShipLineServiceModel item
        in controller.lineModel.value!.region!.services!) {
      String second = '';
      String third = '';
      // 1 运费比例 2固定费用 3单箱固定费用 4单位计费重量固定费用 5单位实际重量固定费用 6申报价值比列
      switch (item.type) {
        case 1:
          second = '实际运费'.inte + (item.value / 100).toStringAsFixed(2) + '%';
          break;
        case 2:
          second = item.value.priceConvert();
          break;
        case 3:
          second = item.value.priceConvert() + '/${'箱'.inte}';
          break;
        case 4:
          second = item.value.priceConvert() +
              '/' +
              (controller.localModel?.weightSymbol ?? '');
          third = '(${'计费重'.inte})';
          break;
        case 5:
          second = item.value.priceConvert() +
              '/' +
              (controller.localModel?.weightSymbol ?? '');
          third = '(${'实重'.inte})';
          break;
        case 6:
          second = '申报价值'.inte + (item.value / 100).toStringAsFixed(2) + '%';

          break;
        default:
      }
      var view = SizedBox(
        height: 50,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 49,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AppText(str: item.name),
                      Container(
                        height: 49,
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppStyles.textBlack,
                                  fontSize: 10.0,
                                ),
                              ),
                              TextSpan(
                                text: second,
                                style: const TextStyle(
                                  color: AppStyles.textRed,
                                  fontSize: 15.0,
                                ),
                              ),
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppStyles.textBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: third,
                                style: const TextStyle(
                                  color: AppStyles.textDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      item.remark.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.error_outline_outlined,
                                  color: AppStyles.green,
                                  size: 25,
                                ),
                                onPressed: () {
                                  controller.showRemark(item.name, item.remark);
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Obx(
                    () => Switch.adaptive(
                      value: controller.LineServiceId.contains(item.id),
                      activeColor: AppStyles.green,
                      onChanged: (value) {
                        if (item.isForced == 1) return;
                        if (controller.LineServiceId.contains(item.id)) {
                          controller.LineServiceId.remove(item.id);
                        } else {
                          controller.LineServiceId.add(item.id);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            AppGaps.line
          ],
        ),
      );
      listView.add(view);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          str: '渠道增值服务'.inte,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        ...listView,
        10.verticalSpace,
      ],
    );
  }

  // 增值服务
  Widget buildAddServiceListView() {
    List<Widget> addValueWigets = [];
    for (var item in controller.valueAddedServiceList) {
      var listTitle = Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppStyles.textDark,
                ),
                children: [
                  TextSpan(
                    text: item.value.content,
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 5.w),
                      child: AppText(
                        str: (item.value.charge ?? 0).priceConvert(),
                        color: AppStyles.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (item.value.remark.isNotEmpty)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          controller.showRemark(
                              item.value.content, item.value.remark);
                        },
                        child: Icon(
                          Icons.help,
                          color: AppStyles.green,
                          size: 18.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Switch.adaptive(
            value: item.value.isOpen,
            activeColor: AppStyles.primary,
            onChanged: (value) {
              item.value.isOpen = value;
              item.refresh();
            },
          ),
        ],
      );
      addValueWigets.add(listTitle);
    }

    return decorateBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '到仓服务'.inte,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          ...addValueWigets,
        ],
      ),
    );
  }

  Widget parcelListCell() {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: parcelItemCell,
      itemCount: controller.formData.length,
    );
    return listView;
  }

  // 包裹
  Widget parcelItemCell(BuildContext context, int index) {
    final model = controller.formData[index];

    return decorateBox(
      padding: EdgeInsets.only(left: 14.w),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // GestureDetector(
            //   onTap: () async {
            //     FocusScope.of(context).requestFocus(FocusNode());
            //     Picker(
            //       adapter: PickerDataAdapter(
            //           data: getPickerExpressCompany(
            //               controller.expressCompanyList)),
            //       cancelText: '取消'.inte,
            //       confirmText: '确认'.inte,
            //       selectedTextStyle:
            //           const TextStyle(color: Colors.blue, fontSize: 12),
            //       onCancel: () {},
            //       onConfirm: (Picker picker, List value) {
            //         model.value.expressName =
            //             controller.expressCompanyList[value.first].name;
            //         model.value.expressId =
            //             controller.expressCompanyList[value.first].id;
            //       },
            //     ).showModal(context);
            //   },
            //   child: InputTextItem(
            //       title: '快递名称'.inte,
            //       leftFlex: 2,
            //       isRequired: true,
            //       bgColor: Colors.transparent,
            //       inputText: Container(
            //         alignment: Alignment.center,
            //         margin: const EdgeInsets.only(left: 11),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: <Widget>[
            //             Text(
            //               model.value.expressName ?? '请选择快递名称'.inte,
            //               style: model.value.expressName != null
            //                   ? SizeConfig.textDark14
            //                   : SizeConfig.textGray14,
            //             ),
            //             const Padding(
            //               padding:
            //                   EdgeInsets.only(right: 15, top: 10, bottom: 10),
            //               child: Icon(
            //                 Icons.arrow_forward_ios,
            //                 color: AppStyles.textBlack,
            //                 size: 18,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )),
            // ),
            InputTextItem(
              title: '快递单号'.inte,
              leftFlex: 2,
              flag: false,
              isRequired: true,
              margin: const EdgeInsets.only(left: 0),
              inputText: BaseInput(
                hintText: '请输入快递单号'.inte,
                contentPadding: EdgeInsets.only(right: 13.w),
                textAlign: TextAlign.right,
                controller: model.value.editControllers!.numController,
                focusNode: model.value.editControllers!.numNode,
                maxLength: 40,
                autoRemoveController: false,
                autoShowRemove: false,
                onChanged: (res) {
                  model.value.expressNum = res;
                },
                keyName: '',
              ),
              addedWidget: controller.formData.length > 1
                  ? Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: GestureDetector(
                        onTap: () {
                          controller.onDeleteParcel(index);
                        },
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    )
                  : null,
            ),
            // InputTextItem(
            //   title: "物品名称".inte,
            //   inputText: BaseInput(
            //     hintText: '请输入物品名称'.inte,
            //     textAlign: TextAlign.right,
            //     controller: model.value.editControllers!.nameController,
            //     focusNode: model.value.editControllers!.nameNode,
            //     contentPadding: EdgeInsets.only(right: 13.w),
            //     autoShowRemove: false,
            //     autoRemoveController: false,
            //     keyboardType: TextInputType.text,
            //     onSubmitted: (res) {
            //       FocusScope.of(context)
            //           .requestFocus(model.value.editControllers!.valueNode);
            //     },
            //     onChanged: (res) {
            //       model.value.packageName = res;
            //     },
            //     keyName: '',
            //   ),
            // ),
            // InputTextItem(
            //   leftFlex: 3,
            //   title: '物品价值'.inte + '(${controller.currencyModel.value?.symbol})',
            //   inputText: BaseInput(
            //       hintText: '请输入物品价值'.inte,
            //       textAlign: TextAlign.right,
            //       controller: model.value.editControllers!.valueController,
            //       contentPadding: EdgeInsets.only(right: 13.w),
            //       focusNode: model.value.editControllers!.valueNode,
            //       autoShowRemove: false,
            //       autoRemoveController: false,
            //       keyboardType:
            //           const TextInputType.numberWithOptions(decimal: true),
            //       onSubmitted: (res) {
            //         FocusScope.of(context)
            //             .requestFocus(model.value.editControllers!.remarkNode);
            //       },
            //       onChanged: (res) {
            //         if (double.tryParse(res) != null) {
            //           model.value.packageValue = double.parse(res);
            //         }
            //       }),
            // ),
            GestureDetector(
              onTap: () async {
                // 属性选择框
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return PropSheetCell(
                        goodsPropsList: controller.goodsPropsList,
                        propSingle: false,
                        prop: model.value.prop,
                        onConfirm: (data) {
                          model.value.prop = data;
                          model.refresh();
                        },
                      );
                    });
              },
              child: InputTextItem(
                title: '物品类型'.inte,
                flag: false,
                margin: const EdgeInsets.only(left: 0),
                inputText: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Obx(
                            () => Text(
                              model.value.prop == null
                                  ? '请选择物品属性'.inte
                                  : model.value.prop!
                                      .map((e) => e.name)
                                      .join(' '),
                              style: model.value.prop == null
                                  ? SizeConfig.textGray14
                                  : SizeConfig.textDark14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 13.w, top: 8.w, bottom: 8.w, left: 10.w),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppStyles.textBlack,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // InputTextItem(
            //     leftFlex: 5,
            //     rightFlex: 5,
            //     title: '商品数量'.inte,
            //     inputText: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: <Widget>[
            //         Container(
            //           alignment: Alignment.center,
            //           child: IconButton(
            //               icon: Obx(
            //                 () => Icon(
            //                   model.value.qty == 1
            //                       ? Icons.remove_circle
            //                       : Icons.remove_circle,
            //                   color: model.value.qty == 1
            //                       ? AppStyles.textGray
            //                       : AppStyles.primary,
            //                   size: 35,
            //                 ),
            //               ),
            //               onPressed: () {
            //                 int k = model.value.qty!;
            //                 if (k == 1) {
            //                   return;
            //                 }
            //                 k--;
            //                 model.value.qty = k;
            //                 model.refresh();
            //               }),
            //         ),
            //         Container(
            //           margin: const EdgeInsets.symmetric(horizontal: 20),
            //           alignment: Alignment.center,
            //           child: Obx(
            //             () => Text(
            //               model.value.qty.toString(),
            //               style: const TextStyle(fontSize: 20),
            //             ),
            //           ),
            //         ),
            //         Container(
            //           alignment: Alignment.center,
            //           child: IconButton(
            //               icon: const Icon(
            //                 Icons.add_circle,
            //                 color: AppStyles.primary,
            //                 size: 35,
            //               ),
            //               onPressed: () {
            //                 int k = model.value.qty!;
            //                 k++;

            //                 model.value.qty = k;
            //                 model.refresh();
            //               }),
            //         )
            //       ],
            //     )),
            10.verticalSpaceFromWidth,
            AppText(
              str: '备注'.inte,
              fontSize: 14,
            ),
            10.verticalSpaceFromWidth,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
              ),
              margin: EdgeInsets.only(right: 14.w),
              clipBehavior: Clip.none,
              child: BaseInput(
                hintText: '请填写备注信息'.inte,
                board: true,
                minLines: 5,
                maxLines: 7,
                maxLength: 300,
                controller: model.value.editControllers!.remarkController,
                focusNode: model.value.editControllers!.remarkNode,
                autoShowRemove: false,
                contentPadding: EdgeInsets.all(10.w),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                autoRemoveController: false,
                onSubmitted: (res) {
                  FocusScope.of(context).requestFocus(controller.blankNode);
                },
                onChanged: (res) {
                  model.value.remark = res;
                },
              ),
            ),
            14.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  getPickerExpressCompany(List<ExpressCompanyModel> list) {
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

  // 转运协议
  showProtocol(BuildContext context) {
    BaseDialog.normalDialog(
      context,
      title: controller.terms['title'],
      child: Flexible(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Html(data: controller.terms['content']),
          ),
        ),
      ),
    );
  }
}
