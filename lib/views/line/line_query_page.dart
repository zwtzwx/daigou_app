import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/banner.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/parcel/widget/prop_sheet_cell.dart';
import 'package:provider/provider.dart';

/*
  运费估算
*/

class LineQueryPage extends StatefulWidget {
  final Map? arguments;
  const LineQueryPage({Key? key, this.arguments}) : super(key: key);
  @override
  LineQueryState createState() => LineQueryState();
}

class LineQueryState extends State<LineQueryPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool showPicker = false;
  List<WareHouseModel> list = [];
  List<CountryModel> countryList = [];
  // 物品属性列表
  List<GoodsPropsModel> propList = [];
  // 选择物品属性
  List<GoodsPropsModel> selectPropList = [];
  WareHouseModel? selectWareHouse;
  CountryModel? selectCountry;
  AreaModel? area;
  AreaModel? subarea;
  LocalizationModel? localizationInfo;
  bool propSingle = false;

  FocusNode blankNode = FocusNode();
  // 重量
  double weightStr = 1.0;
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightNode = FocusNode();
  // 长
  String longStr = '';
  final TextEditingController _longController = TextEditingController();
  final FocusNode _longNode = FocusNode();
  // 宽
  String wideStr = '';
  final TextEditingController _wideController = TextEditingController();
  final FocusNode _wideNode = FocusNode();
  // 高
  String highStr = '';
  final TextEditingController _highController = TextEditingController();
  final FocusNode _highNode = FocusNode();

  @override
  void initState() {
    super.initState();
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _weightController.text = '1';
    getWarehouse();
  }

  void getWarehouse() async {
    EasyLoading.show();
    var data = await WarehouseService.getList();
    var propData = await GoodsService.getPropList();
    var _single = await GoodsService.getPropConfig();
    EasyLoading.dismiss();
    setState(() {
      list = data;
      propSingle = _single;
      if (list.isNotEmpty) {
        selectWareHouse = list.first;
        selectCountry = selectWareHouse!.countries!.first;
        if (selectCountry!.areas != null && selectCountry!.areas!.isNotEmpty) {
          area = selectCountry!.areas!.first;
          if (area!.areas != null && area!.areas!.isNotEmpty) {
            subarea = area!.areas!.first;
          }
        }
      }
      propList = propData;
      isLoading = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 选择国家
  showPickerDestion(BuildContext context) async {
    var s = await Routers.push('/CountryListPage', context, {
      'warehouseId': selectWareHouse!.id,
    });
    if (s == null) return;
    setState(() {
      if (s is Map) {
        selectCountry = s['country'];
        area = s['area'];
        subarea = s['subArea'];
      } else {
        selectCountry = s;
        area = null;
        subarea = null;
      }
    });
  }

  // 选择仓库
  showPickerWareHouse(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerWareHouse()),
      title: Text(Translation.t(context, '选择始发仓库')),
      cancelText: Translation.t(context, '取消'),
      confirmText: Translation.t(context, '确认'),
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        setState(() {
          selectWareHouse = list[value.first];
          countryList = selectWareHouse!.countries!;
          selectCountry = countryList.first;
          area = null;
          subarea = null;
          if (selectCountry!.areas != null &&
              selectCountry!.areas!.isNotEmpty) {
            area = selectCountry!.areas!.first;
            if (area!.areas != null && area!.areas!.isNotEmpty) {
              subarea = area!.areas!.first;
            }
          }
        });
      },
    ).showModal(this.context);
  }

  getPickerWareHouse() {
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

  // 重量加减
  onWeight(int step) {
    num weight =
        _weightController.text.isEmpty ? 0 : num.parse(_weightController.text);
    weight += step;
    _weightController.text = weight <= 0 ? '0' : '$weight';
  }

  // 查询
  void onQuery() {
    if (_weightController.text.isEmpty) {
      Util.showToast(Translation.t(context, '请输入重量'));
      return;
    } else if (selectPropList.isEmpty) {
      Util.showToast(Translation.t(context, '请选择物品属性'));
      return;
    }
    List<int> propIdList = [];
    for (var item in selectPropList) {
      propIdList.add(item.id);
    }
    Map<String, dynamic> dic = {
      'country_id': selectCountry?.id ?? '',
      'length': _longController.text,
      'width': _wideController.text,
      'height': _highController.text,
      'weight': num.parse(_weightController.text) * 1000,
      'prop_ids': propIdList,
      'warehouse_id': selectWareHouse?.id ?? '',
      'area_id': area?.id ?? '',
      'sub_area_id': subarea?.id ?? '',
    };
    Routers.push('/LinesPage', context, {"data": dic, "query": true});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: ColorConfig.bgGray,
            primary: false,
            appBar: const EmptyAppBar(),
            body: SingleChildScrollView(
                child: Container(
              color: ColorConfig.bgGray,
              child: Column(
                children: <Widget>[
                  buildCustomViews(context),
                  buildMiddleView(context),
                  Gaps.vGap10,
                  buildPropsView(),
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
                    width: double.infinity,
                    height: 40,
                    child: MainButton(
                      text: '立即查询',
                      onPressed: onQuery,
                    ),
                  )
                ],
              ),
            ))));
  }

  Widget buildMiddleView(BuildContext context) {
    String propStr = '';
    if (selectPropList.isNotEmpty) {
      for (var item in selectPropList) {
        if (propStr.isEmpty) {
          propStr = item.name!;
        } else {
          propStr += '、' + item.name!;
        }
      }
    }
    var mainView = Container(
      width: ScreenUtil().screenWidth,
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Caption(
                    str: Translation.t(context, '重量单位') +
                        "：" +
                        (localizationInfo?.weightSymbol ?? ''),
                  ),
                ),
                Gaps.line,
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  width: ScreenUtil().screenWidth / 2 + 20,
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          onWeight(-1);
                        },
                        child: Container(
                          color: ColorConfig.primary,
                          width: 60,
                          alignment: Alignment.topCenter,
                          child: const Icon(
                            Icons.minimize,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: ColorConfig.line,
                          child: BaseInput(
                            board: true,
                            isCollapsed: true,
                            textAlign: TextAlign.center,
                            autoShowRemove: false,
                            style: const TextStyle(fontSize: 18),
                            controller: _weightController,
                            focusNode: _weightNode,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          onWeight(1);
                        },
                        child: Container(
                          color: ColorConfig.primary,
                          width: 60,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.line,
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Caption(
                                str: Translation.t(context, '包裹尺寸'),
                              ),
                              Caption(
                                str: '(' + Translation.t(context, '选填') + ')',
                                color: ColorConfig.textGray,
                                fontSize: 13,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Caption(
                                str: Translation.t(context, '单位') + ':',
                              ),
                              Caption(
                                str: localizationInfo?.lengthSymbol ?? '',
                                fontSize: 13,
                              ),
                            ],
                          )
                        ],
                      ),
                      Gaps.vGap5,
                      Caption(
                        str: Translation.t(
                            context, '包裹尺寸为商品打包后实际包装箱的长宽高用于某些体积重线路的运费计算'),
                        color: ColorConfig.textGray,
                        fontSize: 14,
                        lines: 4,
                      ),
                      Gaps.vGap10,
                      Row(
                        children: [
                          Expanded(
                            child: BaseInput(
                              board: true,
                              textAlign: TextAlign.center,
                              controller: _longController,
                              focusNode: _longNode,
                              autoShowRemove: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              hintText: Translation.t(context, '长') +
                                  ':' +
                                  (localizationInfo?.lengthSymbol ?? ''),
                            ),
                          ),
                          Gaps.hGap10,
                          Expanded(
                            child: BaseInput(
                              board: true,
                              textAlign: TextAlign.center,
                              controller: _wideController,
                              focusNode: _wideNode,
                              autoShowRemove: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              hintText: Translation.t(context, '宽') +
                                  ':' +
                                  (localizationInfo?.lengthSymbol ?? ''),
                            ),
                          ),
                          Gaps.hGap10,
                          Expanded(
                            child: BaseInput(
                              board: true,
                              textAlign: TextAlign.center,
                              controller: _highController,
                              focusNode: _highNode,
                              autoShowRemove: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              hintText: Translation.t(context, '高') +
                                  ':' +
                                  (localizationInfo?.lengthSymbol ?? ''),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return mainView;
  }

  // 物品属性
  Widget buildPropsView() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return PropSheetCell(
                goodsPropsList: propList,
                prop: selectPropList,
                propSingle: propSingle,
                onConfirm: (data) {
                  setState(() {
                    selectPropList = data;
                  });
                },
              );
            });
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Caption(
                  str: Translation.t(context, '物品属性'),
                ),
                const Caption(
                  str: '*',
                  color: ColorConfig.textRed,
                ),
              ],
            ),
            Row(
              children: [
                Caption(
                  str: selectPropList.isEmpty
                      ? Translation.t(context, '请选择')
                      : selectPropList.map((e) => e.name).join(' '),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 仓库、国家
  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        color: Colors.white,
        height: ScreenUtil().setHeight(125),
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().screenWidth,
              child: const BannerBox(imgType: 'freight_image'),
            ),
            Positioned(
              bottom: 30,
              left: 15,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      showPickerWareHouse(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Caption(
                          str: Translation.t(context, '始发仓库'),
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        Gaps.vGap5,
                        Caption(
                          str: selectWareHouse?.warehouseName ?? '',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                  const LoadImage(
                    'Home/arrow2',
                    width: 50,
                    fit: BoxFit.fitWidth,
                  ),
                  GestureDetector(
                    onTap: () {
                      showPickerDestion(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Caption(
                          str: Translation.t(context, '收货地址'),
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        Gaps.vGap5,
                        Caption(
                          str: (selectCountry?.name ?? '') +
                              (area != null ? '/${area!.name}' : '') +
                              (subarea != null ? '/${subarea!.name}' : ''),
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
    return headerView;
  }

  @override
  bool get wantKeepAlive => true;
}
