import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/station_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class StationPage extends StatefulWidget {
  const StationPage({Key? key}) : super(key: key);

  @override
  State<StationPage> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await StationService.getList({"page": (++pageIndex)});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '自提点'),
          color: ColorConfig.textBlack,
          fontSize: 18,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SafeArea(
        child: ListRefresh(
          renderItem: renderItem,
          refresh: loadList,
          more: loadMoreList,
        ),
      ),
    );
  }

  renderItem(int index, SelfPickupStationModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Caption(
              str: model.name,
              fontSize: 18,
              color: ColorConfig.primary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Caption(
                    str: Translation.t(context, '联系人'),
                    color: ColorConfig.textGray,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Caption(
                    str: model.contactor ?? '',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Caption(
                    str: Translation.t(context, '收件电话'),
                    color: ColorConfig.textGray,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Caption(
                    str: model.contactInfo ?? '',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Caption(
                    str: Translation.t(context, '详细地址'),
                    color: ColorConfig.textGray,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Caption(
                    str: model.address ?? '',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Caption(
                    str: Translation.t(context, '国家/地区'),
                    color: ColorConfig.textGray,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Caption(
                    str:
                        '${model.country?.name ?? ''}${model.area?.name ?? ''}${model.subArea?.name ?? ''}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Caption(
              str: Translation.t(context, '支持渠道'),
              color: ColorConfig.textGray,
              fontSize: 16,
            ),
          ),
          model.expressLines != null
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.expressLines!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildLineItem(index, model);
                  })
              : Gaps.empty
        ],
      ),
    );
  }

  Widget buildLineItem(int index, SelfPickupStationModel model) {
    ShipLineModel lineModel = model.expressLines![index];
    String? propStr = lineModel.props?.map((item) => item.name).join(',');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: index != model.expressLines!.length - 1
              ? const BorderSide(color: ColorConfig.line)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: ClipOval(
              child: LoadImage(
                lineModel.icon?.icon ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Gaps.hGap15,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Caption(
                  str: lineModel.name,
                  fontSize: 18,
                ),
                Gaps.vGap4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Caption(
                      str: lineModel.regions!.isNotEmpty
                          ? (lineModel.regions?[0].referenceTime ?? '')
                          : '',
                      fontSize: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Routers.push('/LineDetailPage', context,
                            {'id': lineModel.id, 'type': 1});
                      },
                      child: Caption(
                        str: Translation.t(context, '查看详情'),
                        fontSize: 12,
                        color: ColorConfig.main,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Gaps.vGap4,
                Caption(
                  str: propStr ?? '',
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
