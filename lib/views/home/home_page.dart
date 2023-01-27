import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/home/widget/banner_cell.dart';
import 'package:jiyun_app_client/views/home/widget/module_cell.dart';

/*
  首页
*/

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: controller.scaffoldKey,
        primary: false,
        appBar: const EmptyAppBar(),
        backgroundColor: BaseStylesConfig.bgGray,
        body: RefreshIndicator(
          onRefresh: controller.handleRefresh,
          color: BaseStylesConfig.themeRed,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: buildCellForFirstListView,
            controller: controller.scrollController,
            itemCount: 2,
          ),
        ),
      ),
    );
  }

  // 首页布局
  Widget buildCellForFirstListView(BuildContext context, int index) {
    Widget widget;
    switch (index) {
      case 1:
        widget = EntryLinkCell();
        break;
      default:
        widget = const BannerCell();
    }
    return widget;
  }
}
