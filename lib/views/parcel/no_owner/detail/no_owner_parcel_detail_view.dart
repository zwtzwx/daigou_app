/*
  无人认领详细界面
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/input_text_item.dart';
import 'package:huanting_shop/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/parcel/no_owner/detail/no_owner_parcel_detail_controller.dart';

class BeeParcelClaimPage extends GetView<BeeParcelClaimLogic> {
  const BeeParcelClaimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.1,
        centerTitle: true,
        title: AppText(
          str: '异常件认领'.ts,
          fontSize: 17,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: AppColors.bgGray,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: BeeButton(
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
      children: [
        Container(
          color: Colors.white,
          width: ScreenUtil().screenWidth,
          child: InputTextItem(
            leftFlex: 3,
            rightFlex: 8,
            flag: false,
            title: '快递单号'.ts,
            inputText: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  AppText(
                    alignment: TextAlign.left,
                    str: controller.headerStr.value,
                  ),
                  10.horizontalSpace,
                  Expanded(
                      child: NormalInput(
                    hintText: '请输入中间单号'.ts,
                    contentPadding: const EdgeInsets.only(top: 0),
                    textAlign: TextAlign.left,
                    controller: controller.projectNameController,
                    focusNode: controller.projectName,
                    autoFocus: false,
                    keyboardType: TextInputType.text,
                    onChanged: (res) {
                      controller.courierNumber.value = res;
                    },
                  )),
                  AppText(
                    str: controller.footerStr.value,
                  ),
                  10.horizontalSpace,
                ],
              ),
            ),
          ),
        ),
        15.verticalSpaceFromWidth,
        Container(
          color: Colors.white,
          child: Obx(
            () => controller.syncsList.isNotEmpty
                ? InputTextItem(
                    title: '认领并填入已预报包裹信息',
                    leftFlex: 8,
                    rightFlex: 2,
                    flag: false,
                    inputText: SizedBox(
                      height: 55,
                      width: 100,
                      child: Switch.adaptive(
                        value: controller.flag.value,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          controller.flag.value = value;
                        },
                      ),
                    ))
                : Container(),
          ),
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
                                                color: AppColors.textDark)),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    controller.syncsListFirstParcel.value =
                                        controller.syncsList[index];
                                    BeeNav.pop();
                                  },
                                );
                              },
                            ),
                          );
                        });
                  },
                  child: Container(
                    color: Colors.white,
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
                      ),
                    ),
                  ))
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
