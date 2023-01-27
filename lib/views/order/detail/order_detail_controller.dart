import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:video_player/video_player.dart';

class OrderDetailController extends BaseController {
  final model = Rxn<OrderModel?>();
  late int orderId;
  final isLoading = false.obs;

  // 打包视频
  final packVideoManager = <FlickManager>[].obs;

  final statusStr = ''.obs;

  @override
  void onReady() {
    super.onReady();
    var arguments = Get.arguments;
    orderId = arguments['id'];
    getVideoList();
    getOrderDetail();
  }

  getOrderDetail() async {
    showLoading();
    var data = await OrderService.getDetail(orderId);
    hideLoading();
    if (data != null) {
      model.value = data;
      statusStr.value = Util.getOrderStatusName(data.status, data.stationOrder);
      isLoading.value = true;
    }
  }

  // 订单打包视频
  getVideoList() async {
    var videos = await OrderService.getOrderPackVideo(orderId);
    for (var item in videos) {
      packVideoManager.add(
        FlickManager(
          autoPlay: false,
          videoPlayerController: VideoPlayerController.network(item),
        ),
      );
    }
  }

  void onSign() async {
    showLoading();
    var result = await OrderService.signed(orderId);
    hideLoading();
    if (result['ok']) {
      showSuccess('签收成功');
      onRefresh();
    } else {
      showError(result['msg']);
    }
  }

  void onRefresh() {
    getOrderDetail();
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
  }

  String getPriceStr(num? price) {
    return (localModel?.currencySymbol ?? '') +
        ((price ?? 0) / 100).toStringAsFixed(2);
  }

  @override
  void onClose() {
    for (var item in packVideoManager) {
      item.dispose();
    }
    super.onClose();
  }
}
