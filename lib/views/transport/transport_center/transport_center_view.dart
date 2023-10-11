import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/ad_cell.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/contact_cell.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/transport/transport_center/transport_center_controller.dart';
import 'package:jiyun_app_client/views/transport/widget/recommend_group_cell.dart';
import 'package:jiyun_app_client/views/transport/widget/recommend_line_cell.dart';

class TransportCenterView extends GetView<TransportCenterController> {
  const TransportCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: controller.handleRefresh,
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, AppColors.bgGray],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 0.8],
                    ),
                  ),
                  child: Column(
                    children: [
                      const LanguageCell(),
                      const AdsCell(type: 1),
                      10.verticalSpace,
                      mainModuleCell(),
                      15.verticalSpaceFromWidth,
                      linksCell(),
                    ],
                  ),
                ),
                25.verticalSpaceFromWidth,
                RecommandShipLinesCell(
                  currencySymbol: controller.currencyModel.value,
                ),
                const RecommendGroupCell(size: 2),
                30.verticalSpaceFromWidth,
              ],
            ),
          ),
          const ContactCell(),
        ],
      ),
    );
  }

  Widget mainModuleCell() {
    List<Map<String, String>> links = [
      {'img': 'zy', 'name': '我要直邮', 'route': BeeNav.forecast},
      {'img': 'smqj', 'name': '我要拼邮', 'route': BeeNav.groupCenter},
      {'img': 'py', 'name': '自提点', 'route': BeeNav.station},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6.w,
          childAspectRatio: 11 / 7,
        ),
        itemCount: links.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            BeeNav.push(links[index]['route']!);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/Transport/${links[index]['img']}.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Obx(
              () => AppText(
                str: links[index]['name']!.ts,
                fontSize: 14,
                lines: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget linksCell() {
    List<Map<String, String>> list1 = [
      {'img': 'ckdz', 'name': '仓库地址', 'route': BeeNav.warehouse},
      {'img': 'yfss', 'name': '运费试算', 'route': BeeNav.lineQuery},
      {'img': 'wlgz', 'name': '物流查询', 'route': BeeNav.track},
      {'img': 'order', 'name': '我的订单', 'route': BeeNav.orderCenter},
    ];
    List<Map<String, String>> list2 = [
      {'img': 'help', 'name': '帮助支持', 'route': BeeNav.help},
      {'img': 'comment', 'name': '集运评论', 'route': BeeNav.comment},
      {'img': 'chrome', 'name': 'chrome一健预报', 'route': BeeNav.chromeLogin},
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 10.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list1
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      BeeNav.push(e['route']!);
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: (1.sw - 70.w) / 4,
                      ),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            ImgItem(
                              'Transport/${e['img']}',
                              width: 40.w,
                            ),
                            2.verticalSpace,
                            Obx(
                              () => AppText(
                                str: e['name']!.ts,
                                fontSize: 12,
                                lines: 3,
                                alignment: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list2
                .map((e) => GestureDetector(
                      onTap: () {
                        BeeNav.push(e['route']!);
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: (1.sw - 70.w) / 3,
                        ),
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImgItem(
                                'Transport/${e['img']}',
                                width: 14.w,
                              ),
                              5.horizontalSpace,
                              Expanded(
                                child: Obx(
                                  () => AppText(
                                    str: e['name']!.ts,
                                    fontSize: 10,
                                    color: AppColors.textGrayC9,
                                    lines: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
