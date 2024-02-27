import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/empty_app_bar.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/help/guide/guide_controller.dart';

class GuideView extends GetView<GuideController> {
  const GuideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: const Color(0xFFF3F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const LoadAssetImage(
                  'Guide/banner',
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  left: 10.w,
                  top: ScreenUtil().statusBarHeight + 10.h,
                  child: const BackButton(color: Colors.white),
                ),
              ],
            ),
            stepBox(
              title: '支持平台',
              child: Column(
                children: [
                  35.verticalSpaceFromWidth,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        ['tianmao', 'taobao', 'pinduoduo', 'jingdong', '1688']
                            .map((e) => LoadAssetImage(
                                  'Guide/$e',
                                  width: 40.w,
                                  height: 40.w,
                                ))
                            .toList(),
                  ),
                  20.verticalSpaceFromWidth,
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textDark,
                        height: 1.8,
                      ),
                      children: [
                        TextSpan(
                          text: '支持搜索中国大主流电商平台商品代购，也可以提供需要代购商品的连接，点击手动'.ts,
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              BeeNav.push(BeeNav.manualOrder);
                            },
                            child: AppText(
                              str: '【${'填写提交代购单'.ts}】',
                              fontSize: 12,
                              color: const Color(0xFFF14D50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            stepBox(
              title: '代购流程',
              child: Column(
                children: [
                  30.verticalSpaceFromWidth,
                  Wrap(
                    spacing: 20.w,
                    runSpacing: 20.h,
                    children: controller.processList
                        .map((e) => SizedBox(
                              width: (1.sw - 85.w) / 2,
                              child: Column(
                                children: [
                                  LoadAssetImage(
                                    'Guide/${e['icon']}',
                                    width: 40.w,
                                    height: 40.w,
                                  ),
                                  5.verticalSpaceFromWidth,
                                  AppText(
                                    str: e['title']!.ts,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    lines: 2,
                                    alignment: TextAlign.center,
                                  ),
                                  8.verticalSpaceFromWidth,
                                  AppText(
                                    str: e['subTitle']!.ts,
                                    fontSize: 12,
                                    color: AppColors.textNormal,
                                    lines: 4,
                                    alignment: TextAlign.center,
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
            stepBox(
              title: '代购须知',
              child: Column(
                children: controller.protocolList
                    .asMap()
                    .entries
                    .map((e) => Padding(
                          padding: EdgeInsets.only(top: 25.h),
                          child: Column(
                            children: [
                              LoadAssetImage(
                                'Guide/${e.value['icon']}',
                                width: 100.w,
                                height: 84.w,
                              ),
                              AppText(
                                str: (e.value['title'] as String).ts,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              15.verticalSpaceFromWidth,
                              AppText(
                                str: '0${e.key + 1}. ' +
                                    (e.value['subTitle'] as String).ts,
                                fontSize: 14,
                                lines: 10,
                                lineHeight: 1.6,
                              ),
                              10.verticalSpaceFromWidth,
                              ...(e.value['contents'] as List).map(
                                (content) => AppText(
                                  str: (content as String).ts,
                                  fontSize: 12,
                                  lines: 20,
                                  lineHeight: 2,
                                  color: AppColors.textNormal,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepBox({required String title, required Widget child}) {
    return Transform.translate(
      offset: Offset(0, -20.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 15.h),
        padding: EdgeInsets.fromLTRB(15.w, 30.h, 15.w, 20.h),
        child: Column(
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -5.w,
                    right: -5.w,
                    bottom: -1.h,
                    child: const LoadAssetImage(
                      'Guide/line',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  AppText(
                    str: title.ts,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
