/*
  收件地址编辑
 */

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:jiyun_app_client/views/user/address/add/address_add_edit_controller.dart';

class AddressAddEditView extends GetView<AddressAddEditController> {
  const AddressAddEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: !controller.isEdit.value ? '添加地址'.ts : '修改地址'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.only(left: 15, right: 5),
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          activeColor: BaseStylesConfig.primary,
                          checkColor: Colors.black,
                          shape: const CircleBorder(),
                          value: controller.isDefault.value,
                          onChanged: (value) {
                            controller.isDefault.value = value!;
                          },
                        ),
                      ),
                    ),
                    ZHTextLine(
                      str: '设为默认地址'.ts,
                      fontSize: 14,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15, top: 10),
                  height: 40,
                  width: double.infinity,
                  child: MainButton(
                    text: '确认提交',
                    onPressed: controller.onSubmit,
                  ),
                ),
                controller.isEdit.value
                    ? Container(
                        margin:
                            const EdgeInsets.only(right: 15, left: 15, top: 10),
                        width: double.infinity,
                        height: 40,
                        child: MainButton(
                          text: '删除',
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            var res = await BaseDialog.confirmDialog(
                                context, '确认要删除地址吗');
                            if (res == true) {
                              controller.onDeleteAddress();
                            }
                          },
                          textColor: BaseStylesConfig.textRed,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: buildAddressContent(context),
        ),
      ),
    );
  }

  Widget buildAddressContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTextItem(
          title: '收件人'.ts,
          inputText: NormalInput(
            hintText: '请输入收件人名字'.ts,
            textAlign: TextAlign.right,
            contentPadding: const EdgeInsets.only(right: 15),
            controller: controller.recipientNameController,
            focusNode: controller.recipientName,
            maxLength: 40,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(controller.mobileNumber);
            },
            onChanged: (res) {
              controller.model.value.receiverName = res;
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            var s = await Routers.push(Routers.country);
            if (s == null) return;
            CountryModel a = s as CountryModel;
            controller.timezone.value = a.timezone!;
            controller.countryModel.value = a;
          },
          child: InputTextItem(
            title: '电话区号'.ts,
            inputText: Container(
              padding: const EdgeInsets.only(right: 15, left: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Obx(() {
                    return ZHTextLine(
                      str: controller.timezone.value.isEmpty
                          ? '请选择电话区号'.ts
                          : controller.timezone.value,
                      color: controller.timezone.value.isEmpty
                          ? BaseStylesConfig.textGray
                          : BaseStylesConfig.textDark,
                      fontSize: 13,
                    );
                  }),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: BaseStylesConfig.textDark,
                  ),
                ],
              ),
            ),
          ),
        ),
        InputTextItem(
          title: '联系电话'.ts,
          inputText: NormalInput(
            hintText: '请输入联系电话'.ts,
            textAlign: TextAlign.right,
            contentPadding: const EdgeInsets.only(right: 15),
            maxLength: 20,
            controller: controller.mobileNumberController,
            focusNode: controller.mobileNumber,
            keyboardType: TextInputType.phone,
            onSubmitted: (res) {
              if (controller.addressType.value == 1) {
                FocusScope.of(context).requestFocus(controller.zipCode);
              }
            },
            onChanged: (res) {
              controller.model.value.phone = res;
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            var s = await Routers.push(Routers.country);
            if (s == null) {
              return;
            }
            CountryModel a = s as CountryModel;
            controller.countryModel.value = a;
            controller.areaModel.value = null;
            controller.subAreaModel.value = null;
          },
          child: InputTextItem(
            title: '国家地区'.ts,
            inputText: Container(
              padding: const EdgeInsets.only(right: 15, left: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Obx(
                    () => ZHTextLine(
                      str: controller.countryModel.value == null
                          ? '请选择国家地区'.ts
                          : controller.countryModel.value!.name!,
                      color: controller.countryModel.value == null
                          ? BaseStylesConfig.textGray
                          : BaseStylesConfig.textDark,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: BaseStylesConfig.textDark,
                  ),
                ],
              ),
            ),
          ),
        ),
        controller.addressType.value == 1
            ? deliveryCell(context)
            : stationCell(),
      ],
    );
  }

  // 送货上门
  Widget deliveryCell(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTextItem(
          title: '邮编'.ts,
          inputText: NormalInput(
            hintText: '请输入邮编'.ts,
            contentPadding: const EdgeInsets.only(right: 15),
            textAlign: TextAlign.right,
            controller: controller.zipCodeController,
            focusNode: controller.zipCode,
            maxLength: 20,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(controller.doorNoNode);
            },
            onChanged: (res) {
              controller.model.value.postcode = res;
            },
          ),
        ),
        InputTextItem(
          title: '门牌号'.ts,
          inputText: NormalInput(
            hintText: '请输入门牌号'.ts,
            contentPadding: const EdgeInsets.only(right: 15),
            textAlign: TextAlign.right,
            controller: controller.doorNoController,
            focusNode: controller.doorNoNode,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(controller.streetName);
            },
            onChanged: (res) {
              controller.model.value.doorNo = res;
            },
          ),
        ),
        InputTextItem(
          title: '街道'.ts,
          inputText: NormalInput(
            hintText: '请输入街道'.ts,
            contentPadding: const EdgeInsets.only(right: 15),
            textAlign: TextAlign.right,
            controller: controller.streetNameController,
            focusNode: controller.streetName,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(controller.cityNode);
            },
            onChanged: (res) {
              controller.model.value.street = res;
            },
          ),
        ),
        InputTextItem(
          title: '城市'.ts,
          inputText: NormalInput(
            hintText: '请输入城市'.ts,
            contentPadding: const EdgeInsets.only(right: 15),
            textAlign: TextAlign.right,
            controller: controller.cityController,
            focusNode: controller.cityNode,
            onChanged: (res) {
              controller.model.value.city = res;
            },
          ),
        ),
      ],
    );
  }

  // 自提收货
  Widget stationCell() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: BaseStylesConfig.textRed,
                  ),
                ),
                TextSpan(
                  text: '自提点'.ts,
                ),
              ],
            ),
            style: const TextStyle(fontSize: 15),
          ),
          8.verticalSpace,
          Obx(
            () => controller.station.value == null
                ? GestureDetector(
                    onTap: controller.onStationSelect,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: BaseStylesConfig.primary,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: BaseStylesConfig.primary,
                          ),
                          Sized.hGap5,
                          ZHTextLine(
                            str: '选择自提点'.ts,
                            color: BaseStylesConfig.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: controller.onStationSelect,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: BaseStylesConfig.bgGray,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ZHTextLine(
                            str: controller.station.value!.name,
                            fontWeight: FontWeight.bold,
                            lines: 3,
                          ),
                          Sized.vGap4,
                          SizedBox(
                            child: ZHTextLine(
                              str:
                                  '${controller.station.value!.area?.name ?? ''} ${controller.station.value!.subArea?.name ?? ''} ${(controller.station.value!.address ?? '')}',
                              lines: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  showPickerDestion(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerSubView()),
      title: Text('选择区域'.ts),
      cancelText: '取消'.ts,
      confirmText: '确认'.ts,
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {
        // showPicker = false;
      },
      onConfirm: (Picker picker, List value) {
        controller.areaModel.value =
            controller.countryModel.value!.areas![value.first];
        controller.subAreaModel.value = controller
            .countryModel.value!.areas![value.first].areas![value.last];
      },
    ).showModal(context);
  }

  getPickerSubView() {
    List<PickerItem> data = [];
    for (var item in controller.countryModel.value!.areas!) {
      var containe = PickerItem(
        text: ZHTextLine(
          fontSize: 24,
          str: item.name,
        ),
        children: controller.getSubAreaViews(item),
      );
      data.add(containe);
    }
    return data;
  }
}
