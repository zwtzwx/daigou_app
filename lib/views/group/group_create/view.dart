import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/group/group_create/controller.dart';

class BeeGroupCreateView extends GetView<BeeGroupCreateController> {
  const BeeGroupCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '发起拼团'.ts,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
      ),
      backgroundColor: AppColors.bgGray,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addressCell(),
              groupInfoCell(context),
              leaderBox(context),
              protolBox(context),
              Container(
                height: 45.h,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 40),
                child: BeeButton(
                  text: '发起拼团',
                  onPressed: controller.onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 收件地址
  Widget addressCell() {
    return Obx(
      () => controller.addressModel.value == null
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: controller.onAddress,
                child: DottedBorder(
                  radius: const Radius.circular(5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  borderType: BorderType.RRect,
                  color: AppColors.groupText,
                  dashPattern: const [5, 2],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.groupText,
                      ),
                      AppGaps.hGap5,
                      AppText(
                        str: '选择收件地址'.ts,
                        fontWeight: FontWeight.bold,
                        color: AppColors.groupText,
                      ),
                    ],
                  ),
                ),
              ))
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.only(top: 5, bottom: 15, right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3F6EA),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(999),
                            bottomRight: Radius.circular(999),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          top: 3,
                          bottom: 3,
                          left: 10,
                          right: 14,
                        ),
                        child: AppText(
                          str: (controller.addressModel.value!.addressType == 1
                                  ? '送货上门'
                                  : '自提点')
                              .ts,
                          fontSize: 12,
                          color: AppColors.green,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.onAddress,
                        child: const ImgItem(
                          'Group/edit',
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                  AppGaps.vGap10,
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: AppText(
                                  str: controller
                                      .addressModel.value!.receiverName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              AppText(
                                str: controller.addressModel.value!.timezone +
                                    controller.addressModel.value!.phone,
                              ),
                            ],
                          ),
                        ),
                        controller.addressModel.value!.addressType == 2
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: AppText(
                                  str: controller
                                          .addressModel.value!.station?.name ??
                                      '',
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : AppGaps.empty,
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topLeft,
                          child: AppText(
                            lines: 4,
                            str: (controller.addressModel.value!.area != null
                                    ? '${controller.addressModel.value!.area!.name} '
                                    : '') +
                                (controller.addressModel.value!.subArea != null
                                    ? '${controller.addressModel.value!.subArea!.name} '
                                    : '') +
                                (controller.addressModel.value!.addressType == 1
                                    ? '${controller.addressModel.value!.address} ${controller.addressModel.value!.city} ${controller.addressModel.value!.postcode} ${controller.addressModel.value!.countryName}'
                                    : '${controller.addressModel.value!.address}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget groupInfoCell(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTextItem(
            title: '拼团名称',
            inputText: BaseInput(
              controller: controller.nameController,
              focusNode: controller.nameNode,
              autoShowRemove: false,
              textAlign: TextAlign.right,
              hintText: '请输入拼团名称'.ts,
              maxLength: 30,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            ),
          ),
          InputTextItem(
            title: '物流渠道',
            inputText: GestureDetector(
              onTap: controller.onLine,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => AppText(
                      str: controller.lineModel.value == null
                          ? '请选择'.ts
                          : controller.lineModel.value!.name,
                      color: controller.lineModel.value == null
                          ? AppColors.textGray
                          : AppColors.textBlack,
                      lines: 2,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 15),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => controller.lineModel.value != null
                ? InputTextItem(
                    title: '转运仓库',
                    inputText: GestureDetector(
                      onTap: () {
                        controller.onWarehouse(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(
                            str: controller.warehoueModel.value == null
                                ? '请选择'.ts
                                : controller
                                    .warehoueModel.value!.warehouseName!,
                            color: controller.warehoueModel.value == null
                                ? AppColors.textGray
                                : AppColors.textBlack,
                            lines: 2,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 15),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : AppGaps.empty,
          ),
          InputTextItem(
            title: '拼团天数',
            leftFlex: 2,
            inputText: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDFDFDF)),
                borderRadius: BorderRadius.circular(999),
              ),
              margin: const EdgeInsets.only(right: 15),
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkResponse(
                    onTap: () {
                      controller.onDay(-1);
                    },
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Color(0xFFDFDFDF)),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(
                        Icons.minimize_outlined,
                      ),
                    ),
                  ),
                  Expanded(
                    child: BaseInput(
                      controller: controller.dayController,
                      focusNode: controller.dayNode,
                      isCollapsed: true,
                      autoShowRemove: false,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      controller.onDay(1);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Color(0xFFDFDFDF)),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InputTextItem(
            title: '是否公开拼团',
            leftFlex: 2,
            flag: false,
            inputText: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Obx(
                    () => Switch.adaptive(
                      value: controller.isPublicGroup.value,
                      activeColor: AppColors.green,
                      onChanged: (value) {
                        if (!controller.createPublic.value) {
                          controller.showToast('暂无权限');
                        } else {
                          controller.isPublicGroup.value = value;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 拼团规则
  Widget protolBox(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 0,
        top: 10,
      ),
      child: Obx(
        () => TextButton.icon(
          style: ButtonStyle(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
          onPressed: () {
            if (!controller.protocolAgree.value) {
              BaseDialog.normalDialog(
                context,
                child: Html(data: controller.groupProtocol.value ?? ''),
              );
            }

            controller.protocolAgree.value = !controller.protocolAgree.value;
          },
          icon: Icon(
            controller.protocolAgree.value
                ? Icons.check_circle
                : Icons.circle_outlined,
            color: controller.protocolAgree.value
                ? AppColors.green
                : AppColors.textGray,
          ),
          label: Text.rich(
            TextSpan(
              style: const TextStyle(color: AppColors.textBlack),
              children: [
                TextSpan(
                  text: '已查看并同意'.ts,
                ),
                TextSpan(
                  text: '《${'拼团规则'.ts}》',
                  style: const TextStyle(color: AppColors.groupText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget leaderBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '团长有话说'.ts,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          Obx(
            () => Html(data: controller.leaderTips.value ?? ''),
          ),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                chooseImgCell(context),
                AppGaps.hGap15,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.bgGray,
                    ),
                    child: BaseInput(
                      board: true,
                      controller: controller.remarkController,
                      focusNode: controller.remarkNode,
                      autoShowRemove: false,
                      maxLines: 4,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintText: '请输入团长的要求和团员们需要注意的事项，以便拼团顺利的进行'.ts,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseImgCell(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.onUploadImg(context);
      },
      child: Obx(
        () => Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.bgGray,
          ),
          child: controller.image.value == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ImgItem(
                      'Group/group-5',
                      width: 28,
                    ),
                    AppText(
                      str: '上传图片'.ts,
                      color: AppColors.textGrayC,
                    ),
                  ],
                )
              : ImgItem(
                  controller.image.value!,
                  width: 100,
                ),
        ),
      ),
    );
  }
}
