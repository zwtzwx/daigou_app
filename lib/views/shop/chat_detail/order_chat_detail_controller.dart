import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/shop/consult_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class ShopOrderChatDetailController extends BaseController {
  late final order = Rxn<ConsultModel>();
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageNode = FocusNode();
  UserInfoModel userInfoModel = Get.find<UserInfoModel>();
  final messageList = RxMap<String, List<ConsultContentModel>>();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    order.value = arguments['consult'];
    initMessageList();
    onMarkMessage();
  }

  // 消息设为已读
  void onMarkMessage() {
    ShopService.markMessage(order.value!.id!);
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
  }

  // 发送消息
  void onSendMessage() async {
    if (messageController.text.isEmpty) {
      showToast('请输入有效内容');
      return;
    }
    Map<String, dynamic> params = {
      'problem_order_id': order.value?.problemOrderId,
      'order_id': order.value?.orderId,
      'order_sn': order.value?.orderSn,
      'content': messageController.text,
    };
    var res = await ShopService.sendMessage(params);
    if (res) {
      var time = DateTime.now().toString().split('.').first;
      ConsultContentModel content = ConsultContentModel.fromJson({
        'is_right': 1,
        'nickName': userInfoModel.userInfo.value?.name ?? '',
        'content': messageController.text,
        'created_at': time,
      });
      order.value!.contents.add(content);
      if (messageList.containsKey(getTimeKey(time))) {
        messageList[getTimeKey(time)]!.add(content);
      } else {
        messageList[getTimeKey(time)] = [content];
      }

      messageController.text = '';
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }

  void initMessageList() {
    List<ConsultContentModel> historyMessages = order.value!.contents;
    Map<String, List<ConsultContentModel>> message = {};
    for (var ele in historyMessages) {
      String key = getTimeKey(ele.createdAt);
      if (message.containsKey(key)) {
        message[key]!.add(ele);
      } else {
        message[key] = [ele];
      }
    }
    messageList.value = message;
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String getTimeKey(String time) {
    List<String> list = time.split(':');
    return '${list[0]}:${list[1]}';
  }

  @override
  void onClose() {
    messageController.dispose();
    messageNode.dispose();
    super.onClose();
  }
}
