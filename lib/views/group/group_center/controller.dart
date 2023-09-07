import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/loading_util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/coordinate_model.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/group_service.dart';

class GroupCenterController extends BaseController {
  final TextEditingController keywordController = TextEditingController();
  final FocusNode keywordNode = FocusNode();

  final groupType = 1.obs; // 1: 公开拼团 2:我的拼团
  final groupStatus = 0.obs;
  final sortIndex = (-1).obs;
  final locationStr = Rxn<String?>();
  final banner = ''.obs;
  final coordinate = Rxn<CoordinateModel?>();
  final loadingUtil = LoadingUtil<GroupModel>().obs;

  @override
  void onInit() {
    super.onInit();
    getBanner();
    loadingUtil.value.initListener(getList);
    getLocation();
  }

  void getBanner() async {
    var allBanner = await CommonService.getAllBannersInfo();
    banner.value = allBanner?.groupBuyingImage ?? '';
  }

  // 拼团列表
  Future<void> getList() async {
    if (loadingUtil.value.isLoading) return;
    loadingUtil.value.isLoading = true;
    loadingUtil.refresh();
    try {
      Map data = {};
      if (groupType.value == 1) {
        Map<String, dynamic> params = {
          'page': ++loadingUtil.value.pageIndex,
          'keyword': keywordController.text,
          'sort': sortIndex.value == -1 ? '' : sortIndex.value + 1,
        };
        if (sortIndex.value == 2 && coordinate.value != null) {
          params.addAll({
            'lat': coordinate.value!.latitude,
            'lng': coordinate.value!.longitude,
          });
        }
        data = await GroupService.getPublicGroups(params);
      } else {
        data = await GroupService.getMyGroups({
          'page': ++loadingUtil.value.pageIndex,
          'status': groupStatus.value == 0 ? '' : groupStatus.value - 1,
        });
      }
      loadingUtil.value.isLoading = false;
      if (data['dataList'] != null) {
        loadingUtil.value.list.addAll(data['dataList']);
        if (data['dataList'].isEmpty && data['pageIndex'] == 1) {
          loadingUtil.value.isEmpty = true;
        } else if (data['total'] == data['pageIndex']) {
          loadingUtil.value.hasMoreData = false;
        }
      }
    } catch (e) {
      loadingUtil.value.isLoading = false;
      loadingUtil.value.pageIndex--;
      loadingUtil.value.hasError = true;
    } finally {
      loadingUtil.refresh();
    }
  }

  // 客户位置信息
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
        desiredAccuracy: LocationAccuracy.high);

    coordinate.value = CoordinateModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    var data = await GroupService.onLocationGeocode(
        {'lat': position.latitude, 'lon': position.longitude});
    if (data != null) {
      locationStr.value = data;
    }
  }

  Future<void> onRefresh() async {
    loadingUtil.value.clear();
    await getList();
  }

  @override
  void dispose() {
    loadingUtil.value.controllerDestroy();
    super.dispose();
  }
}
