import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/common/fade_route.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:shop_app_client/views/shop/manual_order/controller.dart';

class ManualOrderView extends GetView<ManualOrderController> {
  const ManualOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '代购代买'.inte,
          fontSize: 17,
        ),
        backgroundColor: AppStyles.bgGray,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GlobalPages.pop();
          },
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              10.verticalSpaceFromWidth,
              _product(context),
              10.verticalSpaceFromWidth,
              _freight(context),
              15.verticalSpaceFromWidth,
              SizedBox(
                width: double.infinity,
                height: 35.h,
                child: BeeButton(
                  text: '提交',
                  onPressed: controller.onConfirm,
                ),
              ),
              40.verticalSpaceFromWidth,
            ],
          ),
        ),
      ),
    );
  }

  Widget _freight(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _textEdit(
            isRow:true,
            title: '寄往仓库',
            child: GestureDetector(
              onTap: () {
                controller.onShowWarehousePicker(context);
              },
              child: Container(
                // margin: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                      Obx(
                        () => AppText(
                          str: controller.warehouse.value?.warehouseName ??
                              '请选择仓库'.inte,
                          color: controller.warehouse.value == null
                              ? AppStyles.textGray
                              : AppStyles.textDark,
                          fontSize: 14,
                        ),
                      ),
                    15.horizontalSpace,
                    LoadAssetImage(
                      'Home/expand',
                      width: 16.w,
                      height: 16.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _textEdit(
            isRow:true,
            title: '商品单价',
            child: BaseInput(
              controller: controller.priceController,
              focusNode: controller.priceNode,
              autoShowRemove: false,
              hintText: '请输入商品单价'.inte,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '商品数量',
            isRow: true,
            child: SizedBox(
              height: 20.h,
              width: 100.w,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        border: new Border.all(color: Color(0xFFEEEEEE), width: 0.5),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.onQty(-1);
                        },
                        child: ClipOval(
                          child: Container(
                            height: 20.h,
                            width: 20.h,
                            color: AppStyles.white,
                            child: Icon(
                              Icons.remove,
                              size: 12.sp,
                              color: controller.reduce.value=='1'?Color(0xffBABABA):Color(0xff333333),
                            ),
                          ),
                        ),
                      ),
                    ),),
                    Container(
                      decoration: BoxDecoration(
                        border: new Border(left: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 0.5)),
                      ),
                      width: 80,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: BaseInput(
                        isCollapsed: true,
                        autoShowRemove: false,
                        textAlign: TextAlign.center,
                        controller: controller.qtyController,
                        focusNode: controller.qtyNode,
                        style: const TextStyle(fontSize: 12),
                        contentPadding: const EdgeInsets.only(top: 0),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: new Border.all(color: Color(0xFFEEEEEE), width: 0.5),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.onQty(1);
                        },
                        child: ClipOval(
                          child: Container(
                            height: 20.h,
                            width: 20.h,
                            color: AppStyles.white,
                            child: Icon(
                              Icons.add,
                              size: 12.sp,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _textEdit(
            isRow:true,
            title: '国内运费',
            child: BaseInput(
              controller: controller.feeController,
              focusNode: controller.feeNode,
              autoShowRemove: false,
              hintText: '请输入国内运费'.inte,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          10.verticalSpaceFromWidth,
        ],
      ),
    );
  }

  Widget _product(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textEdit(
            isRow: true,
            title: '商品链接',
            child: BaseInput(
              controller: controller.linkController,
              focusNode: controller.linkNode,
              maxLength: 200,
              hintText: '请粘贴想购买的商品链接'.inte,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            isRow: true,
            title: '商品名称',
            child: BaseInput(
              controller: controller.nameController,
              focusNode: controller.nameNode,
              maxLength: 100,
              hintText: '请填写商品名称'.inte,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '平台',
            isRow: true,
            child: BaseInput(
              controller: controller.platformController,
              focusNode: controller.platformNode,
              maxLength: 100,
              hintText: '请填写平台'.inte,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            isRow: true,
            title: '商品图片',
            isRequired: true,
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Obx(
                    () => Wrap(
                  spacing: 10.w,
                  runSpacing: 10.w,
                  children: [
                    ...controller.imgs.asMap().keys.map(
                          (index) => Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                FadeRoute(
                                  page: PhotoViewGalleryScreen(
                                    images: controller.imgs,
                                    index: index,
                                    heroTag: '',
                                  ),
                                ),
                              );
                              // NinePictureAllScreenShow(model.images, index);
                            },
                            child: Container(
                              width: 60.w,
                              height: 60.w,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: const Color(0xFFE1E1E1),
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: ImgItem(
                                controller.imgs[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5.w,
                            top: 5.w,
                            child: GestureDetector(
                              onTap: () {
                                controller.imgs.removeAt(index);
                              },
                              child: Icon(
                                Icons.cancel_sharp,
                                color: AppStyles.textRed,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.onImgUpload(context);
                      },
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFFE1E1E1),
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: const Color(0xFFE1E1E1),
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _textEdit(
            isRow: true,
            title: '商品规格',
            isRequired: false,
            child: BaseInput(
              controller: controller.specController,
              focusNode: controller.specNode,
              maxLength: 100,
              autoShowRemove: false,
              hintText: '例如颜色：紫色 尺码：XXL'.inte,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            isRow: true,
            title: '商品备注',
            isRequired: false,
            child: BaseInput(
              controller: controller.remarkController,
              focusNode: controller.remarkNode,
              maxLength: 300,
              maxLines: 5,
              hintText: '请填写'.inte,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          10.verticalSpaceFromWidth,
        ],
      ),
    );
  }

  Widget _textEdit({
    required String title,
    required Widget child,
    bool isRequired = true,
    bool isRow = false,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: isRow
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: title.inte,
                      ),
                      TextSpan(
                        text: isRequired ? '*' : '',
                        style: const TextStyle(
                          color: AppStyles.textBlack,
                        ),
                      ),
                    ],
                  ),
                ),),
                Expanded(
                    flex: 2,
                    child: child)
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                    children: [
                      TextSpan(
                        text: isRequired ? '*' : '',
                        style: const TextStyle(
                          color: AppStyles.textRed,
                        ),
                      ),
                      TextSpan(
                        text: title.inte,
                      ),
                    ],
                  ),
                ),
                child,
              ],
            ),
    );
  }
}
