/*
  选择自提点
*/

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/components/empty_box.dart';

class SelectSelfPickUpPage extends StatefulWidget {
  const SelectSelfPickUpPage({Key? key, required this.arguments})
      : super(key: key);
  final Map arguments;

  @override
  SelectSelfPickUpPageState createState() => SelectSelfPickUpPageState();
}

class SelectSelfPickUpPageState extends State<SelectSelfPickUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  String pageTitle = '';
  late int id;
  List<SelfPickupStationModel>? stationList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pageTitle = '选择自提点';
    id = widget.arguments['id'];
    getStationList();
  }

  void getStationList() async {
    EasyLoading.show();
    var data = await ShipLineService.getDetail(id);
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        isLoading = true;
        stationList = data.selfPickupStations;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: pageTitle,
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      body: isLoading
          ? Container(
              child: (stationList != null && stationList!.isNotEmpty)
                  ? buildListView()
                  : emptyBox('暂无可选自提点'))
          : Gaps.empty,
    );
  }

  Widget buildListView() {
    var listView = ListView.builder(
      itemBuilder: buildCellForFirstListView,
      controller: _scrollController,
      itemCount: stationList?.length ?? 0,
    );
    return listView;
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    SelfPickupStationModel model = stationList![index];

    return GestureDetector(
        onTap: () async {
          Navigator.of(context).pop(model);
        },
        child: Container(
            decoration: BoxDecoration(
                color: ColorConfig.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1, color: ColorConfig.white)),
            margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Caption(
                          str: model.name,
                          fontWeight: FontWeight.w500,
                        ),
                        Caption(
                          str:
                              ' ' + model.contactor! + ' ' + model.contactInfo!,
                        )
                      ],
                    )),
                SizedBox(
                  child: Caption(
                    str: '详细地址：' + model.address!,
                    lines: 4,
                  ),
                )
              ],
            )));
  }
}
