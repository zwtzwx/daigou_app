import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/ship_line_service_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/parcel/forecast/forecast_controller.dart';
import 'package:jiyun_app_client/views/parcel/widget/prop_sheet_cell.dart';

/*
  包裹预报
*/
class ForecastParcelView extends GetView<ForecastController> {
  const ForecastParcelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '包裹预报'.ts,
          fontSize: 18,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildCustomViews(context),
              parcelListCell(context),
              buildBottomListView(context),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Obx(
                      () => TextButton.icon(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () {
                          controller.agreementBool.value =
                              !controller.agreementBool.value;
                        },
                        icon: controller.agreementBool.value
                            ? const Icon(
                                Icons.check_circle_outline,
                                color: AppColors.green,
                              )
                            : const Icon(
                                Icons.circle_outlined,
                                color: AppColors.textGray,
                              ),
                        label: AppText(
                          str: '我已阅读并同意'.ts,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showProtocol(context);
                      },
                      child: AppText(
                        str: '《${'转运协议'.ts}》',
                        color: HexToColor('#fe8b25'),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                height: 50,
                child: MainButton(
                  onPressed: controller.onSubmit,
                  text: '提交预报',
                ),
              ),
              30.verticalSpace,
              // AppGaps.vGap15,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Column(
      children: <Widget>[
        10.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Routers.push(Routers.help);
                },
                child: AppText(
                  str: '初次使用包裹转运'.ts,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Routers.push(Routers.warehouse);
                },
                child: AppText(
                  str: '查看仓库地址'.ts,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        buildHeaderView(context),
      ],
    );
    return headerView;
  }

  Widget buildHeaderView(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              controller.onForecastType(context);
            },
            child: InputTextItem(
              title: '下单方式'.ts,
              bgColor: Colors.transparent,
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
                            (controller.forecastType.value == 1
                                    ? '集齐再发'
                                    : '到件即发')
                                .ts,
                            style: TextConfig.textDark14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 13.w, top: 8.w, bottom: 8.w, left: 8.w),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textBlack,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var tmp = await Routers.push(Routers.country);
              if (tmp == null) {
                return;
              }
              CountryModel? s = tmp as CountryModel;
              if (s.id == null) {
                return;
              }

