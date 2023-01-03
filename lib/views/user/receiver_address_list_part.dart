/*
  收件地址列表
 */

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/receiver_address_refresh_event.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/services/address_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';

class ReceiverAddressListPage extends StatefulWidget {
  final Map? arguments;

  const ReceiverAddressListPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  ReceiverAddressListPageState createState() => ReceiverAddressListPageState();
}

class ReceiverAddressListPageState extends State<ReceiverAddressListPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;
  final ScrollController _scrollController = ScrollController();

  List<ReceiverAddressModel> addressList = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _keywordNode = FocusNode();
  String keyword = '';

  @override
  void initState() {
    super.initState();
    created();
    ApplicationEvent.getInstance()
        .event
        .on<ReceiverAddressRefreshEvent>()
        .listen((event) {
      created();
    });
  }

  created() async {
    EasyLoading.show();
    var data = await AddressService.getReceiverList({'keyword': keyword});
    EasyLoading.dismiss();
    setState(() {
      addressList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: ZHTextLine(
            str: Translation.t(context, '地址管理'),
            fontSize: 18,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 40,
            child: MainButton(
              text: '添加地址',
              onPressed: () {
                Routers.push(
                    '/ReceiverAddressEditPage', context, {'isEdit': '0'});
              },
            ),
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              buildSearchView(),
              Expanded(
                child: buildListView(),
              ),
            ],
          ),
        ));
  }

  Widget buildSearchView() {
    return Container(
      color: Colors.white,
      child: SearchBar(
        onSearch: (value) {
          setState(() {
            keyword = value;
          });
        },
        onSearchClick: (value) {
          created();
        },
        controller: _controller,
        focusNode: _keywordNode,
      ),
    );
  }

  Widget buildListView() {
    var listView = ListView.builder(
      shrinkWrap: true,
      itemBuilder: buildCellForFirstListView,
      controller: _scrollController,
      itemCount: addressList.length,
    );
    return listView;
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    ReceiverAddressModel model = addressList[index];
    // 名字
    String nameN = model.receiverName;
    String timezoneN = model.timezone + '-';
    String phoneN = model.phone;
    String nameAll = timezoneN + phoneN;
    // 地址拼接
    String contentStr = '';

    if (model.area != null) {
      if (model.area != null) {
        contentStr = model.countryName + ' ' + model.area!.name;
      }
      if (model.subArea != null) {
        contentStr += ' ' + model.subArea!.name;
      }
    } else {
      contentStr += model.street;
      contentStr += ' ' + model.doorNo;
      contentStr += ' ' + model.city;
      contentStr += ' ' + model.countryName;
    }

    return GestureDetector(
        onTap: () async {
          if (widget.arguments?['select'] == 1) {
            Navigator.of(context).pop(model);
          }
        },
        child: Container(
            decoration: const BoxDecoration(
              color: ColorConfig.white,
              border: Border(
                top: BorderSide(
                  color: ColorConfig.line,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().screenWidth - 60,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                model.isDefault == 1
                                    ? Container(
                                        width: 30,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            top: 3, bottom: 3, right: 5),
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        decoration: BoxDecoration(
                                            color: HexToColor('#886ED7'),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(2))),
                                        child: ZHTextLine(
                                          str: Translation.t(context, '默认'),
                                          fontSize: 9,
                                          color: ColorConfig.white,
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ZHTextLine(
                                    str: nameN,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ZHTextLine(
                                  str: nameAll,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            width: ScreenUtil().screenWidth - 60,
                            alignment: Alignment.topLeft,
                            child: ZHTextLine(
                              str: contentStr,
                              lines: 3,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Routers.push('/ReceiverAddressEditPage', context,
                              {'address': model, 'isEdit': '1'});
                        },
                        child: const ImageIcon(
                          AssetImage("assets/images/AboutMe/编辑@3x.png"),
                          color: ColorConfig.textDark,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    _keywordNode.dispose();
    super.dispose();
  }
}
