import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/order/comment/controller.dart';

class OrderCommentView extends GetView<OrderCommentController> {
  const OrderCommentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: AppText(
          str: '我要评价'.ts,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            contentCell(),
            submitCell(),
            20.verticalSpaceFromWidth,
          ],
        ),
      ),
    );
  }

  Widget contentCell() {
    var headerView = Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: Colors.white),
      ),
      margin: EdgeInsets.only(top: 12.h, right: 12.w, left: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h, left: 12.w),
            child: AppText(
              str: '订单号'.ts + '：' + controller.model.orderSn,
              fontSize: 14,
            ),
          ),
          5.verticalSpace,
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 12.w),
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '综合评分'.ts,
                  fontSize: 14,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                child: Obx(
                  () => Row(
                    children:
                        startsSourceList(controller.comprehensiveStar.value, 1),
                  ),
                ),
              ),
            ],
          ),
          5.verticalSpaceFromWidth,
          AppGaps.line,
          5.verticalSpaceFromWidth,
          Container(
            height: 150,
            alignment: Alignment.centerLeft,
            padding:
                EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h, bottom: 4.h),
            child: TextField(
              controller: controller.contentController,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: '请描述你对本次集运的体验'.ts,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textGrayC9,
                ),
              ),
            ),
          ),
          AppGaps.line,
          15.verticalSpaceFromWidth,
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 10.h),
            child: AppText(
              str: '添加图片'.ts,
              fontSize: 14,
            ),
          ),
          Obx(() => uploadImage()),
          15.verticalSpaceFromWidth,
        ],
      ),
    );
    return headerView;
  }

  Widget uploadImage() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.w,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.selectImg.length + 1,
            itemBuilder: _buildGrideBtnView()));
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      if (index == controller.selectImg.length) {
        return GestureDetector(
          onTap: () {
            controller.onImgUpload();
          },
          child: Container(
            alignment: Alignment.center,
            color: AppColors.bgGray,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 35.sp,
                  color: AppColors.textGray,
                ),
              ],
            ),
          ),
        );
      }
      return imageItem(context, controller.selectImg[index], index);
    };
  }

  Widget imageItem(context, String url, int index) {
    return Stack(
      children: <Widget>[
        Container(
          color: AppColors.bgGray,
          child: ImgItem(
            url,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              controller.selectImg.remove(url);
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.textGrayC,
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: const Icon(
                Icons.close,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  startsSourceList(int selectStar, int type) {
    List<Widget> startList = [];
    for (var i = 0; i < 5; i++) {
      var view = GestureDetector(
        onTap: () {
          controller.comprehensiveStar.value = i + 1;
        },
        child: Container(
            alignment: Alignment.centerLeft,
            height: 25,
            width: 25,
            padding: const EdgeInsets.all(4),
            child: selectStar > i
                ? Image.asset(
                    'assets/images/Center/star.png',
                  )
                : Image.asset(
                    'assets/images/Center/star-uns.png',
                  )),
      );
      startList.add(view);
    }
    return startList;
  }

  Widget submitCell() {
    return Container(
      margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
      child: Column(
        children: <Widget>[
          controller.tips.value.isNotEmpty
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  padding: EdgeInsets.all(15.w),
                  child: AppText(
                    str: controller.tips.value,
                    fontSize: 12,
                  ),
                )
              : AppGaps.empty,
          Container(
            height: 38.h,
            margin: const EdgeInsets.only(top: 40),
            width: double.infinity,
            child: BeeButton(
              text: '提交评价',
              fontWeight: FontWeight.bold,
              onPressed: controller.onSumbit,
            ),
          ),
        ],
      ),
    );
  }
}
