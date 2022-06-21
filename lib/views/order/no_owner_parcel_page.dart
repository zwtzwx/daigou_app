// ignore_for_file: unnecessary_const

/*
  无人认领包裹
 */

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoOwnerParcelPage extends StatefulWidget {
  const NoOwnerParcelPage({Key? key}) : super(key: key);

  @override
  NoOwnerParcelPageState createState() => NoOwnerParcelPageState();
}

class NoOwnerParcelPageState extends State<NoOwnerParcelPage> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              headerView(),
              Expanded(
                child: Container(
                  child: buildListView(context),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   loadList();
    // });
  }

  Widget buildListView(context) {
    return ListRefresh(
      renderItem: buildCellList,
      refresh: loadList,
      more: loadMoreList,
      shrinkWrap: true,
    );
  }

  Widget headerView() {
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      color: Colors.white,
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
        onSearch: (str) {
          // onSearch();
        },
        onSearchClick: (str) {
          onSearch();
        },
      ),
    );
  }

  // 搜索
  onSearch() {
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
      'keyword': _controller.text
    };

    var data = ParcelService.getOnOwnerList(params);
    return data;
  }

  Widget buildCellList(int index, ParcelModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: ColorConfig.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const ImageIcon(
                  const AssetImage("assets/images/PackageAndOrder/tag.png"),
                  color: ColorConfig.primary,
                  size: 20,
                ),
              ),
              Gaps.hGap5,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Caption(
                        str: '快递单号：',
                        fontSize: 14,
                      ),
                      Caption(
                        str: model.expressNum ?? "",
                        fontSize: 14,
                      ),
                    ],
                  ),
                  Gaps.vGap4,
                  Caption(
                    str: '入库时间：' + (model.inStorageAt ?? ""),
                    fontSize: 13,
                    color: ColorConfig.textGray,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            child: MainButton(
              text: '认领',
              onPressed: () {
                Routers.push(
                    '/NoOwnerParcelDetailPage', context, {'order': model});
              },
            ),
          )
        ],
      ),
    );
  }
}
