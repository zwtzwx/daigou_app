/*
  提交转运包裹
*/

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/insurance_item_model.dart';
import 'package:jiyun_app_client/models/insurance_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_condition_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/ship_line_service_model.dart';
import 'package:jiyun_app_client/models/tariff_item_model.dart';
import 'package:jiyun_app_client/models/tariff_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/order/components/rename_dialog.dart';
import 'package:jiyun_app_client/views/order/components/rename_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateOrderPage extends StatefulWidget {
  final Map arguments;
  const CreateOrderPage({Key? key, required this.arguments}) : super(key: key);

  @override
  CreateOrderPageState createState() => CreateOrderPageState();
}

class CreateOrderPageState extends State<CreateOrderPage>
    with AutomaticKeepAliveClientMixin {
  List<ParcelModel> packageList = [];

  // 身份证
  final TextEditingController _idCodeController = TextEditingController();
  // 清关码
  final TextEditingController _clearanceCodeController =
      TextEditingController();

  final TextEditingController _evaluateController = TextEditingController();
  FocusNode blankNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  // 收件地址
  ReceiverAddressModel? selectedAddressModel;
  // 收货形式
  int tempDelivery = 0;
  // 选择的自提点
  SelfPickupStationModel? selectStations;

// 保险服务
  bool insuranceServices = false;
// 关税服务
  bool customsService = false;

  LocalizationModel? localizationInfo;

  // 自提点数据
  SelfPickupStationModel? selfPickupStationModel;

  ShipLineModel? shipLineModel;

  List<ValueAddedServiceModel> serviceList = [];

  // 保险
  InsuranceModel? insuranceModel;

  // 关税
  TariffModel? tariffModel;

  String firstStr = '';
  bool firstMust = false;
  String secondStr = '';
  bool secondMust = false;
  double totalValue = 0.0;

  @override
  void initState() {
    super.initState();
    packageList = widget.arguments['modelList'];
    // for (var i = 0; i< packageList.length; i++) {
    //   packageList[i].select = false
    // }

    setState(() {
      totalValue = 0.0;
      for (var item in packageList) {
        totalValue += item.packageValue ?? 0;
      }
    });

    created();
  }

  created() async {
    EasyLoading.show();
    var _serviceList = await ShipLineService.getValueAddedServiceList();
    var _insurance = await ShipLineService.getInsurance();
    var _tariff = await ShipLineService.getTariff();
    EasyLoading.dismiss();
    setState(() {
      if (_insurance != null) {
        insuranceModel = _insurance;
      }
      if (_tariff != null) {
        tariffModel = _tariff;
      }
      serviceList = _serviceList;
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '提交合并包裹',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isLoading
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: buildSubViews(),
                  ),
                ))
            : Container());
  }

  @override
  void dispose() {
    _clearanceCodeController.dispose();
    _idCodeController.dispose();
    super.dispose();
  }

  Widget buildSubViews() {
    var content = Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        getAllPackageList(),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 0, bottom: 10, left: 30),
          child: Caption(
            fontSize: 14,
            str: '合计申报价值：' +
                localizationInfo!.currencySymbol +
                (totalValue / 100).toStringAsFixed(2),
            color: ColorConfig.textGray,
          ),
        ),
        buildMiddleView(),
        buildBottomView(),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 0, bottom: 10, left: 30),
          child: const Caption(
            fontSize: 14,
            str: '提示:合并打包后无法更改哦！',
            color: ColorConfig.textGray,
          ),
        ),
        shipLineModel != null ? buildRulesView() : Container(),
        Container(
            height: 80,
            width: ScreenUtil().screenWidth - 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 1, color: Colors.white),
            ),
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
            padding: const EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: 80,
                  child: const Caption(
                    fontSize: 16,
                    str: '打包备注：',
                    color: ColorConfig.textDark,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: TextField(
                      controller: _evaluateController,
                      maxLines: 3,
                      maxLength: 100,
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      decoration: const InputDecoration.collapsed(
                        hintText: "请输入打包备注",
                      ),
                    ),
                  ),
                )
              ],
            )),
        Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: TextButton(
            onPressed: () {
              if (shipLineModel == null || selectedAddressModel == null) {
                Util.showToast('请完善数据');
                return;
              }
              if (shipLineModel!.needClearanceCode == 1 ||
                  shipLineModel!.needIdCard == 1) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return RenameDialog(
                        contentWidget: RenameDialogContent(
                          needClearanceCode: shipLineModel!.needClearanceCode,
                          needIdCard: shipLineModel!.needIdCard,
                          title: "该线路需要提供额外信息",
                          okBtnTap: () {
                            updataOrder();
                          },
                          vc: _idCodeController,
                          vc2: _clearanceCodeController,
                          cancelBtnTap: () {},
                        ),
                      );
                    });
              } else {
                updataOrder();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: ColorConfig.warningText,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(width: 1, color: ColorConfig.warningText)),
              alignment: Alignment.center,
              height: 40,
              child: const Caption(
                str: '确认提交',
                color: ColorConfig.textDark,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: const Caption(
            str: '在仓库打包完成之后才会需要进行支付',
            color: ColorConfig.textGray,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
    return content;
  }

  // 提交包裹
  updataOrder() async {
    List<String> packagesId = [];
    for (var item in packageList) {
      packagesId.add(item.id.toString());
    }
    List<String> addServiceList = [];
    for (var item in serviceList) {
      if (item.isOpen) {
        addServiceList.add(item.id.toString());
      }
    }
    List<String> lineServiceList = [];
    for (var item in shipLineModel!.region!.services!) {
      if (item.isOpen || item.isForced == 1) {
        lineServiceList.add(item.id.toString());
      }
    }
    Map<String, dynamic> upData = {
      'address_id': selectedAddressModel!.id,
      'packages': packagesId,
      'station_id': tempDelivery == 1 ? selectStations!.id : '',
      'express_line_id': shipLineModel != null ? shipLineModel!.id : '',
      'add_service': addServiceList,
      'clearance_code': _clearanceCodeController.text,
      'id_card': _idCodeController.text,
      'is_insurance': firstMust
          ? 1
          : insuranceServices
              ? 1
              : 0,
      'is_tariff': secondMust
          ? 1
          : customsService
              ? 1
              : 0,
      'region_id': shipLineModel!.region!.id,
      'line_service_ids': lineServiceList,
      'vip_remark': _evaluateController.text,
    };
    EasyLoading.show(status: '提交中...');
    bool data = await OrderService.store(upData);
    EasyLoading.dismiss();
    if (data) {
      EasyLoading.showSuccess('提交成功').then((value) {
        Navigator.of(context).pop('succeed');
      });
    } else {
      EasyLoading.showError('提交失败');
    }
  }

  Widget line() {
    return const Divider(
      height: 1.0,
      indent: 0,
      color: ColorConfig.bgGray,
    );
  }

  // 包裹列表
  Widget getAllPackageList() {
    List<Widget> viewList = [];
    for (var i = 0; i < packageList.length; i++) {
      ParcelModel model = packageList[i];
      var view = Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 1, color: Colors.white),
            ),
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            height: 110,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        width: 80,
                        child: Caption(
                          fontSize: 14,
                          str: '包裹名称：',
                          color: ColorConfig.textDark,
                        ),
                      ),
                      Caption(
                        fontSize: 14,
                        str: model.packageName!,
                        color: ColorConfig.textDark,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Caption(
                              fontSize: 14,
                              str: '包裹价值：',
                              color: ColorConfig.textDark,
                            ),
                          ),
                          Caption(
                            fontSize: 14,
                            str: localizationInfo!.currencySymbol +
                                (model.packageValue! / 100).toStringAsFixed(2),
                            color: ColorConfig.textDark,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () async {
                                var s = await Navigator.pushNamed(
                                    context, '/PackageDetailPage',
                                    arguments: {'id': model.id, 'edit': true});

                                if (s == null) {
                                  return;
                                }
                                setState(() {
                                  model.packageValue = s as num?;
                                  // print(model.packageValue);
                                  totalValue = 0.0;
                                  for (var item in packageList) {
                                    totalValue += item.packageValue ?? 0;
                                  }
                                  // packageList.replaceRange(i, i + 1, [s]);
                                });
                              },
                              child: const Caption(
                                fontSize: 14,
                                str: '修改',
                                color: ColorConfig.warningText,
                              )),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: ColorConfig.textGray,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        width: 80,
                        child: Caption(
                          fontSize: 14,
                          str: '入库重量：',
                          color: ColorConfig.textDark,
                        ),
                      ),
                      Caption(
                        fontSize: 14,
                        str: ((model.packageWeight ?? 0) / 1000)
                                .toStringAsFixed(2) +
                            localizationInfo!.weightSymbol,
                        color: ColorConfig.textDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );
      viewList.add(view);
    }
    return Column(
      children: viewList,
    );
  }

  // 选择收件地址
  onAddress() async {
    var s = await Navigator.pushNamed(context, '/ReceiverAddressListPage',
        arguments: {'select': 1});

    if (s == null) {
      return;
    }
    setState(() {
      selectedAddressModel = s as ReceiverAddressModel;
    });
  }

  // 选择渠道
  onLine() async {
    if (selectedAddressModel == null) {
      Util.showToast('请先选择地址');
      return;
    }
    num totalWeight = 0;
    List<num> packageIdList = [];
    List<num> propIdList = [];
    for (ParcelModel item in packageList) {
      packageIdList.add(item.id!);
      if (item.prop != null) {
        propIdList.add(item.prop!.first.id);
      }
      if (item.packageWeight == null) {
        totalWeight += 0;
      } else {
        totalWeight += item.packageWeight ?? 0;
      }
    }
    // int areaid = selectedAddressModel!.area =
    // int subareaid =
    Map<String, dynamic> dic = {
      'country_id': selectedAddressModel!.countryId,
      'area_id': selectedAddressModel!.area == null
          ? ''
          : selectedAddressModel!.area?.id,
      'sub_area_id': selectedAddressModel!.subArea == null
          ? ''
          : selectedAddressModel!.subArea?.id,
      'weight': totalWeight, // 所选包裹总重量
      'prop_ids': propIdList, // 所有包裹的propId 数组
      // 'warehouse_id': packageList.first.warehouseId, // 包裹所在的仓库
      'package_ids': packageIdList, // 包裹的id 数组
    };
    var s = await Navigator.pushNamed(context, '/LinesPage',
        arguments: {"data": dic});
    if (s == null) {
      return;
    }
    setState(() {
      shipLineModel = s as ShipLineModel;
      tempDelivery = shipLineModel!.isDelivery;
      if (shipLineModel!.selfPickupStations != null &&
          shipLineModel!.selfPickupStations!.isNotEmpty) {
        selectStations = shipLineModel!.selfPickupStations!.first;
      } else {
        selectStations = null;
      }
    });
  }

  // 选择收货形式
  onDeliveryType() {
    if (shipLineModel?.isDelivery != 2) return;
    List<Map> types = [
      {"name": "送货上门", "value": 0},
      {"name": "自提点提货", "value": 1},
    ];
    List<PickerItem> pickerItems = [];
    for (var item in types) {
      pickerItems.add(PickerItem(
        text: Caption(
          str: item['name'],
          fontSize: 18,
        ),
      ));
    }
    Picker(
      adapter: PickerDataAdapter(data: pickerItems),
      title: const Caption(
        str: '选择收货形式',
      ),
      cancelText: '取消',
      confirmText: '确认',
      onConfirm: (Picker picker, List value) {
        setState(() {
          tempDelivery = types[value.first]['value'];
        });
      },
    ).showModal(context);
  }

  // 地址信息
  Widget buildMiddleView() {
    String contentStr = '';
    if (selectedAddressModel != null) {
      if (selectedAddressModel!.area != null) {
        if (selectedAddressModel!.area != null) {
          contentStr = selectedAddressModel!.countryName +
              ' ' +
              selectedAddressModel!.area!.name;
        }
        if (selectedAddressModel!.subArea != null) {
          contentStr += ' ' + selectedAddressModel!.subArea!.name;
        }
        contentStr += ' ' + (selectedAddressModel!.address ?? '');
      } else {
        contentStr = selectedAddressModel!.countryName +
            ' ' +
            selectedAddressModel!.province +
            ' ' +
            selectedAddressModel!.city;
        if (selectedAddressModel != null) {
          contentStr += ' ' + (selectedAddressModel!.address ?? '');
        }
      }
    }
    var midView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1, color: Colors.white),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      // padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onAddress,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 80,
                    child: const Caption(
                      str: '收货地址:',
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          selectedAddressModel == null
                              ? const Expanded(
                                  child: Caption(
                                    str: '请选择',
                                    color: ColorConfig.textGray,
                                  ),
                                )
                              : Expanded(
                                  // height: 90,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        // height: 40,
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          selectedAddressModel!.receiverName +
                                              ' ' +
                                              selectedAddressModel!.timezone +
                                              '-' +
                                              selectedAddressModel!.phone,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: ColorConfig.textDark),
                                        ),
                                      ),
                                      Container(
                                        // height: 40,
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          contentStr,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              height: 1.5,
                                              color: ColorConfig.textDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: ColorConfig.textGray,
                  ),
                ],
              ),
            ),
          ),
          line(),
          GestureDetector(
            onTap: onLine,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 80,
                    child: const Caption(str: '渠道选择:'),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: shipLineModel == null
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Caption(
                              str: shipLineModel == null
                                  ? '请选择'
                                  : shipLineModel!.name,
                              color: shipLineModel == null
                                  ? ColorConfig.textGray
                                  : ColorConfig.textDark,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: ColorConfig.textGray,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          line(),
          GestureDetector(
            onTap: onDeliveryType,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 80,
                    child: const Caption(str: '收货形式:'),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: shipLineModel == null
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Caption(
                          str: shipLineModel != null
                              ? (shipLineModel?.isDelivery == 0
                                  ? '送货上门'
                                  : shipLineModel?.isDelivery == 1
                                      ? '自提点提货'
                                      : (tempDelivery == 1 ? '自提点提货' : '送货上门'))
                              : '',
                          color: ColorConfig.textDark,
                        ),
                        shipLineModel?.isDelivery == 2
                            ? const Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorConfig.textGray,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          shipLineModel?.isDelivery != 0 ? line() : Gaps.empty,
          shipLineModel != null && tempDelivery != 0
              ? GestureDetector(
                  onTap: () async {
                    var s = await Navigator.pushNamed(
                        context, '/SelectSelfPickUpPage',
                        arguments: {"model": shipLineModel});
                    if (s == null) {
                      return;
                    }
                    setState(() {
                      selectStations = s as SelfPickupStationModel;
                    });
                  },
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                child: const Caption(str: '自提点'),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorConfig.textGray,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 20,
                                child: Caption(
                                  str: selectStations!.name,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 20,
                                child: Caption(
                                    fontSize: 15,
                                    str: ' ' +
                                        selectStations!.contactor! +
                                        ' ' +
                                        selectStations!.contactInfo!),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: const Caption(str: '详细地址：'),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  child:
                                      Caption(str: selectStations!.address!)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 20,
                                child: const Caption(
                                    str: '*您已选择自提点自提，请到相应地址取货',
                                    color: ColorConfig.textRed),
                              ),
                            ],
                          ),
                        ],
                      )))
              : Container(),
        ],
      ),
    );
    return midView;
  }

  // 出库规则服务
  buildRulesView() {
    List<String> contentList = [];
    if (shipLineModel!.region != null &&
        shipLineModel!.region!.rules!.isNotEmpty) {
      int itemNum = 1;
      for (var item in shipLineModel!.region!.rules!) {
        String contentStr = itemNum.toString() + ' 、';
        itemNum++;
        for (ShipLineConditionModel subItem in item.conditions!) {
          contentStr += '(' +
              subItem.paramName +
              subItem.comparison +
              subItem.value.toString() +
              ')' +
              ' 时,';
        }
        if (item.type == 1) {
          contentStr += '限定【按订单收费】' +
              localizationInfo!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
        } else if (item.type == 2) {
          contentStr += '限定【按箱收费】' +
              localizationInfo!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
        } else if (item.type == 3) {
          contentStr += '限定【按单位计费重量收费】' +
              localizationInfo!.currencySymbol +
              (item.value / 100).toStringAsFixed(2);
        } else if (item.type == 4) {
          contentStr += '限定【限制出仓】';
        }
        if (item.minCharge != 0) {
          contentStr += '（最低收费' +
              localizationInfo!.currencySymbol +
              (item.minCharge / 100).toStringAsFixed(2) +
              ',';
        }
        if (item.maxCharge != 0) {
          contentStr += '（最高收费' +
              localizationInfo!.currencySymbol +
              (item.maxCharge / 100).toStringAsFixed(2) +
              '）';
        }
        contentList.add(contentStr);
      }
      String contentStr = '注：以上规则';
      if (shipLineModel!.ruleFeeMode == 0) {
        contentStr += '【同时收取】';
      } else {
        contentStr += '【每个分区仅按最高项规则收取】';
      }
      contentStr += '，最高收费';
      if (shipLineModel!.maxRuleFee == 0) {
        contentStr += '无上限';
      } else {
        contentStr += localizationInfo!.currencySymbol +
            (shipLineModel!.maxRuleFee / 100).toString();
      }
      contentList.add(contentStr);
    }
    if (contentList.isNotEmpty) {
      var view = Container(
          height: 60 + (contentList.length * 23).toDouble(),
          width: ScreenUtil().screenWidth - 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: ColorConfig.white),
          ),
          margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
          padding: const EdgeInsets.only(left: 10, right: 0),
          child: Column(children: rulesTextList(contentList)));
      return view;
    }
    return Container();
  }

  rulesTextList(List<String> list) {
    List<Widget> textList = [];
    textList.add(Container(
      alignment: Alignment.bottomLeft,
      height: 40,
      child: const Caption(
        str: '出库限制规则',
      ),
    ));
    for (var item in list) {
      var con = Container(
        alignment: Alignment.centerLeft,
        height: 23,
        child: Caption(
          fontSize: 13,
          str: item,
        ),
      );
      textList.add(con);
    }
    return textList;
  }

  // 增值服务
  Widget buildBottomView() {
    double totalValue = 0.0;
    for (var item in packageList) {
      if (item.packageValue == null) {
        totalValue += 0.0;
      } else {
        totalValue += item.packageValue ?? 0;
      }
    }
    if (insuranceModel?.enabled == 1) {
      for (InsuranceItemModel item in insuranceModel!.items) {
        if (item.start < totalValue) {
          // print(item.start.toString());
          firstMust = (item.isForce == 1);
          if (item.insuranceType == 1) {
            firstStr = ((totalValue / 100) * (item.insuranceProportion / 100))
                .toStringAsFixed(2);
          } else {
            firstStr = item.insuranceProportion.toStringAsFixed(2);
          }
        }
      }
    }
    if (tariffModel?.enabled == 1) {
      for (TariffItemModel item in tariffModel!.items) {
        if (item.amount < totalValue) {
          secondMust = (item.enforce == 1);
          if (item.type == 1) {
            secondStr =
                ((totalValue / 100) * (item.amount / 10000)).toStringAsFixed(2);
          } else {
            secondStr = item.amount.toStringAsFixed(2);
          }
        }
      }
    }

    var bottomView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1, color: ColorConfig.white),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: (insuranceModel?.enabled == 1 &&
                    insuranceModel!.enabledLineIds.contains(shipLineModel?.id))
                ? 50
                : 0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Caption(str: '保险服务'),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: IconButton(
                                icon: const Icon(
                                  Icons.error_outline_outlined,
                                  color: ColorConfig.warningText,
                                  size: 25,
                                ),
                                onPressed: () {
                                  showRemark(
                                      '保险服务', insuranceModel!.explanation);
                                }),
                          ),
                          Gaps.hGap10,
                          Caption(
                            str: localizationInfo!.currencySymbol + firstStr,
                            color: ColorConfig.textRed,
                          )
                        ],
                      ),
                      Switch.adaptive(
                        value: firstMust ? firstMust : insuranceServices,
                        activeColor: ColorConfig.warningText,
                        onChanged: (value) {
                          setState(() {
                            insuranceServices = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                line()
              ],
            ),
          ),
          SizedBox(
            height: (tariffModel?.enabled == 1 &&
                    tariffModel!.enabledLineIds.contains(shipLineModel?.id))
                ? 50
                : 0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Caption(str: '关税服务'),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: IconButton(
                                icon: const Icon(
                                  Icons.error_outline_outlined,
                                  color: ColorConfig.warningText,
                                  size: 25,
                                ),
                                onPressed: () {
                                  showRemark('关税服务', tariffModel!.explanation);
                                }),
                          ),
                          Caption(
                              str: localizationInfo!.currencySymbol + secondStr,
                              color: ColorConfig.textRed),
                        ],
                      ),
                      Switch.adaptive(
                        value: secondMust ? secondMust : customsService,
                        activeColor: ColorConfig.warningText,
                        onChanged: (value) {
                          setState(() {
                            customsService = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                line()
              ],
            ),
          ),
          shipLineModel != null || serviceList.isNotEmpty
              ? Column(children: getServiceList())
              : Container(),
        ],
      ),
    );
    return bottomView;
  }

  getServiceList() {
    List<Widget> viewList = [];
    if (serviceList.isNotEmpty) {
      for (ValueAddedServiceModel item in serviceList) {
        String first = '';
        String second = localizationInfo!.currencySymbol +
            (item.price! / 100).toStringAsFixed(2);
        String third = '';
        var view = SizedBox(
          height: 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Caption(str: item.name!),
                        item.remark.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.error_outline_outlined,
                                    color: ColorConfig.warningText,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    showRemark(item.name!, item.remark);
                                  },
                                ),
                              )
                            : Container(),
                        Container(
                          height: 49,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: first,
                                  style: const TextStyle(
                                      color: ColorConfig.textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: ColorConfig.textBlack,
                                    fontSize: 10.0,
                                  ),
                                ),
                                TextSpan(
                                  text: second,
                                  style: const TextStyle(
                                    color: ColorConfig.textRed,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: ColorConfig.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: third,
                                  style: const TextStyle(
                                    color: ColorConfig.textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: item.isOpen,
                      activeColor: ColorConfig.warningText,
                      onChanged: (value) {
                        setState(() {
                          item.isOpen = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              line()
            ],
          ),
        );
        viewList.add(view);
      }
    }
    if (shipLineModel == null) {
      return viewList;
    }
    if (shipLineModel?.region?.services != null) {
      for (ShipLineServiceModel item in shipLineModel!.region!.services!) {
        String first = '';
        String second = '';
        String third = '';
        // 1 运费比例 2固定费用 3单箱固定费用 4单位计费重量固定费用 5单位实际重量固定费用 6申报价值比列
        switch (item.type) {
          case 1:
            first = '实际运费';
            second = (item.value / 100).toStringAsFixed(2) + '%';
            break;
          case 2:
            second = localizationInfo!.currencySymbol +
                (item.value / 100).toStringAsFixed(2);
            break;
          case 3:
            second = localizationInfo!.currencySymbol +
                (item.value / 100).toStringAsFixed(2) +
                '/箱';
            break;
          case 4:
            second = localizationInfo!.currencySymbol +
                (item.value / 100).toStringAsFixed(2) +
                '/' +
                localizationInfo!.weightSymbol;
            third = '(计费重)';
            break;
          case 5:
            second = localizationInfo!.currencySymbol +
                (item.value / 100).toStringAsFixed(2) +
                '/' +
                localizationInfo!.weightSymbol;
            third = '(实重)';
            break;
          case 6:
            second = localizationInfo!.currencySymbol +
                ((item.value / 10000) * (totalValue / 100)).toStringAsFixed(2);
            break;
          default:
        }
        var view = SizedBox(
          height: 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Caption(str: item.name),
                        item.remark.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.error_outline_outlined,
                                    color: ColorConfig.warningText,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    showRemark(item.name, item.remark);
                                  },
                                ),
                              )
                            : Container(),
                        Container(
                          height: 49,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: first,
                                  style: const TextStyle(
                                      color: ColorConfig.textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: ColorConfig.textBlack,
                                    fontSize: 10.0,
                                  ),
                                ),
                                TextSpan(
                                  text: second,
                                  style: const TextStyle(
                                    color: ColorConfig.textRed,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: ColorConfig.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: third,
                                  style: const TextStyle(
                                    color: ColorConfig.textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: item.isForced == 1 ? true : item.isOpen,
                      activeColor: ColorConfig.warningText,
                      onChanged: (value) {
                        setState(() {
                          item.isOpen = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              line()
            ],
          ),
        );
        viewList.add(view);
      }
    }
    return viewList;
  }

  // 订单增值服务、渠道增值服务、关税、保险说明
  showRemark(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: ColorConfig.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 1, color: ColorConfig.white),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Caption(
                    str: title,
                    fontSize: 18,
                  ),
                ),
                line(),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    content,
                  ),
                ),
                line(),
                TextButton(
                  child: const Caption(
                    str: '确定',
                    color: ColorConfig.warningText,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
