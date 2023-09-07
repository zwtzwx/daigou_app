import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/coordinate_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/group_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';

class GroupCreateController extends BaseController {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final TextEditingController remarkController = TextEditingController();
  final FocusNode remarkNode = FocusNode();
  final TextEditingController dayController = TextEditingController(text: '1');
  final FocusNode dayNode = FocusNode();

  final addressModel = Rxn<ReceiverAddressModel?>();
  final lineModel = Rxn<ShipLineModel?>();
  final stationModel = Rxn<SelfPickupStationModel?>();
  final warehoueModel = Rxn<WareHouseModel?>();
  final leaderTips = Rxn<String?>();
  final groupProtocol = Rxn<String?>();
  final image = Rxn<String?>();
  final isPublicGroup = false.obs;
  final createPublic = false.obs;
  final protocolAgree = false.obs;
  final deliveryType = Rxn<int?>();
  final coordinate = Rxn<CoordinateModel?>();

  @override
  void onInit() {
    super.onInit();
    getInitData();
  }

  void getInitData() async {
    var public = await GroupService.getPublicGroupConfig();
    var tips = await GroupService.getGroupProtocol();

    createPublic.value = public;
    for (var e in tips) {
      if (e['type'] == 1) {
        groupProtocol.value = e['content'];
      } else if (e['type'] == 2) {
        leaderTips.value = e['content'];
      }
    }
  }

  // 地址
  void onAddress() async {
    var s = await Routers.push(Routers.addressList, {'select': 1});
    if (s == null) return;

    addressModel.value = s as ReceiverAddressModel;
    lineModel.value = null;
    addressGeocode();
  }

  // 地址解析
  void addressGeocode() async {
    String address =
        '${addressModel.value?.address},${addressModel.value?.city},${addressModel.value?.postcode} ${addressModel.value?.countryName}';
    var data = await GroupService.onAddressGeocode({'address': address});
    coordinate.value = data;
  }

  // 快递方式
  void onLine() async {
    if (addressModel.value == null) {
      showToast('请先选择地址');
      return;
    }
    Map<String, dynamic> dic = {
      'country_id': addressModel.value!.countryId,
      'area_id': addressModel.value!.area?.id ?? '',
      'sub_area_id': addressModel.value!.subArea?.id ?? '',
      'is_group': 1,
    };
    var s = await Routers.push(Routers.lineQueryResult, {"data": dic});
    if (s == null) return;

    lineModel.value = s as ShipLineModel;
    if (lineModel.value!.warehouses != null &&
        lineModel.value!.warehouses!.length == 1) {
      warehoueModel.value = lineModel.value!.warehouses!.first;
    }
  }

  // 仓库地址
  void onWarehouse(BuildContext context) async {
    List<Map<String, dynamic>> list = lineModel.value!.warehouses!
        .map((e) => {'id': e.id, 'name': e.warehouseName!})
        .toList();
    var id = await BaseDialog.showBottomActionSheet(
        context: context, list: list, translation: false);
    if (id != null) {
      warehoueModel.value =
          lineModel.value!.warehouses!.firstWhere((e) => e.id == id);
    }
  }

  // 拼团天数
  void onDay(int step) {
    int day = dayController.text.isEmpty ? 0 : int.parse(dayController.text);
    day += step;
    dayController.text = day <= 1 ? '1' : '$day';
  }

  // 上传图片
  void onUploadImg(BuildContext context) async {
    UploadUtil.imagePicker(
      context: context,
      onSuccessCallback: (img) async {
        image.value = img;
      },
    );
  }

  void onSubmit() async {
    var msg = '';
    if (!protocolAgree.value) {
      msg = '请同意拼团规则';
    } else if (addressModel.value == null) {
      msg = '请选择收件地址';
    } else if (lineModel.value == null) {
      msg = '请选择快递方式';
    }
    if (msg.isNotEmpty) {
      showToast(msg);
      return;
    }
    var res = await GroupService.onGroupStart({
      'name': nameController.text,
      'address_id': addressModel.value!.id,
      'express_line_id': lineModel.value!.id,
      'days': dayController.text,
      'is_public': isPublicGroup.value ? 1 : 0,
      'remark': remarkController.text,
      'images': image.value != null ? [image.value] : [],
      'region_id': lineModel.value!.region?.id,
      'warehouse_id': warehoueModel.value?.id ?? '',
      'station_id': addressModel.value!.station?.id ?? '',
      'lat': coordinate.value?.latitude ?? '',
      'lng': coordinate.value?.longitude ?? '',
    });
    if (res['ok']) {
      Routers.pop('successed');
    }
  }

  @override
  void dispose() {
    nameNode.dispose();
    remarkNode.dispose();
    dayNode.dispose();
    super.dispose();
  }
}
