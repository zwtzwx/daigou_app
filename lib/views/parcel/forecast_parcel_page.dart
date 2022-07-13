import 'package:dotted_border/dotted_border.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/views/components/banner.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
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
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/parcel/widget/prop_sheet_cell.dart';
import 'package:provider/provider.dart';

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

  // 协议确认
  bool agreementBool = true;
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
  // 属性单选
  bool propSingle = false;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    localization = Provider.of<Model>(context, listen: false).localizationInfo;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      created();
    });
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      Routers.push('/LoginPage', context);
    });
  }

  created() async {
    EasyLoading.show();
    var countryList = await CommonService.getCountryList();
    var _valueAddedServiceList = await ParcelService.getValueAddedServiceList();
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {
        if (countryList.isNotEmpty) {
          selectedCountryModel = countryList[0];
          getWarehouseList();
          loadInitData();
        }
        valueAddedServiceList = _valueAddedServiceList;
        isloading = true;
      });
    }
  }

  //加载页面所需要的数据
  loadInitData() async {
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _goodsPropsList = await GoodsService.getPropList(
        {'country_id': selectedCountryModel?.id});
    var _single = await GoodsService.getPropConfig();
    var _terms = await CommonService.getTerms();
    if (mounted) {
      setState(() {
        expressCompanyList = _expressCompanyList;
        goodsPropsList = _goodsPropsList;
        propSingle = _single;
        terms = _terms;
        formData.add(ParcelModel(
          packageName: '日用品',
          packageValue: 1,
          expressId: _expressCompanyList[0].id,
          expressName: _expressCompanyList[0].name,
          prop: [_goodsPropsList[0]],
        ));
      });
    }
  }

  // 根据国家获取仓库列表
  getWarehouseList() async {
    var data = await WarehouseService.getList(
        {'country_id': selectedCountryModel?.id});
    setState(() {
      wareHouseList = data;
      selectedWarehouseModel = wareHouseList.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '包裹预报'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: isloading
          ? SingleChildScrollView(
              child: Column(
              children: <Widget>[
                buildCustomViews(context),
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
                          label: Caption(
                            str: Translation.t(context, '已查看并同意'),
                          )),
                      GestureDetector(
                        onTap: () {
                          showTipsView();
                        },
                        child: Caption(
                          str: '《${Translation.t(context, '包裹转运验货协议')}》',
                          color: HexToColor('#fe8b25'),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  width: double.infinity,
                  child: MainButton(
                    onPressed: () {
                      if (!agreementBool) {
                        Util.showToast(Translation.t(context, '请同意包裹转运协议'));
                        return;
                      }
                      for (ParcelModel item in formData) {
                        if (item.expressId == null) {
                          Util.showToast(Translation.t(context, '有包裹没有选择快递公司'));
                          return;
                        }
                        if (item.expressNum == null) {
                          Util.showToast(Translation.t(context, '有包裹没有填写快递单号'));
                          return;
                        }
                        if (item.packageValue == null) {
                          Util.showToast(Translation.t(context, '有包裹没有填写物品价值'));
                          return;
                        }
                        if (item.prop == null) {
                          Util.showToast(Translation.t(context, '有包裹没有选择物品属性'));
                          return;
                        }
                      }

                      List<Map> packageList = [];
                      for (ParcelModel item in formData) {
                        List<String> categoryids = [];
                        Map<String, dynamic> dic = {
                          'express_num': item.expressNum,
                          'package_name': item.packageName,
                          'package_value': item.packageValue! * 100,
                          'prop_id':
                              item.prop == null ? '' : item.prop!.first.id,
                          'express_id': item.expressId,
                          'category_ids': categoryids,
                          'qty': item.qty,
                          'remark': item.remark ?? '',
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
                        if (data.ok) {
                          EasyLoading.showSuccess(data.msg);
                          ApplicationEvent.getInstance()
                              .event
                              .fire(OrderCountRefreshEvent());
                          setState(() {
                            formData.clear();
                            for (ValueAddedServiceModel item
                                in valueAddedServiceList) {
                              item.isOpen = false;
                            }
                            formData.add(ParcelModel(
                              packageName: '日用品',
                              packageValue: 1,
                              expressId: expressCompanyList[0].id,
                              expressName: expressCompanyList[0].name,
                              prop: [goodsPropsList[0]],
                            ));
                          });
                        } else {
                          EasyLoading.showError(data.msg);
                        }
                      }, (message) {
                        EasyLoading.showError(message);
                      });
                    },
                    text: '提交预报',
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

  Widget buildHeaderView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Caption(
              str: Translation.t(context, '国家地区'),
              fontSize: 12,
              color: ColorConfig.main,
            ),
            Gaps.vGap10,
            GestureDetector(
              onTap: () async {
                var tmp =
                    await Navigator.pushNamed(context, '/CountryListPage');
                if (tmp == null) {
                  return;
                }
                CountryModel? s = tmp as CountryModel;
                if (s.id == null) {
                  return;
                }
                setState(() {
                  selectedCountryModel = s;
                  getWarehouseList();
                });
              },
              child: Caption(
                str: selectedCountryModel?.name ??
                    Translation.t(context, '请选择国家地区'),
                fontSize: 18,
                color: ColorConfig.primary,
              ),
            ),
            Gaps.vGap10,
            Caption(
              str: Translation.t(context, '切换'),
              fontSize: 12,
              color: ColorConfig.main,
            ),
          ],
        ),
        const LoadImage(
          'Home/arrow2',
          width: 50,
          fit: BoxFit.fitWidth,
        ),
        Column(
          children: [
            Caption(
              str: Translation.t(context, '转运仓库'),
              fontSize: 12,
              color: ColorConfig.main,
            ),
            Gaps.vGap10,
            GestureDetector(
              onTap: () {
                if (selectedCountryModel?.id != null) {
                  Picker(
                    adapter: PickerDataAdapter(
                        data: getPickerWareHouse(wareHouseList)),
                    cancelText: Translation.t(context, '取消'),
                    confirmText: Translation.t(context, '确认'),
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
              child: Caption(
                str: selectedWarehouseModel?.warehouseName ??
                    Translation.t(context, '请选择仓库'),
                fontSize: 18,
                color: ColorConfig.primary,
              ),
            ),
            Gaps.vGap10,
            Caption(
              str: Translation.t(context, '切换'),
              fontSize: 12,
              color: ColorConfig.main,
            ),
          ],
        )
      ],
    );
  }

  Widget buildBottomListView() {
    return SizedBox(
      child: Column(children: buildAddServiceListView()),
    );
  }

  List<Widget> buildAddServiceListView() {
    List<Widget> listWidget = [];
    var view1 = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          formData.add(ParcelModel(
            packageName: '日用品',
            packageValue: 1,
            expressId: expressCompanyList[0].id,
            expressName: expressCompanyList[0].name,
            prop: [goodsPropsList[0]],
          ));
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10.0),
          dashPattern: const [5, 2],
          color: ColorConfig.primary,
          child: Container(
            height: 55,
            color: ColorConfig.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadImage(
                  'PackageAndOrder/add-icon2',
                  width: 20,
                  height: 20,
                ),
                Gaps.hGap10,
                Caption(
                  str: Translation.t(context, '添加包裹'),
                  color: ColorConfig.primary,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
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
            activeColor: ColorConfig.green,
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
    // 快递单号
    TextEditingController orderNumberController = TextEditingController();
    final FocusNode orderNumber = FocusNode();

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
    if (model.packageValue != null) {
      goodsValueController.text = model.packageValue.toString();
    }
    if (model.remark != null) {
      _remarkController.text = model.remark!;
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
                  cancelText: Translation.t(context, '取消'),
                  confirmText: Translation.t(context, '确认'),
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
                  title: Translation.t(context, '快递名称'),
                  inputText: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model.expressName ??
                              Translation.t(context, '请选择快递名称'),
                          style: model.expressName != null
                              ? TextConfig.textDark14
                              : TextConfig.textGray14,
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
                title: Translation.t(context, '快递单号'),
                inputText: NormalInput(
                  hintText: Translation.t(context, '请输入快递单号'),
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
                leftFlex: 3,
                title: Translation.t(context, '物品总价'),
                inputText: NormalInput(
                  hintText: Translation.t(context, '请输入物品总价'),
                  textAlign: TextAlign.right,
                  controller: goodsValueController,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
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
                // 属性选择框
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return PropSheetCell(
                        goodsPropsList: goodsPropsList,
                        propSingle: propSingle,
                        prop: model.prop,
                        onConfirm: (data) {
                          model.prop = data;
                        },
                      );
                    });
              },
              child: InputTextItem(
                  title: Translation.t(context, '物品属性'),
                  inputText: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model.prop == null
                              ? Translation.t(context, '请选择物品属性')
                              : model.prop!.map((e) => e.name).join(' '),
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
                title: Translation.t(context, '物品数量'),
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
                                : ColorConfig.primary,
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
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: ColorConfig.primary,
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
                title: Translation.t(context, '商品备注'),
                inputText: NormalInput(
                  hintText: Translation.t(context, '请输入备注'),
                  textAlign: TextAlign.right,
                  controller: _remarkController,
                  focusNode: _remark,
                  autoFocus: false,
                  contentPadding: const EdgeInsets.only(top: 17, right: 15),
                  keyboardType: TextInputType.text,
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(blankNode);
                  },
                  onChanged: (res) {
                    model.remark = res;
                  },
                )),
            Container(
              height: 45,
              color: HexToColor('#fafafa'),
              width: ScreenUtil().screenWidth,
              child: TextButton.icon(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var data = await BaseDialog.confirmDialog(
                        context, Translation.t(context, '您确定要删除这个包裹吗'));
                    if (data != null) {
                      setState(() {
                        formData.removeAt(index);
                      });
                    }
                  },
                  icon: const Icon(Icons.delete_outline,
                      color: ColorConfig.textGrayC),
                  label: Caption(
                    str: Translation.t(context, '删除'),
                    color: ColorConfig.textGrayC,
                  )),
            ),
            // Gaps.vGap15,
          ],
        ),
      ),
    );
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(70),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: const BannerBox(imgType: 'forecast_image'),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: buildHeaderView(),
            )
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

  // 转运协议
  showTipsView() {
    BaseDialog.normalDialog(
      context,
      title: terms?['title'],
      child: Flexible(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Html(data: terms?['content']),
          ),
        ),
      ),
    );
  }
}
