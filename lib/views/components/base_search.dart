import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';

class BaseSearch extends StatefulWidget {
  const BaseSearch({
    Key? key,
    this.hintText = '请输入商品名',
    this.searchText = '代购',
    this.onSearch,
    this.needCheck = true,
    this.initData,
    this.goPlatformGoods = true,
    this.showScan = true,
  }) : super(key: key);
  final String hintText;
  final String searchText;
  final bool needCheck;
  final Function(String value)? onSearch;
  final String? initData;
  final bool goPlatformGoods;
  final bool showScan;

  @override
  State<BaseSearch> createState() => _SearchCellState();
}

class _SearchCellState extends State<BaseSearch> {
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
      if (value.startsWith('http')) {
        // 商品链接直接跳转到详情
        BeeNav.push(BeeNav.goodsDetail, {'url': value});
      } else {
        BeeNav.push(
            BeeNav.platformGoodsList, {'keyword': value, 'origin': value});
      }
      controller.text = '';
    }
  }

  void onPhotoSearch() async {
    var cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      BeeNav.push(BeeNav.imageSearch, {'device': cameras.first});
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              height: 36.h,
              padding: EdgeInsets.only(left: 20.w, right: 10.w),
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
                        maxLength: 200,
                        autoShowRemove: false,
                        textInputAction: TextInputAction.search,
                        hintStyle: TextStyle(
                            fontSize: 12.sp, color: AppColors.textGrayC9),
                        contentPadding: EdgeInsets.symmetric(vertical: 7.h),
                        hintText: widget.hintText.ts,
                        onSubmitted: (value) {
                          onConfirm(context, value);
                        },
                      ),
                    ),
                  ),
                  widget.showScan
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: GestureDetector(
                            onTap: onPhotoSearch,
                            child: Icon(
                              Icons.photo_camera_outlined,
                              size: 25.sp,
                              color: AppColors.textNormal,
                            ),
                          ),
                        )
                      : AppGaps.empty,
                ],
              ),
            ),
          ),
          10.horizontalSpace,
          BeeButton(
            text: '代购',
            borderRadis: 14.r,
            onPressed: () {
              onConfirm(context, controller.text);
            },
          ),
        ],
      ),
    );
  }
}
