import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_goods_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/services/station_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
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

  //预报服务
  List<ValueAddedServiceModel> valueAddedServiceList =
      List<ValueAddedServiceModel>.empty(growable: true);
  //仓库列表
  List<WareHouseModel> wareHouseList = [];
  // 默认自提点
  SelfPickupStationModel? stationModel;

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    localization = Provider.of<Model>(context, listen: false).localizationInfo;
    formData.add(ParcelModel());
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      Util.showToast(Translation.t(context, '登录凭证已失效'));
      Routers.push('/LoginPage', context);
    });

    created();
    loadInitData();
    getStation();
  }

  created() async {
    EasyLoading.show();
    var countryList = await CommonService.getCountryList();

    // var _valueAddedServiceList = await ParcelService.getValueAddedServiceList();
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {
        if (countryList.isNotEmpty) {
          selectedCountryModel = countryList[0];
          getWarehouseList();
          getProps();
        }
        // valueAddedServiceList = _valueAddedServiceList;
        isloading = true;
      });
    }
  }

  //加载页面所需要的数据
  loadInitData() async {
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _terms = await CommonService.getTerms();
    if (mounted) {
      setState(() {
        expressCompanyList = _expressCompanyList;
        terms = _terms;
      });
    }
  }

  // 获取自提点
  getStation() async {
    var data = await StationService.getList();
    if (data['dataList'] != null) {
      setState(() {
        stationModel = data['dataList'][0];
      });
    }
  }

  // 物品属性
  getProps() async {
    var _goodsPropsList = await GoodsService.getPropList(
        {'country_id': selectedCountryModel?.id});
    setState(() {
      goodsPropsList = _goodsPropsList;
    });
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

  ParcelGoodsModel getGoodsInfo(int index) {
    return ParcelGoodsModel(
      name: '物品${index + 1}',
      qty: 1,
      price: 1,
    );
  }

  // 提交预报
  void onSubmit() async {
    var userInfo = Provider.of<Model>(context, listen: false).userInfo;
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
    }

    List<Map> packageList = [];
    int defaultProp = goodsPropsList.first.id;
    for (ParcelModel item in formData) {
      Map<String, dynamic> dic = {
        'express_num': item.expressNum,
        'package_name': '日用品',
        'package_value': 100,
        'prop_id': [defaultProp],
        'express_id': item.expressId,
        'category_ids': [],
        'qty': 1,
        'remark': '',
      };
      packageList.add(dic);
    }
    List<int> selectService = [];
    for (ValueAddedServiceModel item in valueAddedServiceList) {
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
      'ship_mode': 3,
      'mode': 2,
      'station_id': stationModel?.id ?? '',
      'express_line_id': stationModel?.expressLines?.first.id,
      'name': userInfo?.name ?? '',
      'phone': userInfo?.phone ?? '',
    }, (data) async {
      EasyLoading.dismiss();
      if (data.ok) {
        ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent());
        await EasyLoading.showSuccess(data.msg);
        Routers.pop(context);
      } else {
        EasyLoading.showError(data.msg);
      }
    }, (message) {
      EasyLoading.showError(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: Translation.t(context, '包裹预报'),
          fontSize: 18,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
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
                              Icons.check_circle_outline,
                              color: ColorConfig.green,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: ColorConfig.textGray,
                            ),
                      label: ZHTextLine(
                        str: Translation.t(context, '我已阅读并同意'),
                      )),
                  GestureDetector(
                    onTap: () {
                      showTipsView();
                    },
                    child: ZHTextLine(
                      str: '《${Translation.t(context, '转运协议')}》',
                      color: HexToColor('#fe8b25'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
                child: MainButton(
                  onPressed: onSubmit,
                  text: '提交预报',
                ),
              ),
            ],
          ),
        ),
      ),
      body: isloading
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildListView(context),
                    // buildBottomListView(),
                    // Gaps.vGap15,
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  Widget buildBottomListView() {
    return SizedBox(
      child: Column(children: buildAddServiceListView()),
    );
  }

  List<Widget> buildAddServiceListView() {
    List<Widget> listWidget = [];
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
            child: ZHTextLine(
              str: item.content,
              fontSize: 16,
            ),
          ),
          subtitle: SizedBox(
            height: 18,
            child: ZHTextLine(
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

  // 包裹
  Widget buildBottomListCell(BuildContext context, int index) {
    // 快递单号
    TextEditingController orderNumberController = TextEditingController();
    final FocusNode orderNumber = FocusNode();
    ParcelModel model = formData[index];
    if (model.expressNum != null) {
      orderNumberController.text = model.expressNum!;
    }

    return SizedBox(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  leftFlex: 2,
                  isRequired: true,
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
              leftFlex: 2,
              isRequired: true,
              flag: false,
              inputText: NormalInput(
                hintText: Translation.t(context, '请输入快递单号'),
                contentPadding: const EdgeInsets.only(top: 17, right: 15),
                textAlign: TextAlign.right,
                controller: orderNumberController,
                focusNode: orderNumber,
                autoFocus: false,
                onChanged: (res) {
                  model.expressNum = res;
                },
                keyName: '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPickerExpressCompany(List<ExpressCompanyModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: ZHTextLine(
          fontSize: 24,
          str: item.name,
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
