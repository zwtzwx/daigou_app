import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/region_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/line/detail/line_detail_controller.dart';

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
          controller.lineModel.value != null ? singleCell() : Sized.empty,
          Container(
            decoration: const BoxDecoration(
              color: BaseStylesConfig.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.only(left: 15, top: 0, right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            // height: reMarkheight + 40,
            alignment: Alignment.centerLeft,
            child: ZHTextLine(
              fontSize: 14,
              lines: 99,
              str: controller.lineModel.value?.remark ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget singleCell() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: const BoxDecoration(
          color: BaseStylesConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          baseInfoCell(controller.lineModel.value!.region!),
          billingDesView(controller.lineModel.value!.region!),
          // lineServiceCell(controller.lineModel.value!.region!),
          // lineRuleCell(controller.lineModel.value!.region!),
        ],
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

    String countWeight =
        (controller.lineModel.value!.countWeight! / 1000).toStringAsFixed(2) +
            (controller.lineModel.value!.mode == 1
                ? '立方'
                : (controller.localModel?.weightSymbol ?? ''));
    String expireFee = (controller.localModel?.currencySymbol ?? '') +
        (controller.lineModel.value!.expireFee! / 100).toStringAsFixed(2);
    list.add(buildTitleAndContentCell('计费重量', countWeight,
        textColor: BaseStylesConfig.textRed));
    list.add(buildTitleAndContentCell('预估运费', expireFee,
        textColor: BaseStylesConfig.textRed));
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
            buildTitleAndContentCell('计费模式', modeStr),
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
        String contentStr = (controller.localModel?.currencySymbol ?? '') +
            (price / 100).toStringAsFixed(2);
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
            priceStr =
                '${(basePrice / 100).toStringAsFixed(2)}+${(price / 100).toStringAsFixed(2)}/$contentSymbol';
          } else if (basePrice != 0) {
            priceStr = (basePrice / 100).toStringAsFixed(2);
          } else if (price != 0) {
            priceStr = (price / 100).toStringAsFixed(2) + '/$contentSymbol';
          }
          newPirces[titleStr] =
              (controller.localModel?.currencySymbol ?? '') + priceStr;
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
          String contentStr = (controller.localModel?.currencySymbol ?? '') +
              (item.price / 100).toStringAsFixed(2) +
              '/$contentSymbol';
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        } else {
          String titleStr = (item.start / 1000).toStringAsFixed(2) +
              '~' +
              (item.end / 1000).toStringAsFixed(2) +
              contentSymbol;
          String contentStr = (controller.localModel?.currencySymbol ?? '') +
              (item.price / 100).toStringAsFixed(2);
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
          String contentStr = (controller.localModel?.currencySymbol ?? '') +
              (price / 100).toStringAsFixed(2) +
              '/' +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        } else {
          ++k;
          String titleStr = '总重'.ts + k.toString();
          num price = item.price;
          String contentStr = (controller.localModel?.currencySymbol ?? '') +
              (price / 100).toStringAsFixed(2) +
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
          String contentStr = (controller.localModel?.currencySymbol ?? '') +
              ((item.price ?? 0) / 100).toStringAsFixed(2) +
              '/' +
              ((unitPrice ?? 0) / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        }
      }
    }
    return listWidget;
  }
}
