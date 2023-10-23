import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/services/announcement_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeeWebviewLogic extends GlobalLogic {
  WebViewController? webController;

  final url = RxnString(null);
  final title = RxnString(null);
  final time = RxnString(null);

  @override
  void onReady() {
    super.onReady();
    var arguments = Get.arguments;
    url.value = arguments["url"];
    title.value = arguments["title"];
    time.value = arguments['time'];
    if ((url.value ?? '').startsWith('http')) {
      webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url.value!));
    }
    if (arguments['id'] != null) {
      getDetail(arguments['id'], arguments['type']);
    }
  }

  void getDetail(int id, String? type) async {
    showLoading();
    if (type == 'notice') {
      // 公告
      var data = await AnnouncementService.getDetail(id);
      if (data != null) {
        url.value = data.content;
        title.value ??= data.title;
        time.value ??= data.createdAt;
      }
    }
    hideLoading();
  }
}