              controller.selectedCountryModel.value = s;
              controller.getWarehouseList();
              controller.getProps();
            },
            child: InputTextItem(
              title: '寄送国家'.ts,
              bgColor: Colors.transparent,
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
                            controller.selectedCountryModel.value == null
                                ? '请选择寄送国家'.ts
                                : controller.selectedCountryModel.value!.name!,
                            style: controller.selectedCountryModel.value == null
                                ? TextConfig.textGray14
                                : TextConfig.textDark14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 13.w, top: 8.w, bottom: 8.w, left: 8.w),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textBlack,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (controller.selectedCountryModel.value?.id != null) {
                Picker(
                  adapter: PickerDataAdapter(
                      data: controller
                          .getPickerWareHouse(controller.wareHouseList)),
                  cancelText: '取消'.ts,
                  confirmText: '确认'.ts,
                  selectedTextStyle:
                      const TextStyle(color: Colors.blue, fontSize: 12),
                  onCancel: () {},
                  onConfirm: (Picker picker, List value) {
                    controller.selectedWarehouseModel.value =
                        controller.wareHouseList[value.first];
                  },
                ).showModal(context);
              }
            },
            child: InputTextItem(
              title: '集运仓库'.ts,
              flag: false,
              bgColor: Colors.transparent,
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
                            controller.selectedWarehouseModel.value == null
                                ? '请选择集运仓库'.ts
                                : controller.selectedWarehouseModel.value!
                                    .warehouseName!,
                            style:
                                controller.selectedWarehouseModel.value == null
                                    ? TextConfig.textGray14
                                    : TextConfig.textDark14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 13.w, top: 8.w, bottom: 8.w, left: 8.w),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textBlack,
                        size: 15,
                      ),
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

  Widget buildBottomListView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            controller.formData.add(Rx(ParcelModel()));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(13.w, 0, 13.w, 10.w),
            height: 50.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primary)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppGaps.hGap10,
                AppText(
                  str: '再添加一个包裹'.ts,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),
        ),
        Obx(
          () => Offstage(
            offstage: controller.forecastType.value == 1,
            child: buildAddressInfoView(context),
          ),
        ),
        Obx(
          () => buildAddServiceListView(),
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
            str: '到件即发'.ts,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          GestureDetector(
            onTap: controller.onAddress,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.line)),
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
                                  str: '收件人信息'.ts,
                                  fontSize: 13,
                                ),
                                2.verticalSpace,
                                AppText(
                                  str: '点击选择收件人信息'.ts,
                                  fontSize: 11,
                                  color: AppColors.textGrayC,
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
                    str: '地址簿'.ts,
                    color: AppColors.textGrayC,
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
                border: Border(bottom: BorderSide(color: AppColors.line)),
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
                                  str: '运送方式'.ts,
                                  fontSize: 13,
                                ),
                                2.verticalSpace,
                                AppText(
                                  str: '点击选择运送方式'.ts,
                                  fontSize: 11,
                                  color: AppColors.textGrayC,
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
                                  str: '时效'.ts +
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
                    str: '请选择'.ts,
                    color: AppColors.textGrayC,
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
            str: '下单备注'.ts,
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
              hintText: '给打包小哥捎话'.ts,
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
          second = '实际运费'.ts + (item.value / 100).toStringAsFixed(2) + '%';
          break;
        case 2:
          second = item.value.rate();
          break;
        case 3:
          second = item.value.rate() + '/${'箱'.ts}';
          break;
        case 4:
          second = item.value.rate() +
              '/' +
              (controller.localModel?.weightSymbol ?? '');
          third = '(${'计费重'.ts})';
          break;
        case 5:
          second = item.value.rate() +
              '/' +
              (controller.localModel?.weightSymbol ?? '');
          third = '(${'实重'.ts})';
          break;
        case 6:
          second = '申报价值'.ts + (item.value / 100).toStringAsFixed(2) + '%';

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
                                  color: AppColors.textBlack,
                                  fontSize: 10.0,
                                ),
                              ),
                              TextSpan(
                                text: second,
                                style: const TextStyle(
                                  color: AppColors.textRed,
                                  fontSize: 15.0,
                                ),
                              ),
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppColors.textBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: third,
                                style: const TextStyle(
                                  color: AppColors.textDark,
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
                                  color: AppColors.green,
                                  size: 25,
                                ),
                                onPressed: () {
                                  controller.showRemark(
                                      context, item.name, item.remark);
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Obx(
                    () => Switch.adaptive(
                      value: controller.LineServiceId.contains(item.id),
                      activeColor: AppColors.green,
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
          str: '渠道增值服务'.ts,
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
      var listTitle = ListTile(
        title: SizedBox(
          height: 20,
          child: AppText(
            str: item.value.content,
            fontSize: 16,
          ),
        ),
        subtitle: SizedBox(
          height: 18,
          child: AppText(
            str: item.value.remark,
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
        trailing: Switch.adaptive(
          value: item.value.isOpen,
          activeColor: AppColors.green,
          onChanged: (value) {
            item.value.isOpen = value;
            item.refresh();
          },
        ),
      );
      addValueWigets.add(listTitle);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: addValueWigets,
      ),
    );
  }

  Widget parcelListCell(BuildContext context) {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: parcelItemCell,
      controller: controller.scrollController,
      itemCount: controller.formData.length,
    );
    return listView;
  }

  // 包裹
  Widget parcelItemCell(BuildContext context, int index) {
    // 快递单号
    TextEditingController orderNumberController = TextEditingController();
    final FocusNode orderNumber = FocusNode();

    // 包裹名称
    TextEditingController goodsNameController = TextEditingController();
    final FocusNode goodsName = FocusNode();
    // 包裹价值
    TextEditingController goodsValueController = TextEditingController();
    final FocusNode goodsValue = FocusNode();
    // 包裹备注
    TextEditingController _remarkController = TextEditingController();
    final FocusNode _remark = FocusNode();

    final model = controller.formData[index];
    if (model.value.expressNum != null) {
      orderNumberController.text = model.value.expressNum!;
    }
    if (model.value.packageName != null) {
      goodsNameController.text = model.value.packageName!;
    }
    if (model.value.packageValue != null) {
      goodsValueController.text = model.value.packageValue.toString();
    }
    if (model.value.remark != null) {
      _remarkController.text = model.value.remark!;
    }
    if (model.value.expressNum != null) {
      orderNumberController.text = model.value.expressNum!;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                Picker(
                  adapter: PickerDataAdapter(
                      data: getPickerExpressCompany(
                          controller.expressCompanyList)),
                  cancelText: '取消'.ts,
                  confirmText: '确认'.ts,
                  selectedTextStyle:
                      const TextStyle(color: Colors.blue, fontSize: 12),
                  onCancel: () {},
                  onConfirm: (Picker picker, List value) {
                    model.value.expressName =
                        controller.expressCompanyList[value.first].name;
                    model.value.expressId =
                        controller.expressCompanyList[value.first].id;
                  },
                ).showModal(context);
              },
              child: InputTextItem(
                  title: '快递名称'.ts,
                  leftFlex: 2,
                  isRequired: true,
                  bgColor: Colors.transparent,
                  inputText: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model.value.expressName ?? '请选择快递名称'.ts,
                          style: model.value.expressName != null
                              ? TextConfig.textDark14
                              : TextConfig.textGray14,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(right: 15, top: 10, bottom: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textBlack,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            InputTextItem(
              title: '快递单号'.ts,
              leftFlex: 2,
              isRequired: true,
              inputText: NormalInput(
                hintText: '请输入快递单号'.ts,
                contentPadding: EdgeInsets.only(right: 13.w),
                textAlign: TextAlign.right,
                controller: orderNumberController,
                focusNode: orderNumber,
                autoFocus: false,
                maxLength: 40,
                onChanged: (res) {
                  model.value.expressNum = res;
                },
                keyName: '',
              ),
            ),
            InputTextItem(
              title: "物品名称".ts,
              inputText: BaseInput(
                hintText: '请输入物品名称'.ts,
                textAlign: TextAlign.right,
                controller: goodsNameController,
                focusNode: goodsName,
                contentPadding: EdgeInsets.only(right: 13.w),
                autoFocus: false,
                keyboardType: TextInputType.text,
                onSubmitted: (res) {
                  FocusScope.of(context).requestFocus(goodsValue);
                },
                onChanged: (res) {
                  model.value.packageName = res;
                },
                keyName: '',
              ),
            ),
            InputTextItem(
              leftFlex: 3,
              title: '物品价值'.ts + '(${controller.currencyModel.value?.symbol})',
              inputText: BaseInput(
                  hintText: '请输入物品价值'.ts,
                  textAlign: TextAlign.right,
                  controller: goodsValueController,
                  contentPadding: EdgeInsets.only(right: 13.w),
                  focusNode: goodsValue,
                  autoFocus: false,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_remark);
                  },
                  onChanged: (res) {
                    if (double.tryParse(res) != null) {
                      model.value.packageValue = double.parse(res);
                    }
                  }),
            ),
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
                        },
                      );
                    });
              },
              child: InputTextItem(
                title: '物品属性'.ts,
                isRequired: true,
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
                                  ? '请选择物品属性'.ts
                                  : model.value.prop!
                                      .map((e) => e.name)
                                      .join(' '),
                              style: model.value.prop == null
                                  ? TextConfig.textGray14
                                  : TextConfig.textDark14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 13.w, top: 8.w, bottom: 8.w, left: 10.w),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textBlack,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InputTextItem(
                leftFlex: 5,
                rightFlex: 5,
                title: '商品数量'.ts,
                inputText: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          icon: Obx(
                            () => Icon(
                              model.value.qty == 1
                                  ? Icons.remove_circle
                                  : Icons.remove_circle,
                              color: model.value.qty == 1
                                  ? AppColors.textGray
                                  : AppColors.primary,
                              size: 35,
                            ),
                          ),
                          onPressed: () {
                            int k = model.value.qty!;
                            if (k == 1) {
                              return;
                            }
                            k--;
                            model.value.qty = k;
                            model.refresh();
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          model.value.qty.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: AppColors.primary,
                            size: 35,
                          ),
                          onPressed: () {
                            int k = model.value.qty!;
                            k++;

                            model.value.qty = k;
                            model.refresh();
                          }),
                    )
                  ],
                )),
            InputTextItem(
                title: '备注'.ts,
                flag: false,
                bgColor: Colors.transparent,
                inputText: BaseInput(
                  hintText: '请输入备注信息'.ts,
                  textAlign: TextAlign.right,
                  controller: _remarkController,
                  focusNode: _remark,
                  autoFocus: false,
                  contentPadding: const EdgeInsets.only(right: 15),
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(controller.blankNode);
                  },
                  onChanged: (res) {
                    model.value.remark = res;
                  },
                )),
            controller.formData.length > 1
                ? Container(
                    height: 45,
                    color: HexToColor('#fafafa'),
                    width: ScreenUtil().screenWidth,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        var data = await BaseDialog.confirmDialog(
                            context, '您确定要删除这个包裹吗'.ts);
                        if (data != null) {
                          controller.formData.removeAt(index);
                        }
                      },
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.textGrayC),
                      label: AppText(
                        str: '删除'.ts,
                        color: AppColors.textGrayC,
                      ),
                    ),
                  )
                : AppGaps.empty
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
