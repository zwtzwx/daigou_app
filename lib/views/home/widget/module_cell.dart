import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';

class EntryLinkCell extends StatelessWidget {
  EntryLinkCell({
    Key? key,
  }) : super(key: key);
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Routers.push(Routers.warehouse);
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
                  Obx(() {
                    return ZHTextLine(
                      str: '仓库地址'.ts,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    );
                  }),
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
                Sized.columnsLine,
                linkItem(
                  context,
                  img: 'Home/home-2',
                  name: '添加快递',
                  enName: 'Add packege',
                  route: Routers.forecast,
                ),
              ],
            ),
          ),
          Sized.line,
          SizedBox(
            height: 140,
            child: Row(
              children: [
                linkItem(
                  context,
                  img: 'Home/home-3',
                  name: '快递跟踪',
                  enName: 'Find track',
                  route: Routers.track,
                ),
                Sized.columnsLine,
                linkItem(
                  context,
                  img: 'Home/home-4',
                  name: '联系客服',
                  enName: 'Contact',
                  route: Routers.contact,
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
            Routers.push(route);
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
            Obx(
              () => ZHTextLine(
                str: name.ts,
                lines: 4,
                alignment: TextAlign.center,
              ),
            ),
            Sized.vGap5,
            ZHTextLine(
              str: enName,
              color: BaseStylesConfig.textGray,
            ),
          ],
        ),
      ),
    );
  }
}
