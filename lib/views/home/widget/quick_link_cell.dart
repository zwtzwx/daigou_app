/*
  订单包裹等按钮列表
  */
import 'package:jiyun_app_client/common/util.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:jiyun_app_client/views/components/load_image.dart';

// ignore: non_constant_identifier_names
Widget QuickLinkCell(BuildContext context, String fansUrl) {
  return Container(
    color: ColorConfig.bgGray,
    padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
    child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10.0, //水平子Widget之间间距
          mainAxisSpacing: 0.0, //垂直子Widget之间间距
          crossAxisCount: 3, //一行的Widget数量
          childAspectRatio: 7 / 4,
        ), // 宽高比例
        itemCount: 3,
        itemBuilder: _buildGrideBtnView(fansUrl)),
  );
}

IndexedWidgetBuilder _buildGrideBtnView(String fansUrl) {
  List<String> listDesTitle = [
    '邀请好友',
    '会员中心',
    '入群福利',
  ];
  List<String> listImg = [
    'Home/邀请好友@3x',
    'Home/会员中心@3x',
    'Home/入群福利@3x',
  ];
  return (context, index) {
    return GestureDetector(
      onTap: () {
        // print(index);
        if (index == 0) {
          Routers.push('/SharePage', context);
        } else if (index == 1) {
          Routers.push('/VipCenterPage', context);
        } else if (index == 2 && fansUrl.isNotEmpty) {
          if (fansUrl.startsWith('/pages')) {
            fluwx.isWeChatInstalled.then((installed) {
              if (installed) {
                fluwx
                    .launchWeChatMiniProgram(
                        username: 'gh_e9afa1eee63a', path: fansUrl)
                    .then((data) {
                  print("---》$data");
                });
              } else {
                Util.showToast("请先安装微信");
              }
            });
          } else {
            Routers.push('/webview', context,
                {'url': fansUrl, 'title': 'BeeGoplus集运', 'time': ''});
          }
          // Routers.push('/LoginPage', context);
          // Routers.push('/PutInPackage', context);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: ColorConfig.line),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                  blurRadius: 0.1, //阴影模糊程度
                  spreadRadius: 0.01 //阴影扩散程度
                  )
            ]),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  top: 10, right: 10, left: 10, bottom: 5),
              child: LoadImage(
                '',
                fit: BoxFit.fitWidth,
                width: 20,
                height: 20,
                holderImg: listImg[index],
                format: "png",
              ),
            ),
            Text(
              listDesTitle[index],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  };
}
