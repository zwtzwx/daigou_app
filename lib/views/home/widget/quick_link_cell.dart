/*
  订单包裹等按钮列表
  */
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
Widget QuickLinkCell(BuildContext context, String fansUrl) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 3, //一行的Widget数量
            childAspectRatio: 7 / 4,
          ), // 宽高比例
          itemCount: 3,
          itemBuilder: _buildGrideBtnView(fansUrl),
        ),
        GestureDetector(
          onTap: () {
            Routers.push('/SharePage', context);
          },
          child: const Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            child: LoadImage(
              'Home/yaoqing',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        buildCustomerServiceView(),
      ],
    ),
  );
}

// 客服
Widget buildCustomerServiceView() {
  return GestureDetector(
    onTap: () {
      fluwx.isWeChatInstalled.then((installed) {
        if (installed) {
          fluwx
              .openWeChatCustomerServiceChat(
                  url: 'https://work.weixin.qq.com/kfid/kfcd1850645a45f5db4',
                  corpId: 'ww82affb1cf55e55e0')
              .then((data) {});
        } else {
          Util.showToast("请先安装微信");
        }
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            child: Caption(
              str: '寄件咨询',
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.bold,
            ),
          ),
          Caption(
            str: '物品能不能寄？运费多少？时效多久？',
            fontSize: ScreenUtil().setSp(12),
            color: ColorConfig.main,
          ),
        ],
      ),
    ),
  );
}

IndexedWidgetBuilder _buildGrideBtnView(String fansUrl) {
  List<Map> listDes = [
    {
      'title': '我要直邮',
      'titleColor': ColorConfig.primary,
      'label': '马上买',
      'labelColor': const Color(0xFF838EED),
      'img': 'assets/images/Home/direct-go.png',
    },
    {
      'title': '我要拼邮',
      'titleColor': const Color(0xFFF06838),
      'label': '马上拼',
      'labelColor': const Color(0xFFEE8764),
      'img': 'assets/images/Home/splic.png',
    },
    {
      'title': '帮助支持',
      'titleColor': const Color(0xFF499A6A),
      'label': '帮助我',
      'labelColor': const Color(0xFF499A6A),
      'img': 'assets/images/Home/direct.png',
    },
  ];
  return (context, index) {
    return GestureDetector(
      onTap: () {
        // print(index);
        if (index == 2) {
          Routers.push('/HelpSupportPage', context);
        } else {
          if (Provider.of<Model>(context, listen: false).token.isEmpty) {
            Routers.push('/LoginPage', context);
            return;
          }
          if (index == 0) {
            ApplicationEvent.getInstance()
                .event
                .fire(ChangePageIndexEvent(pageName: 'middle'));
          } else {}
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.only(
          left: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          image: DecorationImage(
            image: AssetImage(listDes[index]['img']),
            fit: BoxFit.fitWidth,
          ),
        ),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Caption(
              str: listDes[index]['title'],
              fontWeight: FontWeight.bold,
              color: listDes[index]['titleColor'],
            ),
            Gaps.vGap5,
            Caption(
              str: listDes[index]['label'],
              color: listDes[index]['labelColor'],
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  };
}
