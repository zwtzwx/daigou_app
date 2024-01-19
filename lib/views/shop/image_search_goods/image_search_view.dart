import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/views/shop/image_search_goods/image_search_logic.dart';

class GoodsImageSearchPage extends GetView<GoodsImageSearchLogic> {
  const GoodsImageSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(
            () => controller.cameraCtl.value != null &&
                    controller.cameraCtl.value!.value.isInitialized
                ? Column(
                    children: [
                      SizedBox(
                        height: 1.sh,
                        width: 1.sw,
                        child: CameraPreview(
                          controller.cameraCtl.value!,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    15.w,
                                    ScreenUtil().statusBarHeight + 10.w,
                                    15.w,
                                    0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const BackButton(
                                      color: Colors.white,
                                    ),
                                    GestureDetector(
                                      onTap: controller.onPickerImage,
                                      child: Icon(
                                        Icons.photo_library_outlined,
                                        color: Colors.white,
                                        size: 25.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkResponse(
                                onTap: controller.onTakePhoto,
                                child: Container(
                                  width: 55.w,
                                  height: 55.w,
                                  margin: EdgeInsets.only(bottom: 100.h),
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.w,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : AppGaps.empty,
          ),
        ],
      ),
    );
  }
}
