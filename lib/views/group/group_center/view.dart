import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/group/group_center/controller.dart';

class GroupCenterPage extends GetView<GroupCenterController> {
  const GroupCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      primary: false,
      backgroundColor: BaseStylesConfig.bgGray,
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: BaseStylesConfig.primary,
        child: ListView(
          controller: controller.loadingUtil.value.scrollController,
          children: [],
        ),
      ),
    );
  }
}
