import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/user/agent/agent_member/controller.dart';

class AgentMemberPage extends GetView<AgentMemberController> {
  const AgentMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '我的推广'.ts,
          fontSize: 17,
        ),
        bottom: TabBar(
            labelColor: BaseStylesConfig.primary,
            indicatorColor: BaseStylesConfig.primary,
            controller: controller.tabController,
            onTap: (int index) {
              controller.pageController.jumpToPage(index);
            },
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Obx(
                  () => ZHTextLine(
                      str: '已注册好友'.ts +
                          '(${controller.countModel.value?.all ?? 0})'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Obx(
                  () => ZHTextLine(
                      str: '已下单好友'.ts +
                          '(${controller.countModel.value?.hasOrder ?? 0})'),
                ),
              ),
            ]),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: PageView.builder(
        controller: controller.pageController,
        itemCount: 2,
        onPageChanged: controller.onPageChange,
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
        color: BaseStylesConfig.white,
        border: Border(
          bottom: BorderSide(color: BaseStylesConfig.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: ZHTextLine(
              str: model.name,
            ),
          ),
          Sized.vGap5,
          SizedBox(
            child: ZHTextLine(
              str: '注册时间'.ts + '：' + model.createdAt,
              fontSize: 13,
              color: BaseStylesConfig.textGray,
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
        color: BaseStylesConfig.white,
        border: Border(
          bottom: BorderSide(color: BaseStylesConfig.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: ZHTextLine(
              str: model.name,
            ),
          ),
          Sized.vGap5,
          SizedBox(
            child: ZHTextLine(
              str: '注册时间'.ts + '：' + model.createdAt,
              fontSize: 13,
              color: BaseStylesConfig.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
