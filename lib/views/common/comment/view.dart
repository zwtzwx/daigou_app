import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/comment_model.dart';
import 'package:jiyun_app_client/views/common/comment/controller.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';

class CommentPage extends GetView<CommentController> {
  const CommentPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '用户评价'.ts,
          color: AppColors.textBlack,
          fontSize: 17,
        ),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    var listView = Container(
      color: AppColors.bgGray,
      child: RefreshView(
        renderItem: buildBottomListCell,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
    return listView;
  }

  Widget buildBottomListCell(int index, CommentModel model) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: ImgItem(
                    model.user!.avatar,
                    height: 40.w,
                    width: 40.w,
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: AppText(
                              str: model.user!.name,
                            ),
                          ),
                          10.horizontalSpace,
                          AppText(
                            str: model.createdAt.split(' ').first,
                            fontSize: 14,
                            color: AppColors.textGrayC,
                          ),
                        ],
                      ),
                      5.verticalSpaceFromWidth,
                      Row(children: startsSourceList(model)),
                    ],
                  ),
                ),
              ],
            ),
            15.verticalSpaceFromWidth,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AppText(
                lines: 99,
                str: model.content,
                fontSize: 16,
              ),
            ),
            10.verticalSpaceFromWidth,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: buildMoreSupportType(index, model),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: AppColors.textGray,
                      size: 15.sp,
                    ),
                    5.horizontalSpace,
                    AppText(
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
            height: 16.w,
            width: 16.w,
            margin: EdgeInsets.only(right: 5.w),
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
            color: AppColors.white,
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
          color: AppColors.white,
          child: ImgItem(
            model.images[index],
            fit: BoxFit.fitWidth,
            format: "png",
          ),
        ),
      );
    };
  }
}
