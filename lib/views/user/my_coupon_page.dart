/*
  我的优惠券
 */

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_coupon_model.dart';
import 'package:jiyun_app_client/provider/data_index_proivder.dart';
import 'package:jiyun_app_client/services/coupon_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyCouponPage extends StatefulWidget {
  final Map arguments;
  const MyCouponPage({Key? key, required this.arguments}) : super(key: key);

  @override
  MyCouponPageState createState() => MyCouponPageState();
}

class MyCouponPageState extends State<MyCouponPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  int pageIndex = 0;
  bool canSelect = false;
  String lineId = '';
  String amount = '';

  LocalizationModel? localizationInfo;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  int selectNum = 0;

  List<UserCouponModel> availableList = [];
  List<UserCouponModel> unAvailableList = [];

  UserCouponModel? selectCoupon;

  @override
  void initState() {
    super.initState();

    canSelect = widget.arguments['select'];
    lineId = widget.arguments['lineid'].toString();
    amount = widget.arguments['amount'].toString();
    selectCoupon = widget.arguments['model'];

    loadAvailableList();
    loadUnAvailableList();
  }

  loadAvailableList() async {
    Map<String, dynamic> params1 = {
      "page": 1,
      "size": '1000',
      "available": '1', // 1可用 0不可用
      "express_line_id": lineId, // 线路ID
      "amount": amount, // 现金
    };

    var data = await CouponService.getList(params1);
    setState(() {
      availableList.addAll(data['dataList']);
    });
  }

  loadUnAvailableList() async {
    Map<String, dynamic> params1 = {
      "page": 1,
      "size": '1000',
      "available": '2', // 1可用 0不可用
      "express_line_id": lineId, // 线路ID
      "amount": amount, // 现金
    };

    var data = await CouponService.getList(params1);
    setState(() {
      unAvailableList.addAll(data['dataList']);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '优惠券',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBar: canSelect
            ? SafeArea(
                child: Container(
                color: ColorConfig.white,
                padding: const EdgeInsets.only(right: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Caption(str: '可抵扣：'),
                    Caption(
                        color: ColorConfig.textRed,
                        str: selectCoupon == null
                            ? localizationInfo!.currencySymbol + '0.00'
                            : localizationInfo!.currencySymbol +
                                (selectCoupon!.coupon.amount / 100).toString()),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(selectCoupon);
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color: ColorConfig.warningText,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                                width: 1, color: ColorConfig.warningText)),
                        alignment: Alignment.center,
                        height: 40,
                        child: const Caption(str: '确认'),
                      ),
                    )
                  ],
                ),
              ))
            : Container(
                height: 0,
              ),
        backgroundColor: ColorConfig.bgGray,
        body: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(), //禁用滑动事件
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 40,
                alignment: Alignment.centerLeft,
                child: const Caption(
                  str: '可用优惠券',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: buildCellAvailableList,
                controller: _scrollController,
                itemCount: availableList.length,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 40,
                alignment: Alignment.centerLeft,
                child: const Caption(
                  str: '不可用优惠券',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: buildCellUnAvailableList,
                controller: _scrollController,
                itemCount: unAvailableList.length,
              ),
              Gaps.vGap15,
            ]));
  }

  // ignore: missing_return
  Widget buildCellForListView(BuildContext context, int index) {
    if (index == 0) {
      return Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15),
            height: 40,
            alignment: Alignment.centerLeft,
            child: const Caption(
              str: '可用优惠券',
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: buildCellAvailableList,
            controller: _scrollController1,
            itemCount: availableList.length,
          )
        ],
      );
    }
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 15),
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Caption(
            str: '不可用优惠券',
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: buildCellUnAvailableList,
          controller: _scrollController2,
          itemCount: unAvailableList.length,
        )
      ],
    );
  }

  Widget buildCellAvailableList(BuildContext context, int index) {
    UserCouponModel model = availableList[index];

    String startTime =
        model.coupon.effectedAt.split(' ').first.replaceAll('-', '.');

    String endTime =
        model.coupon.expiredAt.split(' ').first.replaceAll('-', '.');

    String money = '';

    if (model.coupon == null) {
      money = '0.00';
    } else {
      money = (model.coupon.amount / 100).toString();
    }
    String scopeStr = '';
    if (model.coupon.scope == 0) {
      scopeStr = '适用范围：' '全部范围';
    } else {
      if (model.coupon.usableLines.length == 1) {
        scopeStr = '适用范围：' + model.coupon.usableLines.first['name'];
      } else {
        scopeStr = '适用范围：' + model.coupon.usableLines.first['name'] + '等';
      }
    }
    return GestureDetector(
        onTap: () {
          if (canSelect) {
            setState(() {
              selectCoupon = model;
            });
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
                color: ColorConfig.white,
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                padding: const EdgeInsets.only(top: 5, left: 15),
                height: 100,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Caption(
                                str: model.coupon.name,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Caption(fontSize: 14, str: scopeStr),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Caption(
                              fontSize: 14,
                              str: '时间：' + startTime + '-' + endTime,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 30,
                                alignment: Alignment.bottomCenter,
                                child: Caption(
                                  str: localizationInfo!.currencySymbol,
                                  color: ColorConfig.textRed,
                                ),
                              ),
                              Container(
                                height: 30,
                                alignment: Alignment.bottomCenter,
                                child: Caption(
                                  str: money,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConfig.textRed,
                                ),
                              )
                            ],
                          ),
                          Gaps.vGap10,
                          Caption(
                            str: model.coupon.threshold == 0
                                ? '无门槛'
                                : '满' +
                                    (model.coupon.threshold / 100).toString() +
                                    '可用',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorConfig.textRed,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Positioned(
                top: 10,
                right: 15,
                child: canSelect
                    ? selectCoupon?.id == model.id
                        ? Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            color: ColorConfig.warningText,
                            child: const Icon(
                              Icons.check,
                              size: 16,
                            ),
                          )
                        : Container()
                    : Container())
          ],
        ));
  }

  Widget buildCellUnAvailableList(BuildContext context, int index) {
    UserCouponModel model = unAvailableList[index];
    String startTime =
        model.coupon.effectedAt.split(' ').first.replaceAll('-', '.');
    String endTime =
        model.coupon.expiredAt.split(' ').first.replaceAll('-', '.');
    String money = '';
    if (model.coupon == null) {
      money = '0.00';
    } else {
      money = (model.coupon.amount / 100).toString();
    }
    String scopeStr = '';
    if (model.coupon.scope == 0) {
      scopeStr = '适用范围： 全部范围';
    } else {
      String useableStr =
          model.coupon.usableLines.map((e) => e['name']).join(',');
      scopeStr = '适用范围：$useableStr';
    }
    return Container(
        color: ColorConfig.whiteGray,
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: const EdgeInsets.only(top: 5, left: 15),
        height: 100,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Caption(
                      str: model.coupon.name,
                      fontWeight: FontWeight.bold,
                      color: HexToColor('CCCCCC'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Caption(
                      fontSize: 14,
                      str: scopeStr,
                      color: HexToColor('CCCCCC'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Caption(
                      fontSize: 14,
                      str: '时间：' + startTime + '-' + endTime,
                      color: HexToColor('CCCCCC'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30,
                        alignment: Alignment.bottomCenter,
                        child: Caption(
                          str: localizationInfo!.currencySymbol,
                          color: HexToColor('FFC7C7'),
                        ),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.bottomCenter,
                        child: Caption(
                          str: money,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HexToColor('FFC7C7'),
                        ),
                      )
                    ],
                  ),
                  Gaps.vGap10,
                  Caption(
                    str: model.coupon.threshold == 0
                        ? '无门槛'
                        : '满' +
                            (model.coupon.threshold / 100).toString() +
                            '可用',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: HexToColor('FFC7C7'),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

// 优惠券列表
class CouponsList extends StatefulWidget {
  final Map<String, dynamic> params;
  const CouponsList({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  CouponsListState createState() => CouponsListState();
}

class CouponsListState extends State<CouponsList> {
  final GlobalKey<CouponsListState> key = GlobalKey();
  int pageIndex = 0;
  bool canSelect = false;

  LocalizationModel? localizationInfo;

  List<UserCouponModel> selectList = [];

  @override
  void initState() {
    super.initState();
    loadList();
    canSelect = widget.params['select'];
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params1 = {
      "page": (++pageIndex),
      "size": '100',
      "available": widget.params['selectType'] == '0' ? '1' : '0', // 1可用 0不可用
      "express_line_id": '', // 线路ID
      "amount": '', // 现金
    };

    var data = await CouponService.getList(params1);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ListRefresh(
      renderItem: renderItem,
      refresh: loadList,
      more: loadMoreList,
    );
  }

  Widget renderItem(index, UserCouponModel model) {
    return cellViews(index, model);
  }

  Widget cellViews(int index, UserCouponModel model) {
    String money = '';

    if (model.coupon == null) {
      money = '0.00';
    } else {
      money = (model.coupon.amount / 100).toStringAsFixed(2);
    }
    return GestureDetector(
        onTap: () {
          if (canSelect) {
            if (widget.params['selectType'] == '0') {
              Navigator.of(context).pop(model);
            }
          }
        },
        child: Container(
            margin: const EdgeInsets.only(top: 0, left: 15, right: 15),
            height: 150,
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.params['selectType'] == '0'
                        ? const AssetImage(
                            "assets/images/AboutMe/youhuiquan@3x.png")
                        : const AssetImage(
                            "assets/images/AboutMe/youhuiquandiss@3x.png"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().screenWidth - 90,
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  child: Caption(
                                    str: localizationInfo!.currencySymbol +
                                        money,
                                    color: ColorConfig.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Caption(
                                          alignment: TextAlign.left,
                                          str: '满22.00可用',
                                          color: ColorConfig.white,
                                          fontSize: 17,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                        Caption(
                                          alignment: TextAlign.left,
                                          str: model.coupon.effectedAt
                                                  .substring(0, 10) +
                                              '-' +
                                              model.coupon.expiredAt
                                                  .substring(0, 10),
                                          color: ColorConfig.white,
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          children: const <Widget>[
                            Caption(
                              alignment: TextAlign.left,
                              str: '试用范围：全部范围',
                              color: ColorConfig.white,
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: ScreenUtil().screenWidth - 120,
                              decoration: BoxDecoration(
                                color: widget.params['selectType'] == '0'
                                    ? const Color(0xFFffe39f)
                                    : ColorConfig.textGray,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(17.5)),
                                // border: new Border.all(width: 1, color: Colors.white),
                              ),
                              child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                  ),
                                  onPressed: () {},
                                  child: Caption(
                                    str: model.coupon.name,
                                    color: widget.params['selectType'] == '0'
                                        ? ColorConfig.textRed
                                        : ColorConfig.white,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ))));
  }
}

///tab 标签栏
class _TabView extends StatelessWidget {
  const _TabView(this.tabName, this.tabSub, this.index);

  final String tabName;
  final String tabSub;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataIndexProvider>(
      builder: (_, provider, child) {
        return Tab(
            child: SizedBox(
          width: 88.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(tabName),
              Offstage(
                  offstage: provider.index != index,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(tabSub,
                        style: const TextStyle(fontSize: TextConfig.smallSize)),
                  )),
            ],
          ),
        ));
      },
    );
  }
}
