import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/home/widget/ship_line_item.dart';
import 'package:provider/provider.dart';

class LineAllPage extends StatefulWidget {
  const LineAllPage({Key? key}) : super(key: key);

  @override
  State<LineAllPage> createState() => _LineAllPageState();
}

class _LineAllPageState extends State<LineAllPage> {
  List<ShipLineModel> lineList = [];
  LocalizationModel? localModel;

  @override
  void initState() {
    super.initState();
    localModel = Provider.of<Model>(context, listen: false).localizationInfo;
    getList();
  }

  getList() async {
    List<ShipLineModel> result =
        await ShipLineService.getList(const {'is_great_value': 1});
    setState(() {
      lineList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Caption(
          str: '所有路线',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListView.builder(
            itemCount: lineList.length, itemBuilder: _buildLineItem),
      ),
    );
  }

  Widget _buildLineItem(BuildContext context, int index) {
    ShipLineModel model = lineList[index];
    String propStr = '';
    if (model.props != null) {
      for (var item in model.props!) {
        if (propStr.isEmpty) {
          propStr = item.name!;
        } else {
          propStr = propStr + ',' + item.name!;
        }
      }
    }
    return buildLineItem(context, model, propStr, localModel);
  }
}
