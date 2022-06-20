/*
  代理邀请的好友
*/

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/agent_data_count_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';

class AgentMemberPage extends StatefulWidget {
  const AgentMemberPage({Key? key}) : super(key: key);

  @override
  AgentMemberPageState createState() => AgentMemberPageState();
}

class AgentMemberPageState extends State<AgentMemberPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final PageController _pageController = PageController();

  AgentDataCountModel? countModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getSubCount();
  }

  getSubCount() async {
    var data = await AgentService.getDataCount();
    setState(() {
      countModel = data;
    });
  }

  void _onPageChange(int index) {
    _tabController.animateTo(index);
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
        title: const Caption(
          str: '我的推广',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        bottom: TabBar(
            labelColor: ColorConfig.primary,
            indicatorColor: ColorConfig.primary,
            controller: _tabController,
            onTap: (int index) {
              _pageController.jumpToPage(index);
            },
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Caption(str: '已注册好友' '(${countModel?.all ?? 0})'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Caption(str: '已下单好友' '(${countModel?.hasOrder ?? 0})'),
              ),
            ]),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: PageView.builder(
        controller: _pageController,
        itemCount: 2,
        onPageChanged: _onPageChange,
        itemBuilder: (context, index) {
          return _AgentMemberList(hasOrder: index);
        },
      ),
    );
  }

  Widget buildAgentUserView(int index, UserModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        border: Border(
          bottom: BorderSide(color: ColorConfig.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: Caption(
              str: model.name,
            ),
          ),
          Gaps.vGap5,
          SizedBox(
            child: Caption(
              str: '注册时间：' + model.createdAt,
              fontSize: 13,
              color: ColorConfig.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentMemberList extends StatefulWidget {
  final int hasOrder;
  const _AgentMemberList({Key? key, required this.hasOrder}) : super(key: key);

  @override
  State<_AgentMemberList> createState() => __AgentMemberListState();
}

class __AgentMemberListState extends State<_AgentMemberList> {
  int pageIndex = 0;

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
      "has_order": widget.hasOrder,
    };
    var data = await AgentService.getSubList(dic);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ListRefresh(
      renderItem: buildAgentUserView,
      refresh: loadList,
      more: loadMoreList,
    );
  }

  Widget buildAgentUserView(int index, UserModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        border: Border(
          bottom: BorderSide(color: ColorConfig.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: Caption(
              str: model.name,
            ),
          ),
          Gaps.vGap5,
          SizedBox(
            child: Caption(
              str: '注册时间：' + model.createdAt,
              fontSize: 13,
              color: ColorConfig.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
