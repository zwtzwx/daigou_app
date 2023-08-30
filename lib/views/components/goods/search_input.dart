import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';

class SearchCell extends StatefulWidget {
  const SearchCell({
    Key? key,
    this.hintText = '请输入',
    this.searchText = '代购',
    this.onSearch,
    this.needCheck = true,
    this.initData,
    this.goPlatformGoods = false,
  }) : super(key: key);
  final String hintText;
  final String searchText;
  final bool needCheck;
  final Function(String value)? onSearch;
  final String? initData;
  final bool goPlatformGoods;

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
      Routers.push(Routers.platformGoodsList, {'keyword': value});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(30),
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(left: 10.w, right: 5.w),
      decoration: BoxDecoration(
        color: BaseStylesConfig.bgGray,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: BaseInput(
              board: true,
              controller: controller,
              focusNode: focusNode,
              isCollapsed: true,
              isSearchInput: true,
              textInputAction: TextInputAction.search,
              hintStyle: TextStyle(
                  fontSize: 12.sp, color: BaseStylesConfig.textGrayC9),
              contentPadding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(7)),
              hintText: widget.hintText.ts,
              onSubmitted: (value) {
                onConfirm(context, value);
              },
            ),
          ),
          Sized.hGap10,
          MainButton(
            text: widget.searchText,
            borderRadis: 999,
            fontSize: 12,
            onPressed: () {
              onConfirm(context, controller.text);
            },
          ),
        ],
      ),
    );
  }
}
