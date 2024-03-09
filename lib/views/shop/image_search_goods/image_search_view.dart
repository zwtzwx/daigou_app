import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/views/shop/image_search_goods/image_search_logic.dart';

class GoodsImageSearchPage extends GetView<GoodsImageSearchLogic> {
  const GoodsImageSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => Column(
          children: [
            if (controller.cameraCtl.value != null &&
                controller.cameraCtl.value!.value.isInitialized) ...[
              CameraPreview(
                controller.cameraCtl.value!,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(
                      15.w, ScreenUtil().statusBarHeight + 10.w, 15.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButton(
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: controller.onPickerImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 25.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: InkResponse(
                    onTap: controller.onTakePhoto,
                    child: Container(
                      width: 55.w,
                      height: 55.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.all(3.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppStyles.primary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
