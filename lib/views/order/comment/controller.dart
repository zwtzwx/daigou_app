import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/upload_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/list_refresh_event.dart';
import 'package:huanting_shop/models/order_model.dart';
import 'package:huanting_shop/services/comment_service.dart';

class OrderCommentController extends GlobalLogic {
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
    ImageUpload.imagePicker(
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
      BeeNav.pop('success');
    }
  }
}
