/*
  我的优惠券
 */

import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_coupon_model.dart';
import 'package:jiyun_app_client/services/coupon_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyCouponPage extends StatefulWidget {
  final Map arguments;
  const MyCouponPage({Key? key, required this.arguments}) : super(key: key);

  @override
  MyCouponPageState createState() => MyCouponPageState();
}

class MyCouponPageState extends State<MyCouponPage>
    with TickerProviderStateMixin {
  bool isLoading = false;
  int pageIndex = 0;
  bool canSelect = false;
  String lineId = '';
  String amount = '';

  LocalizationModel? localizationInfo;

  late TabController _tabController;
  final PageController _pageController = PageController();

  int selectNum = 0;

  List<UserCouponModel> availableList = [];
  List<UserCouponModel> unAvailableList = [];

  UserCouponModel? selectCoupon;

  @override
  void initState() {
    super.initState();
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    canSelect = widget.arguments['select'];
    lineId = widget.arguments['lineid'].toString();
    amount = widget.arguments['amount'].toString();
    selectCoupon = widget.arguments['model'];
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPageChange(int index) {
    _tabController.animateTo(index);
  }

  // 选择优惠券
  void _onSelected(UserCouponModel model) {
    if (!canSelect) return;
    setState(() {
      if (selectCoupon != null && selectCoupon!.id == model.id) {
        selectCoupon = null;
      } else {
        selectCoupon = model;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '优惠券'),
          color: ColorConfig.textBlack,
          fontSize: 18,
        ),
        bottom: TabBar(
            labelColor: ColorConfig.primary,
            indicatorColor: ColorConfig.primary,
            controller: _tabController,
            onTap: (int index) {
              _pageController.jumpToPage(index);
            },
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Caption(
                  str: Translation.t(context, '可用'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Caption(
                  str: Translation.t(context, '不可用'),
                ),
              ),
            ]),
      ),
      bottomNavigationBar: canSelect
          ? Container(
              color: ColorConfig.white,
              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Caption(str: Translation.t(context, '可抵扣') + '：'),
                    Caption(
                        color: ColorConfig.textRed,
                        str: selectCoupon == null
                            ? '0.00'
                            : (selectCoupon!.coupon!.amount / 100)
                                .toStringAsFixed(2)),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: MainButton(
                        text: '确认',
                        borderRadis: 20.0,
                        onPressed: () {
                          Navigator.of(context).pop({
                            'confirm': true,
                            'selectCoupon': selectCoupon,
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 0,
            ),
      backgroundColor: ColorConfig.bgGray,
      body: PageView.builder(
          itemCount: 2,
          controller: _pageController,
          onPageChanged: _onPageChange,
          itemBuilder: (context, int index) {
            return CouponsList(
              params: {
                'selectType': index,
                'lineId': lineId,
                'amount': amount,
                'selectCoupon': selectCoupon,
                'localizationInfo': localizationInfo,
              },
              onSelected: _onSelected,
            );
          }),
    );
  }
}

// 优惠券列表
class CouponsList extends StatefulWidget {
  const CouponsList({
    Key? key,
    required this.params,
    required this.onSelected,
  }) : super(key: key);

  final Map<String, dynamic> params;
  final Function onSelected;

  @override
  CouponsListState createState() => CouponsListState();
}

class CouponsListState extends State<CouponsList> {
  final GlobalKey<CouponsListState> key = GlobalKey();
  int pageIndex = 0;

  LocalizationModel? localizationInfo;

  List<UserCouponModel> selectList = [];

  @override
  void initState() {
    super.initState();
    localizationInfo = widget.params['localizationInfo'];
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params1 = {
      "page": (++pageIndex),
      "available": widget.params['selectType'] == 0 ? '1' : '0', // 1可用 0不可用
      "express_line_id": widget.params['lineId'], // 线路ID
      "amount": widget.params['amount'], // 现金
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
      money = ((model.coupon?.amount ?? 0) / 100).toStringAsFixed(2);
    }
    return GestureDetector(
        onTap: () {
          if (widget.params['selectType'] == 0) {
            // if (widget.params['selectType'] == '0') {
            //   Navigator.of(context).pop(model);
            // }
            widget.onSelected(model);
          }
        },
        child: Container(
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            height: 150,
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.params['selectType'] == 0
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
                                    str: money,
                                    color: ColorConfig.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
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
                                        Caption(
                                          alignment: TextAlign.left,
                                          str: Translation.t(
                                              context, '满{price}可用', value: {
                                            'price':
                                                ((model.coupon?.threshold ??
                                                            0) /
                                                        100)
                                                    .toStringAsFixed(2)
                                          }),
                                          color: ColorConfig.white,
                                          fontSize: 17,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                        Caption(
                                          alignment: TextAlign.left,
                                          str: model.coupon != null
                                              ? model.coupon!.effectedAt
                                                      .substring(0, 10) +
                                                  '-' +
                                                  model.coupon!.expiredAt
                                                      .substring(0, 10)
                                              : '',
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
                        Container(
                          width: ScreenUtil().screenWidth - 90,
                          alignment: Alignment.center,
                          child: Caption(
                            alignment: TextAlign.left,
                            str: Translation.t(context, '适用范围') +
                                '：' +
                                ((model.coupon?.scope ?? 0) == 1
                                    ? model.coupon?.usableLines
                                            .map((e) => e['name'])
                                            .join(',') ??
                                        ''
                                    : Translation.t(context, '全部范围')),
                            color: ColorConfig.white,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                          ),
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
                                color: widget.params['selectType'] == 0
                                    ? const Color(0xFFffcc7e)
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
                                    str: (widget.params['selectCoupon'] !=
                                                null &&
                                            widget.params['selectCoupon'].id ==
                                                model.id)
                                        ? Translation.t(context, '取消使用')
                                        : model.coupon?.name ?? '',
                                    color: widget.params['selectType'] == 0
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
