/*
  选择自提点
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  late ShipLineModel model;

  @override
  void initState() {
    super.initState();
    pageTitle = '选择自提点';
    model = widget.arguments['model'] as ShipLineModel;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
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
      body: Container(
        child: buildListView(),
      ),
    );
  }

  Widget buildListView() {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: buildCellForFirstListView,
      controller: _scrollController,
      itemCount: model.selfPickupStations!.length,
    );
    return listView;
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    SelfPickupStationModel model1 = model.selfPickupStations![index];

    return GestureDetector(
        onTap: () async {
          Navigator.of(context).pop(model1);
        },
        child: Container(
            decoration: BoxDecoration(
                color: ColorConfig.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1, color: ColorConfig.white)),
            margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 30,
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    width: ScreenUtil().screenWidth - 50,
                    child: Row(
                      children: <Widget>[
                        Caption(
                          str: model1.name,
                          fontWeight: FontWeight.w500,
                        ),
                        Caption(
                          str: ' ' +
                              model1.contactor! +
                              ' ' +
                              model1.contactInfo!,
                        )
                      ],
                    )),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Caption(
                        str: '详细地址：',
                      ),
                      Caption(
                        str: model1.address!,
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
