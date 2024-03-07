import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/goods_props.dart';
import 'package:huanting_shop/models/ship_line_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/line/query_result/line_query_result_controller.dart';
import 'package:huanting_shop/views/line/widget/line_item_widget.dart';

class LineQueryResultView extends GetView<LineQueryResultController> {
  const LineQueryResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: AppText(
            str: '线路列表'.ts,
            color: AppColors.textBlack,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: AppColors.bgGray,
        body: Obx(
          () => !controller.isEmpty.value
              ? lineListCell()
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 140,
                      width: 140,
                      child: ImgItem(
                        '',
                        fit: BoxFit.contain,
                        holderImg: "Home/empty",
                      ),
                    ),
                    AppText(
                      str: controller.emptyMsg.value,
                      color: AppColors.textGrayC,
                    )
                  ],
                )),
        ));
  }

  Widget lineListCell() {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: queryInfoCell,
      itemCount: controller.fromQuery.value
          ? controller.lineData.length + 1
          : controller.lineData.length,
    );
    return listView;
  }

  Widget buildQueryInfoView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    AppText(
                      str: controller.postDic.value?['warehouseName'] ?? '',
                      fontSize: 16,
                    ),
                    5.verticalSpaceFromWidth,
                    AppText(
                      str: '出发地'.ts,
                      fontSize: 12,
                      color: AppColors.textNormal,
                    ),
                  ],
                ),
                ImgItem(
                  'Home/ship',
                  width: 80.w,
                  fit: BoxFit.fitWidth,
                ),
                Column(
                  children: [
                    AppText(
                      alignment: TextAlign.center,
                      str: controller.postDic.value?['countryName'],
                      fontSize: 16,
                      lines: 3,
                    ),
                    5.verticalSpaceFromWidth,
                    AppText(
                      str: '目的地'.ts,
                      fontSize: 12,
                      color: AppColors.textNormal,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppGaps.line,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    AppText(
                      str: (controller.postDic.value?['weight'] / 1000)
                              .toStringAsFixed(2) +
                          (controller.localModel?.weightSymbol ?? ''),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    AppGaps.vGap4,
                    AppText(
                      str: '预估重量'.ts,
                      fontSize: 12,
                      color: AppColors.textNormal,
                    ),
                  ],
                ),
                Column(
                  children: [
                    AppText(
                      str: (controller.volumnWeight.value ?? '') + ' m³',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    AppGaps.vGap4,
                    AppText(
                      str: '体积'.ts,
                      fontSize: 12,
                      color: AppColors.textNormal,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppGaps.line,
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10.h, 10, 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: '物品属性'.ts,
                  fontSize: 14,
                ),
                10.horizontalSpace,
                Flexible(
                  child: Wrap(
                    children: ((controller.postDic.value?['propList'] ?? [])
                            as List<ParcelPropsModel>)
                        .map((prop) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: AppColors.primary,
                              ),
                              child: AppText(
                                str: prop.name ?? '',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget queryInfoCell(BuildContext context, int index) {
    if (index == 0 && controller.fromQuery.value) {
      return buildQueryInfoView();
    }
    ShipLineModel model =
        controller.lineData[controller.fromQuery.value ? index - 1 : index];
    return LineItemWidget(
      model: model,
      onSelect: () {
        if (controller.fromQuery.value) {
          BeeNav.push(BeeNav.lineDetail, arg: {'line': model, 'type': 2});
        } else {
          BeeNav.pop(model);
        }
      },
    );
  }
}
