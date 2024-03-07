import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/announcement_model.dart';
import 'package:huanting_shop/models/article_model.dart';
import 'package:huanting_shop/services/announcement_service.dart';
import 'package:huanting_shop/services/article_service.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/help/help_center/controller.dart';

class BeeSupportView extends GetView<BeeSupportLogic> {
  const BeeSupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: AppText(
          str: '帮助中心'.ts,
          fontSize: 17,
        ),
        bottom: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          tabs: ['公告', '常见问题', '禁运物品', '新手指引']
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                  child: AppText(
                    str: e.ts,
                    lines: 2,
                    alignment: TextAlign.center,
                  ),
                ),
              )
              .toList(),
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          onTap: (value) {
            controller.pageController.jumpToPage(value);
          },
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: PageView.builder(
        itemCount: 4,
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.tabController.animateTo(value);
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: index == 0
                ? const _AnnouncementList()
                : _ArticleList(type: index),
          );
        },
      ),
    );
  }
}

// 公告消息列表
class _AnnouncementList extends StatefulWidget {
  const _AnnouncementList({
    Key? key,
  }) : super(key: key);

  @override
  _AnnouncementListState createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<_AnnouncementList> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {'page': (++pageIndex)};
    return await AnnouncementService.getList(params);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshView(
      shrinkWrap: true,
      // physics: true,
      renderItem: buildBottomListCell,
      refresh: loadList,
      more: loadMoreList,
    );
  }

  Widget buildBottomListCell(int index, AnnouncementModel model) {
    return GestureDetector(
      onTap: () async {
        BeeNav.push(BeeNav.webview, arg: {
          'url': model.content,
          'title': model.title,
          'time': model.createdAt
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppText(
              str: model.title,
              fontSize: 16,
            ),
            5.verticalSpaceFromWidth,
            AppText(
              str: model.createdAt,
              color: AppColors.textGrayC,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleList extends StatefulWidget {
  const _ArticleList({
    Key? key,
    required this.type,
  }) : super(key: key);
  final int type;

  @override
  State<_ArticleList> createState() => __ArticleListState();
}

class __ArticleListState extends State<_ArticleList> {
  List<ArticleModel> articles = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getList();
  }

  void getList() async {
    var data = await ArticleService.getList({'type': widget.type});
    setState(() {
      articles = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoading()
        : ListView.builder(
            itemCount: articles.length,
            itemBuilder: buildBottomListCell,
          );
  }

  Widget buildBottomListCell(BuildContext context, int index) {
    ArticleModel model = articles[index];
    return GestureDetector(
      onTap: () async {
        BeeNav.push(BeeNav.webview, arg: {
          'url': model.content,
          'title': model.title,
          'time': '',
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              str: model.title,
            ),
            5.verticalSpaceFromWidth,
            AppText(
              str: model.createdAt ?? '',
              color: AppColors.textGrayC,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: Column(
        children: <Widget>[
          10.verticalSpaceFromWidth,
          const CupertinoActivityIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              '加载中'.ts + '...',
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 14.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
