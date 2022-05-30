/*
  申请提现
 */

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/models/agent_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/provider/data_index_proivder.dart';
import 'package:jiyun_app_client/services/agent_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ApplyWithDrawPage extends StatefulWidget {
  const ApplyWithDrawPage({Key? key}) : super(key: key);

  @override
  ApplyWithDrawPageState createState() => ApplyWithDrawPageState();
}

class ApplyWithDrawPageState extends State<ApplyWithDrawPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int pageIndex = 0;

  DataIndexProvider provider = DataIndexProvider();

  late TabController _tabController;

  List<WithdrawalModel> selModelList = [];
  List<WithdrawalModel> allModelList = [];

  final PageController _pageController = PageController(initialPage: 0);

  int selectNum = 0;
  bool selectAll = false;
  AgentModel? agentModel;

  @override
  void initState() {
    super.initState();
    created();
    _tabController = TabController(vsync: this, length: 2);
  }

  /*
    创建
   */
  created() async {
    EasyLoading.show();

    //加载代理信息
    agentModel = await AgentService.getProfile();
    EasyLoading.dismiss();
    setState(() {
      isLoading = true;
    });
  }

  // 申请提现
  onApply() async {
    List<int> ids = [];
    for (var item in selModelList) {
      ids.add(item.id);
    }
    if (ids.isEmpty) {
      Util.showToast('请选择要提现的订单');
      return;
    }
    EasyLoading.show();
    Map result = await AgentService.applyWithDraw({
      'commission_ids': ids,
      'withdraw_type': '4',
    });
    EasyLoading.dismiss();
    if (result['ok']) {
      Routers.push('/ApplyWithDrawSuccessPage', context);
    } else {
      EasyLoading.showError(result['msg'] ?? '提现申请失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalizationModel? localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return ChangeNotifierProvider<DataIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              title: const Caption(
                str: '提现',
                color: ColorConfig.textBlack,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            bottomNavigationBar: SafeArea(
                child: SizedBox(
                    height: pageIndex == 0 ? 110 : 0,
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 49.5,
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Caption(
                                  str: '提现到',
                                ),
                                GestureDetector(
                                    onTap: () {
                                      var s = Routers.push(
                                        '/WithdrawlUserInfoPage',
                                        context,
                                      );
                                      if (s != null) {
                                        created();
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          color: ColorConfig.white,
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Caption(
                                            str: agentModel == null ||
                                                    agentModel!.bankCode.isEmpty
                                                ? '请完善提现信息'
                                                : agentModel!.bankName +
                                                    '(' +
                                                    agentModel!.bankNumber
                                                        .substring(agentModel!
                                                                .bankNumber
                                                                .length -
                                                            4) +
                                                    ')',
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: ColorConfig.textGray,
                                        )
                                      ],
                                    )),
                              ],
                            )),
                        Gaps.line,
                        Container(
                          height: 60,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextButton.icon(
                                      onPressed: () {
                                        int totalMoney = 0;
                                        setState(() {
                                          selectAll = !selectAll;
                                          selModelList.clear();

                                          if (selectAll) {
                                            selModelList.addAll(allModelList);
                                            for (WithdrawalModel item
                                                in selModelList) {
                                              totalMoney +=
                                                  item.commissionAmount;
                                            }
                                          }
                                          selectNum = totalMoney;
                                        });
                                      },
                                      icon: selectAll
                                          ? const Icon(
                                              Icons.check_circle,
                                              color: ColorConfig.warningText,
                                            )
                                          : const Icon(
                                              Icons.radio_button_unchecked,
                                              color: ColorConfig.textGray),
                                      label: const Caption(
                                        str: '全选',
                                      )),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: const Caption(
                                            str: '已选：',
                                          )),
                                      Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: Caption(
                                            str: isLoading
                                                ? localizationInfo!
                                                    .currencySymbol
                                                : '',
                                            fontSize: 12,
                                            color: ColorConfig.textRed,
                                          )),
                                      Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: Caption(
                                            str: (selectNum / 100)
                                                .toStringAsFixed(2),
                                            color: ColorConfig.textRed,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: onApply,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 15, left: 15, top: 10, bottom: 10),
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  decoration: BoxDecoration(
                                      color: ColorConfig.warningText,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorConfig.warningText)),
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: const Caption(
                                    str: '申请提现',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
            body: Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Color(0xFFF2F2F7), width: 1))),
                  child: TabBar(
                    onTap: (index) {
                      if (!mounted) {
                        return;
                      }
                      _pageController.jumpToPage(index);
                    },
                    isScrollable: false,
                    controller: _tabController,
                    labelColor: ColorConfig.textNormal,
                    labelStyle: TextConfig.textBoldDark14,
                    unselectedLabelColor: ColorConfig.textDark,
                    unselectedLabelStyle: TextConfig.textDark14,
                    indicatorColor: ColorConfig.warningText,
                    tabs: const <Widget>[
                      _TabView("可提现", "", 0),
                      _TabView("已提现", "", 1),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    key: const Key('pageView'),
                    itemCount: 2,
                    onPageChanged: _onPageChange,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 1) {
                        // 已经提现
                        return TradingList(
                          params: {'selectType': '$index'},
                        );
                      } else {
                        // 可以提现
                        return PrepaidList(
                          params: {
                            'selectType': '$index',
                            'selList': selModelList
                          },
                          onChanged: (WithdrawalModel number) {
                            if (selModelList.contains(number)) {
                              selModelList.remove(number);
                            } else {
                              selModelList.add(number);
                            }
                            int totalMoney = 0;
                            for (WithdrawalModel item in selModelList) {
                              totalMoney += item.commissionAmount;
                            }
                            setState(() {
                              if (allModelList.length == selModelList.length) {
                                selectAll = true;
                              } else {
                                selectAll = false;
                              }
                              selectNum = totalMoney;
                            });
                          },
                          onChangedDtatList: (List<WithdrawalModel> data) {
                            if (data.isEmpty) {
                              allModelList.clear();
                            } else {
                              allModelList.addAll(data);
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )));
  }

  _onPageChange(int index) {
    _tabController.animateTo(index);
    setState(() {
      pageIndex = index;
    });

    provider.setIndex(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/*
  可提现列表
 */
class PrepaidList extends StatefulWidget {
  final ValueChanged<WithdrawalModel>? onChanged;
  final ValueChanged<List<WithdrawalModel>>? onChangedDtatList;
  final Map<String, dynamic> params;

  const PrepaidList({
    Key? key,
    required this.params,
    this.onChanged,
    this.onChangedDtatList,
  }) : super(key: key);

  @override
  PrepaidListState createState() => PrepaidListState();
}

class PrepaidListState extends State<PrepaidList> {
  final GlobalKey<PrepaidListState> key = GlobalKey();

  int pageIndex = 0;
  List<int> selectList = [];
  List<WithdrawalModel> selectModelList = [];
  LocalizationModel? localizationInfo;

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await AgentService.getAvailableWithDrawList({
      'is_withdraw_list': '2',
      'page': (++pageIndex),
      'size': '10',
    });
    if (pageIndex == 1 && widget.onChangedDtatList != null) {
      widget.onChangedDtatList!([]);
    }
    if (widget.onChangedDtatList != null && data['total'] > 0) {
      widget.onChangedDtatList!(data['dataList']);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: bottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget bottomListCell(index, WithdrawalModel model) {
    var container = GestureDetector(
        onTap: () {
          setState(() {
            // if (selectModelList.contains(model)) {
            //   selectModelList.remove(model);
            // } else {
            //   selectModelList.add(model);
            // }
            widget.onChanged!(model);
          });
        },
        child: Container(
            margin: const EdgeInsets.only(right: 15, left: 15, top: 10),
            padding: const EdgeInsets.only(right: 15, left: 15),
            width: ScreenUtil().screenWidth - 60,
            decoration: BoxDecoration(
                color: ColorConfig.white,
                border: Border(
                  bottom: Divider.createBorderSide(context,
                      color: ColorConfig.line, width: 1),
                )),
            height: 121,
            child: Row(
              children: <Widget>[
                Container(
                  height: 60,
                  width: 40,
                  alignment: Alignment.centerLeft,
                  child: widget.params['selList'].contains(model)
                      ? const Icon(
                          Icons.check_circle,
                          color: ColorConfig.warningText,
                        )
                      : const Icon(
                          Icons.radio_button_off,
                          color: ColorConfig.bgGray,
                        ),
                  // : selectModelList.contains(model)
                  //     ? const Icon(
                  //         Icons.check_circle,
                  //         color: ColorConfig.warningText,
                  //       )
                  //     : const Icon(
                  //         Icons.radio_button_off,
                  //         color: ColorConfig.bgGray,
                  //       ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().screenWidth - 100,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Caption(
                            alignment: TextAlign.left,
                            str: model.orderNumber,
                            color: ColorConfig.textDark,
                            fontSize: 13,
                          ),
                          Caption(
                            alignment: TextAlign.left,
                            str: model.createdAt,
                            color: ColorConfig.textGray,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: ScreenUtil().screenWidth - 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(right: 0),
                              decoration: const BoxDecoration(
                                color: ColorConfig.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: LoadImage(
                                  model.customer!.avatar,
                                  fit: BoxFit.fitWidth,
                                  holderImg: "PackageAndOrder/defalutIMG@3x",
                                  format: "png",
                                ),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Caption(
                                str: model.customer!.name,
                                fontSize: 14,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Caption(
                                    str: '金额：',
                                    fontSize: 14,
                                  ),
                                  Caption(
                                    fontSize: 14,
                                    str: localizationInfo!.currencySymbol +
                                        (model.orderAmount / 100)
                                            .toStringAsFixed(2),
                                    color: ColorConfig.textBlack,
                                  )
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Caption(
                                str: '',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Caption(
                                    fontSize: 14,
                                    str: '收益：',
                                  ),
                                  Caption(
                                    fontSize: 14,
                                    str: localizationInfo!.currencySymbol +
                                        (model.commissionAmount / 100)
                                            .toStringAsFixed(2),
                                    color: ColorConfig.textRed,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )));
    return container;
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

// 已提现
class TradingList extends StatefulWidget {
  final ValueChanged<int>? onChanged;
  final Map<String, dynamic> params;

  const TradingList({
    Key? key,
    required this.params,
    this.onChanged,
  }) : super(key: key);

  @override
  TradingListState createState() => TradingListState();
}

class TradingListState extends State<TradingList> {
  final GlobalKey<TradingListState> key = GlobalKey();
  int pageIndex = 0;
  LocalizationModel? localizationInfo;

  @override
  void initState() {
    super.initState();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    return await AgentService.getWithdrawedList({
      'page': (++pageIndex),
      'size': '10',
    });
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: bottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget bottomListCell(index, WithdrawalModel model) {
    var container = Container(
        margin: const EdgeInsets.only(right: 15, left: 15, top: 10),
        padding: const EdgeInsets.only(right: 15, left: 15),
        width: ScreenUtil().screenWidth - 60,
        decoration: BoxDecoration(
            color: ColorConfig.white,
            border: Border(
              bottom: Divider.createBorderSide(context,
                  color: ColorConfig.line, width: 1),
            )),
        height: 121,
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil().screenWidth - 60,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Caption(
                        alignment: TextAlign.left,
                        str: model.orderNumber,
                        color: ColorConfig.textDark,
                        fontSize: 13,
                      ),
                      Caption(
                        alignment: TextAlign.left,
                        str: model.createdAt,
                        color: ColorConfig.textGray,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: ScreenUtil().screenWidth - 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                            color: ColorConfig.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: LoadImage(
                              model.customer!.avatar,
                              fit: BoxFit.fitWidth,
                              holderImg: "PackageAndOrder/defalutIMG@3x",
                              format: "png",
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Caption(
                            str: model.customer!.name,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const Caption(
                                str: '金额：',
                              ),
                              Caption(
                                str: localizationInfo!.currencySymbol +
                                    (model.orderAmount / 100)
                                        .toStringAsFixed(2),
                                color: ColorConfig.textBlack,
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Caption(
                            str: '   ',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const Caption(
                                str: '收益：',
                              ),
                              Caption(
                                str: localizationInfo!.currencySymbol +
                                    (model.commissionAmount / 100)
                                        .toStringAsFixed(2),
                                color: ColorConfig.textRed,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
    return container;
  }
}
