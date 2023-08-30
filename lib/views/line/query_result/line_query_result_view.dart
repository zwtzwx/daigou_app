import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/line/query_result/line_query_result_controller.dart';

class LineQueryResultView extends GetView<LineQueryResultController> {
  const LineQueryResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: ZHTextLine(
            str: '线路列表'.ts,
            color: BaseStylesConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: BaseStylesConfig.bgGray,
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
                      child: LoadImage(
                        '',
                        fit: BoxFit.contain,
                        holderImg: "Home/empty",
                      ),
                    ),
                    ZHTextLine(
                      str: controller.emptyMsg.value,
                      color: BaseStylesConfig.textGrayC,
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
                    ZHTextLine(
                      str: controller.postDic.value?['warehouseName'] ?? '',
                      fontSize: 18,
                    ),
                    Sized.vGap4,
                    ZHTextLine(
                      str: '出发地'.ts,
                      fontSize: 12,
                      color: BaseStylesConfig.textGrayC,
                    ),
                  ],
                ),
                const LoadImage(
                  'Home/arrow',
                  width: 60,
                ),
                Column(
                  children: [
                    ZHTextLine(
                      alignment: TextAlign.center,
                      str: controller.postDic.value?['countryName'],
                      fontSize: 18,
                      lines: 3,
                    ),
                    Sized.vGap4,
                    ZHTextLine(
                      str: '目的地'.ts,
                      fontSize: 12,
                      color: BaseStylesConfig.textGrayC,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Sized.line,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ZHTextLine(
                      str: (controller.postDic.value?['weight'] / 1000)
                              .toStringAsFixed(2) +
                          (controller.localModel?.weightSymbol ?? ''),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Sized.vGap4,
                    ZHTextLine(
                      str: '预估重量'.ts,
                      fontSize: 12,
                      color: BaseStylesConfig.textGrayC,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ZHTextLine(
                      str: (controller.volumnWeight.value ?? '') + ' m³',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Sized.vGap4,
                    ZHTextLine(
                      str: '体积'.ts,
                      fontSize: 12,
                      color: BaseStylesConfig.textGrayC,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Sized.line,
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: '物品属性'.ts,
                  fontSize: 14,
                ),
                Sized.hGap10,
                Flexible(
                  child: Wrap(
                    children: ((controller.postDic.value?['props'] ?? [])
                            as List<ParcelPropsModel>)
                        .map((prop) => Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                border:
                                    Border.all(color: BaseStylesConfig.primary),
                              ),
                              child: Text(
                                prop.name ?? '',
                                style: const TextStyle(
                                  color: BaseStylesConfig.primary,
                                ),
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
    String modelName = Util.getLineModelName(model.mode);
    return GestureDetector(
      onTap: () async {
        if (controller.fromQuery.value) {
          Routers.push(Routers.lineDetail, {'line': model, 'type': 2});
        } else {
          Routers.pop(model);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: BaseStylesConfig.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1, color: BaseStylesConfig.white)),
        margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF51CEA5),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(10)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: ZHTextLine(
                str: model.isDelivery == 0
                    ? '派送'.ts
                    : (model.isDelivery == 1 ? '自提'.ts : '派送/自提'.ts),
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Sized.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: model.name,
                  fontSize: 18,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: BaseStylesConfig.textRed),
                    children: [
                      TextSpan(
                          text: (controller.localModel?.currencySymbol ?? '')),
                      TextSpan(
                        text: ((model.expireFee ?? 0) / 100).toStringAsFixed(2),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Sized.vGap4,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: '运送时效'.ts + '：' + model.region!.referenceTime,
                  color: BaseStylesConfig.textNormal,
                  fontSize: 14,
                ),
                ZHTextLine(
                  str: '预估运费'.ts,
                  color: BaseStylesConfig.textRed,
                  fontSize: 12,
                ),
              ],
            ),
            Sized.vGap4,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: '计费重'.ts +
                      '：' +
                      ((model.countWeight ?? 0) / 1000).toStringAsFixed(2) +
                      (controller.localModel?.weightSymbol ?? ''),
                  color: BaseStylesConfig.textNormal,
                  fontSize: 14,
                ),
                Sized.hGap10,
                ZHTextLine(
                  str: modelName.ts,
                  fontSize: 12,
                ),
              ],
            ),
            Sized.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (model.labels != null && model.labels!.isNotEmpty)
                    ? Flexible(
                        child: Row(
                          children: model.labels!
                              .map(
                                (e) => Container(
                                  color: BaseStylesConfig.primary,
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: ZHTextLine(
                                    str: e.name,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : Sized.empty,
                GestureDetector(
                    onTap: () {
                      Routers.push(Routers.lineDetail, {'line': model});
                    },
                    child: ZHTextLine(
                      str: '查看详情'.ts,
                      color: BaseStylesConfig.textGray,
                      fontSize: 12,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
