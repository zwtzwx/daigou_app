import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
// import 'package:jiyun_app_client/model/home/Localization.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
// import 'package:jiyun_app_client/utils/localstorage.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:provider/provider.dart';

/*
  运费估算
*/

class LineQueryPage extends StatefulWidget {
  const LineQueryPage({Key? key}) : super(key: key);
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
  List<GoodsPropsModel> propList = [];
  List<GoodsPropsModel> selectPropList = [];
  GoodsPropsModel? selectProp;
  WareHouseModel selectWareHouse = WareHouseModel();
  CountryModel selectCountry = CountryModel();
  AreaModel area = AreaModel.empty();
  AreaModel subarea = AreaModel.empty();
  String destination = '';
  late LocalizationModel localizationInfo;
  FocusNode blankNode = FocusNode();
  final textEditingController = TextEditingController();
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getWarehouse();
    });
  }

  void getWarehouse() async {
    EasyLoading.show();
    var data = await WarehouseService.getList();
    var propData = await GoodsService.getPropList();
    EasyLoading.dismiss();
    setState(() {
      list = data;
      localizationInfo =
          Provider.of<Model>(context, listen: false).localizationInfo!;
      selectWareHouse = list.first;
      selectCountry = selectWareHouse.countries!.first;
      destination = selectCountry.name!;
      propList = propData;
      isLoading = true;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  showPickerDestion(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerSubView()),
      title: const Text("选择区域"),
      cancelText: '取消',
      confirmText: '确认',
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {
        showPicker = false;
      },
      onConfirm: (Picker picker, List value) {
        setState(() {
          selectCountry = selectWareHouse.countries![value.first];
          area = AreaModel.empty();
          subarea = AreaModel.empty();
          if (selectCountry.areas != null && selectCountry.areas!.isNotEmpty) {
            area = selectCountry.areas![value[1]];
            if (area.areas != null && area.areas!.isNotEmpty) {
              subarea = area.areas![value.last];
            }
          }
          destination = selectCountry.name!;
          if (area.name.isNotEmpty) {
            destination = destination + '/' + area.name;
          }
          if (subarea.name.isNotEmpty) {
            destination = destination + '/' + subarea.name;
          }
        });
      },
    ).showModal(this.context);
  }

  getPickerSubView() {
    List<PickerItem> data = [];
    for (var item in selectWareHouse.countries!) {
      var containe = PickerItem(
          text: Caption(
            fontSize: 24,
            str: item.name!,
          ),
          children: getSubAreaViews(item));
      data.add(containe);
    }
    return data;
  }

  getSubAreaViews(CountryModel conutry) {
    List<PickerItem> subList = [];
    for (var item in conutry.areas!) {
      var subArea = PickerItem(
          text: Caption(
            fontSize: 24,
            str: item.name,
          ),
          children: getThirdSubAreaViews(item));
      subList.add(subArea);
    }
    return subList;
  }

  getThirdSubAreaViews(AreaModel conutry) {
    List<PickerItem> subList = [];
    for (var item in conutry.areas!) {
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

  showPickerWareHouse(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerWareHouse()),
      title: const Text("选择始发仓库"),
      cancelText: '取消',
      confirmText: '确认',
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        setState(() {
          selectWareHouse = list[value.first];
          countryList = selectWareHouse.countries!;
          selectCountry = countryList.first;
          destination = selectCountry.name!;
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
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0.5,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            title: const Caption(
              str: '运费试算',
              color: ColorConfig.textBlack,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          body: isLoading
              ? SingleChildScrollView(
                  child: Container(
                  color: ColorConfig.bgGray,
                  child: Column(
                    children: <Widget>[
                      buildCustomViews(context),
                      buildMiddleView(context),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          onPressed: () async {
                            if (selectPropList.isEmpty) {
                              Util.showToast('请选择物品属性');
                              return;
                            }
                            List<int> propIdList = [];
                            for (var item in selectPropList) {
                              propIdList.add(item.id);
                            }
                            Map<String, dynamic> dic = {
                              'country_id': selectCountry.id,
                              'length': longStr,
                              'width': wideStr,
                              'height': highStr,
                              'weight': weightStr * 1000,
                              'prop_ids': propIdList,
                              'warehouse_id': selectWareHouse.id,
                              'area_id': area.id != 0 ? area.id : '',
                              'sub_area_id': subarea.id != 0 ? subarea.id : '',
                            };
                            // List<LineData> result = await Api.getLines(dic);
                            // List<LineData> list = result;
                            // EasyLoading.dismiss();
                            // if (list.length == 0) {
                            //   return;
                            // }
                            // Navigator.pushNamed(context, '/SelectCourierType',
                            //     arguments: {"data": dic, "show": true});
                            Routers.push('/LinesPage', context,
                                {"data": dic, "query": true});
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: ColorConfig.warningText,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            alignment: Alignment.center,
                            height: 40,
                            child: const Caption(
                              str: '立即查询',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              : Container(),
        ));
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
      color: ColorConfig.white,
      height: 440,
      width: ScreenUtil().screenWidth,
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Caption(
                str: '始发仓库',
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(blankNode);
                  showPickerWareHouse(context);
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: ColorConfig.bgGray,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 0.3, color: ColorConfig.line),
                  ),
                  alignment: Alignment.center,
                  width: ScreenUtil().screenWidth - 30,
                  child: Caption(
                    str: selectWareHouse.warehouseName!,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Caption(
                str: '目的地',
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(blankNode);
                    showPickerDestion(context);
                  },
                  child: Stack(children: <Widget>[
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                              width: 1, color: ColorConfig.textGrayC)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Caption(
                        str: destination,
                        fontSize: 14,
                      ),
                    ),
                    const Positioned(
                        right: 0,
                        child: SizedBox(
                          height: 40,
                          width: 30,
                          child: Icon(Icons.keyboard_arrow_right,
                              color: ColorConfig.textGray),
                        )),
                  ]))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Caption(
                str: '实重(' + localizationInfo.weightSymbol + ')',
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: ColorConfig.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border:
                          Border.all(width: 1, color: ColorConfig.textGrayC)),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: NormalInput(
                    board: false,
                    contentPadding: const EdgeInsets.only(top: 0, bottom: 8),
                    hintText: '输入包裹重量',
                    maxLines: 1,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    controller: _weightController,
                    focusNode: _weightNode,
                    autoFocus: false,
                    keyboardType: TextInputType.number,
                    onSubmitted: (res) {
                      FocusScope.of(context).requestFocus(_longNode);
                    },
                    onChanged: (res) {
                      weightStr = double.parse(res);
                    },
                  )),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Caption(
                str: '物品属性',
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(blankNode);
                    // 属性选择框
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          List<GoodsPropsModel> selPropList = selectPropList;
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
                                          crossAxisSpacing:
                                              20.0, //水平子Widget之间间距
                                          mainAxisSpacing: 20.0, //垂直子Widget之间间距
                                          crossAxisCount: 3, //一行的Widget数量
                                          childAspectRatio: 2.6,
                                        ), // 宽高比例
                                        itemCount: propList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          GoodsPropsModel propmodel =
                                              propList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setBottomSheetState(() {
                                                if (selPropList
                                                    .contains(propmodel)) {
                                                  selPropList.remove(propmodel);
                                                } else {
                                                  selPropList.add(propmodel);
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: selPropList
                                                          .contains(propmodel)
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
                                          selectPropList = selPropList;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        decoration: BoxDecoration(
                                            color: ColorConfig.warningText,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    ColorConfig.warningText)),
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
                  child: Stack(children: <Widget>[
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: ColorConfig.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border:
                            Border.all(width: 1, color: ColorConfig.textGrayC),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Caption(
                        str: selectPropList.isEmpty ? '选择物品属性' : propStr,
                      ),
                    ),
                    const Positioned(
                        right: 0,
                        child: SizedBox(
                          height: 40,
                          width: 30,
                          child: Icon(Icons.keyboard_arrow_right,
                              color: ColorConfig.textGray),
                        )),
                  ]))
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Caption(
                    str: '包裹尺寸' '(' + localizationInfo.lengthSymbol + ')',
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: ColorConfig.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  width: 1, color: ColorConfig.textGrayC),
                            ),
                            alignment: Alignment.center,
                            height: 40,
                            width: 90,
                            child: NormalInput(
                              board: false,
                              contentPadding:
                                  const EdgeInsets.only(top: 0, bottom: 8),
                              hintText: '长',
                              maxLines: 1,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                              controller: _longController,
                              focusNode: _longNode,
                              autoFocus: false,
                              keyboardType: TextInputType.number,
                              onSubmitted: (res) {
                                FocusScope.of(context).requestFocus(_wideNode);
                              },
                              onChanged: (res) {
                                longStr = res;
                              },
                            )),
                        Container(
                            height: 40,
                            width: 90,
                            decoration: BoxDecoration(
                              color: ColorConfig.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  width: 1, color: ColorConfig.textGrayC),
                            ),
                            alignment: Alignment.center,
                            child: NormalInput(
                              board: false,
                              contentPadding:
                                  const EdgeInsets.only(top: 0, bottom: 8),
                              hintText: '宽',
                              maxLines: 1,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                              controller: _wideController,
                              focusNode: _wideNode,
                              autoFocus: false,
                              keyboardType: TextInputType.number,
                              onSubmitted: (res) {
                                FocusScope.of(context).requestFocus(_highNode);
                              },
                              onChanged: (res) {
                                wideStr = res;
                              },
                            )),
                        Container(
                            height: 40,
                            width: 90,
                            decoration: BoxDecoration(
                              color: ColorConfig.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  width: 1, color: ColorConfig.textGrayC),
                            ),
                            alignment: Alignment.center,
                            child: NormalInput(
                              board: false,
                              contentPadding:
                                  const EdgeInsets.only(top: 0, bottom: 8),
                              hintText: '高',
                              maxLines: 1,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                              controller: _highController,
                              focusNode: _highNode,
                              autoFocus: false,
                              keyboardType: TextInputType.number,
                              onSubmitted: (res) {
                                FocusScope.of(context).requestFocus(blankNode);
                              },
                              onChanged: (res) {
                                highStr = res;
                              },
                            )),
                      ],
                    ),
                  )
                ]))
      ]),
    );
    return mainView;
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        color: Colors.white,
        height: ScreenUtil().setHeight(124),
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

  @override
  bool get wantKeepAlive => true;
}

class TrackingBanner extends StatefulWidget {
  const TrackingBanner({Key? key}) : super(key: key);

  @override
  _TrackingBannerState createState() => _TrackingBannerState();
}

class _TrackingBannerState extends State<TrackingBanner>
    with AutomaticKeepAliveClientMixin {
  BannersModel allimagesModel = BannersModel();

  @override
  void initState() {
    super.initState();
    getBanner();
  }

  @override
  bool get wantKeepAlive => true;

  // 获取顶部 banner 图
  void getBanner() async {
    var imageList = await CommonService.getAllBannersInfo();
    setState(() {
      allimagesModel = imageList!;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadImage(
      allimagesModel.freightImage ?? '',
      fit: BoxFit.fitHeight,
    );
  }
}
