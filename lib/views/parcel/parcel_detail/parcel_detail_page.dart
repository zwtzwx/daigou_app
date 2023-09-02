/*
  已入库包裹详情
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/parcel_goods_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/views/parcel/parcel_detail/parcel_detail_controller.dart';

/*
  包裹详情
*/

class ParcelDetailView extends GetView<ParcelDetailController> {
  const ParcelDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '包裹详情'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: SingleChildScrollView(
        child: Obx(() => controller.isLoadingLocal.value
            ? Column(
                children: [
                  goodsInfoCell(),
                  parcelInfoCell(),
                ],
              )
            : Sized.empty),
      ),
    );
  }

  // 商品信息
  Widget goodsInfoCell() {
    return Container(
      decoration: const BoxDecoration(
        color: BaseStylesConfig.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ZHTextLine(
              fontWeight: FontWeight.bold,
              str: '商品信息'.ts,
            ),
          ),
          Sized.line,
          controller.parcelModel.value!.details == null
              ? singleGoodsCell()
              : goodsDetailsCell(),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: '物品属性'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: controller.parcelModel.value!.prop != null
                      ? controller.parcelModel.value!.prop!
                          .map((e) => e.name)
                          .join(' ')
                      : '',
                ),
              ],
            ),
          ),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: '商品备注'.ts,
                    color: BaseStylesConfig.textNormal,
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
                child: ZHTextLine(
                  str: '物品名称'.ts,
                  color: BaseStylesConfig.textNormal,
                ),
              ),
              ZHTextLine(
                str: controller.parcelModel.value?.packageName ?? '',
              ),
            ],
          ),
        ),
        Sized.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: ZHTextLine(
                  str: '物品总价'.ts,
                  color: BaseStylesConfig.textNormal,
                ),
              ),
              ZHTextLine(
                  str: controller.parcelModel.value!.packageValue!
                      .rate(showPriceSymbol: false, showInt: true))
            ],
          ),
        ),
        Sized.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: ZHTextLine(
                  str: '物品数量'.ts,
                  color: BaseStylesConfig.textNormal,
                ),
              ),
              ZHTextLine(
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
                  child: ZHTextLine(
                    str: '物品名称'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: ZHTextLine(
                    str: '物品价值'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: ZHTextLine(
                    str: '数量'.ts,
                    color: BaseStylesConfig.textNormal,
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
        border: Border(top: BorderSide(color: BaseStylesConfig.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ZHTextLine(
              str: model.name ?? '',
              lines: 3,
            ),
            flex: 2,
          ),
          Expanded(
            child: ZHTextLine(
              str: model.price.toString(),
            ),
          ),
          Expanded(
            child: ZHTextLine(
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
            child: ZHTextLine(
              fontWeight: FontWeight.bold,
              str: '包裹信息'.ts,
            ),
          ),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: '快递名称'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: controller.parcelModel.value?.expressName ?? '',
                ),
              ],
            ),
          ),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: '快递单号'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                ),
                Row(
                  children: [
                    ZHTextLine(
                      str: controller.parcelModel.value?.expressNum ?? '',
                    ),
                    Sized.hGap15,
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                              text: controller.parcelModel.value!.expressNum),
                        ).then((value) {
                          EasyLoading.showSuccess('复制成功'.ts);
                        });
                      },
                      child: ZHTextLine(
                        str: '复制'.ts,
                        color: BaseStylesConfig.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: ZHTextLine(
                    str: '发往国家'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: controller.parcelModel.value?.country != null
                      ? controller.parcelModel.value!.country!.name!
                      : '',
                ),
              ],
            ),
          ),
          Sized.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: ZHTextLine(
                    str: '转运仓库'.ts,
                    color: BaseStylesConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: controller.parcelModel.value?.warehouse != null
                      ? controller.parcelModel.value!.warehouse!.warehouseName!
                      : '',
                ),
              ],
            ),
          ),
          Sized.line,
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
                ZHTextLine(
                  str: '物品照片'.ts,
                  color: BaseStylesConfig.textNormal,
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
          color: BaseStylesConfig.white,
          alignment: Alignment.topCenter,
          child: LoadImage(
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
