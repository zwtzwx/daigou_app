/*
  收件地址编辑
 */

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/receiver_address_refresh_event.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/services/address_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';

class ReceiverAddressEditPage extends StatefulWidget {
  final Map? arguments;
  const ReceiverAddressEditPage({Key? key, this.arguments}) : super(key: key);

  @override
  ReceiverAddressEditPageState createState() => ReceiverAddressEditPageState();
}

class ReceiverAddressEditPageState extends State<ReceiverAddressEditPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final textEditingController = TextEditingController();

// 收件人
  String recipientName = "";
// 电话区号
  String mobilArea = "请选择电话区号";
// 联系电话
  String mobileNumber = "";
// 国家/地区
  String country = "请选择国家/地区";
// 城市
  String cityName = "";
// 街道
  String streetName = "";
// 邮编
  String zipCode = "";
// 门牌号
  String doorNumber = "";

  // 收件人
  final TextEditingController _recipientNameController =
      TextEditingController();
  final FocusNode _recipientName = FocusNode();
  // 联系电话
  final TextEditingController _mobileNumberController = TextEditingController();
  final FocusNode _mobileNumber = FocusNode();
  // 邮编
  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode _zipCode = FocusNode();
  // 邮箱
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailNumber = FocusNode();
  // 州/省
  final TextEditingController _stateORprovinceController =
      TextEditingController();
  final FocusNode _stateORprovince = FocusNode();
  // 城市
  final TextEditingController _cityNameController = TextEditingController();
  final FocusNode _cityName = FocusNode();
  // 详细地址
  final TextEditingController _streetNameController = TextEditingController();

  final FocusNode _streetName = FocusNode();

  FocusNode blankNode = FocusNode();

  ReceiverAddressModel model = ReceiverAddressModel.empty();
  bool isEdit = false;

  CountryModel countryModel = CountryModel();
  AreaModel? areaModel;
  AreaModel? subAreaModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      //如果是编辑
      if (widget.arguments?['isEdit'] == '1') {
        isEdit = true;
        model = widget.arguments?['address'] as ReceiverAddressModel;
        _recipientNameController.text = model.receiverName;
        _mobileNumberController.text = model.phone;
        _emailController.text = model.email;
        _zipCodeController.text = model.postcode;
        if (model.area != null) {
          areaModel = model.area;
          if (model.subArea != null) {
            subAreaModel = model.subArea;
          }
        } else {
          _stateORprovinceController.text = model.province;
          _cityNameController.text = model.city;
        }
        _streetNameController.text = model.address ?? '';
      } else {
        model.phone = '';
        model.receiverName = '';
        model.timezone = '';
        model.city = '';
        model.countryId = 999;
        model.street = '';
        model.postcode = '';
        model.doorNo = '';
        model.isDefault = 0;
      }
    });
    if (isEdit) {
      getCountryData();
    }
  }

  /*
    得到国家数据
   */
  getCountryData() async {
    List<AlphabeticalCountryModel> alphaListModel =
        await CommonService.getCountryListByAlphabetical();

    for (AlphabeticalCountryModel alphaModel in alphaListModel) {
      for (CountryModel cmodel in alphaModel.items) {
        if (cmodel.id == model.country!.id) {
          setState(() {
            countryModel = cmodel;
          });
        }
      }
    }
  }

  onDelete() async {
    bool? data = await onDeleteAlter();
    if (data != null) {
      EasyLoading.show();
      var result = await AddressService.deleteReciever(model.id!);
      EasyLoading.dismiss();
      if (result) {
        Navigator.pop(context);
        ApplicationEvent.getInstance()
            .event
            .fire(ReceiverAddressRefreshEvent());
      } else {
        EasyLoading.showError('删除失败');
      }
    }
  }

  // 删除地址
  Future<bool?> onDeleteAlter() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认要删除地址'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '添加地址',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        bottomNavigationBar: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                height: isEdit ? 110 : 50,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          const EdgeInsets.only(right: 15, left: 15, top: 10),
                      height: 40,
                      width: double.infinity,
                      child: MainButton(
                        text: '确认提交',
                        onPressed: onUpdateClick,
                      ),
                    ),
                    isEdit
                        ? Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 10),
                            width: double.infinity,
                            height: 40,
                            child: MainButton(
                              text: '删除',
                              backgroundColor: Colors.white,
                              onPressed: onDelete,
                              textColor: ColorConfig.textRed,
                            ),
                          )
                        : Container(),
                  ],
                ))),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                InputTextItem(
                    title: "收件人",
                    inputText: NormalInput(
                      hintText: "请输入收件人名字",
                      textAlign: TextAlign.left,
                      contentPadding: const EdgeInsets.only(top: 17),
                      controller: _recipientNameController,
                      focusNode: _recipientName,
                      maxLength: 40,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(_mobileNumber);
                      },
                      onChanged: (res) {
                        model.receiverName = res;
                      },
                    )),
                GestureDetector(
                  onTap: () async {
                    var s =
                        await Navigator.pushNamed(context, '/CountryListPage');
                    CountryModel a = s as CountryModel;
                    if (a == null) {
                      return;
                    }
                    setState(() {
                      model.timezone = a.timezone!;
                    });
                  },
                  child: InputTextItem(
                      title: "电话区号",
                      inputText: Container(
                        padding: const EdgeInsets.only(right: 15, left: 0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Caption(
                              str: model.timezone == null ||
                                      model.timezone.isEmpty
                                  ? "请选择电话区号"
                                  : model.timezone,
                              color: model.timezone == null ||
                                      model.timezone.isEmpty
                                  ? ColorConfig.textGray
                                  : ColorConfig.textDark,
                              fontSize: 14,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ],
                        ),
                      )),
                ),
                InputTextItem(
                    title: "联系电话",
                    inputText: NormalInput(
                      hintText: "请输入收件人电话",
                      textAlign: TextAlign.left,
                      contentPadding: const EdgeInsets.only(top: 17),
                      maxLength: 20,
                      controller: _mobileNumberController,
                      focusNode: _mobileNumber,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(_zipCode);
                      },
                      onChanged: (res) {
                        model.phone = res;
                      },
                    )),
                Gaps.line,
                InputTextItem(
                    title: "邮编",
                    inputText: NormalInput(
                      hintText: "请输入邮编",
                      contentPadding: const EdgeInsets.only(top: 17),
                      textAlign: TextAlign.left,
                      controller: _zipCodeController,
                      focusNode: _zipCode,
                      maxLength: 20,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(_emailNumber);
                      },
                      onChanged: (res) {
                        model.postcode = res;
                      },
                    )),
                InputTextItem(
                    title: "邮箱",
                    inputText: NormalInput(
                      hintText: "请输入邮箱",
                      contentPadding: const EdgeInsets.only(top: 17),
                      textAlign: TextAlign.left,
                      controller: _emailController,
                      focusNode: _emailNumber,
                      maxLength: 40,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(_stateORprovince);
                      },
                      onChanged: (res) {
                        model.email = res;
                      },
                    )),
                GestureDetector(
                  onTap: () async {
                    var s =
                        await Navigator.pushNamed(context, '/CountryListPage');
                    if (s == null) {
                      return;
                    }
                    CountryModel a = s as CountryModel;

                    setState(() {
                      countryModel = a;
                      areaModel = null;
                      subAreaModel = null;
                    });
                  },
                  child: InputTextItem(
                      title: "国家",
                      inputText: Container(
                        padding: const EdgeInsets.only(right: 15, left: 0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Caption(
                              str: countryModel.name == null
                                  ? '请选择国家'
                                  : countryModel.name!,
                              color: countryModel.name == null
                                  ? ColorConfig.textGray
                                  : ColorConfig.textDark,
                              fontSize: 16,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ],
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () async {
                    showPickerDestion(context);
                  },
                  child: InputTextItem(
                      height: (countryModel.areas == null ||
                              countryModel.areas!.isEmpty)
                          ? 0
                          : 55,
                      title: "省/市",
                      inputText: Container(
                        padding: const EdgeInsets.only(right: 15, left: 0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Caption(
                              str: areaModel?.id == null
                                  ? '请选择省/市'
                                  : subAreaModel?.id == null
                                      ? areaModel!.name
                                      : areaModel!.name +
                                          ' ' +
                                          subAreaModel!.name,
                              color: areaModel?.id == null
                                  ? ColorConfig.textGray
                                  : ColorConfig.textDark,
                              fontSize: 16,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: areaModel?.id == null
                                  ? ColorConfig.textGray
                                  : ColorConfig.textDark,
                            ),
                          ],
                        ),
                      )),
                ),
                InputTextItem(
                    height: (countryModel.areas == null ||
                            countryModel.areas!.isEmpty)
                        ? 55
                        : 0,
                    title: "州/省",
                    inputText: NormalInput(
                      contentPadding: const EdgeInsets.only(top: 17),
                      hintText: "请输入州/省",
                      textAlign: TextAlign.left,
                      controller: _stateORprovinceController,
                      focusNode: _stateORprovince,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(_cityName);
                      },
                      onChanged: (res) {
                        model.province = res;
                      },
                    )),
                InputTextItem(
                    height: countryModel.areas == null ? 55 : 0,
                    title: "城市",
                    inputText: NormalInput(
                      contentPadding: const EdgeInsets.only(top: 17),
                      hintText: "请输入城市",
                      textAlign: TextAlign.left,
                      controller: _cityNameController,
                      focusNode: _cityName,
                      maxLength: 30,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(_streetName);
                      },
                      onChanged: (res) {
                        model.city = res;
                      },
                    )),
                InputTextItem(
                    title: "详细地址",
                    inputText: NormalInput(
                      hintText: "请输详细地址",
                      contentPadding: const EdgeInsets.only(top: 17),
                      textAlign: TextAlign.left,
                      controller: _streetNameController,
                      focusNode: _streetName,
                      maxLength: 50,
                      autoFocus: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (res) {
                        FocusScope.of(context).requestFocus(blankNode);
                      },
                      onChanged: (res) {
                        model.address = res;
                      },
                    )),
                Gaps.vGap15,
                InputTextItem(
                  title: "设为默认地址",
                  inputText: Container(
                    padding: const EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: Switch.adaptive(
                      value: model.isDefault == 1,
                      activeColor: ColorConfig.warningText,
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            model.isDefault = 1;
                          } else {
                            model.isDefault = 0;
                          }
                        });
                      },
                    ),
                  ),
                ),
                Gaps.vGap15,
              ],
            ),
          ),
        ));
  }

  onUpdateClick() async {
    if (model.receiverName == '') {
      Util.showToast('请填写收货人');
      return;
    }

    if (model.timezone == '') {
      Util.showToast('请选择区号');
      return;
    }

    if (model.phone == '') {
      Util.showToast('请填写电话号码');
      return;
    }

    if (countryModel.id == null) {
      Util.showToast('请选择国家');
      return;
    }

    if (countryModel.areas != null && countryModel.areas!.isNotEmpty) {
      if (areaModel?.id == null) {
        Util.showToast('请选择省/市');
        return;
      }
    }
    Map<String, dynamic> data;
    if (countryModel.areas != null && countryModel.areas!.isNotEmpty) {
      // 国家有子区域
      data = {
        'receiver_name': model.receiverName,
        'timezone': model.timezone,
        'phone': model.phone,
        'email': model.email,
        'is_default': model.isDefault,
        'address': model.address,
        'country_id': countryModel.id,
        'postcode': model.postcode,
        'area_id': areaModel?.id,
        'sub_area_id': subAreaModel?.id,
      };
    } else {
      // 国家无子区域
      data = {
        'receiver_name': model.receiverName,
        'timezone': model.timezone,
        'phone': model.phone,
        'email': model.email,
        'province': model.province,
        'is_default': model.isDefault,
        'address': model.address,
        'country_id': countryModel.id,
        'city': model.city,
        'postcode': model.postcode,
      };
    }

    // List updataList = [];
    // if (isEdit) {
    //   updataList.add({
    //     'id': model.id,
    //   });
    //   updataList.add(data);
    // } else {
    //   updataList.add(data);
    // }
    Map result = {};
    if (isEdit) {
      result = await AddressService.updateReciever(model.id!, data);
    } else {
      result = await AddressService.addReciever(data);
    }
    EasyLoading.dismiss();
    if (result['ok']) {
      EasyLoading.showSuccess(result['msg']);
      Navigator.of(context).pop();
      ApplicationEvent.getInstance().event.fire(ReceiverAddressRefreshEvent());
    } else {
      EasyLoading.showError(result['msg']);
    }
  }

  @override
  bool get wantKeepAlive => true;

  showPickerDestion(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerSubView()),
      title: const Text("选择区域"),
      cancelText: '取消',
      confirmText: '确认',
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {
        // showPicker = false;
      },
      onConfirm: (Picker picker, List value) {
        setState(() {
          areaModel = countryModel.areas![value.first];
          subAreaModel = countryModel.areas![value.first].areas![value.last];
        });
      },
    ).showModal(this.context);
  }

  getPickerSubView() {
    List<PickerItem> data = [];
    for (var item in countryModel.areas!) {
      var containe = PickerItem(
          text: Caption(
            fontSize: 24,
            str: item.name,
          ),
          children: getSubAreaViews(item));
      data.add(containe);
    }
    return data;
  }

  getSubAreaViews(AreaModel areasitem) {
    List<PickerItem> subList = [];
    for (var item in areasitem.areas!) {
      var subArea = PickerItem(
        text: Caption(
          fontSize: 24,
          str: item.name,
        ),
      );
      subList.add(subArea);
    }
    return subList;
  }
}
