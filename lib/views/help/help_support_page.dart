/*
  帮助支持
*/
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/provider/data_index_proivder.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/services/article_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

class HelpSupportPage extends StatefulWidget {
  final Map? arguments;

  const HelpSupportPage({Key? key, this.arguments}) : super(key: key);

  @override
  HelpSupportPageState createState() => HelpSupportPageState();
}

class HelpSupportPageState extends State<HelpSupportPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  DataIndexProvider provider = DataIndexProvider();
  bool isLoading = false;

  TabController? _tabController;

  final PageController _pageController = PageController(initialPage: 0);

  final GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  _onPageChange(int index) {
    _tabController?.animateTo(index);
    provider.setIndex(index);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pageController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider<DataIndexProvider>(
        create: (_) => provider,
        child: Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              title: const Caption(
                str: '注意事项',
                color: ColorConfig.textBlack,
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: Column(
              key: _bodyKey,
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
                    labelColor: ColorConfig.warningText,
                    labelStyle: TextConfig.textBoldDark14,
                    unselectedLabelColor: ColorConfig.textDark,
                    unselectedLabelStyle: TextConfig.textDark14,
                    indicatorColor: ColorConfig.warningText,
                    tabs: const <Widget>[
                      _TabView("公告", "", 0),
                      _TabView("禁运物品", "", 1),
                      _TabView("常见问题", "", 2),
                      _TabView("如何下单", "", 3),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    key: const Key('pageView'),
                    itemCount: 4,
                    onPageChanged: _onPageChange,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) {
                      // print(index);
                      if (index == 0) {
                        return AnnouncementList(
                          params: {'selectType': index},
                        );
                      }
                      return OtherMessageList(
                        params: {'type': index},
                      );
                    },
                  ),
                ),
              ],
            )));
  }
}

// 其余三个消息列表
class OtherMessageList extends StatefulWidget {
  final Map<String, dynamic> params;

  const OtherMessageList({Key? key, required this.params}) : super(key: key);
  @override
  OtherMessageListState createState() => OtherMessageListState();
}

class OtherMessageListState extends State<OtherMessageList> {
  int pageIndex = 0;
  bool canSelect = false;
  late int? type;

  @override
  void initState() {
    super.initState();
    // life circle
    if (widget.params['type'] == 1) {
      // titleStr = '禁运物品';
      type = 2;
    } else if (widget.params['type'] == 2) {
      // titleStr = '常见问题';
      type = 1;
    } else if (widget.params['type'] == 3) {
      // titleStr = '入门教程';
      type = 3;
    }

    setState(() {
      type = type;
    });
  }

  loadList({type}) async {
    return await loadMoreList();
  }

  loadMoreList() async {
    return await ArticleService.getList({'type': type ?? ''});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConfig.bgGray,
      padding: const EdgeInsets.all(10),
      child: ListRefresh(
        renderItem: buildBottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
  }

  Widget buildBottomListCell(int index, ArticleModel model) {
    return GestureDetector(
        onTap: () async {
          Routers.push('/webview', context, {
            'url': model.content,
            'title': model.title,
            'time': model.createdAt
          });
        },
        child: widget.params['type'] == '1'
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                decoration: const BoxDecoration(
                  color: ColorConfig.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: ColorConfig.line,
                          style: BorderStyle.solid)),
                ),
                height: 60,
                width: ScreenUtil().screenWidth,
                child: Caption(
                  str: model.title,
                ))
            : Container(
                decoration: const BoxDecoration(
                  color: ColorConfig.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: ColorConfig.line,
                          style: BorderStyle.solid)),
                ),
                padding: const EdgeInsets.only(left: 5),
                // margin: EdgeInsets.only(top: 15, right: 15, left: 15),
                height: 100,
                child: Row(
                  children: <Widget>[
                    // Container(
                    //   height: 80,
                    //   width: 100,
                    //   padding: EdgeInsets.only(left: 10),
                    //   decoration: new BoxDecoration(
                    //       color: ColorConfig.white,
                    //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    //       border: Border.all(width: 1, color: ColorConfig.white)),
                    //   alignment: Alignment.center,
                    //   child: LoadImage(
                    //     model.coverFullPath,
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    Gaps.hGap10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                height: 30,
                                width: ScreenUtil().screenWidth - 120,
                                padding: const EdgeInsets.only(top: 25),
                                alignment: Alignment.topLeft,
                                child: Caption(
                                  str: model.title,
                                  fontSize: 18,
                                  color: ColorConfig.textBlack,
                                ))),
                        Expanded(
                            child: Container(
                                height: 30,
                                width: ScreenUtil().screenWidth - 120,
                                padding: const EdgeInsets.only(top: 10),
                                alignment: Alignment.topLeft,
                                child: Caption(
                                  str: model.updatedAt!,
                                  color: ColorConfig.textGrayC,
                                ))),
                      ],
                    ),
                  ],
                )));
  }
}

