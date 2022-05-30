import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

/*
  运费查询结果、选择线路
*/

class LinesPage extends StatefulWidget {
  const LinesPage({Key? key, this.arguments}) : super(key: key);
  final Map? arguments;

  @override
  LinesPageState createState() => LinesPageState();
}

class LinesPageState extends State<LinesPage> {
  final ScrollController _scrollController = ScrollController();
  List<ShipLineModel> lineData = [];
  Map<String, dynamic>? postDic;
  bool isEmpty = false;
  late LocalizationModel localModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      postDic = widget.arguments?['data'];
      localModel = Provider.of<Model>(context, listen: false).localizationInfo!;
    });
    loadDataList();
  }

  loadDataList() async {
    EasyLoading.show(status: '加载...');
    List<ShipLineModel> result = await ShipLineService.getList(postDic);
    EasyLoading.dismiss();
    setState(() {
      lineData = result;
      if (result.isEmpty) {
        isEmpty = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = '选择渠道';
    if (widget.arguments != null && widget.arguments!['query'] != null) {
      title = '渠道列表';
    }
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: Caption(
          str: title,
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: !isEmpty
          ? buildListView()
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  height: 140,
                  width: 140,
                  child: LoadImage(
                    '',
                    fit: BoxFit.contain,
                    holderImg: "PackageAndOrder/暂无内容@3x",
                    format: "png",
                  ),
                ),
                Caption(
                  str: '当前区域暂无线路可选',
                  color: ColorConfig.textGrayC,
                )
              ],
            )),
    );
  }

  Widget buildListView() {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: buildCellForFirstListView,
      controller: _scrollController,
      itemCount: lineData.length,
    );
    return listView;
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    ShipLineModel model = lineData[index];
    String deliveryStr = '';
    // 1 自提/送货上门  0送货上门 2自提
    switch (model.isDelivery) {
      case 0:
        deliveryStr = '(送货上门)';
        break;
      case 1:
        deliveryStr = '(自提/送货上门)';
        break;
      case 2:
        deliveryStr = '(自提)';
        break;
      default:
    }

    return GestureDetector(
        onTap: () async {
          if (widget.arguments?['query'] ?? false) {
            Routers.push(
                '/LineDetailPage', context, {'line': model, 'type': 2});
          } else {
            Navigator.of(context).pop(model);
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: ColorConfig.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1, color: ColorConfig.white)),
            margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
            height: model.isDelivery != 0 ? 160 : 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                model.isGreatValue == 1
                    ? Container(
                        height: 20,
                        width: 90,
                        decoration: const BoxDecoration(
                          color: ColorConfig.warningTextDark80,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular((10)),
                              bottomRight: Radius.circular((10))),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 20,
                              alignment: Alignment.center,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: ColorConfig.warningTextDark,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular((10)),
                                    bottomRight: Radius.circular((10))),
                              ),
                              child: SizedBox(
                                height: 19,
                                width: 19,
                                child: Image.asset(
                                    'assets/images/AboutMe/密封LOGO@3x.png'),
                              ),
                            ),
                            Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 30,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Caption(
                                    str: '精选路线',
                                    fontSize: 13,
                                  ),
                                ))
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            width: ScreenUtil().screenWidth - 52,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: model.name,
                                            style: const TextStyle(
                                              color: ColorConfig.textBlack,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // TextSpan(
                                          //   text: deliveryStr,
                                          //   style: TextStyle(
                                          //     color: ColorConfig.textRed,
                                          //     fontSize: 15.0,
                                          //     fontWeight: FontWeight.bold,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  GestureDetector(
                                    onTap: () {
                                      Routers.push('/LineDetailPage', context,
                                          {'line': model, 'type': 2});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Row(
                                        children: const <Widget>[
                                          Caption(
                                            str: '查看详情',
                                            color: ColorConfig.textGray,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: ColorConfig.textGray,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                child: LoadImage(
                                  model.icon!.icon,
                                  fit: BoxFit.contain,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: ScreenUtil().screenWidth - 52 - 50 - 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    getTextDes(
                                        0,
                                        localModel.currencySymbol +
                                            (model.expireFee! / 100)
                                                .toStringAsFixed(2)),
                                    getTextDes(
                                        1,
                                        (model.countWeight! / 1000)
                                                .toStringAsFixed(2) +
                                            localModel.weightSymbol),
                                    getTextDes(2, model.region!.referenceTime),
                                    model.isDelivery != 0
                                        ? getTextDes(3, '自提路线收货地址为自提点地址')
                                        : Container()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  Widget getTextDes(int index, String contents) {
    List<String> titleList = ['预估运费*：', '计费重量：', '运送时效：', '*'];
    var text = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Caption(
          str: titleList[index],
          color: index == 3 ? ColorConfig.textRed : ColorConfig.textDark,
        ),
        Caption(
          str: contents,
          color: index == 0 ? ColorConfig.textRed : ColorConfig.textGray,
        )
      ],
    );

    return text;
  }
}
