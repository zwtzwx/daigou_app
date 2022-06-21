/*
  无人认领详细界面
 */

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoOwnerParcelDetailPage extends StatefulWidget {
  final Map? arguments;
  const NoOwnerParcelDetailPage({Key? key, this.arguments}) : super(key: key);

  @override
  NoOwnerParcelDetailPageState createState() => NoOwnerParcelDetailPageState();
}

class NoOwnerParcelDetailPageState extends State<NoOwnerParcelDetailPage>
    with AutomaticKeepAliveClientMixin {
  String headerStr = '';
  String footerStr = '';

  // 同步信息包裹列表
  List<ParcelModel> syncsList = [];
  // 快递单号
  String courierNumber = "";

  // 同步包裹, 这个有啥用???
  ParcelModel syncsListFirstParcel = ParcelModel();

  // 是传过来的Model
  ParcelModel argusmentParcelModel = ParcelModel();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    argusmentParcelModel = widget.arguments!['order'] as ParcelModel;
    setState(() {
      String s1 = argusmentParcelModel.expressNum!;
      headerStr = s1.split('*')[0];
      footerStr = s1.split('*')[1];
    });
    getListData();
  }

  getListData() async {
    var data = await ParcelService.getSyncsList();
    setState(() {
      syncsList = data;
      if (syncsList.isNotEmpty) {
        syncsListFirstParcel = syncsList.first;
      }
    });
  }

  final TextEditingController _projectNameController = TextEditingController();

  final FocusNode _projectName = FocusNode();

  bool flag = false;
  FocusNode blankNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Caption(
          str: '异常件认领',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: ColorConfig.bgGray,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: MainButton(
            text: '提交',
            onPressed: () async {
              ParcelModel? tmpParcelModel;
              if (flag) {
                tmpParcelModel = ParcelModel.fromSimpleJson({
                  'express_num':
                      headerStr + _projectNameController.text + footerStr,
                  'id': syncsListFirstParcel.id,
                });
              } else {
                tmpParcelModel = ParcelModel.fromSimpleJson({
                  'express_num':
                      headerStr + _projectNameController.text + footerStr,
                  'id': 0,
                });
              }
              EasyLoading.show(status: '认领中...');
              var result = await ParcelService.setNoOwnerToMe(
                  argusmentParcelModel.id!, tmpParcelModel);
              EasyLoading.dismiss();
              if (result['ok']) {
                EasyLoading.showSuccess('认领成功').then((value) {
                  Routers.pop(context);
                });
              } else {
                EasyLoading.showError(result['msg']);
              }
            },
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            child: buildSubViews(),
          ),
        ),
      ),
    );
  }

  Widget buildSubViews() {
    var content = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().screenWidth,
              child: InputTextItem(
                  leftFlex: 3,
                  rightFlex: 8,
                  title: "快递单号",
                  inputText: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Caption(
                                alignment: TextAlign.left,
                                str: headerStr,
                              )),
                          Expanded(
                              flex: 6,
                              child: NormalInput(
                                hintText: "请输入中间单号",
                                contentPadding: const EdgeInsets.only(top: 17),
                                textAlign: TextAlign.left,
                                controller: _projectNameController,
                                focusNode: _projectName,
                                autoFocus: false,
                                keyboardType: TextInputType.text,
                                onSubmitted: (res) {
                                  FocusScope.of(context)
                                      .requestFocus(blankNode);
                                },
                                onChanged: (res) {
                                  courierNumber = res;
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: Caption(
                                str: footerStr,
                              )),
                        ],
                      ))),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        syncsList.isNotEmpty
            ? InputTextItem(
                title: "认领并填入已预报包裹信息",
                leftFlex: 8,
                rightFlex: 2,
                inputText: SizedBox(
                  height: 55,
                  width: 100,
                  child: Switch.adaptive(
                    value: flag,
                    activeColor: ColorConfig.primary,
                    onChanged: (value) {
                      setState(() {
                        flag = value;
                        FocusScope.of(context).requestFocus(blankNode);
                      });
                    },
                  ),
                ))
            : Container(),
        flag
            ? GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                      context: context,
                      // isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: syncsList.length < 6
                              ? syncsList.length.toDouble() * 44
                              : 220,
                          child: ListView.builder(
                            itemCount: syncsList.length,
                            itemExtent: 44,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                trailing:
                                    syncsListFirstParcel == syncsList[index]
                                        ? const Icon(Icons.check)
                                        : Container(
                                            width: 10,
                                          ),
                                title: SizedBox(
                                  height: 44,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(syncsList[index].expressNum!,
                                          style: const TextStyle(
                                              color: ColorConfig.textDark)),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    syncsListFirstParcel = syncsList[index];
                                    Navigator.of(context).pop();
                                  });
                                },
                              );
                            },
                          ),
                        );
                      });
                },
                child: InputTextItem(
                    title: "同步包裹",
                    inputText: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            syncsListFirstParcel.expressNum!,
                            style: TextConfig.textGray14,
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(right: 15, top: 10, bottom: 10),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
    return content;
  }
}
