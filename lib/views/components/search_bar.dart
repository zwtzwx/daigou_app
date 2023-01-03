import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatefulWidget {
  // 头部组件 可选
  final Widget? leading;
  // 标题 可选
  final String? title;
  final ValueChanged<String>? onchangeValue;
  final VoidCallback? onEditingComplete;
  // 点击取消回调 可选
  final VoidCallback? onCancel;
  // 点击键盘搜索回调 可选
  final ValueChanged<String> onSearch;

  final ValueChanged<String> onSearchClick;

  final TextEditingController controller;

  final FocusNode? focusNode;

  const SearchBar({
    Key? key,
    required this.onSearch,
    required this.onSearchClick,
    required this.controller,
    this.leading,
    this.title,
    this.onCancel,
    this.focusNode,
    this.onchangeValue,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBar> {
  ///编辑控制器

  String _title = "";
  Widget _searchPanel() {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: 30,
      child: TextField(
        textAlign: TextAlign.start,
        cursorColor: ColorConfig.textGray,
        focusNode: widget.focusNode,
        controller: widget.controller,
        autofocus: false,
        style: const TextStyle(fontSize: 15),
        textInputAction: TextInputAction.search,
        onChanged: (string1) {
          _title = string1;
          // print(string1);
          // print("$widget.onSearch");
          // if (widget.onSearch is Function) {
          // print(string1);
          widget.onSearch(string1);
          // }
        },
        onSubmitted: (strin) {
          _title = strin;
          // print(string1);
          // print("$widget.onSearch");
          // if (widget.onSearchClick is Function) {
          // print(strin);
          widget.onSearchClick(strin);
          // }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 10),
          prefixIcon: const Icon(
            Icons.search_outlined,
            size: 25,
          ),
          suffixIcon: _action(),
          filled: false,
          hintText: Translation.t(context, '输入关键字查询'),
          hintStyle: TextConfig.textGray14,
          fillColor: ColorConfig.bgGray,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  // 搜索/取消按钮
  Widget _action() {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      child: RawMaterialButton(
        fillColor: ColorConfig.primary,
        child: ZHTextLine(
          str: Translation.t(context, '搜索'),
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          // print("$_title");
          widget.onSearchClick(_title);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: ColorConfig.white,
      alignment: Alignment.center,
      child: _searchPanel(),
    );
  }
}