// 公告消息列表
class AnnouncementList extends StatefulWidget {
  final Map<String, dynamic> params;

  const AnnouncementList({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  AnnouncementListState createState() => AnnouncementListState();
}

class AnnouncementListState extends State<AnnouncementList> {
  final GlobalKey<AnnouncementListState> key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 0;
  bool canSelect = false;

  List<AnnouncementModel> msgList = [];

  @override
  void initState() {
    super.initState();
    canSelect = widget.params['select'] ?? false;
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {'page': (++pageIndex)};
    return await AnnouncementService.getList(params);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConfig.bgGray,
      padding: const EdgeInsets.all(10),
      child: ListRefresh(
        renderItem: buildBottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
      // child: ListView.builder(
      //   shrinkWrap: true,
      //   physics: const NeverScrollableScrollPhysics(),
      //   itemBuilder: buildBottomListCell,
      //   controller: _scrollController,
      //   itemCount: msgList.length,
      // ),
    );
  }

  Widget buildBottomListCell(int index, AnnouncementModel model) {
    return GestureDetector(
        onTap: () async {
          if (model.content.startsWith('/pages')) {
            isWeChatInstalled.then((installed) {
              if (installed) {
                launchWeChatMiniProgram(
                        username: 'gh_e9afa1eee63a', path: model.content)
                    .then((data) {
                  print("---》$data");
                });
              } else {
                Util.showToast("请先安装微信");
              }
            });
          } else {
            if (model.content.startsWith('/pages')) {
              isWeChatInstalled.then((installed) {
                if (installed) {
                  launchWeChatMiniProgram(
                          username: 'gh_e9afa1eee63a', path: model.content)
                      .then((data) {
                    print("---》$data");
                  });
                } else {
                  Util.showToast("请先安装微信");
                }
              });
            } else {
              Routers.push('/webview', context, {
                'url': model.content,
                'title': model.title,
                'time': model.createdAt
              });
            }
          }
        },
        child: Container(
            decoration: const BoxDecoration(
              color: ColorConfig.white,
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: ColorConfig.line,
                      style: BorderStyle.solid)),
            ),
            padding: const EdgeInsets.only(left: 15),
            // margin: EdgeInsets.only(top: 15, right: 15, left: 15),
            height: 80,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            height: 30,
                            width: ScreenUtil().screenWidth - 80,
                            padding: const EdgeInsets.only(top: 15),
                            alignment: Alignment.topLeft,
                            child: Caption(
                              str: model.title,
                              fontSize: 16,
                              color: ColorConfig.textBlack,
                            ))),
                    Expanded(
                        child: Container(
                            height: 30,
                            width: ScreenUtil().screenWidth - 80,
                            padding: const EdgeInsets.only(top: 5),
                            alignment: Alignment.topLeft,
                            child: Caption(
                              str: model.createdAt,
                              color: ColorConfig.textGrayC,
                            ))),
                  ],
                ),
              ],
            )));
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
          width: 80.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Caption(
                str: tabName,
                fontSize: 15,
              ),
              Offstage(
                offstage: provider.index != index,
                child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Caption(
                      str: tabSub,
                      fontSize: 13,
                    )),
              ),
            ],
          ),
        ));
      },
    );
  }
}
