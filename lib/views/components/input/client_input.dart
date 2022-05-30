// ignore_for_file: unnecessary_this

import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:flutter/material.dart';

class ClientInput extends StatefulWidget {
  ClientInput(
      {Key? key,
      this.id = 0,
      this.name = '',
      this.hintText = '',
      this.keyName = '',
      this.onChange,
      this.focusNode,
      this.pageTitle = '',
      this.readOnly = false,
      this.type = '',
      this.router = '',
      this.warehouseId = 0,
      this.controller,
      this.isDisabledJump = false})
      : super(key: key);
  late TextEditingController? controller;
  late int id;
  late String keyName;
  late String hintText;
  late bool readOnly;
  late String name;
  late FocusNode? focusNode;
  late ValueChanged? onChange;
  late String pageTitle;
  late String type;
  late String router;
  late int warehouseId;
  late bool isDisabledJump;

  @override
  State<StatefulWidget> createState() {
    return _ClientInput();
  }
}

class _ClientInput extends State<ClientInput> {
  String name = '';
  final TextEditingController _nameInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openModal() {
    Routers.push(widget.router, context);
  }

  Widget buildInputItem() {
    if (widget.controller == null) {
      this._nameInput.text = this.widget.name;
    }
    var suffix = GestureDetector(
      child: const Padding(
        padding: EdgeInsets.only(right: 15),
        child: Icon(Icons.arrow_forward_ios),
      ),
      onTap: () {
        if (widget.warehouseId == 0) return;
        openModal();
      },
    );

    return BaseInput(
      controller: widget.controller ?? _nameInput,
      keyName: widget.keyName,
      hintText: widget.hintText,
      autoShowRemove: false,
      readOnly: widget.readOnly,
      focusNode: widget.focusNode!,
      onTab: () {
        if (widget.warehouseId == 0) return;
        if (widget.isDisabledJump) return;
        FocusScope.of(context).requestFocus(FocusNode());
        openModal();
      },
      suffix: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildInputItem(),
    );
  }
}
