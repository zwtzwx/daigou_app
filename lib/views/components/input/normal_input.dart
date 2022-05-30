import 'base_input.dart';
import 'package:flutter/material.dart';

class NormalInput extends StatefulWidget {
  const NormalInput(
      {Key? key,
      required this.controller,
      this.readOnly = false,
      this.board = false,
      this.keyName,
      this.keyboardType = TextInputType.text,
      this.hintText = "",
      this.maxLength = 50,
      this.maxLines = 50,
      this.autoFocus = false,
      required this.focusNode,
      this.prefixIcon,
      this.textAlign = TextAlign.left,
      this.onChanged,
      this.onSubmitted,
      this.contentPadding,
      this.textInputAction = TextInputAction.next})
      : super(key: key);
  final TextEditingController controller;
  final bool readOnly;
  final int maxLength;
  final int maxLines;
  final bool autoFocus;
  final bool board;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode focusNode;
  final String? keyName;
  final Icon? prefixIcon;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;

  @override
  State<StatefulWidget> createState() {
    return _NormalInput();
  }
}

class _NormalInput extends State<NormalInput> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget buildInputItem() {
    return BaseInput(
      readOnly: widget.readOnly,
      board: widget.board,
      contentPadding: widget.contentPadding,
      controller: widget.controller,
      textAlign: widget.textAlign,
      keyName: widget.keyName,
      hintText: widget.hintText,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      autoFocus: widget.autoFocus,
      focusNode: widget.focusNode,
      prefixIcon: widget.prefixIcon,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      autoShowRemove: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildInputItem();
  }
}
