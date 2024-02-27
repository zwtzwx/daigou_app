import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_binding.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_list_view.dart';

class SearchCell extends StatefulWidget {
  const SearchCell({
    Key? key,
    this.hintText = '请输入商品名称',
    this.onSearch,
    this.needCheck = true,
    this.initData,
    this.goPlatformGoods = false,
    this.showScan = false,
    this.cleanContentWhenSearch = false,
  }) : super(key: key);
  final String hintText;
  final bool needCheck;
  final Function(String value)? onSearch;
  final String? initData;
  final bool goPlatformGoods;
  final bool showScan;
  final bool cleanContentWhenSearch;

  @override
  State<SearchCell> createState() => _SearchCellState();
}

class _SearchCellState extends State<SearchCell> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  initState() {
    super.initState();
    if (widget.initData != null) {
      controller.text = widget.initData!;
    }
  }

  void onConfirm(BuildContext context, String value) {
    if (value.trim().isEmpty && widget.needCheck) {
      EasyLoading.showToast('请输入搜索内容'.ts);
      return;
    }
    focusNode.unfocus();
    if (widget.onSearch != null) {
      widget.onSearch!(value);
    } else if (widget.goPlatformGoods) {
      Get.to(PlatformGoodsListView(controllerTag: value),
          arguments: {'keyword': value, 'origin': value},
          binding: PlatformGoodsBinding(tag: value));
    }
    if (widget.cleanContentWhenSearch) {
      controller.text = '';
    }
  }

  void onPhotoSearch() async {
    var cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      BeeNav.push(BeeNav.imageSearch, arg: {'device': cameras.first});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.bgGray,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => BaseInput(
                board: true,
                controller: controller,
                focusNode: focusNode,
                isCollapsed: true,
                isSearchInput: true,
                maxLength: 50,
                textInputAction: TextInputAction.search,
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: AppColors.textGrayC9),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                hintText: widget.hintText.ts,
                onSubmitted: (value) {
                  onConfirm(context, value);
                },
              ),
            ),
          ),
          if (widget.showScan) ...[
            10.horizontalSpace,
            GestureDetector(
              onTap: onPhotoSearch,
              child: Icon(
                Icons.photo_camera_outlined,
                size: 25.sp,
                color: AppColors.textNormal,
              ),
            ),
          ],
          10.horizontalSpace,
          GestureDetector(
            onTap: () {
              onConfirm(context, controller.text);
            },
            child: ImgItem(
              'Shop/search',
              width: 20.w,
              height: 20.w,
            ),
          ),
        ],
      ),
    );
  }
}
