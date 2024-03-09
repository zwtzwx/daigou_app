import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/region_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/skeleton/skeleton.dart';
import 'package:shop_app_client/views/line/detail/line_detail_controller.dart';

class LineDetailView extends GetView<LineDetailController> {
  const LineDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '详情'.inte,
          fontSize: 17,
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: Obx(
        () => controller.loading.value
            ? Container(
                height: 170.h,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
                child: const Skeleton(
                  type: SkeletonType.singleSkeleton,
                  lineCount: 6,
                ),
              )
            : ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
                children: <Widget>[
                  baseInfo(),
                  Offstage(
                    offstage: controller.tabIndex.value != 0,
                    child: regionList(),
                  ),
                  Offstage(
                    offstage: controller.tabIndex.value != 1,
                    child: remark(),
                  ),
                  Offstage(
                    offstage: controller.tabIndex.value != 2,
                    child: linePropList(),
                  ),
                  30.verticalSpaceFromWidth,
                ],
              ),
      ),
    );
  }

  Widget baseInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.verticalSpaceFromWidth,
          AppText(
            str: controller.lineModel.value?.name ?? '',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          10.verticalSpaceFromWidth,
          if (controller.fromCalc) ...[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppText(
                    str: '目的地'.inte,
                    fontSize: 12,
                    color: AppStyles.textGray,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  flex: 7,
                  child: AppText(
                    str: controller.lineModel.value!.region!.name,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            8.verticalSpaceFromWidth,
          ],
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  str: '计费方式'.inte,
                  fontSize: 12,
                  color: AppStyles.textGray,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                flex: 7,
                child: AppText(
                  str: BaseUtils.getLineModelName(
                      controller.lineModel.value?.mode ?? 0),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          8.verticalSpaceFromWidth,
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  str: '体积计算'.inte,
                  fontSize: 12,
                  color: AppStyles.textGray,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                flex: 7,
                child: AppText(
                  str:
                      '(${'长'.inte} (${controller.localModel?.lengthSymbol}) x '
                      '${'宽'.inte} (${controller.localModel?.lengthSymbol}) x '
                      '${'高'.inte} (${controller.localModel?.lengthSymbol})) ÷ ${controller.lineModel.value?.factor}',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (controller.fromCalc) ...[
            8.verticalSpaceFromWidth,
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppText(
                    str: '预估运费'.inte,
                    fontSize: 12,
                    color: AppStyles.textGray,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  flex: 7,
                  child: AppText(
                    str: controller.lineModel.value!.expireFee!.priceConvert(),
                    color: AppStyles.textRed,
                  ),
                ),
              ],
            ),
          ],
          30.verticalSpaceFromWidth,
          TabBar(
            tabs: ['报价标准', '注意事项', '可寄物品']
                .asMap()
                .entries
                .map(
                  (e) => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                    child: Obx(
                      () => AppText(
                        str: e.value.inte,
                        fontSize: 14,
                        fontWeight: controller.tabIndex.value == e.key
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                )
                .toList(),
            controller: controller.tabController,
            indicatorColor: AppStyles.primary,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            onTap: (index) {
              controller.tabIndex.value = index;
            },
          ),
        ],
      ),
    );
  }

  Widget regionList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      child: Get.arguments!['type'] == 1
          ? Column(
              children: controller.lineModel.value!.regions!
                  .map((e) => regionItem(e))
                  .toList(),
            )
          : regionItem(controller.lineModel.value!.region!),
    );
  }

  Widget regionItem(RegionModel model) {
    return Column(
      children: [
        15.verticalSpaceFromWidth,
        Row(
          children: [
            AppText(
              str: model.name,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        10.verticalSpaceFromWidth,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                str: '运送时效'.inte,
                fontSize: 12,
                color: AppStyles.textGray,
              ),
              8.verticalSpaceFromWidth,
              AppText(
                str: model.referenceTime,
                fontSize: 14,
              ),
              10.verticalSpaceFromWidth,
              ...priceList(model),
              if ((model.services ?? []).isNotEmpty) ...lineServiceList(model),
              if ((model.rules ?? []).isNotEmpty) ruleList(model),
            ],
          ),
        ),
      ],
    );
  }

  // 备注
  Widget remark() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: AppText(
        fontSize: 14,
        lines: 99,
        str: controller.lineModel.value?.remark ?? '',
      ),
    );
  }

  // 可寄物品
  Widget linePropList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: AppText(
        fontSize: 14,
        lines: 99,
        str: controller.lineModel.value?.propStr ?? '',
      ),
    );
  }

  lineServiceList(RegionModel model) {
    List<Widget> viewList = [];
    viewList.add(
      Padding(
          padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
          child: AppText(
            str: '渠道增值服务'.inte,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            lines: 2,
          )),
    );
    for (var item in model.services!) {
      String first = '';
      String second = '';
      String third = '';
      // 1 运费比例 2固定费用 3单箱固定费用 4单位计费重量固定费用 5单位实际重量固定费用 6申报价值比列
      switch (item.type) {
        case 1:
          first = '实际运费'.inte;
          second = (item.value / 100).toStringAsFixed(2) + '%';
          break;
        case 2:
          second = item.value.priceConvert();
          break;
        case 3:
          second = item.value.priceConvert() + '/${'箱'.inte}';
          break;
        case 4:
          second = item.value.priceConvert() +
              '/' +
              controller.localModel!.weightSymbol;
          third = '(${'计费重'.inte})';
          break;
        case 5:
          second = item.value.priceConvert() +
              '/' +
              controller.localModel!.weightSymbol;
          third = '(${'实重'.inte})';
          break;
        case 6:
          second = '申报价值'.inte + (item.value / 100).toString() + '%';
          break;
        default:
      }
      var view = SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AppText(
                        str: item.name,
                        fontSize: 13,
                      ),
                      AppText(
                        str: item.isForced == 0
                            ? '（${'可选'.inte}）'
                            : '（${'必选'.inte}）',
                        fontSize: 13,
                      ),
                      item.remark.isNotEmpty
                          ? InkResponse(
                              child: Icon(
                                Icons.error_outline_outlined,
                                color: AppStyles.green,
                                size: 20.sp,
                              ),
                              onTap: () {
                                controller.showTipsView(item);
                              },
                            )
                          : Container(),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        maxLines: 2,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: first + ' ',
                              style: TextStyle(
                                  color: AppStyles.textDark,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: second + ' ',
                              style: TextStyle(
                                color: AppStyles.textBlack,
                                fontSize: 13.sp,
                              ),
                            ),
                            TextSpan(
                              text: third,
                              style: TextStyle(
                                color: AppStyles.textDark,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpaceFromWidth,
          ],
        ),
      );
      viewList.add(view);
    }
    return viewList;
  }

  descriptItem(
    String title,
    String content, {
    bool showIcon = false,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: AppText(
              str: title.inte,
              fontSize: 13,
              lines: 2,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: AppText(
              str: content,
              fontSize: 13,
              color: textColor ?? AppStyles.textBlack,
              lines: 2,
              alignment: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  priceList(RegionModel model) {
    List<Widget> listWidget = [];
    listWidget.add(Container(
      alignment: Alignment.centerLeft,
      child: AppText(
        str: '计费标准'.inte,
        fontSize: 12,
        color: AppStyles.textGray,
      ),
    ));
    String contentSymbol = controller.lineModel.value!.baseMode == 0
        ? (controller.localModel?.weightSymbol ?? '')
        : 'm³';
    if (controller.lineModel.value!.mode == 1) {
      // 首重续重
      for (var item in model.prices!) {
        String titleStr;
        if (listWidget.length == 1) {
          titleStr = '首重'.inte +
              '（' +
              (item.start / 1000).toStringAsFixed(2) +
              (controller.localModel?.weightSymbol ?? '') +
              '）';
        } else {
          titleStr = '续重'.inte +
              '（' +
              (item.start / 1000).toStringAsFixed(2) +
              (controller.localModel?.weightSymbol ?? '') +
              '）';
        }
        num price = item.price;
        String contentStr = price.priceConvert() +
            '/' +
            (listWidget.length == 1
                ? (item.start / 1000).toStringAsFixed(2)
                : ((item.unitWeight ?? 0) != 0
                    ? (item.unitWeight! / 1000).toStringAsFixed(2)
                    : '')) +
            (controller.lineModel.value!.baseMode == 0
                ? controller.localModel!.weightSymbol
                : 'm³');
        listWidget.add(descriptItem(titleStr, contentStr));
      }
    } else if (controller.lineModel.value!.mode == 2) {
      // 阶梯价格档 基价 + 单价
      Map<String, dynamic> newPirces = {};
      for (var priceModel in model.prices!) {
        String titleStr =
            '${(priceModel.start / 1000).toStringAsFixed(2)}~${(priceModel.end / 1000).toStringAsFixed(2)}';
        if (newPirces[titleStr] == null) {
          newPirces[titleStr] = priceModel.price;
        } else {
          num basePrice =
              priceModel.type == 8 ? priceModel.price : newPirces[titleStr];
          num price =
              priceModel.type == 2 ? priceModel.price : newPirces[titleStr];
          String priceStr = '0.00';

          if (basePrice != 0 && price != 0) {
            priceStr =
                '${basePrice.priceConvert()}+${price.priceConvert()}/$contentSymbol';
          } else if (basePrice != 0) {
            priceStr = basePrice.priceConvert();
          } else if (price != 0) {
            priceStr = price.priceConvert() + '/$contentSymbol';
          }
          newPirces[titleStr] = priceStr;
        }
      }
      for (var key in newPirces.keys) {
        String titleStr = key + contentSymbol;
        listWidget.add(descriptItem(titleStr, newPirces[key]));
      }
    } else if (controller.lineModel.value!.mode == 3) {
      // 单位价格 + 阶梯总价模式
      for (var item in model.prices!) {
        if (item.type == 3) {
          String titleStr = '单位价格'.inte;
          String contentStr = item.price.priceConvert() + '/$contentSymbol';
          listWidget.add(descriptItem(titleStr, contentStr));
        } else {
          String titleStr = (item.start / 1000).toStringAsFixed(2) +
              '~' +
              (item.end / 1000).toStringAsFixed(2) +
              contentSymbol;
          String contentStr = item.price.priceConvert();
          listWidget.add(descriptItem(titleStr, contentStr));
        }
      }
    } else if (controller.lineModel.value!.mode == 4) {
      // 多级续重模式
      int k = 0;
      for (var item in model.prices!) {
        if (item.type == 0) {
          String titleStr = '首重'.inte +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol +
              '）';
          num price = item.price;
          String contentStr = price.priceConvert() +
              '/' +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(descriptItem(titleStr, contentStr));
        } else {
          ++k;
          String titleStr = '总重'.inte + k.toString();
          num price = item.price;
          String contentStr = price.priceConvert() +
              '/' +
              (item.unitWeight != null
                  ? (item.unitWeight! / 1000).toStringAsFixed(2)
                  : '') +
              contentSymbol;
          listWidget.add(descriptItem(titleStr, contentStr));
        }
      }
      String titleStr = '最大限重'.inte;
      String contentStr =
          (controller.lineModel.value!.maxWeight! / 1000).toStringAsFixed(2) +
              contentSymbol;
      listWidget.add(descriptItem(titleStr, contentStr));
    } else if (controller.lineModel.value!.mode == 5) {
      // 阶梯价格范围首重续重模式
      model.prices!.sort((a, b) {
        if (a.start < b.start) {
          return -1;
        }
        return 1;
      });
      Map<String, List> sortPrices = {};
      for (var item in model.prices!) {
        String key =
            '${(item.start / 1000).toStringAsFixed(2)}~${(item.end / 1000).toStringAsFixed(2)}';
        if (sortPrices[key] == null) {
          sortPrices[key] = [item];
        } else {
          if (item.type == 6) {
            sortPrices[key]!.insert(0, item);
          } else {
            sortPrices[key]!.add(item);
          }
        }
      }
      for (var key in sortPrices.keys) {
        String title = key + contentSymbol;
        listWidget.add(Container(
          alignment: Alignment.centerLeft,
          height: 25.h,
          child: AppText(
            str: title,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ));
        for (var item in sortPrices[key]!) {
          String titleStr = '续重'.inte;
          if (item.type == 6) {
            titleStr = '首重'.inte +
                '(${(item.firstWeight / 1000).toStringAsFixed(2)}$contentSymbol)';
          }
          num? unitPrice = item.type == 6 ? item.firstWeight : item.unitWeight;
          num? price = item.price;
          String contentStr = (price ?? 0).priceConvert() +
              '/' +
              ((unitPrice ?? 0) / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(descriptItem(titleStr, contentStr));
        }
      }
    }
    return listWidget;
  }

  //渠道增值服务
  Widget ruleList(RegionModel model) {
    List<String> contents = [];
    for (var rule in model.rules!) {
      String contentStr = '${contents.length + 1}、';
      for (var subItem in rule.conditions!) {
        contentStr += '({condition})时'.inArgs({
              'condition': subItem.paramName +
                  subItem.comparison +
                  subItem.value.toString()
            }) +
            '，';
        if (rule.type == 1) {
          contentStr += '限定【按订单收费】'.inte + rule.value.priceConvert();
        } else if (rule.type == 2) {
          contentStr += '限定【按箱收费】'.inte + rule.value.priceConvert();
        } else if (rule.type == 3) {
          contentStr += '限定【按单位计费重量收费】'.inte + rule.value.priceConvert();
        } else if (rule.type == 4) {
          contentStr += '限定【限制出仓】'.inte;
        }
        if (rule.minCharge != 0) {
          contentStr += '（${'最低收费'.inte}' + rule.minCharge.priceConvert() + ',';
        }
        if (rule.maxCharge != 0) {
          contentStr += '（${'最高收费'.inte}' + rule.maxCharge.priceConvert() + '）';
        }
      }
      contents.add(contentStr);
    }
    String tips = '${'注'.inte} '
        '${controller.lineModel.value?.ruleFeeMode == 0 ? '以上规则【同时收取】'.inte : '以上规则【每个分区仅按最高项规则收取】'}'
        '，${'最高收费'.inte}'
        '${controller.lineModel.value?.maxRuleFee == 0 ? '无上限'.inte : controller.lineModel.value?.maxRuleFee.priceConvert()}';
    contents.add(tips);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          str: '渠道规则'.inte,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        10.verticalSpaceFromWidth,
        ...contents.map(
          (e) => AppText(
            str: e.wordBreak,
            fontSize: 13,
            lines: 10,
            lineHeight: 1.6,
          ),
        ),
      ],
    );
  }
}
