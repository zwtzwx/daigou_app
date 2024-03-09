import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/common/upload_util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/list_refresh_event.dart';
import 'package:shop_app_client/models/order_model.dart';
import 'package:shop_app_client/services/comment_service.dart';

class OrderCommentController extends GlobalController {
  final TextEditingController contentController = TextEditingController();
  final FocusNode contentNode = FocusNode();
  final tips = ''.obs;
  final comprehensiveStar = 0.obs;

  late OrderModel model;
  final selectImg = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    var argument = Get.arguments;
    model = argument['order'];
    getTips();
  }

  getTips() async {
    var data = await CommentService.getInfo();
    tips.value = data;
  }

  onImgUpload() {
    ImagePickers.imagePicker(
      context: Get.context!,
      onSuccessCallback: (imageUrl) {
        selectImg.add(imageUrl);
      },
    );
  }

  onSumbit() async {
    String msg = '';
    if (contentController.text.isEmpty) {
      msg = '请输入评价内容';
    }
    if (msg.isNotEmpty) {
      showToast(msg);
      return;
    }
    Map<String, dynamic> dic = {
      'order_id': model.id,
      'content': contentController.text,
      'score': comprehensiveStar.value,
      'images': selectImg,
    };
    Map data = await CommentService.onComment(dic);
    if (data['ok']) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
      GlobalPages.pop('success');
    }
  }
}
