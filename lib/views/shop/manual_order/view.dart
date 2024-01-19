import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/common/fade_route.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/components/photo_view_gallery_screen.dart';
import 'package:huanting_shop/views/shop/manual_order/controller.dart';

class ManualOrderView extends GetView<ManualOrderController> {
  const ManualOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '代购代买'.ts,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: AppColors.bgGray,
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
            title: '寄往仓库',
            child: GestureDetector(
              onTap: () {
                controller.onShowWarehousePicker(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => AppText(
                          str: controller.warehouse.value?.warehouseName ??
                              '请选择仓库'.ts,
                          color: controller.warehouse.value == null
                              ? AppColors.textGray
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
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
            title: '商品链接',
            child: BaseInput(
              controller: controller.linkController,
              focusNode: controller.linkNode,
              maxLength: 200,
              hintText: '请粘贴想购买的商品链接'.ts,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '商品平台',
            child: BaseInput(
              controller: controller.platformController,
              focusNode: controller.platformNode,
              maxLength: 100,
              hintText: '请填写平台'.ts,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '商品名称',
            child: BaseInput(
              controller: controller.nameController,
              focusNode: controller.nameNode,
              maxLength: 100,
              hintText: '请填写商品名称'.ts,
              autoShowRemove: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '商品规格',
            isRequired: false,
            child: BaseInput(
              controller: controller.specController,
              focusNode: controller.specNode,
              maxLength: 100,
              autoShowRemove: false,
              hintText: '例如颜色：紫色 尺码：XXL'.ts,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '商品数量',
            isRow: true,
            child: SizedBox(
              height: 20.h,
              width: 100.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.onQty(-1);
                    },
                    child: ClipOval(
                      child: Container(
                        height: 20.h,
                        width: 20.h,
                        color: AppColors.primary,
                        child: Icon(
                          Icons.remove,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: BaseInput(
                        isCollapsed: true,
                        autoShowRemove: false,
                        textAlign: TextAlign.center,
                        controller: controller.qtyController,
                        focusNode: controller.qtyNode,
                        style: const TextStyle(fontSize: 18),
                        contentPadding: const EdgeInsets.only(top: 0),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.onQty(1);
                    },
                    child: ClipOval(
                      child: Container(
                        height: 20.h,
                        width: 20.h,
                        color: AppColors.primary,
                        child: Icon(
                          Icons.add,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _textEdit(
            title: '商品单价',
            child: BaseInput(
              controller: controller.priceController,
              focusNode: controller.priceNode,
              autoShowRemove: false,
              hintText: '请输入商品单价'.ts,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          _textEdit(
            title: '上传图片',
            isRequired: false,
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
                                  width: 75.w,
                                  height: 75.w,
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
                                    color: AppColors.textRed,
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
                        width: 75.w,
                        height: 75.w,
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
            title: '商品备注',
            isRequired: false,
            child: BaseInput(
              controller: controller.remarkController,
              focusNode: controller.remarkNode,
              maxLength: 300,
              maxLines: 5,
              hintText: '请填写'.ts,
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
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                    children: [
                      TextSpan(
                        text: isRequired ? '*' : '',
                        style: const TextStyle(
                          color: AppColors.textRed,
                        ),
                      ),
                      TextSpan(
                        text: title.ts,
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,
                Flexible(child: child),
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
                          color: AppColors.textRed,
                        ),
                      ),
                      TextSpan(
                        text: title.ts,
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
