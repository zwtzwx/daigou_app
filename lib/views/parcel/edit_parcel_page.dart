/*
  未入库包裹修改页面
*/

import 'package:jiyun_app_client/common/translation.dart';
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
import 'package:jiyun_app_client/models/parcel_goods_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/express_company_service.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/parcel/widget/prop_sheet_cell.dart';
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
  bool isLoadingLocal = false;

  ParcelModel packageModel = ParcelModel();

  String categoriesStr = '';

  // 可能改变的数据
  ExpressCompanyModel? expressCompany;
  CountryModel? countryModel;

  List<GoodsCategoryModel> selectCategories = [];

  List<ExpressCompanyModel> expressCompanyList = [];
  List<GoodsPropsModel> propList = [];
  List<GoodsCategoryModel> categoryList = [];
  List<ValueAddedServiceModel> serviceList = [];
  List<WareHouseModel> wareHouseList = [];

  bool propSingle = false;

  FocusNode blankNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getDetail(widget.arguments['id']);
    created();
  }

  void getDetail(int id) async {
    EasyLoading.show();
    var data = await ParcelService.getDetail(id);
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        packageModel = data;
        if (packageModel.categories != null) {
          if (packageModel.categoriesStr == null) {
            packageModel.categoriesStr = '';
          } else {
            packageModel.categoriesStr = '';
          }
          for (var item in packageModel.categories!) {
            if (packageModel.categoriesStr == null ||
                packageModel.categoriesStr!.isEmpty) {
              packageModel.categoriesStr =
                  packageModel.categoriesStr! + item.name;
            } else {
              packageModel.categoriesStr =
                  packageModel.categoriesStr! + '、' + item.name;
            }
          }
        }
        if (packageModel.country != null) {
          isSelectedCountry = true;
          getWarehouse();
        }
        getPropsList();
        _packgeNameController.text = (packageModel.packageName ?? '');
        _packgeQtyController.text = (packageModel.qty ?? '').toString();
        _packgeValueController.text =
            ((packageModel.packageValue ?? 0) / 100).toStringAsFixed(2);
        _remarkController.text = (packageModel.remark ?? '');
        isLoadingLocal = true;
      });
    }
  }

  /*
    加载
   */
  created() async {
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _single = await GoodsService.getPropConfig();
    var _categoriesList = await GoodsService.getCategoryList();
    setState(() {
      expressCompanyList = _expressCompanyList;
      propSingle = _single;
      categoryList = _categoriesList;
    });
  }

  // 根据国家获取仓库列表
  getWarehouse() async {
    var id = countryModel != null ? countryModel!.id : packageModel.country!.id;
    var data = await WarehouseService.getList({'country_id': id});
    setState(() {
      wareHouseList = data;
    });
  }

  // 根据国家获取属性列表
  getPropsList() async {
    var _propList = await GoodsService.getPropList(
        {'country_id': countryModel?.id ?? packageModel.country?.id});
    setState(() {
      propList = _propList;
    });
  }

  ParcelGoodsModel getGoodsInfo(int index) {
    return ParcelGoodsModel(
      name: '物品${index + 1}',
      qty: 1,
      price: 1,
    );
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
    int packageValue = 0;
    int qty = 0;
    List<String> names = [];
    List<Map> details = [];
    if (packageModel.details != null) {
      for (var item in packageModel.details!) {
        if (item.price == null || item.qty == null || item.name!.isEmpty) {
          msg = '请完善物品信息';
          break;
        }
        item.totalPrice = (item.price! * 100 * item.qty!).toInt();
        packageValue += item.totalPrice!;
        qty += item.qty!;
        names.add(item.name!);
        details.add({
          'name': item.name,
          'total_price': item.totalPrice,
          'qty': item.qty,
        });
      }
      if (msg.isNotEmpty) {
        Util.showToast(Translation.t(context, msg));
        return;
      }
    }
    if (packageModel.details == null && _packgeNameController.text.isEmpty) {
      msg = '请输入物品名称';
    } else if (packageModel.details == null &&
        _packgeValueController.text.isEmpty) {
      msg = '请输入物品总价';
    } else if (packageModel.details == null &&
        double.parse(_packgeValueController.text) <= 0) {
      msg = '请输入正确的物品总价';
    } else if (packageModel.prop == null || packageModel.prop!.isEmpty) {
      msg = '请选择物品属性';
    } else if (countryModel == null && packageModel.country == null) {
      msg = '请选择发往国家';
    }
    if (msg.isNotEmpty) {
      Util.showToast(Translation.t(context, msg));
      return;
    }
    num value = double.parse(_packgeValueController.text) * 100;
    Map<String, dynamic> map = {
      'express_num': packageModel.expressNum,
      'express_id': expressCompany?.id ?? packageModel.id,
      'category_ids': categoryList,
      'package_value': packageModel.details == null ? value : packageValue,
      'package_name': packageModel.details == null
          ? _packgeNameController.text
          : names.join(' '),
      'qty': packageModel.details == null ? _packgeQtyController.text : qty,
      'prop_id': packageModel.prop != null
          ? packageModel.prop!.map((e) => e.id).toList()
          : [],
      'country_id': countryModel != null
          ? countryModel!.id
          : (packageModel.country != null ? packageModel.country!.id : ''),
      'warehouse_id': packageModel.warehouse?.id,
      'remark': _remarkController.text,
    };
    if (details.isNotEmpty) {
      map['details'] = details;
    }
    EasyLoading.show();
    bool data = await ParcelService.update(packageModel.id!, map);
    EasyLoading.dismiss();
    if (data) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'reset'));
      EasyLoading.showSuccess(Translation.t(context, '修改成功')).then((value) {
        Routers.pop(context);
      });
    } else {
      EasyLoading.showError(Translation.t(context, '修改失败'));
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
          title: Caption(
            str: Translation.t(context, '修改包裹'),
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
                child: Column(
                  children: <Widget>[
                    buildTopBox(),
                    Gaps.vGap15,
                    packageModel.status == 1 || packageModel.notConfirmed == 1
                        ? buildBottomBox()
                        : Gaps.empty,
                    Gaps.vGap50,
                    Container(
                      height: 40,
                      width: ScreenUtil().screenWidth - 30,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: MainButton(
                        text: '确认',
                        onPressed: onSubmit,
                      ),
                    ),
                  ],
                ),
              ))
            : Container());
  }

  // 选择快递公司
  onPickerExpressName() {
    Picker(
      adapter:
          PickerDataAdapter(data: getPickerExpressCompany(expressCompanyList)),
      cancelText: Translation.t(context, '取消'),
      confirmText: Translation.t(context, '确认'),
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
      color: ColorConfig.white,
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Caption(
              fontWeight: FontWeight.bold,
              str: Translation.t(context, '商品信息'),
            ),
          ),
          Gaps.line,
          packageModel.details != null
              ? buildGoodsDetails()
              : buildSingleGoods(),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: Translation.t(context, '物品属性'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          // 属性选择框
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return PropSheetCell(
                                  goodsPropsList: propList,
                                  propSingle: propSingle,
                                  prop: packageModel.prop,
                                  onConfirm: (data) {
                                    setState(() {
                                      packageModel.prop = data;
                                    });
                                  },
                                );
                              });
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Caption(
                                  str: packageModel.prop != null
                                      ? packageModel.prop!
                                          .map((e) => e.name)
                                          .join(' ')
                                      : '',
                                  lines: 2,
                                  alignment: TextAlign.right,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorConfig.textGray,
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: Translation.t(context, '商品备注'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: BaseInput(
                  hintText: Translation.t(context, '请输入备注'),
                  controller: _remarkController,
                  focusNode: _remarkNode,
                  contentPadding: const EdgeInsets.all(0),
                  isCollapsed: true,
                  autoShowRemove: false,
                  maxLines: 5,
                  textAlign: TextAlign.right,
                  maxLength: 200,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 没有商品详细清单
  Widget buildSingleGoods() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Caption(
                  str: Translation.t(context, '物品名称'),
                  color: ColorConfig.textNormal,
                ),
              ),
              Expanded(
                  child: BaseInput(
                hintText: Translation.t(context, '请输入物品名称'),
                controller: _packgeNameController,
                focusNode: _packageNameNode,
                contentPadding: const EdgeInsets.all(0),
                isCollapsed: true,
                autoShowRemove: false,
                textAlign: TextAlign.right,
                maxLines: 1,
              )),
            ],
          ),
        ),
        Gaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Caption(
                  str: Translation.t(context, '物品总价'),
                  color: ColorConfig.textNormal,
                ),
              ),
              Expanded(
                  child: BaseInput(
                hintText: Translation.t(context, '请输入物品总价'),
                controller: _packgeValueController,
                focusNode: _packageValueNode,
                contentPadding: const EdgeInsets.all(0),
                isCollapsed: true,
                textAlign: TextAlign.right,
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
        Gaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Caption(
                  str: Translation.t(context, '物品数量'),
                  color: ColorConfig.textNormal,
                ),
              ),
              Expanded(
                  child: BaseInput(
                hintText: Translation.t(context, '请输入物品数量'),
                controller: _packgeQtyController,
                focusNode: _packageQtyNode,
                contentPadding: const EdgeInsets.all(0),
                isCollapsed: true,
                keyboardType: TextInputType.number,
                autoShowRemove: false,
                textAlign: TextAlign.right,
                maxLines: 1,
              )),
              // Caption(
              //   str: packageModel.qty.toString(),
              // )
            ],
          ),
        ),
      ],
    );
  }

  // 商品详细清单
  Widget buildGoodsDetails() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Caption(
                    str: Translation.t(context, '物品名称'),
                    color: ColorConfig.textNormal,
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Caption(
                    str: Translation.t(context, '物品价值'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: Caption(
                    str: Translation.t(context, '数量'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: PlainButton(
                    visualDensity: VisualDensity.compact,
                    text: '添加',
                    onPressed: () {
                      var length = packageModel.details!.length;
                      setState(() {
                        packageModel.details!.add(getGoodsInfo(length));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            itemCount: packageModel.details!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return buildGoodsCell(i, packageModel.details![i]);
            },
          ),
        ],
      ),
    );
  }

  // 包裹内物品
  Widget buildGoodsCell(int index, ParcelGoodsModel model) {
    TextEditingController nameController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    FocusNode nameNode = FocusNode();
    FocusNode qtyNode = FocusNode();
    FocusNode priceNode = FocusNode();

    if (model.name != null) {
      nameController.text = model.name!;
    }
    if (model.qty != null) {
      qtyController.text = model.qty.toString();
    }
    if (model.price != null) {
      priceController.text = model.price.toString();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: ColorConfig.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: BaseInput(
              controller: nameController,
              focusNode: nameNode,
              onChanged: (value) {
                model.name = value;
              },
            ),
            flex: 2,
          ),
          Expanded(
            child: BaseInput(
              controller: priceController,
              focusNode: priceNode,
              showDone: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                if (value.isEmpty) {
                  model.price = null;
                } else {
                  model.price = double.parse(value);
                }
              },
            ),
          ),
          Expanded(
            child: BaseInput(
              controller: qtyController,
              focusNode: qtyNode,
              showDone: false,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isEmpty) {
                  model.qty = null;
                } else {
                  model.qty = int.parse(value);
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
            child: PlainButton(
              visualDensity: VisualDensity.compact,
              borderColor: ColorConfig.textRed,
              textColor: ColorConfig.textRed,
              text: '删除',
              onPressed: () {
                if (packageModel.details!.length == 1) {
                  Util.showToast(Translation.t(context, '至少填写一个物品'));
                  return;
                }
                setState(() {
                  packageModel.details!.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // 发往国家、发往仓库
  Widget buildBottomBox() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Caption(
              fontWeight: FontWeight.bold,
              str: Translation.t(context, '包裹信息'),
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: Translation.t(context, '快递名称'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: onPickerExpressName,
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Caption(
                                str: expressCompany == null
                                    ? packageModel.expressName!
                                    : expressCompany!.name,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorConfig.textGray,
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: Translation.t(context, '快递单号'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: packageModel.expressNum!,
                )
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: Translation.t(context, '发往国家'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          var s = await Navigator.pushNamed(
                              context, '/CountryListPage',
                              arguments: {
                                'warehouseId': packageModel.warehouse?.id,
                              });
                          if (s == null) {
                            return;
                          }
                          setState(() {
                            countryModel = s as CountryModel;
                            isSelectedCountry = true;
                            packageModel.prop = null;
                            if (packageModel.status == 1 ||
                                (packageModel.status == 2 &&
                                    packageModel.warehouse == null)) {
                              packageModel.warehouse = null;
                              getWarehouse();
                            }
                            getPropsList();
                          });
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Caption(
                                  str: countryModel == null
                                      ? (packageModel.country != null
                                          ? packageModel.country!.name!
                                          : '')
                                      : countryModel!.name!),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorConfig.textGray,
                              ),
                            ],
                          ),
                        )))
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    str: Translation.t(context, '发往仓库'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if ((packageModel.status == 2 &&
                              packageModel.warehouse != null)) {
                            return;
                          }
                          Picker(
                            adapter: PickerDataAdapter(
                                data: getPickerWareHouse(wareHouseList)),
                            cancelText: Translation.t(context, '取消'),
                            confirmText: Translation.t(context, '确认'),
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                            onCancel: () {},
                            onConfirm: (Picker picker, List value) {
                              setState(() {
                                packageModel.warehouse =
                                    wareHouseList[value.first];
                              });
                            },
                          ).showModal(context);
                        },
                        child: Container(
                          color: ColorConfig.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Caption(
                                  str: packageModel.warehouse?.warehouseName ??
                                      ''),
                              (packageModel.status == 1 ||
                                      (packageModel.status == 2 &&
                                          packageModel.warehouse == null))
                                  ? const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: ColorConfig.textGray,
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
