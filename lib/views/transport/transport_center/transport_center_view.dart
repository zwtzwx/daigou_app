import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/views/components/ad_cell.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/transport/transport_center/transport_center_controller.dart';
import 'package:huanting_shop/views/transport/widget/comment_list_widget.dart';

class TransportCenterView extends GetView<TransportCenterController> {
  const TransportCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: '集运'.ts,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        color: AppColors.primary,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const AdsCell(type: 1),
            14.verticalSpaceFromWidth,
            buildShipType(),
            20.verticalSpaceFromWidth,
            Obx(() => parcelModule()),
            22.verticalSpaceFromWidth,
            linksCell(),
            25.verticalSpaceFromWidth,
            adList(),
            25.verticalSpaceFromWidth,
            const CommentListWidget(),
            30.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  Widget buildShipType() {
    List<Map<String, dynamic>> links = [
      {
        'img': 'wyzy',
        'name': '我要直邮',
        'color': const Color(0xFFFFF8F1),
        'route': BeeNav.forecast
      },
      {
        'img': 'wypy',
        'name': '拼邮更划算',
        'route': BeeNav.groupCenter,
        'color': const Color(0xFFFFF9E3),
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: links
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      BeeNav.push(e['route']!);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(left: e['img'] == 'wypy' ? 10.w : 0),
                      padding: EdgeInsets.only(
                        top: 12.h,
                        bottom: 30.h,
                      ),
                      decoration: BoxDecoration(
                        color: e['color'],
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImgItem(
                            'Transport/${e['img']}',
                            width: 100.w,
                            height: 84.w,
                          ),
                          10.verticalSpaceFromWidth,
                          Obx(
                            () => AppText(
                              str: (e['name'] as String).ts,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget parcelModule() {
    final parcelCount = Get.find<AppStore>().amountInfo;
    List<Map<String, dynamic>> list = [
      {'name': '未入库', 'count': parcelCount.value?.waitStorage},
      {'name': '已入库', 'count': parcelCount.value?.alreadyStorage},
      {'name': '待处理', 'count': parcelCount.value?.waitPack},
      {'name': '待支付', 'count': parcelCount.value?.waitPay},
      {'name': '待发货', 'count': parcelCount.value?.waitTran},
      {'name': '已发货', 'count': parcelCount.value?.shipping},
      {'name': '已签收'}
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36.h,
              child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        BeeNav.push(BeeNav.orderCenter, index);
                      },
                      child: UnconstrainedBox(
                        child: Container(
                          height: 30.h,
                          margin: EdgeInsets.only(top: 3.h, right: 14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE4E4E4)),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          alignment: Alignment.center,
                          child: AppText(
                            str: (list[index]['name'] as String).ts,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    list[index]['count'] != null && list[index]['count'] != 0
                        ? Positioned(
                            right: 5.w,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 2.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: const Color(0xFFFF6868),
                              ),
                              child: AppText(
                                str: list[index]['count'].toString(),
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ))
                        : AppGaps.empty,
                  ],
                ),
              ),
            ),
          ),
          10.horizontalSpace,
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textNormal,
            size: 12.sp,
          ),
          10.horizontalSpace,
        ],
      ),
    );
  }

  Widget linksCell() {
    List<Map<String, String>> list = [
      {'img': 'ico_ckdz', 'name': '仓库地址', 'route': BeeNav.warehouse},
      {'img': 'ico_yfgs', 'name': '运费试算', 'route': BeeNav.lineQuery},
      {'img': 'ico_bgyb', 'name': '包裹预报', 'route': BeeNav.forecast},
      {'img': 'ico_ycjrl', 'name': '异常件认领', 'route': BeeNav.noOwnerList},
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      BeeNav.push(e['route']!);
                    },
                    child: Container(
                      color: Colors.transparent,
                      constraints: BoxConstraints(
                        maxWidth: (1.sw - 50.w) / 4,
                      ),
                      child: Column(
                        children: [
                          ImgItem(
                            'Transport/${e['img']}',
                            width: 50.w,
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
                )
                .toList(),
          ),
          40.verticalSpaceFromWidth,
          GestureDetector(
            onTap: () {
              BeeNav.push(BeeNav.chromeLogin);
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  ImgItem(
                    'Transport/chrome',
                    width: 25.w,
                    height: 25.w,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Obx(
                      () => AppText(
                        str: 'chrome省心预报'.ts,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textNormal,
                    size: 12.sp,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget adList() {
    return Obx(() {
      var ads = Get.find<AppStore>()
          .adList
          .where((item) => item.position == 3 && item.type == 2)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ads
            .map(
              (e) => Container(
                margin: EdgeInsets.only(
                    bottom: e.id != ads.last.id ? 15.h : 0,
                    left: 14.w,
                    right: 14.w),
                child: GestureDetector(
                  child: ImgItem(
                    e.fullPath,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }
}
