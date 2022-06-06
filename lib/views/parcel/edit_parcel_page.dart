/*
  未入库包裹修改页面
*/

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/express_company_service.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditParcelPage extends StatefulWidget {
  final Map arguments;

  const EditParcelPage({Key? key, required this.arguments}) : super(key: key);
  @override
  EditParcelPageState createState() => EditParcelPageState();
}

class EditParcelPageState extends State<EditParcelPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _packgeNameController = TextEditingController();
  final FocusNode _packageNameNode = FocusNode();
  final TextEditingController _packgeValueController = TextEditingController();
  final FocusNode _packageValueNode = FocusNode();
  final TextEditingController _packgeQtyController = TextEditingController();
  final FocusNode _packageQtyNode = FocusNode();

  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkNode = FocusNode();
  bool isSelectedCountry = false;

  LocalizationModel? localizationInfo;
  bool isLoading = false;
  bool isLoadingLocal = false;

  ParcelModel packageModel = ParcelModel();

  String categoriesStr = '';

  // 可能改变的数据
  ExpressCompanyModel? expressCompany;
  CountryModel? countryModel;
  WareHouseModel? wareHouseModel;

  String remarkStr = '';
  GoodsPropsModel? propModel;
  List<GoodsCategoryModel> selectCategories = [];

  List<ExpressCompanyModel> expressCompanyList = [];
  List<GoodsPropsModel> propList = [];
  List<GoodsCategoryModel> categoryList = [];
  List<ValueAddedServiceModel> serviceList = [];
  List<WareHouseModel> wareHouseList = [];

  bool isRequest = false;
  bool isButtonEnable = true;

  FocusNode blankNode = FocusNode();

  @override
  void initState() {
    super.initState();
    packageModel = widget.arguments['model'];
    if (packageModel.categories != null) {
      if (packageModel.categoriesStr == null) {
        packageModel.categoriesStr = '';
      } else {
        packageModel.categoriesStr = '';
      }
      for (var item in packageModel.categories!) {
        if (packageModel.categoriesStr == null ||
            packageModel.categoriesStr!.isEmpty) {
          packageModel.categoriesStr = packageModel.categoriesStr! + item.name;
        } else {
          packageModel.categoriesStr =
              packageModel.categoriesStr! + '、' + item.name;
        }
      }
    }
    _packgeNameController.text = (packageModel.packageName ?? '');
    _packgeQtyController.text = (packageModel.qty ?? '').toString();
    _packgeValueController.text =
        ((packageModel.packageValue ?? 0) / 100).toStringAsFixed(2);
    _remarkController.text = (packageModel.remark ?? '');

    created();
  }

  /*
    加载
   */
  created() async {
    EasyLoading.show();
    var _expressCompanyList = await ExpressCompanyService.getList();

    var _propList = await GoodsService.getPropList();

    var _categoriesList = await GoodsService.getCategoryList();
    EasyLoading.dismiss();
    setState(() {
      expressCompanyList = _expressCompanyList;
      propList = _propList;
      categoryList = _categoriesList;
      isLoadingLocal = true;
    });
  }

  @override
  bool get wantKeepAlive => true;

  // 修改包裹信息
  onSubmit() async {
    // 包裹类型
    List<int> categoryList = [];
    if (selectCategories.isNotEmpty) {
      for (GoodsCategoryModel item in selectCategories) {
        categoryList.add(item.id);
      }
    } else {
      for (GoodsCategoryModel item in packageModel.categories!) {
        categoryList.add(item.id);
      }
    }
    String msg = '';
    if (_packgeNameController.text.isEmpty) {
      msg = '请输入包裹名称';
    } else if (_packgeValueController.text.isEmpty) {
      msg = '请输入包裹价值';
    } else if (double.parse(_packgeValueController.text) <= 0) {
      msg = '请输入正确的包裹价值';
    } else if (propModel == null && packageModel.prop!.isEmpty) {
      msg = '请选择包裹属性';
    } else if (countryModel == null && packageModel.country == null) {
      msg = '请选择发往国家';
    }
    if (msg.isNotEmpty) {
      Util.showToast(msg);
      return;
    }
    num value = double.parse(_packgeValueController.text) * 100;
    Map<String, dynamic> map = {
      'express_num': packageModel.expressNum,
      'express_id': expressCompany?.id ?? packageModel.id,
      'category_ids': categoryList,
      'package_value': value,
      'package_name': _packgeNameController.text,
      'qty': _packgeQtyController.text,
      'prop_id': propModel?.id == null
          ? [packageModel.prop!.first.id]
          : [propModel!.id],
      'country_id': countryModel != null
          ? countryModel!.id
          : (packageModel.country != null ? packageModel.country!.id : ''),
      'warehouse_id': wareHouseModel == null
          ? packageModel.warehouse!.id!
          : wareHouseModel!.id!,
      'remark': _remarkController.text,
    };
    EasyLoading.show();
    bool data = await ParcelService.update(packageModel.id!, map);
    EasyLoading.dismiss();
    if (data) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'reset'));
      EasyLoading.showSuccess('修改成功').then((value) {
        Routers.pop(context);
      });
    } else {
      EasyLoading.showError('修改失败');
    }
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
            str: '修改包裹',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isLoadingLocal
            ? SingleChildScrollView(
                child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      buildTopBox(),
                      buildMiddleBox(),
                      buildBottomBox(),
                      Gaps.vGap50,
                      Container(
                        height: 40,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: MainButton(
                          text: '确认',
                          onPressed: onSubmit,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 15),
                        child: MainButton(
                          text: '取消',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            Routers.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            : Container());
  }

  // 选择快递公司
  onPickerExpressName() {
    Picker(
      adapter:
          PickerDataAdapter(data: getPickerExpressCompany(expressCompanyList)),
      cancelText: '取消',
      confirmText: '确认',
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        setState(() {
          expressCompany = expressCompanyList[value.first];
        });
      },
    ).showModal(context);
  }

  // 快递单号、快递公司
  Widget buildTopBox() {
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 100,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '快递名称',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: onPickerExpressName,
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                str: expressCompany == null
                                    ? packageModel.expressName!
                                    : expressCompany!.name,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorConfig.textGray,
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '快递单号',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: packageModel.expressNum!,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 包裹基本信息
  Widget buildMiddleBox() {
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '包裹名称',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: BaseInput(
                  hintText: '请输入包裹名称',
                  controller: _packgeNameController,
                  focusNode: _packageNameNode,
                  contentPadding: const EdgeInsets.all(0),
                  isCollapsed: true,
                  autoShowRemove: false,
                  maxLines: 1,
                )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: '包裹价值' + (localizationInfo!.currencySymbol),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: BaseInput(
                  hintText: '请输入包裹价值',
                  controller: _packgeValueController,
                  focusNode: _packageValueNode,
                  contentPadding: const EdgeInsets.all(0),
                  isCollapsed: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autoShowRemove: false,
                  maxLines: 1,
                )),
                // Caption(
                //     str: (packageModel.packageValue! / 100).toStringAsFixed(2))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '包裹数量',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: BaseInput(
                  hintText: '请输入包裹数量',
                  controller: _packgeQtyController,
                  focusNode: _packageQtyNode,
                  contentPadding: const EdgeInsets.all(0),
                  isCollapsed: true,
                  keyboardType: TextInputType.number,
                  autoShowRemove: false,
                  maxLines: 1,
                )),
                // Caption(
                //   str: packageModel.qty.toString(),
                // )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '包裹类型',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          var s = await Navigator.pushNamed(
                              context, '/CategoriesPage',
                              arguments: {
                                "categories": categoryList //参数map
                              });
                          if (s == null) {
                            return;
                          } else {
                            selectCategories = s as List<GoodsCategoryModel>;
                            packageModel.categoriesStr = '';
                            setState(() {
                              for (GoodsCategoryModel item
                                  in selectCategories) {
                                if (packageModel.categoriesStr == null ||
                                    packageModel.categoriesStr!.isEmpty) {
                                  packageModel.categoriesStr = item.name;
                                } else {
                                  packageModel.categoriesStr =
                                      packageModel.categoriesStr! +
                                          '、' +
                                          item.name;
                                }
                              }
                            });
                          }
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                str: packageModel.categoriesStr!,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorConfig.textGray,
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '包裹属性',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          // 属性选择框
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                int selectPropIndex = 999;
                                return StatefulBuilder(
                                    builder: (context1, setBottomSheetState) {
                                  return SizedBox(
                                      height: 320,
                                      child: Column(children: <Widget>[
                                        Container(
                                          height: 44,
                                          margin:
                                              const EdgeInsets.only(left: 15),
                                          alignment: Alignment.centerLeft,
                                          child: const Caption(
                                            str: '包裹属性',
                                            fontSize: 19,
                                          ),
                                        ),
                                        Gaps.line,
                                        Container(
                                          height: 190,
                                          margin: const EdgeInsets.only(
                                              right: 20, left: 20, top: 20),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing:
                                                    20.0, //水平子Widget之间间距
                                                mainAxisSpacing:
                                                    20.0, //垂直子Widget之间间距
                                                crossAxisCount: 3, //一行的Widget数量
                                                childAspectRatio: 2.6,
                                              ), // 宽高比例
                                              itemCount: propList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                GoodsPropsModel propmodel =
                                                    propList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    setBottomSheetState(() {
                                                      selectPropIndex = index;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: selectPropIndex ==
                                                                    999 &&
                                                                packageModel
                                                                        .prop !=
                                                                    null &&
                                                                packageModel
                                                                        .prop!
                                                                        .first ==
                                                                    propList[
                                                                        index]
                                                            ? ColorConfig
                                                                .warningText
                                                            : selectPropIndex ==
                                                                    index
                                                                ? ColorConfig
                                                                    .warningText
                                                                : ColorConfig
                                                                    .white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    4.0)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: ColorConfig
                                                                .line)),
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Caption(
                                                          str: propmodel.name!,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (selectPropIndex != 999) {
                                                  propModel =
                                                      propList[selectPropIndex];
                                                }
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15, left: 15),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorConfig.warningText,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: ColorConfig
                                                          .warningText)),
                                              alignment: Alignment.center,
                                              height: 40,
                                              child: const Caption(
                                                str: '确定',
                                              ),
                                            )),
                                      ]));
                                });
                              });
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                  str: propModel == null
                                      ? (packageModel.prop!.isNotEmpty
                                          ? packageModel.prop!.first.name!
                                          : '')
                                      : propModel!.name!),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorConfig.textGray,
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 90,
                  // height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Caption(
                    str: '包裹备注',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: BaseInput(
                  hintText: '请输入备注',
                  controller: _remarkController,
                  focusNode: _remarkNode,
                  contentPadding: const EdgeInsets.all(0),
                  isCollapsed: true,
                  autoShowRemove: false,
                  maxLines: 5,
                  maxLength: 200,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 发往国家、发往仓库
  Widget buildBottomBox() {
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 80,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 0),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  child: const Caption(
                    str: '发往国家',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          var s = await Navigator.pushNamed(
                              context, '/CountryListPage');
                          if (s == null) {
                            return;
                          }
                          setState(() {
                            countryModel = s as CountryModel;
                            isSelectedCountry = true;
                          });
                          EasyLoading.show(status: '获取仓库列表...');
                          var data99 = await WarehouseService.getList(
                              {'country_id': countryModel!.id});
                          EasyLoading.dismiss();
                          wareHouseList = data99;
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                  str: countryModel == null
                                      ? (packageModel.country != null
                                          ? packageModel.country!.name!
                                          : '')
                                      : countryModel!.name!),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorConfig.textGray,
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, top: 0),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  child: const Caption(
                    str: '发往仓库',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (isSelectedCountry) {
                            return;
                          }
                          Picker(
                            adapter: PickerDataAdapter(
                                data: getPickerWareHouse(wareHouseList)),
                            cancelText: '取消',
                            confirmText: '确认',
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                            onCancel: () {},
                            onConfirm: (Picker picker, List value) {
                              setState(() {
                                wareHouseModel = wareHouseList[value.first];
                              });
                            },
                          ).showModal(this.context);
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                  str: wareHouseModel == null
                                      ? packageModel.warehouse!.warehouseName!
                                      : wareHouseModel!.warehouseName!),
                              isSelectedCountry
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: ColorConfig.textGray,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )))
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildChosenServiceView() {
    List<Widget> listWidget = [];
    for (var item in packageModel.chosenService!) {
      var con = SizedBox(
        height: 20,
        child: Caption(
          str: item['content'],
        ),
      );
      listWidget.add(con);
    }
    return listWidget;
  }

  getPickerExpressCompany(List<ExpressCompanyModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: Caption(
          fontSize: 24,
          str: item.name,
        ),
      );
      data.add(containe);
    }
    return data;
  }

  getPickerWareHouse(List<WareHouseModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: Caption(
          fontSize: 24,
          str: item.warehouseName!,
        ),
      );
      data.add(containe);
    }
    return data;
  }
}
