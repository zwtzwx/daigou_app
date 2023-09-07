import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/region_model.dart';
import 'package:jiyun_app_client/models/ship_line_service_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/line/detail/line_detail_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LineDetailView extends GetView<LineDetailController> {
  const LineDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '详情'.ts,
          fontSize: 18,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
        children: <Widget>[
          Obx(() => controller.lineModel.value != null
              ? (Get.arguments!['type'] == 1
                  ? multipleRegion(context)
                  : singleCell(context))
              : Sized.empty),
          Container(
            decoration: const BoxDecoration(
              color: BaseStylesConfig.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.only(left: 15, top: 0, right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            // height: reMarkheight + 40,
            alignment: Alignment.centerLeft,
            child: Obx(
              () => ZHTextLine(
                fontSize: 14,
                lines: 99,
                str: controller.lineModel.value?.remark ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget singleCell(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: const BoxDecoration(
          color: BaseStylesConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          baseInfoCell(controller.lineModel.value!.region!),
          billingDesView(controller.lineModel.value!.region!),
          lineServiceCell(context, controller.lineModel.value!.region!),
          // lineRuleCell(controller.lineModel.value!.region!),
        ],
      ),
    );
  }

  // 线路服务数据
  lineServiceCell(BuildContext context, RegionModel model) {
    return model.services!.isNotEmpty
        ? Container(
            color: BaseStylesConfig.white,
            padding:
                const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
            child: Column(children: listWidgetForLineServices(context, model)))
        : Container();
  }

  listWidgetForLineServices(BuildContext context, RegionModel model) {
    List<Widget> viewList = [];
    viewList.add(Container(
      alignment: Alignment.centerLeft,
      child: ZHTextLine(
        str: '渠道增值服务'.ts,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        lines: 2,
      ),
    ));
    for (var item in model.services!) {
      String first = '';
      String second = '';
      String third = '';
      // 1 运费比例 2固定费用 3单箱固定费用 4单位计费重量固定费用 5单位实际重量固定费用 6申报价值比列
      switch (item.type) {
        case 1:
          first = '实际运费'.ts;
          second = (item.value / 100).toStringAsFixed(2) + '%';
          break;
        case 2:
          second = item.value.rate();
          break;
        case 3:
          second = item.value.rate() + '/${'箱'.ts}';
          break;
        case 4:
          second =
              item.value.rate() + '/' + controller.localModel!.weightSymbol;
          third = '(${'计费重'.ts})';
          break;
        case 5:
          second =
              item.value.rate() + '/' + controller.localModel!.weightSymbol;
          third = '(${'实重'.ts})';
          break;
        case 6:
          second = '申报价值'.ts + (item.value / 100).toString() + '%';
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
                      ZHTextLine(
                        str: item.name,
                      ),
                      ZHTextLine(
                          str: item.isForced == 0
                              ? '（${'可选'.ts}）'
                              : '（${'必选'.ts}）'),
                      item.remark.isNotEmpty
                          ? InkResponse(
                              child: const Icon(
                                Icons.error_outline_outlined,
                                color: BaseStylesConfig.green,
                                size: 25,
                              ),
                              onTap: () {
                                showTipsView(context, item);
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
                              text: first,
                              style: const TextStyle(
                                  color: BaseStylesConfig.textDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                            const TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: BaseStylesConfig.textBlack,
                                fontSize: 10.0,
                              ),
                            ),
                            TextSpan(
                              text: second,
                              style: const TextStyle(
                                color: BaseStylesConfig.textBlack,
                                fontSize: 15.0,
                              ),
                            ),
                            const TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: BaseStylesConfig.textBlack,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: third,
                              style: const TextStyle(
                                color: BaseStylesConfig.textDark,
                                fontSize: 15,
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
            Sized.vGap10,
          ],
        ),
      );
      viewList.add(view);
    }
    return viewList;
  }

  multipleRegion(context) {
    return Column(
      children: [
        SizedBox(
          child: Obx(
            () => Container(
              margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
              height: ScreenUtil().screenHeight * 3 / 5,
              child: PageView.builder(
                key: const Key('pageView'),
                itemCount: controller.lineModel.value?.regions?.length,
                controller: controller.pageController,
                itemBuilder: (BuildContext context, int index) {
                  return buildSignScrollView(context, index);
                },
              ),
            ),
          ),
        ),
        buildPlugin(),
      ],
    );
  }

  buildSignScrollView(BuildContext context, int index) {
    RegionModel regionModel = controller.lineModel.value!.regions![index];
    var scrollVIew = Container(
        height: ScreenUtil().screenHeight * 3 / 5,
        decoration: const BoxDecoration(
            color: BaseStylesConfig.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              baseInfoCell(regionModel),
              billingDesView(regionModel),
              lineServiceCell(context, regionModel),
              // buildAddRulesForLine(regionModel),
            ],
          ),
        ));
    return scrollVIew;
  }

  buildPlugin() {
    return Obx(
      () => Container(
        alignment: Alignment.center,
        height: 50,
        width: ScreenUtil().screenWidth,
        child: SmoothPageIndicator(
          count: controller.lineModel.value!.regions!.length,
          controller: controller.pageController,
          effect: const WormEffect(
              dotWidth: 10,
              dotHeight: 10,
              spacing: 5,
              dotColor: BaseStylesConfig.textGray,
              activeDotColor: BaseStylesConfig.textBlack),
        ),
      ),
    );
  }

  Widget baseInfoCell(RegionModel model) {
    String modeStr = '';
    switch (controller.lineModel.value!.mode) {
      case 1:
        modeStr = '首重续重模式';
        break;
      case 2:
        modeStr = '阶梯价格模式';
        break;
      case 3:
        modeStr = '单位价格+阶梯价格模式';
        break;
      case 4:
        modeStr = '多级续重模式';
        break;
      case 5:
        modeStr = '阶梯首重续重模式';
        break;
      default:
    }
    List<Widget> list = [];
    if (Get.arguments['type'] == 2) {
      String countWeight =
          (controller.lineModel.value!.countWeight! / 1000).toStringAsFixed(2) +
              (controller.lineModel.value!.mode == 1
                  ? '立方'
                  : (controller.localModel?.weightSymbol ?? ''));
      String expireFee = controller.lineModel.value!.expireFee!.rate();
      list.add(buildTitleAndContentCell('计费重量', countWeight,
          textColor: BaseStylesConfig.textRed));
      list.add(buildTitleAndContentCell('预估运费', expireFee,
          textColor: BaseStylesConfig.textRed));
    }
    return Container(
        // height: 100,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ZHTextLine(
              str: controller.lineModel.value?.name ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            buildTitleAndContentCell('分区', model.name, showIcon: true),
            buildTitleAndContentCell('计费模式', modeStr.ts),
            buildTitleAndContentCell('运送时效', model.referenceTime),
            ...list
          ],
        ));
  }

  buildTitleAndContentCell(
    String title,
    String content, {
    bool showIcon = false,
    Color? textColor,
  }) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ZHTextLine(
                  str: title.ts,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ZHTextLine(
                  str: content,
                  fontSize: 14,
                  color: textColor ?? BaseStylesConfig.textBlack,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  billingDesView(RegionModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
      child: Column(
        children: listWidget(model),
      ),
    );
  }

  listWidget(RegionModel model) {
    List<Widget> listWidget = [];
    listWidget.add(Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: ZHTextLine(
        str: '计费标准'.ts,
        fontSize: 20,
        fontWeight: FontWeight.bold,
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
          titleStr = '首重'.ts +
              '（' +
              (item.start / 1000).toStringAsFixed(2) +
              (controller.localModel?.weightSymbol ?? '') +
              '）';
        } else {
          titleStr = '续重'.ts +
              '（' +
              (item.start / 1000).toStringAsFixed(2) +
              (controller.localModel?.weightSymbol ?? '') +
              '）';
        }
        num price = item.price;
        String contentStr = price.rate() +
            '/' +
            (listWidget.length == 1
                ? (item.start / 1000).toStringAsFixed(2)
                : ((item.unitWeight ?? 0) != 0
                    ? (item.unitWeight! / 1000).toStringAsFixed(2)
                    : '')) +
            (controller.lineModel.value!.baseMode == 0
                ? controller.localModel!.weightSymbol
                : 'm³');
        listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
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
            priceStr = '${basePrice.rate()}+${price.rate()}/$contentSymbol';
          } else if (basePrice != 0) {
            priceStr = basePrice.rate();
          } else if (price != 0) {
            priceStr = price.rate() + '/$contentSymbol';
          }
          newPirces[titleStr] = priceStr;
        }
      }
      for (var key in newPirces.keys) {
        String titleStr = key + contentSymbol;
        listWidget.add(buildTitleAndContentCell(titleStr, newPirces[key]));
      }
    } else if (controller.lineModel.value!.mode == 3) {
      // 单位价格 + 阶梯总价模式
      for (var item in model.prices!) {
        if (item.type == 3) {
          String titleStr = '单位价格'.ts;
          String contentStr = item.price.rate() + '/$contentSymbol';
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        } else {
          String titleStr = (item.start / 1000).toStringAsFixed(2) +
              '~' +
              (item.end / 1000).toStringAsFixed(2) +
              contentSymbol;
          String contentStr = item.price.rate();
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        }
      }
    } else if (controller.lineModel.value!.mode == 4) {
      // 多级续重模式
      int k = 0;
      for (var item in model.prices!) {
        if (item.type == 0) {
          String titleStr = '首重'.ts +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol +
              '）';
          num price = item.price;
          String contentStr = price.rate() +
              '/' +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        } else {
          ++k;
          String titleStr = '总重'.ts + k.toString();
          num price = item.price;
          String contentStr = price.rate() +
              '/' +
              (item.unitWeight != null
                  ? (item.unitWeight! / 1000).toStringAsFixed(2)
                  : '') +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        }
      }
      String titleStr = '最大限重'.ts;
      String contentStr =
          (controller.lineModel.value!.maxWeight! / 1000).toStringAsFixed(2) +
              contentSymbol;
      listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
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
          height: 40,
          child: ZHTextLine(
            str: title,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ));
        for (var item in sortPrices[key]!) {
          String titleStr = '续重'.ts;
          if (item.type == 6) {
            titleStr = '首重'.ts +
                '(${(item.firstWeight / 1000).toStringAsFixed(2)}$contentSymbol)';
          }
          num? unitPrice = item.type == 6 ? item.firstWeight : item.unitWeight;
          num? price = item.price;
          String contentStr = (price ?? 0).rate() +
              '/' +
              ((unitPrice ?? 0) / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        }
      }
    }
    return listWidget;
  }

  showTipsView(context, ShipLineServiceModel item) {
    BaseDialog.normalDialog(
      context,
      title: item.name,
      titleFontSize: 18,
      child: Container(
        // height: 60,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: ZHTextLine(
          str: item.remark,
          lines: 10,
        ),
      ),
    );
  }
}
