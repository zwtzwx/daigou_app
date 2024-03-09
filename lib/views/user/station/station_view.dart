import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/self_pickup_station_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/user/station/station_controller.dart';

class StationView extends GetView<StationController> {
  const StationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '自提点'.inte,
          fontSize: 18,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: AppStyles.bgGray,
      body: SafeArea(
        child: RefreshView(
          renderItem: renderItem,
          refresh: controller.loadList,
          more: controller.loadMoreList,
        ),
      ),
    );
  }

  Widget renderItem(int index, SelfPickupStationModel model) {
    List<Map> list = [
      {'label': '联系人', 'value': model.contactor},
      {'label': '联系电话', 'value': model.contactInfo},
      {'label': '详细地址', 'value': model.address},
      {'label': '国家/地区', 'value': model.country?.name ?? ''},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
          child: AppText(
            str: model.name,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 15),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(5),
          // ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list
                .map((e) => Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: e['label'] != '国家/地区'
                                ? const BorderSide(color: AppStyles.line)
                                : BorderSide.none),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppText(
                            str: (e['label'] as String).inte,
                            color: AppStyles.textGrayC,
                            fontSize: 13,
                          ),
                          AppGaps.vGap4,
                          AppText(
                            str: e['value'],
                            lines: 4,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
