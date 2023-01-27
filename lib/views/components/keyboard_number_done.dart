import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class KeyboardDone {
  OverlayEntry? _overlayEntry;
  BuildContext context;
  FocusNode node;
  KeyboardDone(this.context, this.node);

  void initState() {
    node.addListener(() {
      if (node.hasFocus) {
        showOverlay();
      } else {
        removeOverlay();
      }
    });
  }

  showOverlay() {
    if (_overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) {
      return;
    }
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: doneWidget());
    });
    overlayState.insert(_overlayEntry!);
  }

  removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  Widget doneWidget() {
    return Container(
      width: double.infinity,
      color: BaseStylesConfig.bgGray,
      alignment: Alignment.centerRight,
      child: CupertinoButton(
        padding: const EdgeInsets.only(right: 24, top: 8, bottom: 8),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: const ZHTextLine(
          str: 'Done',
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
