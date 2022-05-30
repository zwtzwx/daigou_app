/*
  银行选择
*/

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/bank_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectBankPage extends StatefulWidget {
  const SelectBankPage({Key? key}) : super(key: key);

  @override
  SelectBankPageState createState() => SelectBankPageState();
}

class SelectBankPageState extends State<SelectBankPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = '';

  BankModel? bankModel;

  FocusNode blankNode = FocusNode();

  final TextEditingController _searchContraller = TextEditingController();

  final FocusNode _searchNode = FocusNode();
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageTitle = '选择银行';
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var dic = await AgentService.getBankList({
      'page': ++pageIndex,
      'size': '50',
      'name': _searchContraller.text,
    });
    return dic;
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
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 60,
          child: GestureDetector(
            onTap: () {
              if (bankModel == null) {
                Util.showToast('请选择银行');
              } else {
                Navigator.of(context).pop(bankModel);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(
                  right: 15, left: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: ColorConfig.warningText,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(width: 1, color: ColorConfig.warningText)),
              alignment: Alignment.center,
              height: 40,
              child: const Caption(
                str: '确认提交',
              ),
            ),
          ),
        ),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    var listView = Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: buildBottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
    return listView;
  }

  Widget buildBottomListCell(int index, BankModel model) {
    if (index == 0) {
      return SearchBar(
        onSearchClick: (content) {
          ApplicationEvent.getInstance()
              .event
              .fire(ListRefreshEvent(type: 'refresh'));
          loadList();
        },
        controller: _searchContraller,
        focusNode: _searchNode,
        onSearch: (String value) {},
      );
    }
    return GestureDetector(
        onTap: () async {
          FocusScope.of(context).requestFocus(blankNode);
          setState(() {
            bankModel = model;
          });
        },
        child: Container(
            decoration: const BoxDecoration(
              color: ColorConfig.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Caption(
                  str: model.name,
                ),
                model == bankModel
                    ? const Icon(
                        Icons.check_circle,
                        color: ColorConfig.warningText,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                      ),
              ],
            )));
  }
}
