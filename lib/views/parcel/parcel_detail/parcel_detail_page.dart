/*
  已入库包裹详情
*/

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/common/fade_route.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/parcel_goods_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/views/parcel/parcel_detail/parcel_detail_controller.dart';

/*
  包裹详情
*/

class BeePackageDetailPage extends GetView<BeePackageDetailLogic> {
  const BeePackageDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: AppText(
          str: '包裹详情'.inte,
          color: AppStyles.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: Obx(() => controller.isLoadingLocal.value
            ? Column(
                children: [
                  goodsInfoCell(),
                  parcelInfoCell(),
                ],
              )
            : AppGaps.empty),
      ),
    );
  }

  // 商品信息
  Widget goodsInfoCell() {
    return Container(
      decoration: const BoxDecoration(
        color: AppStyles.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AppText(
              fontWeight: FontWeight.bold,
              str: '商品信息'.inte,
            ),
          ),
          AppGaps.line,
          controller.parcelModel.value!.details == null
              ? singleGoodsCell()
              : goodsDetailsCell(),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '物品属性'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                AppText(
                  str: controller.parcelModel.value!.prop != null
                      ? controller.parcelModel.value!.prop!
                          .map((e) => e.name)
                          .join(' ')
                      : '',
                ),
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '商品备注'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      controller.parcelModel.value?.remark ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 没有商品详细清单
  Widget singleGoodsCell() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '物品名称'.inte,
                  color: AppStyles.textNormal,
                ),
              ),
              AppText(
                str: controller.parcelModel.value?.packageName ?? '',
              ),
            ],
          ),
        ),
        AppGaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '物品总价'.inte,
                  color: AppStyles.textNormal,
                ),
              ),
              AppText(
                  str: controller.parcelModel.value!.packageValue!
                      .priceConvert(showPriceSymbol: false, showInt: true))
            ],
          ),
        ),
        AppGaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: AppText(
                  str: '物品数量'.inte,
                  color: AppStyles.textNormal,
                ),
              ),
              AppText(
                str: controller.parcelModel.value!.qty.toString(),
              )
            ],
          ),
        ),
      ],
    );
  }

  // 商品详细清单
  Widget goodsDetailsCell() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    str: '物品名称'.inte,
                    color: AppStyles.textNormal,
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: AppText(
                    str: '物品价值'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Expanded(
                  child: AppText(
                    str: '数量'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            itemCount: controller.parcelModel.value!.details!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return buildGoodsCell(controller.parcelModel.value!.details![i]);
            },
          ),
        ],
      ),
    );
  }

  // 包裹内物品
  Widget buildGoodsCell(ParcelGoodsModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppStyles.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              str: model.name ?? '',
              lines: 3,
            ),
            flex: 2,
          ),
          Expanded(
            child: AppText(
              str: model.price.toString(),
            ),
          ),
          Expanded(
            child: AppText(
              str: model.qty.toString(),
            ),
          ),
        ],
      ),
    );
  }

  // 包裹信息
  Widget parcelInfoCell() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AppText(
              fontWeight: FontWeight.bold,
              str: '包裹信息'.inte,
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '快递名称'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                AppText(
                  str: controller.parcelModel.value?.expressName ?? '',
                ),
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str: '快递单号'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                Row(
                  children: [
                    AppText(
                      str: controller.parcelModel.value?.expressNum ?? '',
                    ),
                    AppGaps.hGap15,
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                              text: controller.parcelModel.value!.expressNum ??
                                  ''),
                        ).then((value) {
                          EasyLoading.showSuccess('复制成功'.inte);
                        });
                      },
                      child: Icon(
                        Icons.copy,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: AppText(
                    str: '发往国家'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                AppText(
                  str: controller.parcelModel.value?.country != null
                      ? controller.parcelModel.value!.country!.name!
                      : '',
                ),
              ],
            ),
          ),
          AppGaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: AppText(
                    str: '转运仓库'.inte,
                    color: AppStyles.textNormal,
                  ),
                ),
                AppText(
                  str: controller.parcelModel.value?.warehouse != null
                      ? controller.parcelModel.value!.warehouse!.warehouseName!
                      : '',
                ),
              ],
            ),
          ),
          AppGaps.line,
          Container(
            constraints: BoxConstraints(
              maxHeight: (controller.parcelModel.value?.packagePictures !=
                          null &&
                      controller.parcelModel.value!.packagePictures!.isNotEmpty)
                  ? double.infinity
                  : 40,
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  str: '物品照片'.inte,
                  color: AppStyles.textNormal,
                ),
                controller.parcelModel.value?.packagePictures != null
                    ? Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5.0, //水平子Widget之间间距
                                mainAxisSpacing: 5.0, //垂直子Widget之间间距
                                crossAxisCount: 3, //一行的Widget数量
                              ), // 宽高比例
                              itemCount: controller
                                  .parcelModel.value!.packagePictures!.length,
                              itemBuilder: _buildGrideBtnView(controller
                                  .parcelModel.value!.packagePictures!)),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView(List<String> imgList) {
    return (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: imgList, //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
        },
        child: Container(
          color: AppStyles.white,
          alignment: Alignment.topCenter,
          child: ImgItem(
            imgList[index],
            fit: BoxFit.contain,
            width: 120,
            height: 60,
          ),
        ),
      );
    };
  }
}
