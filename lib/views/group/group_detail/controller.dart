import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/coordinate_model.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/services/group_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/group/widget/group_detail/group_delay.dart';
import 'package:jiyun_app_client/views/group/widget/group_detail/leader_tip.dart';
import 'package:url_launcher/url_launcher.dart';

class BeeGroupDetailController extends GlobalLogic {
  final model = Rxn<GroupModel?>();
  final tipsContent = Rxn<String?>();
  final protocolContent = Rxn<String?>();
  final coordinate = Rxn<CoordinateModel?>();
  final isAllSubmit = false.obs;
  late int id;
  final canSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    getDetail();
    getRules();
  }

  void getDetail() async {
    showLoading();
    var res = await GroupService.getGroupDetail(id);
    hideLoading();
    if (res != null) {
      model.value = res;
      isAllSubmit.value = res.members!.every((e) => e.isSubmitted == 1);

      if (!res.isGroupLeader!) {
        getLocation();
      }
    }
  }

  void onContact(String number) {
    Uri uri = Uri(
      scheme: 'tel',
      path: number,
    );
    launchUrl(uri);
  }

  void getRules() async {
    var tips = await GroupService.getGroupProtocol();
    for (var e in tips) {
      if (e['type'] == 1) {
        protocolContent.value = e['content'];
      } else if (e['type'] == 3) {
        tipsContent.value = e['content'];
      }
    }
  }

  void onChooseParcel([Function? callback]) async {
    var s = await BeeNav.push(BeeNav.groupParcelSelect,
        {'id': model.value!.id, 'warehouseId': model.value!.warehouseId});
    if (s != null) {
      getDetail();
      if (callback != null) {
        callback();
      }
    }
  }

  Future<bool?> showProtocol(context) async {
    return await BaseDialog.normalDialog(
      context,
      child: Html(data: protocolContent.value ?? ''),
      confirmText: '确认同意拼团规则',
      barrierDismissible: true,
    );
  }

  // 获取坐标位置
  void getLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast('获取位置信息失败');
        return;
      }
    } else if (permission == LocationPermission.deniedForever) {
      showToast('获取位置信息失败');
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    coordinate.value = CoordinateModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  // 加入拼团
  void onAddGroup(context) async {
    var confirm = await showProtocol(context);
    if (confirm == true) {
      var res = await GroupService.onGroupJoin(model.value!.id!);
      if (res['ok']) {
        getDetail();
      }
    }
  }

  // 退出拼团
  void onExistGroup(context) async {
    var confirm = await BaseDialog.confirmDialog(
      context,
      '退团后，所有拼团仓库内的包裹将原路返回至原仓库，确认吗？',
    );
    if (confirm == true) {
      var res = await GroupService.onGroupExist(model.value!.id!);
      if (res['ok']) {
        getDetail();
      }
    }
  }

  // 取消拼团
  void onCancelGroup(context) async {
    var confirm = await BaseDialog.confirmDialog(
      context,
      '您确定要取消拼团吗？',
    );
    if (confirm == true) {
      var res = await GroupService.onCancelGroup(model.value!.id!);
      if (res['ok']) {
        getDetail();
      }
    }
  }

  // 完成提交拼团
  void onEndGroup(context) async {
    bool memberNotAllSubmit = model.value!.members!
        .any((e) => e.isGroupLeader! == 0 && e.isSubmitted! == 0);
    var confirm = await BaseDialog.confirmDialog(
      context,
      memberNotAllSubmit ? '有团员未提交拼团订单，确认将他踢出拼团并提交订单吗？' : '您确定要提交拼团吗？',
      confirmText: memberNotAllSubmit ? '确认提交' : '确认',
      cancelText: memberNotAllSubmit ? '再等等' : '取消',
    );
    if (confirm ?? false) {
      var res = await GroupService.onEndGroup(model.value!.id!);
      if (res['ok']) {
        getDetail();
      }
    }
  }

  // 提交拼团货物
  void onSubmitParcel() async {
    var s = await BeeNav.push(BeeNav.createOrder, {'id': model.value!.id});
    if (s != null) {
      getDetail();
    }
  }

  // 延长拼团
  void onDelayDays(context) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => CountdownDelay(
        id: model.value!.id!,
        onConfirm: () {
          getDetail();
        },
      ),
    );
  }

  // 修改团长有话说
  void onChangeRemark(context) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => LeaderTip(
        id: model.value!.id!,
        remark: model.value!.remark!,
        image: model.value!.images!.isNotEmpty ? model.value!.images![0] : '',
        onConfirm: () {
          getDetail();
        },
      ),
    );
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
