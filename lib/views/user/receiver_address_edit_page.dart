/*
  收件地址编辑
 */

import 'package:jiyun_app_client/common/translation.dart';
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
import 'package:jiyun_app_client/views/components/base_dialog.dart';
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
  final TextEditingController _recipientNameController =
      TextEditingController();
  final FocusNode _recipientName = FocusNode();
  // 联系电话
  final TextEditingController _mobileNumberController = TextEditingController();
  final FocusNode _mobileNumber = FocusNode();
  // 邮编
  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode _zipCode = FocusNode();

  // 详细地址
  final TextEditingController _streetNameController = TextEditingController();
  final FocusNode _streetName = FocusNode();
  final TextEditingController _doorNoController = TextEditingController();
  final FocusNode _doorNoNode = FocusNode();
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityNode = FocusNode();

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
        _zipCodeController.text = model.postcode;
        _streetNameController.text = model.street;
        _cityController.text = model.city;
        _doorNoController.text = model.doorNo;
        if (model.area != null) {
          areaModel = model.area;
          if (model.subArea != null) {
            subAreaModel = model.subArea;
          }
        }
      } else {
        model.phone = '';
        model.receiverName = '';
        model.timezone = '';
        model.city = '';
        model.countryId = 999;
        model.street = '';
        model.postcode = '';
        model.doorNo = '';
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
        EasyLoading.showSuccess(Translation.t(context, '删除成功')).then((value) {
          ApplicationEvent.getInstance()
              .event
              .fire(ReceiverAddressRefreshEvent());
          Navigator.pop(context);
        });
      } else {
        EasyLoading.showError(Translation.t(context, '删除失败'));
      }
    }
  }

  // 删除地址
  Future<bool?> onDeleteAlter() {
    return BaseDialog.confirmDialog(context, '确认要删除地址吗');
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
          title: ZHTextLine(
            str: Translation.t(context, !isEdit ? '添加地址' : '修改地址'),
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
            child: buildAddressContent(),
          ),
        ));
  }

  Widget buildAddressContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTextItem(
          title: Translation.t(context, '收件人'),
          inputText: NormalInput(
            hintText: Translation.t(context, '请输入收件人名字'),
            textAlign: TextAlign.right,
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            controller: _recipientNameController,
            focusNode: _recipientName,
            maxLength: 40,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_mobileNumber);
            },
            onChanged: (res) {
              model.receiverName = res;
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            var s = await Navigator.pushNamed(context, '/CountryListPage');
            if (s == null) return;
            CountryModel a = s as CountryModel;
            setState(() {
              model.timezone = a.timezone!;
            });
          },
          child: InputTextItem(
            title: Translation.t(context, '电话区号'),
            inputText: Container(
              padding: const EdgeInsets.only(right: 15, left: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ZHTextLine(
                    str: model.timezone.isEmpty
                        ? Translation.t(context, '请选择电话区号')
                        : model.timezone,
                    color: model.timezone.isEmpty
                        ? ColorConfig.textGray
                        : ColorConfig.textDark,
                    fontSize: 14,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ColorConfig.textGray,
                  ),
                ],
              ),
            ),
          ),
        ),
        InputTextItem(
          title: Translation.t(context, '联系电话'),
          inputText: NormalInput(
            hintText: Translation.t(context, '请输入联系电话'),
            textAlign: TextAlign.right,
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            maxLength: 20,
            controller: _mobileNumberController,
            focusNode: _mobileNumber,
            keyboardType: TextInputType.phone,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_zipCode);
            },
            onChanged: (res) {
              model.phone = res;
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            var s = await Navigator.pushNamed(context, '/CountryListPage');
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
            title: Translation.t(context, '国家地区'),
            inputText: Container(
              padding: const EdgeInsets.only(right: 15, left: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ZHTextLine(
                    str: countryModel.name == null
                        ? Translation.t(context, '请选择国家地区')
                        : countryModel.name!,
                    color: countryModel.name == null
                        ? ColorConfig.textGray
                        : ColorConfig.textDark,
                    fontSize: 14,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ColorConfig.textGray,
                  ),
                ],
              ),
            ),
          ),
        ),
        InputTextItem(
          title: Translation.t(context, '邮编'),
          inputText: NormalInput(
            hintText: Translation.t(context, '请输入邮编'),
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            textAlign: TextAlign.right,
            controller: _zipCodeController,
            focusNode: _zipCode,
            maxLength: 20,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_doorNoNode);
            },
            onChanged: (res) {
              model.postcode = res;
            },
          ),
        ),
        InputTextItem(
          title: Translation.t(context, '门牌号'),
          inputText: NormalInput(
            hintText: Translation.t(context, '请输入门牌号'),
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            textAlign: TextAlign.right,
            controller: _doorNoController,
            focusNode: _doorNoNode,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_streetName);
            },
            onChanged: (res) {
              model.doorNo = res;
            },
          ),
        ),
        InputTextItem(
          title: Translation.t(context, '街道'),
          inputText: NormalInput(
            hintText: Translation.t(context, '请输入街道'),
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            textAlign: TextAlign.right,
            controller: _streetNameController,
            focusNode: _streetName,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_cityNode);
            },
            onChanged: (res) {
              model.street = res;
            },
          ),
        ),
        InputTextItem(
          title: Translation.t(context, '城市'),
          inputText: NormalInput(
            hintText: Translation.t(context, '请输入城市'),
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            textAlign: TextAlign.right,
            controller: _cityController,
            focusNode: _cityNode,
            onChanged: (res) {
              model.postcode = res;
            },
          ),
        ),
      ],
    );
  }

  onUpdateClick() async {
    if (model.receiverName == '') {
      Util.showToast(Translation.t(context, '请输入收件人名字'));
      return;
    }

    if (model.timezone == '') {
      Util.showToast(Translation.t(context, '请选择电话区号'));
      return;
    }

    if (model.phone == '') {
      Util.showToast(Translation.t(context, '请输入收件人电话'));
      return;
    }

    if (countryModel.id == null) {
      Util.showToast(Translation.t(context, '请选择国家地区'));
      return;
    }

    Map<String, dynamic> data = {
      'receiver_name': model.receiverName,
      'timezone': model.timezone,
      'phone': model.phone,
      'street': model.street,
      'door_no': model.doorNo,
      'city': model.city,
      'country_id': countryModel.id,
      'postcode': model.postcode,
      'area_id': areaModel?.id ?? '',
      'sub_area_id': subAreaModel?.id ?? '',
    };
    EasyLoading.show();
    Map result = {};
    if (isEdit) {
      result = await AddressService.updateReciever(model.id!, data);
    } else {
      result = await AddressService.addReciever(data);
    }
    EasyLoading.dismiss();
    if (result['ok']) {
      EasyLoading.showSuccess(result['msg']).then((value) {
        ApplicationEvent.getInstance()
            .event
            .fire(ReceiverAddressRefreshEvent());
        Navigator.of(context).pop();
      });
    } else {
      EasyLoading.showError(result['msg']);
    }
  }

  @override
  bool get wantKeepAlive => true;

  showPickerDestion(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerSubView()),
      title: Text(Translation.t(context, '选择区域')),
      cancelText: Translation.t(context, '取消'),
      confirmText: Translation.t(context, '确认'),
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
          text: ZHTextLine(
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
        text: ZHTextLine(
          fontSize: 24,
          str: item.name,
        ),
      );
      subList.add(subArea);
    }
    return subList;
  }
}
