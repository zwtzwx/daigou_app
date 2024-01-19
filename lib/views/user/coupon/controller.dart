import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/user_coupon_model.dart';

class CouponController extends GlobalLogic
    with GetSingleTickerProviderStateMixin {
  final isLoading = false.obs;
  int pageIndex = 0;
  String lineId = '';
  final amount = RxNum(0);
  final canSelect = false.obs;

  late TabController tabController;
  final PageController pageController = PageController();

  final selectNum = 0.obs;

  final availableList = <UserCouponModel>[].obs;
  final unAvailableList = <UserCouponModel>[].obs;

  final selectCoupon = Rxn<UserCouponModel?>();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    canSelect.value = arguments?['select'] ?? false;
    lineId = (arguments?['lineid'] ?? '').toString();
    amount.value = (arguments?['amount'] ?? 0);
    selectCoupon.value = arguments?['model'];
    tabController = TabController(length: 2, vsync: this);
  }

  void onPageChange(int index) {
    tabController.animateTo(index);
  }

  // 选择优惠券
  void onSelected(UserCouponModel model) {
    if (!canSelect.value) return;
    if (selectCoupon.value != null && selectCoupon.value!.id == model.id) {
      selectCoupon.value = null;
    } else {
      selectCoupon.value = model;
    }
  }
}
