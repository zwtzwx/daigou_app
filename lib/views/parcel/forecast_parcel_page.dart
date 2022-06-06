import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/express_company_service.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/localization_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

/*
  包裹预报
*/

class ForcastParcelPage extends StatefulWidget {
  const ForcastParcelPage({Key? key}) : super(key: key);

  @override
  ForcastParcelPageState createState() => ForcastParcelPageState();
}

class ForcastParcelPageState extends State<ForcastParcelPage> {
  ScrollController scrollController = ScrollController();
  final textEditingController = TextEditingController();
  FocusNode blankNode = FocusNode();
  CountryModel? selectedCountryModel;
  WareHouseModel? selectedWarehouseModel;

  //预报的包裹列表
  List<ParcelModel> formData = List<ParcelModel>.empty(growable: true);

  String selectCountry = '请选择发往国家';
  String selectWareHouse = '请选择发往仓库';
  // 协议确认
  bool agreementBool = false;
  // 协议条款
  Map<String, dynamic>? terms;
  //单位，长度
  LocalizationModel? localization;
  //快递公司
  List<ExpressCompanyModel> expressCompanyList =
      List<ExpressCompanyModel>.empty(growable: true);
  //商品属性
  List<GoodsPropsModel> goodsPropsList =
      List<GoodsPropsModel>.empty(growable: true);
  //商品分类
  List<GoodsCategoryModel> goodsCategoryList =
      List<GoodsCategoryModel>.empty(growable: true);
  //预报服务
  List<ValueAddedServiceModel> valueAddedServiceList =
      List<ValueAddedServiceModel>.empty(growable: true);
  //仓库列表
  List<WareHouseModel> wareHouseList = [];
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      loadInitData();
    });
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      Routers.push('/LoginPage', context);
    });
  }

  //加载页面所需要的数据
  loadInitData() async {
    EasyLoading.show();
    var _localization = await LocalizationService.getInfo();
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _goodsPropsList = await GoodsService.getPropList();
    var _goodsCategoryList = await GoodsService.getCategoryList();
    var _valueAddedServiceList = await ParcelService.getValueAddedServiceList();
    var _terms = await CommonService.getTerms();
    formData.add(ParcelModel());
    if (mounted) {
      setState(() {
        localization = _localization!;
        expressCompanyList = _expressCompanyList;
        goodsPropsList = _goodsPropsList;
        goodsCategoryList = _goodsCategoryList;
        valueAddedServiceList = _valueAddedServiceList;
        terms = _terms!;
        isloading = true;
        EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '包裹预报',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: isloading
          ? SingleChildScrollView(
              child: Column(
              children: <Widget>[
                buildCustomViews(context),
                Container(
                  color: ColorConfig.bgGray,
                  height: 10,
                ),
                buildHeaderListView(),
                Container(
                  color: ColorConfig.bgGray,
                  height: 10,
                ),
                buildListView(context),
                buildBottomListView(),
                Container(
                  height: 55,
                  color: ColorConfig.bgGray,
                  child: Row(
                    children: <Widget>[
                      TextButton.icon(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          onPressed: () {
                            setState(() {
                              agreementBool = !agreementBool;
                            });
                          },
                          icon: agreementBool
                              ? const Icon(
                                  Icons.check_box_outlined,
                                  color: ColorConfig.green,
                                )
                              : const Icon(
                                  Icons.check_box_outline_blank_outlined,
                                  color: ColorConfig.textGray,
                                ),
                          label: const Caption(
                            str: '已查看并同意',
                          )),
                      GestureDetector(
                        onTap: () {
                          showTipsView();
                        },
                        child: const Caption(
                          str: '《BeeGoPlus集运协议》',
                          color: ColorConfig.warningTextDark,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: ColorConfig.bgGray,
                  child: TextButton(
                    onPressed: () {
                      for (ParcelModel item in formData) {
                        if (item.expressId == null) {
                          Util.showToast('有包裹没有选择快递公司');
                          return;
                        }
                        if (item.expressNum == null) {
                          Util.showToast('有包裹没有填写快递单号');
                          return;
                        }
                        if (item.packageName == null) {
                          Util.showToast('有包裹没有填写名称');
                          return;
                        }
                        if (item.packageValue == null) {
                          Util.showToast('有包裹没有填写价值');
                          return;
                        }
                        if (item.prop == null) {
                          Util.showToast('有包裹没有选择属性');
                          return;
                        }
                      }
                      if (!agreementBool) {
                        Util.showToast('请下同意包裹货运规则');
                        return;
                      }

                      List<Map> packageList = [];
                      for (ParcelModel item in formData) {
                        List<String> categoryids = [];
                        for (GoodsCategoryModel itemca in item.categories!) {
                          categoryids.add(itemca.id.toString());
                        }
                        Map<String, dynamic> dic = {
                          'express_num': item.expressNum,
                          'package_name': item.packageName,
                          'package_value': item.packageValue,
                          'prop_id':
                              item.prop == null ? '' : item.prop!.first.id,
                          'express_id': item.expressId,
                          'category_ids': categoryids,
                          'qty': item.qty,
                          'remark': item.remark,
                        };
                        packageList.add(dic);
                      }
                      List<int> selectService = [];
                      for (ValueAddedServiceModel item
                          in valueAddedServiceList) {
                        if (item.isOpen) {
                          selectService.add(item.id);
                        }
                      }
                      EasyLoading.show();
                      //开始提交预报
                      ParcelService.store({
                        'packages': packageList,
                        'country_id': selectedCountryModel!.id,
                        'warehouse_id': selectedWarehouseModel!.id,
                        'op_service_ids': selectService,
                      }, (data) {
                        EasyLoading.dismiss();
                        if (data.ret) {
                          EasyLoading.showSuccess(data.message);
                          setState(() {
                            formData.clear();
                            // selectedCountryModel = CountryModel();
                            // selectedWarehouseModel = WareHouseModel();
                            // formData.add(ParcelModel());
                            agreementBool = false;
                            for (ValueAddedServiceModel item
                                in valueAddedServiceList) {
                              item.isOpen = false;
                            }
                          });
                        } else {
                          EasyLoading.showError(data.msg);
                        }
                      }, (message) {
                        EasyLoading.showError(message);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorConfig.warningText,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(
                              width: 1, color: ColorConfig.warningText)),
                      alignment: Alignment.center,
                      height: 40,
                      child: const Caption(
                        str: '     提交     ',
                        color: ColorConfig.textBlack,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: ColorConfig.bgGray,
                  height: 60,
                )
              ],
            ))
          : Container(),
    );
  }

  Widget buildHeaderListView() {
    return SizedBox(
      height: 110,
      child: Column(children: buildHeaderView()),
    );
  }

  List<Widget> buildHeaderView() {
    List<Widget> listWidget = [];
    var view2 = GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        var tmp = await Navigator.pushNamed(context, '/CountryListPage');
        if (tmp == null) {
          return;
        }
        CountryModel? s = tmp as CountryModel;
        if (s.id == null) {
          return;
        }

        var data = await WarehouseService.getWareHouseByCountry(
            {'country_id': selectedCountryModel?.id});
        setState(() {
          selectedCountryModel = s;
          wareHouseList = data;
          selectedWarehouseModel = wareHouseList.first;
        });
      },
      child: InputTextItem(
          title: "发往国家",
          inputText: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  selectedCountryModel?.name ?? selectCountry,
                  style: selectedCountryModel?.name == null
                      ? TextConfig.textGray14
                      : TextConfig.textDark14,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: selectedCountryModel?.name == null
                        ? ColorConfig.textGray
                        : ColorConfig.textDark,
                    size: 18,
                  ),
                ),
              ],
            ),
          )),
    );

    var view3 = GestureDetector(
      onTap: () async {
        if (selectedCountryModel?.id != null) {
          Picker(
            adapter: PickerDataAdapter(data: getPickerWareHouse(wareHouseList)),
            cancelText: '取消',
            confirmText: '确认',
            selectedTextStyle:
                const TextStyle(color: Colors.blue, fontSize: 12),
            onCancel: () {},
            onConfirm: (Picker picker, List value) {
              setState(() {
                selectedWarehouseModel = wareHouseList[value.first];
              });
            },
          ).showModal(context);
        }
      },
      child: InputTextItem(
          title: "发往仓库",
          inputText: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  selectedWarehouseModel?.warehouseName ?? selectWareHouse,
                  style: selectedWarehouseModel?.warehouseName == null
                      ? TextConfig.textGray14
                      : TextConfig.textDark14,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: selectedWarehouseModel?.warehouseName == null
                        ? ColorConfig.textGray
                        : ColorConfig.textDark,
                    size: 18,
                  ),
                ),
              ],
            ),
          )),
    );
    listWidget.add(view2);
    listWidget.add(view3);
    return listWidget;
  }

  Widget buildBottomListView() {
    return SizedBox(
      height: (85 + 73 * valueAddedServiceList.length).toDouble(),
      child: Column(children: buildAddServiceListView()),
    );
  }

  List<Widget> buildAddServiceListView() {
    List<Widget> listWidget = [];
    var view1 = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          formData.add(ParcelModel());
        });
      },
      child: Container(
        height: 85,
        color: ColorConfig.textGrayCS,
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
        ),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
          decoration: BoxDecoration(
            color: ColorConfig.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: ColorConfig.warningText),
          ),
          width: ScreenUtil().screenWidth,
          child: const Caption(
            str: ' 继续添加 ',
            color: ColorConfig.textBlack,
            fontSize: 17,
          ),
        ),
      ),
    );

    listWidget.add(view1);
    for (ValueAddedServiceModel item in valueAddedServiceList) {
      var listTitle = Container(
        decoration: BoxDecoration(
            color: ColorConfig.white,
            border: Border(
              bottom: Divider.createBorderSide(context,
                  color: ColorConfig.line, width: 1),
            )),
        child: ListTile(
          tileColor: ColorConfig.white,
          title: SizedBox(
            height: 20,
            child: Caption(
              str: item.content,
              fontSize: 16,
            ),
          ),
          subtitle: SizedBox(
            height: 18,
            child: Caption(
              str: item.remark,
              fontSize: 14,
              color: ColorConfig.textGray,
            ),
          ),
          trailing: Switch.adaptive(
            value: item.isOpen,
            activeColor: ColorConfig.warningText,
            onChanged: (value) {
              setState(() {
                item.isOpen = value;
                FocusScope.of(context).requestFocus(blankNode);
              });
            },
          ),
        ),
      );
      listWidget.add(listTitle);
    }

    return listWidget;
  }

  Widget buildListView(BuildContext context) {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: buildBottomListCell,
      controller: scrollController,
      itemCount: formData.length,
    );
    return listView;
  }

  Widget buildBottomListCell(BuildContext context, int index) {
    // 包裹名称
    // String recipientName = "";
    // 包裹数量
    // int goodsNumber = 1;
    // 快递名称
    String courierName = "请选择快递名称";
    // 包裹类型
    String goodsTypes = "请选择包裹类型";
    // 包裹属性
    String goodsProperties = "请选择包裹属性";

    // 快递单号
    TextEditingController orderNumberController = TextEditingController();
    final FocusNode orderNumber = FocusNode();
    // 包裹名称
    TextEditingController goodsNameController = TextEditingController();
    final FocusNode goodsName = FocusNode();
    // 包裹价值
    TextEditingController goodsValueController = TextEditingController();
    final FocusNode goodsValue = FocusNode();
    // 包裹备注
    TextEditingController _remarkController = TextEditingController();
    final FocusNode _remark = FocusNode();

    ParcelModel model = formData[index];
    if (model.expressNum != null) {
      orderNumberController.text = model.expressNum!;
    }
    if (model.packageName != null) {
      goodsNameController.text = model.packageName!;
    }
    if (model.packageValue != null) {
      goodsValueController.text =
          (model.packageValue! / 100).toStringAsFixed(2);
    }
    if (model.remark != null) {
      _remarkController.text = model.remark!;
    }
    return SizedBox(
      height: formData.length != 1 ? 496 : 441, //55*9
      width: ScreenUtil().screenWidth,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                Picker(
                  adapter: PickerDataAdapter(
                      data: getPickerExpressCompany(expressCompanyList)),
                  cancelText: '取消',
                  confirmText: '确认',
                  selectedTextStyle:
                      const TextStyle(color: Colors.blue, fontSize: 12),
                  onCancel: () {},
                  onConfirm: (Picker picker, List value) {
                    setState(() {
                      model.expressName = expressCompanyList[value.first].name;
                      model.expressId = expressCompanyList[value.first].id;
                    });
                  },
                ).showModal(this.context);
              },
              child: InputTextItem(
                  title: "快递名称",
                  inputText: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model.expressName ?? courierName,
                          style: model.expressName != null
                              ? TextConfig.textDark14
                              : TextConfig.textGray16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, top: 10, bottom: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: model.expressName != null
                                ? ColorConfig.textBlack
                                : ColorConfig.textGray,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            InputTextItem(
                title: "快递单号",
                inputText: NormalInput(
                  hintText: "请输入快递单号",
                  textAlign: TextAlign.right,
                  controller: orderNumberController,
                  focusNode: orderNumber,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(goodsName);
                  },
                  onChanged: (res) {
                    model.expressNum = res;
                  },
                  keyName: '',
                )),
            InputTextItem(
                title: "包裹名称",
                inputText: NormalInput(
                  hintText: "请输入包裹名称",
                  textAlign: TextAlign.right,
                  controller: goodsNameController,
                  focusNode: goodsName,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(goodsValue);
                  },
                  onChanged: (res) {
                    model.packageName = res;
                  },
                  keyName: '',
                )),
            InputTextItem(
                leftFlex: 3,
                title: '包裹价值（' + localization!.currencySymbol + '）',
                inputText: NormalInput(
                  hintText: "请输入包裹价值",
                  textAlign: TextAlign.right,
                  controller: goodsValueController,
                  focusNode: goodsValue,
                  autoFocus: false,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(_remark);
                  },
                  onChanged: (res) {
                    model.packageValue = (double.parse(res) * 100).toInt();
                  },
                )),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                var s = await Navigator.pushNamed(context, '/CategoriesPage',
                    arguments: {
                      "categories": goodsCategoryList //参数map
                    });

                if (s is! List<GoodsCategoryModel>) {
                  return;
                } else {
                  model.categories = s;
                  model.categoriesStr = '';
                  setState(() {
                    for (GoodsCategoryModel item in s) {
                      if (model.categoriesStr == null) {
                        model.categoriesStr = item.name;
                      } else {
                        model.categoriesStr =
                            model.categoriesStr! + '、' + item.name;
                      }
                    }
                  });
                }
              },
              child: InputTextItem(
                  title: "包裹类型",
                  inputText: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model.categoriesStr ?? goodsTypes,
                          style: model.categoriesStr == ''
                              ? TextConfig.textGray14
                              : TextConfig.textDark14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, top: 10, bottom: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: model.categoriesStr == ''
                                ? ColorConfig.textGray
                                : ColorConfig.textBlack,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () async {
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
                                margin: const EdgeInsets.only(left: 15),
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
                                      crossAxisSpacing: 20.0, //水平子Widget之间间距
                                      mainAxisSpacing: 20.0, //垂直子Widget之间间距
                                      crossAxisCount: 3, //一行的Widget数量
                                      childAspectRatio: 2.6,
                                    ), // 宽高比例
                                    itemCount: goodsPropsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      GoodsPropsModel propmodel =
                                          goodsPropsList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          setBottomSheetState(() {
                                            selectPropIndex = index;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectPropIndex == 999 &&
                                                      model.prop != null &&
                                                      model.prop!.first ==
                                                          goodsPropsList[index]
                                                  ? ColorConfig.warningText
                                                  : selectPropIndex == index
                                                      ? ColorConfig.warningText
                                                      : ColorConfig.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4.0)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: ColorConfig.line)),
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Caption(
                                                fontSize: 14,
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
                                        model.prop = [
                                          goodsPropsList[selectPropIndex]
                                        ];
                                      }
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 15, left: 15),
                                    decoration: BoxDecoration(
                                        color: ColorConfig.warningText,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                        border: Border.all(
                                            width: 1,
                                            color: ColorConfig.warningText)),
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
              child: InputTextItem(
                  title: "包裹属性",
                  inputText: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model.prop == null
                              ? goodsProperties
                              : model.prop!.first.name!,
                          style: model.prop == null
                              ? TextConfig.textGray14
                              : TextConfig.textDark14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, top: 10, bottom: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: model.prop == null
                                ? ColorConfig.textGray
                                : ColorConfig.textBlack,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            InputTextItem(
                leftFlex: 5,
                rightFlex: 5,
                title: "包裹内物品数量",
                inputText: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          icon: Icon(
                            model.qty == 1
                                ? Icons.remove_circle
                                : Icons.remove_circle,
                            color: model.qty == 1
                                ? ColorConfig.textGray
                                : ColorConfig.warningText,
                            size: 35,
                          ),
                          onPressed: () {
                            int k = model.qty!;
                            if (k == 1) {
                              return;
                            }
                            k--;
                            setState(() {
                              model.qty = k;
                            });
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 0),
                      alignment: Alignment.center,
                      child: Text(
                        model.qty.toString(),
                        style: const TextStyle(
                            // backgroundColor: ColorConfig.warningText,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: ColorConfig.warningText,
                            size: 35,
                          ),
                          onPressed: () {
                            int k = model.qty!;
                            k++;
                            setState(() {
                              model.qty = k;
                              // print(model.qty);
                            });
                          }),
                    )
                  ],
                )),
            InputTextItem(
                title: "包裹备注",
                inputText: NormalInput(
                  hintText: "请输入备注",
                  textAlign: TextAlign.right,
                  controller: _remarkController,
                  focusNode: _remark,
                  autoFocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(blankNode);
                  },
                  onChanged: (res) {
                    model.remark = res;
                  },
                )),
            formData.length != 1
                ? Container(
                    height: 45,
                    margin: const EdgeInsets.only(bottom: 10),
                    color: ColorConfig.white,
                    width: ScreenUtil().screenWidth,
                    child: TextButton.icon(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (formData.length == 1) {
                            return;
                          }
                          setState(() {
                            formData.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete_outline,
                            color: ColorConfig.warningText),
                        label: const Caption(
                          str: '删除',
                          color: ColorConfig.warningText,
                        )),
                  )
                : Container(),
            Gaps.line,
            // Gaps.vGap15,
          ],
        ),
      ),
    );
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        height: 150,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().screenWidth,
              child: const TrackingBanner(),
            ),
          ],
        ));
    return headerView;
  }

  showPickerWareHouse(BuildContext context) {}
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

  showTipsView() {
    showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: ColorConfig.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 1, color: ColorConfig.white),
            ),
            padding: const EdgeInsets.only(top: 15),
            margin: const EdgeInsets.only(
                right: 45, left: 45, top: 100, bottom: 100),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  child: Html(data: terms!['content']),
                ),
              ],
            )),
          );
        });
  }
}

class TrackingBanner extends StatefulWidget {
  const TrackingBanner({Key? key}) : super(key: key);

  @override
  _TrackingBannerState createState() => _TrackingBannerState();
}

class _TrackingBannerState extends State<TrackingBanner>
    with AutomaticKeepAliveClientMixin {
  late String banner;
  BannersModel allimagesModel = BannersModel();
  @override
  void initState() {
    super.initState();
    banner = '';
    getBanner();
  }

  @override
  bool get wantKeepAlive => true;

  // 获取顶部 banner 图
  void getBanner() async {
    var imagesData = await CommonService.getAllBannersInfo();

    if (mounted) {
      setState(() {
        allimagesModel = imagesData!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadImage(
      allimagesModel.forecastImage ?? "",
      fit: BoxFit.fitWidth,
    );
  }
}
