/*
  无人认领详细界面
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/detail/no_owner_parcel_detail_controller.dart';

class NoOwnerParcelDetailView extends GetView<NoOwnerParcelDetailController> {
  const NoOwnerParcelDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '异常件认领'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: MainButton(
            text: '提交',
            onPressed: controller.onSubmit,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: buildSubViews(context),
        ),
      ),
    );
  }

  Widget buildSubViews(BuildContext context) {
    var content = Column(
      children: <Widget>[
        SizedBox(
          width: ScreenUtil().screenWidth,
          child: InputTextItem(
            leftFlex: 3,
            rightFlex: 8,
            title: '快递单号'.ts,
            inputText: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: ZHTextLine(
                        alignment: TextAlign.left,
                        str: controller.headerStr.value,
                      )),
                  Expanded(
                      flex: 5,
                      child: NormalInput(
                        hintText: '请输入中间单号'.ts,
                        contentPadding: const EdgeInsets.only(top: 17),
                        textAlign: TextAlign.left,
                        controller: controller.projectNameController,
                        focusNode: controller.projectName,
                        autoFocus: false,
                        keyboardType: TextInputType.text,
                        onChanged: (res) {
                          controller.courierNumber.value = res;
                        },
                      )),
                  Expanded(
                    flex: 1,
                    child: ZHTextLine(
                      str: controller.footerStr.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(
          () => controller.syncsList.isNotEmpty
              ? InputTextItem(
                  title: '认领并填入已预报包裹信息',
                  leftFlex: 8,
                  rightFlex: 2,
                  inputText: SizedBox(
                    height: 55,
                    width: 100,
                    child: Switch.adaptive(
                      value: controller.flag.value,
                      activeColor: BaseStylesConfig.primary,
                      onChanged: (value) {
                        controller.flag.value = value;
                      },
                    ),
                  ))
              : Container(),
        ),
        Obx(
          () => controller.flag.value
              ? GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        // isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: controller.syncsList.length < 6
                                ? controller.syncsList.length.toDouble() * 44
                                : 220,
                            child: ListView.builder(
                              itemCount: controller.syncsList.length,
                              itemExtent: 44,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  trailing:
                                      controller.syncsListFirstParcel.value ==
                                              controller.syncsList[index]
                                          ? const Icon(Icons.check)
                                          : Container(
                                              width: 10,
                                            ),
                                  title: SizedBox(
                                    height: 44,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            controller
                                                .syncsList[index].expressNum!,
                                            style: const TextStyle(
                                                color:
                                                    BaseStylesConfig.textDark)),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    controller.syncsListFirstParcel.value =
                                        controller.syncsList[index];
                                    Routers.pop();
                                  },
                                );
                              },
                            ),
                          );
                        });
                  },
                  child: InputTextItem(
                      title: '同步包裹'.ts,
                      inputText: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              controller.syncsListFirstParcel.value.expressNum!,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: 15, top: 10, bottom: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      )),
                )
              : Container(),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
    return content;
  }
}
