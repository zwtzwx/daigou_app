import 'package:jiyun_app_client/config/color_config.dart';
import 'package:flutter/material.dart';

class RenameDialog extends AlertDialog {
  RenameDialog({Key? key, required Widget contentWidget})
      : super(
          key: key,
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: ColorConfig.line, width: 3)),
        );
}
