/*
  订单包裹等按钮列表
  */
import 'package:jiyun_app_client/common/translation.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
Widget QuickLinkCell(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 4, //一行的Widget数量
            childAspectRatio: 4 / 3,
          ), // 宽高比例
          itemCount: 4,
          itemBuilder: _buildGrideBtnView(context),
        ),
      ],
    ),
  );
}

IndexedWidgetBuilder _buildGrideBtnView(context) {
  List<Map> listDes = [
    {
      'title': Translation.t(context, '仓库地址', listen: true),
      'img': 'Home/warehouse-icon',
    },
    {
      'title': Translation.t(context, '汇景公告', listen: true),
      'img': 'Home/help-icon',
    },
    {
      'title': Translation.t(context, '集运评论', listen: true),
      'img': 'Home/icon-comment',
    },
    {
      'title': Translation.t(context, '分享领券', listen: true),
      'img': 'Home/share-icon',
    },
  ];
  return (context, index) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Routers.push('/HelpSupportPage', context);
        } else if (index == 2) {
          Routers.push('/CommentListPage', context);
        } else {
          if (Provider.of<Model>(context, listen: false).token.isEmpty) {
            Routers.push('/LoginPage', context);
            return;
          }
          if (index == 0) {
            Routers.push('/WarehousePage', context);
          } else {
            Routers.push('/SharePage', context);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: const BoxDecoration(
          color: ColorConfig.mainAlpha,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Caption(
              str: listDes[index]['title'],
              fontWeight: FontWeight.bold,
            ),
            Gaps.vGap5,
            Container(
              alignment: Alignment.centerRight,
              child: LoadImage(
                listDes[index]['img'],
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  };
}
