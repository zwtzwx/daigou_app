import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:huanting_shop/common/fade_route.dart';
import 'package:huanting_shop/common/loading_util.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/shop/goods_comment_model.dart';
import 'package:huanting_shop/services/shop_service.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/loading_cell.dart';
import 'package:huanting_shop/views/components/photo_view_gallery_screen.dart';

class GoodsCommentsList extends StatefulWidget {
  const GoodsCommentsList({
    Key? key,
    required this.goodsId,
    required this.total,
    this.platform,
    this.nick,
    this.userId,
  }) : super(key: key);
  final String goodsId;
  final String total;
  final String? platform;
  final String? nick;
  final String? userId;

  @override
  State<GoodsCommentsList> createState() => _GoodsCommentsListState();
}

class _GoodsCommentsListState extends State<GoodsCommentsList> {
  final LoadingUtil<GoodsCommentModel> loadingUtil =
      LoadingUtil<GoodsCommentModel>();

  @override
  void initState() {
    super.initState();
    loadingUtil.initListener(getList);
  }

  @override
  dispose() {
    loadingUtil.controllerDestroy();
    super.dispose();
  }

  void getList() async {
    if (loadingUtil.isLoading) return;
    setState(() {
      loadingUtil.isLoading = true;
    });
    try {
      var data = await ShopService.getGoodsComments(widget.goodsId, {
        'page': ++loadingUtil.pageIndex,
        'platform': widget.platform,
        'user_id': widget.userId,
        'nick': widget.nick,
        'page_size': 10,
      });
      setState(() {
        loadingUtil.isLoading = false;
        if (data['dataList'] != null) {
          loadingUtil.list.addAll(data['dataList']);
          if (data['dataList'].isEmpty && data['pageIndex'] == 1) {
            loadingUtil.isEmpty = true;
          } else if (data['dataList'].isEmpty) {
            loadingUtil.hasMoreData = false;
          }
        }
      });
    } catch (e) {
      setState(() {
        loadingUtil.isLoading = false;
        loadingUtil.pageIndex--;
        loadingUtil.hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgGray,
      margin: EdgeInsets.only(
        top: ScreenUtil().statusBarHeight + 20.h,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      str: '商品评价'.ts + '(${widget.total})',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      size: 22.sp,
                      color: AppColors.textGrayC9,
                    ),
                  ),
                ],
              ),
            ),
            AppGaps.line,
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: loadingUtil.scrollController,
                children: [
                  ...loadingUtil.list.asMap().entries.map(
                        (item) => Container(
                          margin: EdgeInsets.only(top: item.key != 0 ? 8.h : 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 10.h),
                          color: Colors.white,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                str: item.value.displayUserNick ?? '',
                              ),
                              5.verticalSpaceFromWidth,
                              AppText(
                                str: '规格'.ts +
                                    '：' +
                                    (item.value.actionSku ?? ''),
                                fontSize: 13,
                                color: AppColors.textGrayC,
                                lines: 3,
                              ),
                              8.verticalSpaceFromWidth,
                              AppText(
                                str: item.value.rateContent ?? '',
                                color: const Color(0xff555555),
                                lines: 20,
                                fontSize: 14,
                              ),
                              (item.value.pics ?? []).isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Wrap(
                                        spacing: 10.w,
                                        runSpacing: 10.w,
                                        children: item.value.pics!
                                            .map(
                                              (pic) => GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      FadeRoute(
                                                        page:
                                                            PhotoViewGalleryScreen(
                                                          images:
                                                              item.value.pics!,
                                                          index: item
                                                              .value.pics!
                                                              .indexOf(pic),
                                                          heroTag: '',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    width: 100.w,
                                                    height: 80.w,
                                                    child: ImgItem(
                                                      pic,
                                                      fit: BoxFit.cover,
                                                      placeholderWidget:
                                                          Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: 80.w,
                                                        ),
                                                        color: AppColors.bgGray,
                                                      ),
                                                    ),
                                                  )),
                                            )
                                            .toList(),
                                      ),
                                    )
                                  : AppGaps.empty,
                            ],
                          ),
                        ),
                      ),
                  LoadingCell(
                    util: loadingUtil,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
