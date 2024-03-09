import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/self_pickup_station_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/user/station_select/station_select_controller.dart';

class StationSelectView extends GetView<StationSelectController> {
  const StationSelectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '选择自提点'.inte,
          fontSize: 18,
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: Obx(
        () => ListView.builder(
          itemCount: controller.stationList.length,
          itemBuilder: stationItemCell,
        ),
      ),
    );
  }

  Widget stationItemCell(BuildContext context, int index) {
    SelfPickupStationModel model = controller.stationList[index];

    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pop(model);
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppStyles.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1, color: AppStyles.white)),
        margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppText(
              str: model.name,
              fontWeight: FontWeight.bold,
              lines: 3,
            ),
            AppGaps.vGap4,
            AppText(
              str: model.contactor! + ' ${model.contactInfo ?? ''}',
              lines: 3,
            ),
            AppGaps.vGap4,
            SizedBox(
              child: AppText(
                str:
                    '${model.area?.name ?? ''}${model.subArea?.name ?? ''}${model.address!}',
                lines: 6,
              ),
            ),
            // Spaces.vGap4,
            // AppText(
            //   str: '支持貨到付款：${model.isDelivery == 1 ? '是' : '否'}',
            // ),
            // Spaces.vGap4,
            // Wrap(
            //   spacing: 10,
            //   children: [
            //     Text(
            //       '${'包裹限重'.inte}：' +
            //           ((model.limitOneWeight ?? 0) < 1000000
            //               ? ((model.limitOneWeight! / 1000).toString())
            //               : '无'.inte),
            //     ),
            //     Text(
            //       '${'包裹单边限长'.inte}：' +
            //           ((model.limitLength ?? 0) < 1000000
            //               ? ((model.limitLength! / 100).toString())
            //               : '无'.inte),
            //     ),
            //     Text(
            //       '${'整票限重'.inte}：' +
            //           ((model.limitManyWeight ?? 0) < 1000000
            //               ? ((model.limitManyWeight! / 1000).toString())
            //               : '无'.inte),
            //     ),
            //   ],
            // ),
            // Spaces.vGap4,
            // AppText(
            //   str: '${'营业时间'.inte}：${model.openingHours ?? ''}',
            //   lines: 4,
            // ),
            // Spaces.vGap4,
            // AppText(
            //   str: '${'公告'.inte}：${model.announcement ?? ''}',
            //   lines: 5,
            // ),
          ],
        ),
      ),
    );
  }
}
