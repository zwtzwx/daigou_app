import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/line/query/line_query_controller.dart';

class LineQueryView extends GetView<LineQueryController> {
  const LineQueryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: BaseStylesConfig.bgGray,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: ZHTextLine(
            str: '包裹测算'.ts,
            fontSize: 18,
          ),
          leading: const BackButton(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: <Widget>[
                queryItemCell(context),
                Sized.vGap10,
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 30),
                  width: double.infinity,
                  height: 50,
                  child: MainButton(
                    text: '立即试算',
                    borderRadis: 999,
                    onPressed: controller.onSubmit,
                  ),
                ),
                lineIllustrate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  destinationCell(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BaseStylesConfig.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () async {
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
              child: Column(
                children: [
                  Obx(
                    () => ZHTextLine(
                      str: controller.selectWareHouse.value != null
                          ? controller.selectWareHouse.value!.warehouseName!
                          : '请选择'.ts,
                      fontSize: 17,
                      lines: 4,
                      alignment: TextAlign.center,
                    ),
                  ),
                  Sized.vGap5,
                  ZHTextLine(
                    str: '出发地'.ts,
                    fontSize: 13,
                    color: BaseStylesConfig.textGrayC,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: LoadImage(
              'Home/arrow',
              width: 60,
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: controller.onCountry,
              child: Column(
                children: [
                  Obx(
                    () => ZHTextLine(
                      alignment: TextAlign.center,
                      str: controller.selectCountry.value != null
                          ? controller.selectCountry.value!.name!
                          : '请选择'.ts,
                      fontSize: 17,
                      lines: 4,
                    ),
                  ),
                  Sized.vGap5,
                  ZHTextLine(
                    str: '目的地'.ts,
                    fontSize: 13,
                    color: BaseStylesConfig.textGrayC,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget queryItemCell(BuildContext context) {
    var mainView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          destinationCell(context),
          selectItem(
            '预估重量',
            rightItem: Expanded(
              child: Container(
                // width: ScreenUtil().screenWidth - 200,
                margin: const EdgeInsets.only(left: 10),
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDFDFDF)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.onWeight(-1);
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Icon(
                          Icons.minimize_outlined,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: BaseStylesConfig.line),
                            right: BorderSide(color: BaseStylesConfig.line),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: BaseInput(
                                isCollapsed: true,
                                autoShowRemove: false,
                                controller: controller.weightController,
                                focusNode: controller.weightNode,
                                style: const TextStyle(fontSize: 18),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                            ZHTextLine(
                              str: controller.localModel?.weightSymbol ?? '',
                              color: BaseStylesConfig.textGrayC9,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.onWeight(1);
                      },
                      child: Container(
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZHTextLine(
                  str: '预估体积重'.ts,
                ),
                Sized.vGap5,
                ZHTextLine(
                  str: '包裹尺寸为商品打包，实际包裹箱的长宽高用于某些体积重线路的运费计算'.ts,
                  color: BaseStylesConfig.textGray,
                  fontSize: 14,
                  lines: 4,
                ),
                Sized.vGap20,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: BaseStylesConfig.line),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 14),
                        child: BaseInput(
                          textAlign: TextAlign.center,
                          controller: controller.longController,
                          focusNode: controller.longNode,
                          autoShowRemove: false,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 11),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          hintText: '长'.ts +
                              ':' +
                              (controller.localModel?.lengthSymbol ?? ''),
                        ),
                      ),
                    ),
                    Sized.hGap15,
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: BaseStylesConfig.line),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 14),
                        child: BaseInput(
                          textAlign: TextAlign.center,
                          controller: controller.wideController,
                          focusNode: controller.wideNode,
                          autoShowRemove: false,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 11),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          hintText: '${'宽'.ts}:' +
                              (controller.localModel?.lengthSymbol ?? ''),
                        ),
                      ),
                    ),
                    Sized.hGap15,
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: BaseStylesConfig.line),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 14),
                        child: BaseInput(
                          textAlign: TextAlign.center,
                          controller: controller.highController,
                          focusNode: controller.highNode,
                          autoShowRemove: false,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 11),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          hintText: '${'高'.ts}:' +
                              (controller.localModel?.lengthSymbol ?? ''),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZHTextLine(
                  str: '物品属性'.ts,
                ),
                Sized.vGap10,
                Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.propList
                        .map(
                          (prop) => GestureDetector(
                            onTap: () {
                              controller.onProps(prop);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  color: controller.selectPropList
                                          .map((e) => e.id)
                                          .contains(prop.id)
                                      ? Colors.transparent
                                      : const Color(0xffFAF8FB),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: controller.selectPropList
                                            .map((e) => e.id)
                                            .contains(prop.id)
                                        ? BaseStylesConfig.primary
                                        : const Color(0xffFAF8FB),
                                  )),
                              child: ZHTextLine(
                                str: prop.name!,
                                color: controller.selectPropList
                                        .map((e) => e.id)
                                        .contains(prop.id)
                                    ? BaseStylesConfig.primary
                                    : const Color(0xff918E91),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
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
        border: Border(bottom: BorderSide(color: BaseStylesConfig.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: ZHTextLine(
                    str: label.ts,
                    lines: 3,
                  ),
                ),
                Sized.hGap5,
                Flexible(
                  child: ZHTextLine(
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
                    ZHTextLine(
                      str: value ?? '请选择'.ts,
                      color: (value != null && value.isNotEmpty)
                          ? BaseStylesConfig.textDark
                          : BaseStylesConfig.textGray,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget lineIllustrate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZHTextLine(
          str: '运费规则说明'.ts,
          fontWeight: FontWeight.bold,
        ),
        Sized.vGap10,
        ZHTextLine(
          str:
              '${'体积重计算方法'.ts}：\n${'计算公式'.ts}：\n${'按照国际惯例，低密度的包裹，比较其实重，占用的空间通常较大，计算出的体积重量。体积重量和实际重量两者取大者计算。体积重量(KG) = (长 (cm) x 宽 (cm) x 高 (cm)) ÷ 6000'.ts}\n${'具体规则会在详细的试算结果中注明'.ts}',
          lines: 10,
          fontSize: 14,
        ),
      ],
    );
  }
}
