import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/user/logged_guide/controller.dart';

class LoggedGuideView extends GetView<LoggedGuideController> {
  const LoggedGuideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: EmptyAppBar(),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: LoadAssetImage('Home/cur_bg'),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                margin:
                    EdgeInsets.only(top: kToolbarHeight + 15.h, right: 16.w),
                child: UnconstrainedBox(
                  child: GestureDetector(
                    onTap: controller.onSkip,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x80FFFFFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      height: 27.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Obx(
                        () => AppText(
                          str: '跳过'.inte,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              30.verticalSpaceFromWidth,
              SizedBox(
                height: 0.6.sh,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: 2,
                  onPageChanged: (value) {
                    controller.step.value = value;
                  },
                  itemBuilder: (context, index) => index == 0
                      ? buildLanguagePicker()
                      : buildCurrencyPicker(),
                ),
              ),
              10.verticalSpaceFromWidth,
              buildPagination(),
              30.verticalSpaceFromWidth,
              Obx(
                () => Offstage(
                  offstage: controller.step.value == 0,
                  child: UnconstrainedBox(
                    child: GestureDetector(
                      onTap: controller.onSkip,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppStyles.primary,
                          shape: BoxShape.circle,
                        ),
                        width: 56.w,
                        height: 56.w,
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 35.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLanguagePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          LoadAssetImage(
            'Home/lag',
            width: 146.w,
            height: 146.w,
          ),
          30.verticalSpaceFromWidth,
          Expanded(
            child: Obx(
              () => GridView.builder(
                shrinkWrap: true,
                itemCount: controller.langList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 18.w,
                  childAspectRatio: 5 / 2,
                ),
                itemBuilder: (context, index) {
                  var item = controller.langList[index];
                  return GestureDetector(
                    onTap: () {
                      controller.onLanguagePicker(item.languageCode);
                      controller.step.value++;
                      controller.pageController
                          .jumpToPage(controller.step.value);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.i10n.language == item.languageCode
                            ? AppStyles.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: AppText(
                        str: item.name,
                        fontSize: 14,
                        color: controller.i10n.language == item.languageCode
                            ? Colors.white
                            : AppStyles.textDark,
                        lines: 2,
                        alignment: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCurrencyPicker() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          LoadAssetImage(
            'Home/cur',
            width: 146.w,
            height: 146.w,
          ),
          30.verticalSpaceFromWidth,
          Expanded(
            child: Obx(
              () => GridView.builder(
                shrinkWrap: true,
                itemCount: controller.rateList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 18.w,
                  childAspectRatio: 5 / 2,
                ),
                itemBuilder: (context, index) {
                  var item = controller.rateList[index];
                  return GestureDetector(
                    onTap: () {
                      controller.onCurrencyPicker(item);
                    },
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color:
                              controller.currencyModel.value?.code == item.code
                                  ? AppStyles.primary
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: AppText(
                          str: item.code,
                          fontSize: 14,
                          color:
                              controller.currencyModel.value?.code == item.code
                                  ? Colors.white
                                  : AppStyles.textDark,
                          lines: 2,
                          alignment: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPagination() {
    return Obx(
      () => Wrap(
        spacing: 6.w,
        children: [0, 1]
            .map((e) => Container(
                  width: 26.w,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(
                        controller.step.value >= e ? 0xFF2B3036 : 0xFFBBBEC3),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
