/*
  评论列表
*/
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:jiyun_app_client/models/comment_model.dart';
import 'package:jiyun_app_client/services/comment_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentListPage extends StatefulWidget {
  const CommentListPage({Key? key}) : super(key: key);

  @override
  CommentListPageState createState() => CommentListPageState();
}

class CommentListPageState extends State<CommentListPage> {
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
    Map dic = await CommentService.getList({
      'page': (++pageIndex),
      'size': '10',
    });
    return dic;
  }

  @override
  void dispose() {
    super.dispose();
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
          str: Translation.t(context, '用户评价'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    var listView = Container(
      color: ColorConfig.bgGray,
      child: ListRefresh(
        renderItem: buildBottomListCell,
        refresh: loadList,
        more: loadMoreList,
      ),
    );
    return listView;
  }

  Widget buildBottomListCell(int index, CommentModel model) {
    double height = calculateTextHeight(model.content, 17.0, FontWeight.w400,
        ScreenUtil().screenWidth - 60, 99);
    double imgHeight =
        model.images.isEmpty ? 0 : (ScreenUtil().screenWidth - 60) / 4;
    return Container(
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(width: 1, color: Colors.white),
        ),
        padding: const EdgeInsets.only(left: 5, right: 5),
        margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
        height: 110 + height + imgHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 0, left: 15),
                      decoration: const BoxDecoration(
                        color: ColorConfig.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: LoadImage(
                          model.user!.avatar,
                          fit: BoxFit.fitWidth,
                          holderImg: "PackageAndOrder/defalutIMG@3x",
                          format: "png",
                        ),
                      )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      height: 20,
                                      margin: const EdgeInsets.only(
                                          top: 10, left: 15),
                                      alignment: Alignment.centerLeft,
                                      child: Caption(
                                        str: model.user!.name,
                                        fontSize: 16,
                                        color: ColorConfig.textBlack,
                                      )),
                                  // Container(
                                  //     height: 15,
                                  //     width: 20,
                                  //     margin: EdgeInsets.only(
                                  //         top: 15, right: 5, left: 5),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(3)),
                                  //       color: ColorConfig.vipBG,
                                  //     ),
                                  //     alignment: Alignment.center,
                                  //     child: Caption(
                                  //       str: 'V6',
                                  //       fontSize: 10,
                                  //       color: ColorConfig.white,
                                  //     )),
                                ],
                              ),
                              Container(
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 10),
                                  alignment: Alignment.bottomRight,
                                  child: Caption(
                                    str: model.createdAt.split(' ').first,
                                    fontSize: 14,
                                    color: ColorConfig.textGrayC,
                                  )),
                            ],
                          ),
                          Container(
                              height: 30,
                              width: ScreenUtil().screenWidth / 2 - 60,
                              margin: const EdgeInsets.only(top: 5, left: 15),
                              alignment: Alignment.topLeft,
                              child: Row(children: startsSourceList(model))),
                        ]),
                  ))
                ],
              ),
            ),
            Row(children: <Widget>[
              Container(
                  height: height,
                  padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  width: ScreenUtil().screenWidth - 42,
                  alignment: Alignment.topLeft,
                  child: Caption(
                    lines: 99,
                    str: model.content,
                    fontSize: 17,
                    color: ColorConfig.textBlack,
                  )),
            ]),
            Container(
              margin: const EdgeInsets.only(top: 0, left: 15, right: 15),
              width: ScreenUtil().screenWidth - 60,
              height: imgHeight,
              child: buildMoreSupportType(index, model),
            ),
            Container(
                padding: const EdgeInsets.only(left: 15, top: 4),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: ColorConfig.textGray,
                      size: 15,
                    ),
                    Caption(
                      fontSize: 13,
                      str: model.order!.address.countryName,
                    )
                  ],
                )
                // IconText(model.order.address.countryName,
                //     icon: ),
                )
          ],
        ));
  }

  startsSourceList(CommentModel model) {
    int selectStar = model.score;
    List<Widget> startList = [];
    for (var i = 0; i < 5; i++) {
      var view = GestureDetector(
        onTap: () {},
        child: Container(
            alignment: Alignment.centerLeft,
            height: 25,
            width: 25,
            padding: const EdgeInsets.all(4),
            child: selectStar > i
                ? Image.asset(
                    'assets/images/AboutMe/好评Sel@3x.png',
                  )
                : Image.asset(
                    'assets/images/AboutMe/好评Dis@3x.png',
                  )),
      );
      startList.add(view);
    }
    return startList;
  }

  static double calculateTextHeight(String value, fontSize,
      FontWeight fontWeight, double maxWidth, int maxLines) {
    value = value;
    TextPainter painter = TextPainter(

        ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
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

  // 评论图片
  Widget buildMoreSupportType(int index, CommentModel model) {
    return model.images.isNotEmpty
        ? Container(
            color: ColorConfig.white,
            padding: const EdgeInsets.only(top: 0),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5.0, //水平子Widget之间间距
                  mainAxisSpacing: 5.0, //垂直子Widget之间间距
                  crossAxisCount: 4, //一行的Widget数量
                  childAspectRatio: 1,
                ), // 宽高比例
                itemCount: model.images.length,
                itemBuilder: _buildGrideBtnView(index, model)),
          )
        : Container();
  }

  IndexedWidgetBuilder _buildGrideBtnView(int superIndex, CommentModel model) {
    return (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: model.images, //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
          // NinePictureAllScreenShow(model.images, index);
        },
        child: Container(
          color: ColorConfig.white,
          child: LoadImage(
            model.images[index],
            fit: BoxFit.fitWidth,
            format: "png",
          ),
        ),
      );
    };
  }
}

class TrackingBanner extends StatefulWidget {
  const TrackingBanner({Key? key}) : super(key: key);

  @override
  _TrackingBannerState createState() => _TrackingBannerState();
}

class _TrackingBannerState extends State<TrackingBanner>
    with AutomaticKeepAliveClientMixin {
  String banner = '';

  @override
  void initState() {
    super.initState();
    banner = '';
    getBanner();
  }

  @override
  bool get wantKeepAlive => true;

  // 获取顶部 banner 图
  void getBanner() async {
    BannersModel? result = await CommonService.getAllBannersInfo();
    setState(() {
      banner = result!.trackImage ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadImage(
      banner,
      fit: BoxFit.contain,
    );
  }
}
