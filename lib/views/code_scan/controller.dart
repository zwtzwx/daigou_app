import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CodeScanController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isRequest = false;

  void onQRViewCreated(QRViewController value) {
    controller = value;
    controller?.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        onLogin(scanData.code!);
      }
    });
  }

  void onLogin(String data) async {
    if (isRequest) return;
    isRequest = true;
    var res = await CommonService.onChromeLogin({
      'key': data,
    });
    if (res) {
      Routers.pop();
    } else {
      isRequest = false;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
