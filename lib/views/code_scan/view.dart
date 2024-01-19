import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/views/code_scan/controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CodeScanPage extends GetView<CodeScanController> {
  const CodeScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: controller.qrKey,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250.w,
            ),
            onQRViewCreated: controller.onQRViewCreated,
          ),
          Positioned(
            left: 15.w,
            top: ScreenUtil().statusBarHeight,
            child: const BackButton(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
