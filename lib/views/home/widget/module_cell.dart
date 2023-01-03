import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class EntryLinkCell extends StatelessWidget {
  const EntryLinkCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Routers.push('/WarehousePage', context);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1819),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ZHTextLine(
                    str: Translation.t(context, '仓库地址', listen: true),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          linksCell(context),
        ],
      ),
    );
  }

  Widget linksCell(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Row(
              children: [
                linkItem(
                  context,
                  img: 'Home/home-1',
                  name: '我的快递',
                  enName: 'My packages',
                  route: 'orders',
                ),
                Gaps.columnsLine,
                linkItem(
                  context,
                  img: 'Home/home-2',
                  name: '添加快递',
                  enName: 'Add packege',
                  route: '/forecastPage',
                ),
              ],
            ),
          ),
          Gaps.line,
          SizedBox(
            height: 140,
            child: Row(
              children: [
                linkItem(
                  context,
                  img: 'Home/home-3',
                  name: '快递跟踪',
                  enName: 'Find track',
                  route: 'express',
                ),
                Gaps.columnsLine,
                linkItem(
                  context,
                  img: 'Home/home-4',
                  name: '联系客服',
                  enName: 'Contact',
                  route: '/contactPage',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget linkItem(
    BuildContext context, {
    required String img,
    required String name,
    required String enName,
    required String route,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (route.startsWith('/')) {
            Routers.push(route, context);
          } else {
            ApplicationEvent.getInstance()
                .event
                .fire(ChangePageIndexEvent(pageName: route));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadImage(
              img,
              width: 60,
              height: 60,
            ),
            ZHTextLine(
              str: Translation.t(context, name, listen: true),
              lines: 4,
              alignment: TextAlign.center,
            ),
            Gaps.vGap5,
            ZHTextLine(
              str: enName,
              color: ColorConfig.textGray,
            ),
          ],
        ),
      ),
    );
  }
}
