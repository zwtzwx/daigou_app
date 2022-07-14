/*
  帮助支持
*/
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class HelpSupportPage extends StatefulWidget {
  final Map? arguments;

  const HelpSupportPage({Key? key, this.arguments}) : super(key: key);

  @override
  HelpSupportPageState createState() => HelpSupportPageState();
}

class HelpSupportPageState extends State<HelpSupportPage>
    with AutomaticKeepAliveClientMixin {
  String? banner;
  String? receiver;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    var data = await CommonService.getAllBannersInfo();
    var warehouse = await WarehouseService.getDefaultWarehouse();
    setState(() {
      banner = data?.supportImage;
      receiver = warehouse?.receiverName;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: ColorConfig.bgGray,
      body: SafeArea(
        child: Column(
          children: [
            bannerBox(),
            helpListView(),
            const Expanded(
              child: AnnouncementList(),
            ),
          ],
        ),
      ),
    );
  }

  // banner
  Widget bannerBox() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            height: ScreenUtil().setHeight(200),
            alignment: Alignment.topCenter,
            child: LoadImage(
              banner ?? '',
              fit: BoxFit.fitWidth,
              width: ScreenUtil().screenWidth,
            ),
          ),
        ),
        Positioned(
          top: ScreenUtil().statusBarHeight,
          left: 15,
          child: const BackButton(
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: ScreenUtil().setHeight(180),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const LoadImage(
                    'Help/home-user',
                    width: 33,
                    height: 33,
                  ),
                  Gaps.hGap10,
                  Caption(
                    str: Translation.t(context, '专属收货员') + '：${receiver ?? ''}',
                  )
                ],
              ),
              Flexible(
                child: MainButton(
                  text: Translation.t(context, '在线客服'),
                  onPressed: () async {
                    BaseDialog.customerDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget helpListView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHelpItem(
            'Help/how',
            Translation.t(context, '如何下单'),
            3,
          ),
          buildHelpItem(
            'Help/forbid',
            Translation.t(context, '禁运物品'),
            2,
          ),
          buildHelpItem(
            'Help/question',
            Translation.t(context, '常见问题'),
            1,
          ),
          buildHelpItem(
            'Help/suggest',
            Translation.t(context, '投诉建议'),
            0,
          ),
        ],
      ),
    );
  }

  Widget buildHelpItem(String img, String label, int type) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          if (type > 0) {
            Routers.push('/QuestionPage', context, {'type': type});
          } else {
            Routers.push('/SuggestPage', context);
          }
        },
        child: Column(
          children: [
            LoadImage(
              img,
              width: 46,
              height: 46,
            ),
            Gaps.vGap5,
            Caption(
              str: label,
              fontSize: 14,
              lines: 2,
              alignment: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 公告消息列表
class AnnouncementList extends StatefulWidget {
  const AnnouncementList({
    Key? key,
  }) : super(key: key);

  @override
  AnnouncementListState createState() => AnnouncementListState();
}

class AnnouncementListState extends State<AnnouncementList> {
  final GlobalKey<AnnouncementListState> key = GlobalKey();
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
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
    return ListRefresh(
      shrinkWrap: true,
      // physics: true,
      renderItem: buildBottomListCell,
      refresh: loadList,
      more: loadMoreList,
    );
  }

  Widget buildBottomListCell(int index, AnnouncementModel model) {
    return GestureDetector(
        onTap: () async {
          if (model.content.startsWith('/pages')) {
            isWeChatInstalled.then((installed) {
              if (installed) {
                launchWeChatMiniProgram(
                        username: 'gh_4c98b7c6b461', path: model.content)
                    .then((data) {});
              } else {
                Util.showToast(Translation.t(context, '请先安装微信'));
              }
            });
          } else {
            if (model.content.startsWith('/pages')) {
              isWeChatInstalled.then((installed) {
                if (installed) {
                  launchWeChatMiniProgram(
                          username: 'gh_e9afa1eee63a', path: model.content)
                      .then((data) {});
                } else {
                  Util.showToast(Translation.t(context, '请先安装微信'));
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
