import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/group_order_model.dart';
import 'package:huanting_shop/services/group_service.dart';

class BeeGroupOrderDetailController extends GlobalLogic {
  final orderModel = Rxn<GroupOrderModel?>();

  @override
  void onInit() {
    super.onInit();
    getDetail();
  }

  void getDetail() async {
    showLoading();
    var data = await GroupService.getGroupOrderDetail(Get.arguments['id']);
    hideLoading();
    if (data != null) {
      orderModel.value = data;
    }
  }

  // 支付
  void onPay() async {
    BeeNav.push(BeeNav.transportPay, arg: {
      'id': orderModel.value!.id,
      'payModel': 1,
      'deliveryStatus': 1,
      'isLeader': 1
    });
  }

  String getOrderStatus(int status, int mode) {
    String str = '';
    switch (status) {
      case 1:
        str = '打包进度';
        break;
      case 2:
        str = mode == 1 ? '待支付' : '支付进度';
        break;
      case 3:
        str = '待发货';
        break;
      case 4:
        str = '已发货';
        break;
      case 5:
        str = '已签收';
        break;
      case 11:
        str = mode == 1 ? '待审核' : '';
        break;
      case 12:
        str = mode == 1 ? '审核拒绝' : '';
        break;
    }
    return str;
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
