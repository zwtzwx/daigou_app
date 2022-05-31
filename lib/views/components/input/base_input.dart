import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter/foundation.dart';

class BaseInput extends StatefulWidget {
  const BaseInput(
      {Key? key,
      required this.controller,
      this.maxLength = 16,
      this.textAlign = TextAlign.left,
      this.autoFocus = false,
      this.keyboardType = TextInputType.text,
      this.hintText = "",
      required this.focusNode,
      this.config,
      this.keyName,
      this.suffix,
      this.isScureText = false,
      this.readOnly = false,
      this.board = false,
      this.onTab,
      this.autoShowRemove = true,
      this.maxLines = 1,
      this.prefixIcon,
      this.onEditingComplete,
      this.onChanged,
      this.isSearchInput = false,
      this.onSubmitted,
      this.isCollapsed = false,
      this.hintStyle = TextConfig.textGray14,
      this.textInputAction = TextInputAction.next,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 16.0)})
      : super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final TextAlign textAlign;
  final VoidCallback? onEditingComplete;
  final bool autoFocus;
  final bool board;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode? focusNode;
  final KeyboardActionsConfig? config;
  final Widget? suffix;
  final TextStyle hintStyle;
  final bool isScureText;
  final bool isCollapsed;
  final bool readOnly;
  final bool autoShowRemove;
  final VoidCallback? onTab;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final Icon? prefixIcon;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final bool isSearchInput;

  /// 用于集成测试寻找widget
  final String? keyName;

  @override
  _BaseInputState createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  late bool _isShowRemove;
  bool _isFoucsed = false;

  @override
  void initState() {
    super.initState();

    _isShowRemove = widget.readOnly;

    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {
          _isFoucsed = widget.focusNode!.hasFocus;
        });
      });
    }

    if (widget.autoShowRemove) {
      /// 监听输入改变
      widget.controller.addListener(() {
        setState(() {
          _isShowRemove = widget.controller.text.isNotEmpty;
        });
      });
    }

    if (widget.config != null && defaultTargetPlatform == TargetPlatform.iOS) {
      // 因Android平台输入法兼容问题，所以只配置IOS平台
      // FormKeyboardActions.setKeyboardActions(context, widget.config);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        fillColor: widget.board ? ColorConfig.line : Colors.white,
        filled: true,
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        isCollapsed: widget.isCollapsed,
        prefixIcon: widget.prefixIcon,
        suffixIcon: (_isShowRemove && _isFoucsed && widget.suffix == null)
            ? GestureDetector(
                // padding: const EdgeInsets.all(0),
                child: const Icon(
                  Icons.cancel,
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    widget.controller.text = "";
                    if (widget.isSearchInput) {
                      // ApplicationEvent.getInstance()
                      //     .event
                      //     .fire(ListRefreshEvent('reset'));
                      if (widget.onChanged is Function) widget.onChanged!("");
                    }
                  });
                })
            : null,
        counterText: "",
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none));

    var widgetList = <Widget>[
      TextField(
        enabled: !widget.readOnly,
        // enableInteractiveSelection: false,
        cursorColor: Theme.of(context).primaryColor,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        onEditingComplete: widget.onEditingComplete,
        style: TextConfig.middleText,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        obscureText: widget.isScureText,
        autofocus: widget.autoFocus,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        // enableInteractiveSelection: widget.readOnly,
        onSubmitted: (string) {
          if (widget.onSubmitted is Function) widget.onSubmitted!(string);
        },
        onChanged: (string) {
          if (widget.onChanged is Function) widget.onChanged!(string);
        },
        onTap: () {
          if (widget.onTab is Function) widget.onTab!();
        },
        // 数字、手机号限制格式为0到9(白名单)， 密码限制不包含汉字（黑名单）
        // inputFormatters: (widget.keyboardType == TextInputType.number ||
        //         widget.keyboardType == TextInputType.phone)
        //     ? [WhitelistingTextInputFormatter(RegExp("[0-9]"))]
        //     : [BlacklistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]"))],
        decoration: inputDecoration,
      ),
    ];

    if (widget.suffix != null) {
      widgetList.add(widget.suffix!);
    }
    return Stack(alignment: Alignment.centerRight, children: widgetList);
  }
}
