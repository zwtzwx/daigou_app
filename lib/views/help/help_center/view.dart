import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/help/help_center/controller.dart';

class BeeSupportView extends GetView<BeeSupportLogic> {
  const BeeSupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
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
            child: Obx(
              () => ImgItem(
                controller.banner.value ?? '',
                fit: BoxFit.fitWidth,
                width: ScreenUtil().screenWidth,
              ),
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
            '如何下单'.ts,
            3,
          ),
          buildHelpItem(
            'Help/forbid',
            '禁运物品'.ts,
            2,
          ),
          buildHelpItem(
            'Help/question',
            '常见问题'.ts,
            1,
          ),
          // buildHelpItem(
          //   'Help/suggest',
          //   '投诉建议'.ts,
          //   0,
          // ),
        ],
      ),
    );
  }

  Widget buildHelpItem(String img, String label, int type) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          if (type > 0) {
            BeeNav.push(BeeNav.question, {'type': type});
          } else {
            BeeNav.push('/SuggestPage');
          }
        },
        child: Column(
          children: [
            ImgItem(
              img,
              width: 46,
              height: 46,
            ),
            AppGaps.vGap5,
            AppText(
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
    return RefreshView(
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
          BeeNav.push(BeeNav.webview, {
            'url': model.content,
            'title': model.title,
            'time': model.createdAt
          });
        },
        child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: AppColors.line,
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
                            child: AppText(
                              str: model.title,
                              fontSize: 16,
                              color: AppColors.textBlack,
                            ))),
                    Expanded(
                        child: Container(
                            height: 30,
                            width: ScreenUtil().screenWidth - 80,
                            padding: const EdgeInsets.only(top: 5),
                            alignment: Alignment.topLeft,
                            child: AppText(
                              str: model.createdAt,
                              color: AppColors.textGrayC,
                            ))),
                  ],
                ),
              ],
            )));
  }
}
