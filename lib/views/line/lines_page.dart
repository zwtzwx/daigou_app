import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:jiyun_app_client/common/translation.dart';
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
    EasyLoading.show();
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
          str: Translation.t(context, title),
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
              children: <Widget>[
                const SizedBox(
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
                  str: Translation.t(context, '当前区域暂无线路可选'),
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

    return GestureDetector(
      onTap: () async {
        if (widget.arguments?['query'] ?? false) {
          Routers.push('/LineDetailPage', context, {'line': model, 'type': 2});
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
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
        child: Row(
          children: [
            LoadImage(
              model.icon!.icon,
              fit: BoxFit.contain,
              width: 50,
              height: 50,
            ),
            Gaps.hGap15,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    verticalDirection: VerticalDirection.up,
                    children: [
                      Caption(
                        str: model.name,
                        fontWeight: FontWeight.bold,
                      ),
                      model.isDelivery > 0
                          ? Caption(
                              str: ' (自提' +
                                  (model.isDelivery == 2 ? '/送货上门' : '') +
                                  ')',
                              color: ColorConfig.textRed,
                              fontWeight: FontWeight.bold,
                            )
                          : Gaps.empty,
                    ],
                  ),
                  Gaps.vGap4,
                  getTextDes(
                    0,
                    localModel.currencySymbol +
                        ((model.expireFee ?? 0) / 100).toStringAsFixed(2),
                    isRequired: true,
                  ),
                  getTextDes(
                    1,
                    model.region!.referenceTime,
                  ),
                  getTextDes(
                    2,
                    ((model.countWeight ?? 0) / 1000).toStringAsFixed(2) +
                        localModel.weightSymbol,
                  ),
                  Gaps.vGap4,
                  model.labels != null && model.labels!.isNotEmpty
                      ? Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: model.labels!.map((e) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFf59598),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  height: 20,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Caption(
                                    str: e.name,
                                    color: const Color(0xFFe80c13),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      : Gaps.empty,
                ],
              ),
            ),
            Gaps.hGap15,
            GestureDetector(
              onTap: () {
                Routers.push(
                    '/LineDetailPage', context, {'line': model, 'type': 2});
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                color: ColorConfig.textGray,
                size: 20,
              ),
            ),
          ],
        ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Container(
        //       padding: const EdgeInsets.all(10),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               Container(
        //                 height: 30,
        //                 alignment: Alignment.center,
        //                 width: ScreenUtil().screenWidth - 52,
        //                 child: Row(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: <Widget>[
        //                       Expanded(
        //                           child: Container(
        //                         alignment: Alignment.centerLeft,
        //                         child: RichText(
        //                           maxLines: 1,
        //                           overflow: TextOverflow.ellipsis,
        //                           text: TextSpan(
        //                             children: <TextSpan>[
        //                               TextSpan(
        //                                 text: model.name,
        //                                 style: const TextStyle(
        //                                   color: ColorConfig.textBlack,
        //                                   fontSize: 17.0,
        //                                   fontWeight: FontWeight.bold,
        //                                 ),
        //                               ),
        //                               // TextSpan(
        //                               //   text: deliveryStr,
        //                               //   style: TextStyle(
        //                               //     color: ColorConfig.textRed,
        //                               //     fontSize: 15.0,
        //                               //     fontWeight: FontWeight.bold,
        //                               //   ),
        //                               // ),
        //                             ],
        //                           ),
        //                         ),
        //                       )),
        //                       GestureDetector(
        //                         onTap: () {
        //                           Routers.push('/LineDetailPage', context,
        //                               {'line': model, 'type': 2});
        //                         },
        //                         child: Padding(
        //                           padding: const EdgeInsets.only(
        //                             right: 0,
        //                           ),
        //                           child: Row(
        //                             children: const <Widget>[
        //                               Caption(
        //                                 str: '查看详情',
        //                                 color: ColorConfig.textGray,
        //                               ),
        //                               Icon(
        //                                 Icons.arrow_forward_ios,
        //                                 color: ColorConfig.textGray,
        //                                 size: 20,
        //                               )
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ]),
        //               ),
        //               Row(
        //                 children: <Widget>[
        //                   Container(
        //                     alignment: Alignment.topCenter,
        //                     child: LoadImage(
        //                       model.icon!.icon,
        //                       fit: BoxFit.contain,
        //                       width: 50,
        //                       height: 50,
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 10,
        //                   ),
        //                   SizedBox(
        //                     width: ScreenUtil().screenWidth - 52 - 50 - 10,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         getTextDes(
        //                             0,
        //                             localModel.currencySymbol +
        //                                 (model.expireFee! / 100)
        //                                     .toStringAsFixed(2)),
        //                         getTextDes(
        //                             1,
        //                             (model.countWeight! / 1000)
        //                                     .toStringAsFixed(2) +
        //                                 localModel.weightSymbol),
        //                         getTextDes(2, model.region!.referenceTime),
        //                         model.isDelivery != 0
        //                             ? getTextDes(3, '自提路线收货地址为自提点地址')
        //                             : Container()
        //                       ],
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }

  Widget getTextDes(int index, String contents, {bool isRequired = false}) {
    List<String> titleList = ['预估运费', '运送时效', '计费重量'];
    var text = Row(
      children: <Widget>[
        Caption(
          str: titleList[index],
          color: ColorConfig.textGray,
          fontSize: 14,
        ),
        isRequired
            ? const Caption(
                str: '*',
                color: ColorConfig.textRed,
                fontSize: 14,
              )
            : Gaps.empty,
        const Caption(
          str: '：',
          color: ColorConfig.textGray,
          fontSize: 14,
        ),
        Caption(
          str: contents,
          fontSize: 14,
        )
      ],
    );

    return text;
  }
}
