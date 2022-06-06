import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/region_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/ship_line_service_model.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/*
  线路详情
*/

class LineDetailPage extends StatefulWidget {
  const LineDetailPage({Key? key, this.arguments}) : super(key: key);
  final Map? arguments;
  @override
  LineDetailPageState createState() => LineDetailPageState();
}

class LineDetailPageState extends State<LineDetailPage> {
  final PageController _pageController = PageController();
  int lineId = 0;
  ShipLineModel? detailLine;
  int type = 0;
  LocalizationModel? localModel;
  bool isloading = false;
  double reMarkheight = 0;
  @override
  void initState() {
    super.initState();
    localModel = Provider.of<Model>(context, listen: false).localizationInfo;
    if (widget.arguments!['type'] == 1) {
      getDetail();
    } else if (widget.arguments!['type'] == 2) {
      setState(() {
        detailLine = widget.arguments!['line'];
        isloading = true;
      });
    }
  }

  getDetail() async {
    EasyLoading.show();
    var data = await ShipLineService.getDetail(widget.arguments!['id']);
    if (data != null) {
      setState(() {
        data.regions = data.regions!.where((e) => e.enabled == 1).toList();
        detailLine = data;
        isloading = true;
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const BackButton(color: Colors.black),
            elevation: 0.5,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            title: Caption(
              str: isloading ? detailLine!.name : '',
              color: ColorConfig.textBlack,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            )),
        backgroundColor: ColorConfig.bgGray,
        body: isloading
            ? ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
                children: <Widget>[
                    widget.arguments!['type'] == 1
                        ? buildMultipleRegion()
                        : buildSingleRegion(),
                    Container(
                      decoration: const BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      margin:
                          const EdgeInsets.only(left: 25, top: 0, right: 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      // height: reMarkheight + 40,
                      alignment: Alignment.centerLeft,
                      child: Caption(
                        fontSize: 14,
                        lines: 99,
                        str: detailLine!.remark,
                      ),
                    ),
                  ])
            : Container());
  }

  // 运费查询、选择路线 单个分区
  Widget buildSingleRegion() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: const BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          topDesView(detailLine!.region!),
          billingDesView(detailLine!.region!),
          buildAddServicesForLine(detailLine!.region!),
          buildAddRulesForLine(detailLine!.region!),
        ],
      ),
    );
  }

  // 首页路线详情、多个分区
  Widget buildMultipleRegion() {
    return Column(
      children: [
        SizedBox(
          child: Container(
            margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
            height: ScreenUtil().screenHeight * 3 / 5,
            child: PageView.builder(
              key: const Key('pageView'),
              itemCount: detailLine?.regions?.length,
              onPageChanged: _onPageChange,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                return buildSignScrollView(index);
              },
            ),
          ),
        ),
        buildPlugin(),
      ],
    );
  }

  buildPlugin() {
    return Container(
        alignment: Alignment.center,
        height: 50,
        width: ScreenUtil().screenWidth,
        child: SmoothPageIndicator(
          count: detailLine!.regions!.length,
          controller: _pageController,
          effect: const WormEffect(
              dotWidth: 10,
              dotHeight: 10,
              spacing: 5,
              dotColor: ColorConfig.textGray,
              activeDotColor: ColorConfig.textBlack),
        ));
  }

  buildSignScrollView(int index) {
    RegionModel regionModel = detailLine!.regions![index];
    var scrollVIew = Container(
        height: ScreenUtil().screenHeight * 3 / 5,
        decoration: const BoxDecoration(
            color: ColorConfig.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              topDesView(regionModel),
              billingDesView(regionModel),
              buildAddServicesForLine(regionModel),
              buildAddRulesForLine(regionModel),
            ],
          ),
        ));
    return scrollVIew;
  }

  topDesView(RegionModel model) {
    String modeStr = '';
    switch (detailLine!.mode) {
      case 1:
        modeStr = '首重续重模式';
        break;
      case 2:
        modeStr = '阶梯价格模式';
        break;
      case 3:
        modeStr = '单位价格+阶梯总价模式';
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
    if (widget.arguments!['type'] == 2) {
      String countWeight =
          (detailLine!.countWeight! / 1000).toStringAsFixed(2) +
              (detailLine!.mode == 1 ? '立方' : localModel!.weightSymbol);
      String expireFee = localModel!.currencySymbol +
          (detailLine!.expireFee! / 100).toStringAsFixed(2);
      list.add(
          buildTitleAndContentCell('计费重量', countWeight, ColorConfig.textRed));
      list.add(
          buildTitleAndContentCell('预估运费', expireFee, ColorConfig.textRed));
    }
    return Container(
        // height: 100,
        color: ColorConfig.white,
        padding: const EdgeInsets.only(
          top: 10,
          right: 15,
          left: 15,
        ),
        child: Column(
          children: <Widget>[
            buildTitleAndContentCell('分区', model.name),
            buildTitleAndContentCell('计费模式', modeStr),
            buildTitleAndContentCell('运送时效', model.referenceTime),
            ...list
          ],
        ));
  }

  billingDesView(RegionModel model) {
    return Container(
        color: ColorConfig.white,
        padding: const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
        child: Column(children: listWidget(model)));
  }

  listWidget(RegionModel model) {
    List<Widget> listWidget = [];
    listWidget.add(Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: const Caption(
        str: '计费标准',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ));
    String contentSymbol =
        detailLine!.baseMode == 0 ? localModel!.weightSymbol : 'm³';
    if (detailLine!.mode == 1) {
      // 首重续重
      for (var item in model.prices!) {
        String titleStr;
        if (listWidget.length == 1) {
          titleStr = '首重' '（' +
              (item.start / 1000).toStringAsFixed(2) +
              localModel!.weightSymbol +
              '）';
        } else {
          titleStr = '续重' '（' +
              (item.start / 1000).toStringAsFixed(2) +
              localModel!.weightSymbol +
              '）';
        }
        num price = item.price;
        String contentStr =
            localModel!.currencySymbol + (price / 100).toStringAsFixed(2);
        listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
      }
    } else if (detailLine!.mode == 2) {
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
          newPirces[titleStr] = localModel!.currencySymbol + priceStr;
        }
      }
      for (var key in newPirces.keys) {
        String titleStr = key + contentSymbol;
        listWidget.add(buildTitleAndContentCell(titleStr, newPirces[key]));
      }
    } else if (detailLine!.mode == 3) {
      // 单位价格 + 阶梯总价模式
      for (var item in model.prices!) {
        if (item.type == 3) {
          String titleStr = '单位价格';
          String contentStr = localModel!.currencySymbol +
              (item.price / 100).toStringAsFixed(2) +
              '/$contentSymbol';
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        } else {
          String titleStr = (item.start / 1000).toStringAsFixed(2) +
              '~' +
              (item.end / 1000).toStringAsFixed(2) +
              contentSymbol;
          String contentStr = localModel!.currencySymbol +
              (item.price / 100).toStringAsFixed(2);
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        }
      }
    } else if (detailLine!.mode == 4) {
      // 多级续重模式
      int k = 0;
      for (var item in model.prices!) {
        if (item.type == 0) {
          String titleStr = '首重（' +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol +
              '）';
          num price = item.price;
          String contentStr = localModel!.currencySymbol +
              (price / 100).toStringAsFixed(2) +
              '/' +
              (item.start / 1000).toStringAsFixed(2) +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        } else {
          ++k;
          String titleStr = '续重' + k.toString();
          num price = item.price;
          String contentStr = localModel!.currencySymbol +
              (price / 100).toStringAsFixed(2) +
              '/' +
              (item.unitWeight != null
                  ? (item.unitWeight! / 1000).toStringAsFixed(2)
                  : '') +
              contentSymbol;
          listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
        }
      }
      String titleStr = '最大限重';
      String contentStr =
          (detailLine!.maxWeight! / 1000).toStringAsFixed(2) + contentSymbol;
      listWidget.add(buildTitleAndContentCell(titleStr, contentStr));
    } else if (detailLine!.mode == 5) {
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
          child: Caption(
            str: title,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ));
        for (var item in sortPrices[key]!) {
          String titleStr = '续重';
          if (item.type == 6) {
            titleStr =
                '首重(${(item.firstWeight / 1000).toStringAsFixed(2)}$contentSymbol)';
          }
          num? unitPrice = item.type == 6 ? item.firstWeight : item.unitWeight;
          String contentStr = localModel!.currencySymbol +
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

  buildTitleAndContentCell(String title, String content, [Color? textColor]) {
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
                Caption(
                  str: title,
                  fontSize: 14,
                ),
                title == '分区'
                    ? Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: IconButton(
                            icon: const Icon(
                              Icons.error_outline_outlined,
                              color: ColorConfig.warningText,
                              size: 25,
                            ),
                            onPressed: () {
                              showReginsList();
                            }),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
              height: 30,
              alignment: Alignment.bottomCenter,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Caption(
                      str: content,
                      fontSize: 14,
                      color: textColor ?? ColorConfig.textBlack,
                    )
                  ]))
        ],
      ),
    );
  }

  // 线路服务数据
  buildAddServicesForLine(RegionModel model) {
    return model.services!.isNotEmpty
        ? Container(
            color: ColorConfig.white,
            padding:
                const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
            child: Column(children: listWidgetForLineServices(model)))
        : Container();
  }

  listWidgetForLineServices(RegionModel model) {
    List<Widget> viewList = [];
    viewList.add(Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: const Caption(
        str: '渠道增值服务',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ));
    for (var item in model.services!) {
      String first = '';
      String second = '';
      String third = '';
      // 1 运费比例 2固定费用 3单箱固定费用 4单位计费重量固定费用 5单位实际重量固定费用 6申报价值比列
      switch (item.type) {
        case 1:
          first = '实际运费';
          second = (item.value / 100).toStringAsFixed(2) + '%';
          break;
        case 2:
          second = localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
          break;
        case 3:
          second = localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2) +
              '/箱';
          break;
        case 4:
          second = localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2) +
              '/' +
              localModel!.weightSymbol;
          third = '(计费重)';
          break;
        case 5:
          second = localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2) +
              '/' +
              localModel!.weightSymbol;
          third = '(实重)';
          break;
        case 6:
          second = '申报价值' + (item.value / 100).toString() + '%';
          // localModel.currencySymbol +
          //     ((item.value / 10000) * (totalValue / 100)).toStringAsFixed(2);
          break;
        default:
      }
      var view = SizedBox(
        height: 30,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Caption(str: item.name),
                      Caption(str: item.isForced == 0 ? '（可选）' : '（必选）'),
                      item.remark.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.error_outline_outlined,
                                    color: ColorConfig.warningText,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    showTipsView(item);
                                  }),
                            )
                          : Container(),
                    ],
                  ),
                  Container(
                    height: 49,
                    alignment: Alignment.bottomRight,
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: first,
                            style: const TextStyle(
                                color: ColorConfig.textDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          const TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: ColorConfig.textBlack,
                              fontSize: 10.0,
                            ),
                          ),
                          TextSpan(
                            text: second,
                            style: const TextStyle(
                              color: ColorConfig.textBlack,
                              fontSize: 15.0,
                            ),
                          ),
                          const TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: ColorConfig.textBlack,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: third,
                            style: const TextStyle(
                              color: ColorConfig.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      viewList.add(view);
    }
    return viewList;
  }

  // 出库规则
  buildAddRulesForLine(RegionModel model) {
    return model.rules!.isNotEmpty
        ? Container(
            color: ColorConfig.white,
            padding:
                const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
            child: Column(children: buildRulesView(model)))
        : Container();
  }

  buildRulesView(RegionModel model) {
    List<String> contentList = [];
    if (model.rules != null && model.rules!.isNotEmpty) {
      int itemNum = 1;
      for (var item in model.rules!) {
        String contentStr = itemNum.toString() + ' 、';
        itemNum++;
        for (var subItem in item.conditions!) {
          contentStr += '(' +
              subItem.paramName +
              subItem.comparison +
              subItem.value.toString() +
              ')' +
              ' 时,';
        }
        if (item.type == 1) {
          contentStr += '限定【按订单收费】' +
              localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
        } else if (item.type == 2) {
          contentStr += '限定【按箱收费】' +
              localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
        } else if (item.type == 3) {
          contentStr += '限定【按单位计费重量收费】' +
              localModel!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
        } else if (item.type == 4) {
          contentStr += '限定【限制出仓】';
        }
        if (item.minCharge != null && item.minCharge != 0) {
          contentStr += '（最低收费' +
              localModel!.currencySymbol +
              (item.minCharge / 100).toStringAsFixed(2) +
              ',';
        }
        if (item.maxCharge != null && item.maxCharge != 0) {
          contentStr += '（最高收费' +
              localModel!.currencySymbol +
              (item.maxCharge / 100).toStringAsFixed(2) +
              '）';
        }

        contentList.add(contentStr);
      }
      String contentStr = '注：以上规则';
      if (detailLine!.ruleFeeMode == 0) {
        contentStr += '【同时收取】';
      } else {
        contentStr += '【每个分区仅按最高项规则收取】';
      }
      contentStr += '，最高收费';
      if (detailLine!.maxRuleFee == 0) {
        contentStr += '无上限';
      } else {
        contentStr += localModel!.currencySymbol +
            (detailLine!.maxRuleFee / 100).toString();
      }
      contentList.add(contentStr);
    }
    return rulesTextList(contentList);
  }

  rulesTextList(List<String> list) {
    List<Widget> textList = [];
    textList.add(Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: const Caption(
        str: '渠道限制规则',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ));
    for (var item in list) {
      double height = calculateTextHeight(
              item, 14.0, FontWeight.w300, ScreenUtil().screenWidth - 80, 9) +
          3;
      var con = Container(
        alignment: Alignment.centerLeft,
        height: height,
        child: Caption(
          lines: 9,
          fontSize: 14,
          str: item,
        ),
      );
      textList.add(con);
    }
    return textList;
  }

  double calculateTextHeight(String value, fontSize, FontWeight fontWeight,
      double maxWidth, int maxLines) {
    // value = filterText(value);
    TextPainter painter = TextPainter(
        // ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        // locale: Localizations.localeOf(GlobalStatic.context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }

  showReginsList() {
    var _dialogWidth = MediaQuery.of(context).size.width * 0.86;
    Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Caption(
        str: detailLine!.name,
      ),
    );
    // widgetList.add(Gaps.line);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: ScreenUtil().screenHeight - 200,
              ),
              width: _dialogWidth,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  title,
                  Gaps.line,
                  getAreaList(),
                  const Divider(
                    height: 1,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: _dialogWidth,
                      alignment: Alignment.center,
                      child: const Caption(
                          str: '确定', color: ColorConfig.warningTextDark),
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
  }

  Widget getAreaList() {
    List<Widget> widgetList = [];
    for (var item in detailLine!.regions!) {
      String contentStr = '';
      for (var item1 in item.areas!) {
        if (contentStr.isNotEmpty) {
          contentStr += '、' +
              item1.countryName +
              (item1.areaName ?? '') +
              (item1.subAreaName ?? '');
        } else {
          contentStr += item1.countryName +
              (item1.areaName ?? '') +
              (item1.subAreaName ?? '');
        }
      }
      widgetList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 30,
            child: Caption(str: item.name + ':'),
          ),
          Gaps.hGap5,
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(width: 0.5, color: ColorConfig.textGray)),
            child: Caption(
              str: contentStr,
              lines: 100,
            ),
          )
        ],
      ));
    }
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: widgetList,
        ),
      ),
    );
  }

  showTipsView(ShipLineServiceModel item) {
    showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: ColorConfig.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 1, color: ColorConfig.white),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: <Widget>[
                        Caption(
                          str: item.name,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                  Gaps.line,
                  Container(
                      // height: 60,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Caption(
                        str: item.remark,
                        lines: 10,
                      )),
                  SizedBox(
                    height: 50,
                    width: ScreenUtil().screenWidth - 90,
                    child: Column(
                      children: <Widget>[
                        Gaps.line,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: TextButton(
                                    child: const Caption(
                                      str: '确定',
                                      color: ColorConfig.warningText,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    }))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _onPageChange(int index) {
    // _tabController.animateTo(index);
    // provider.setIndex(index);
  }
}
