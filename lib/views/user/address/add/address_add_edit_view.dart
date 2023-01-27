/*
  收件地址编辑
 */

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
            height: controller.isEdit.value ? 110 : 50,
            child: Column(
              children: <Widget>[
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
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
                      fontSize: 14,
                    );
                  }),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: BaseStylesConfig.textGray,
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
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            maxLength: 20,
            controller: controller.mobileNumberController,
            focusNode: controller.mobileNumber,
            keyboardType: TextInputType.phone,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(controller.zipCode);
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
                      str: controller.countryModel.value.name == null
                          ? '请选择国家地区'.ts
                          : controller.countryModel.value.name!,
                      color: controller.countryModel.value.name == null
                          ? BaseStylesConfig.textGray
                          : BaseStylesConfig.textDark,
                      fontSize: 14,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: BaseStylesConfig.textGray,
                  ),
                ],
              ),
            ),
          ),
        ),
        InputTextItem(
          title: '邮编'.ts,
          inputText: NormalInput(
            hintText: '请输入邮编'.ts,
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
            controller.countryModel.value.areas![value.first];
        controller.subAreaModel.value = controller
            .countryModel.value.areas![value.first].areas![value.last];
      },
    ).showModal(context);
  }

  getPickerSubView() {
    List<PickerItem> data = [];
    for (var item in controller.countryModel.value.areas!) {
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
