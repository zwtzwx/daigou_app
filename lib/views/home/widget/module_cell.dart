// ignore_for_file: non_constant_identifier_names

/*
  运费试算、仓库地址
  */
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/ship_line_prop_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

class ModuleCell extends StatefulWidget {
  const ModuleCell({Key? key}) : super(key: key);

  @override
  State<ModuleCell> createState() => _ModuleCellState();
}

class _ModuleCellState extends State<ModuleCell> {
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightNode = FocusNode();
  final TextEditingController _postcodeController = TextEditingController();
  final FocusNode _postcodeNode = FocusNode();

  // 仓库列表
  List<WareHouseModel> warehouses = [];
  WareHouseModel? selectedWarehouse;
  // 物品属性
  List<GoodsPropsModel> propList = [];
  bool propSingle = false;
  List<int> selectedProps = [];

  // 国家、区域
  CountryModel? selectedCountry;
  AreaModel? selectedArea;
  AreaModel? selectedSubArea;

  @override
  void initState() {
    super.initState();
    getWarehouseList();
    getPropsList();
  }

  // 仓库列表
  void getWarehouseList() async {
    var data = await WarehouseService.getList();
    setState(() {
      warehouses = data;
    });
  }

  // 物品属性列表、物品属性单选、多选
  void getPropsList() async {
    var data = await GoodsService.getPropList();
    var single = await GoodsService.getPropConfig();
    setState(() {
      propList = data;
      propSingle = single;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: 10, top: ScreenUtil().setHeight(125)),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(35),
            child: Row(
              children: [
                buildModuleTitle('运费试算', 0),
                buildModuleTitle('仓库地址', 1),
              ],
            ),
          ),
          buildQueryView(),
        ],
      ),
    );
  }

  Widget buildModuleTitle(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (index == 1) {
              ApplicationEvent.getInstance()
                  .event
                  .fire(ChangePageIndexEvent(pageName: 'warehouse'));
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == 0 ? Colors.white : ColorConfig.mainAlpha,
            borderRadius: BorderRadius.only(
              bottomLeft: index == 0 ? Radius.zero : const Radius.circular(20),
              topLeft: index == 0 ? const Radius.circular(20) : Radius.zero,
              topRight: index == 0 ? Radius.zero : const Radius.circular(20),
            ),
          ),
          child: Caption(
            str: title,
            color: index == 0 ? ColorConfig.textDark : ColorConfig.main,
          ),
        ),
      ),
    );
  }

  // 运费试算
  Widget buildQueryView() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: Column(
        children: [
          buildQueryAddress(),
          Gaps.line,
          buildQueryItem(
            '重量',
            '请输入重量，数字即可',
            _weightController,
            _weightNode,
            keyboardType: TextInputType.number,
          ),
          Gaps.line,
          (selectedCountry?.regionsCount ?? 0) > 0
              ? buildQueryItem(
                  '邮编',
                  '请输入收件地址邮编',
                  _postcodeController,
                  _postcodeNode,
                )
              : Gaps.empty,
          (selectedCountry?.regionsCount ?? 0) > 0 ? Gaps.line : Gaps.empty,
          buildPropsView(),
          queryBtn(),
          SizedBox(
            child: Caption(
              str: '*运费试算仅为参考结果',
              fontSize: ScreenUtil().setSp(9),
              color: ColorConfig.main,
            ),
          ),
        ],
      ),
    );
  }

  List<PickerItem> getWarehousePicker() {
    List<PickerItem> data = [];
    for (var item in warehouses) {
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

  // 仓库、收货地区
  Widget buildQueryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Picker(
                  cancelText: '取消',
                  confirmText: '确认',
                  adapter: PickerDataAdapter(
                    data: getWarehousePicker(),
                  ),
                  onConfirm: (Picker picker, List value) {
                    setState(() {
                      selectedWarehouse = warehouses[value.first];
                      selectedArea = null;
                      selectedCountry = null;
                      selectedSubArea = null;
                    });
                  },
                ).showModal(context);
              },
              child: Column(
                children: [
                  Caption(
                    str: selectedWarehouse?.warehouseName ?? '请选择',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Caption(
                      str: '出发地',
                      color: ColorConfig.main,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: const LoadImage(
              'Home/arrow',
              fit: BoxFit.fitWidth,
              width: 60,
              format: 'png',
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (selectedWarehouse == null) {
                  Util.showToast('请选择出发地');
                  return;
                }
                var data = await Routers.push('/CountryListPage', context, {
                  'warehouseId': selectedWarehouse!.id,
                });
                if (data != null) {
                  setState(() {
                    if (data is Map) {
                      selectedCountry = data['country'];
                      selectedArea = data['area'];
                      selectedSubArea = data['subArea'];
                    } else {
                      selectedCountry = (data as CountryModel);
                      selectedArea = null;
                      selectedSubArea = null;
                    }
                  });
                }
              },
              child: Column(
                children: [
                  Caption(
                    str: selectedCountry != null
                        ? (selectedCountry!.name! +
                            (selectedArea != null
                                ? '/${selectedArea!.name}'
                                : '') +
                            (selectedSubArea != null
                                ? '/${selectedSubArea!.name}'
                                : ''))
                        : '请选择',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(18),
                    // lines: 4,
                    alignment: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Caption(
                      str: '收货地区',
                      color: ColorConfig.main,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 物品属性
  Widget buildPropsView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          child: Caption(
            str: '货物属性',
            color: ColorConfig.main,
            fontSize: ScreenUtil().setSp(12),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(22),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: propList.length,
            itemBuilder: (BuildContext context, index) {
              GoodsPropsModel model = propList[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedProps.contains(model.id)) {
                      selectedProps.remove(model.id);
                    } else {
                      if (propSingle) {
                        selectedProps.isEmpty
                            ? (selectedProps.add(model.id))
                            : (selectedProps[0] = model.id);
                      } else {
                        selectedProps.add(model.id);
                      }
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorConfig.mainAlpha,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: selectedProps.contains(model.id)
                          ? Border.all(color: ColorConfig.primary, width: 2)
                          : null),
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil().setWidth(70),
                  ),
                  child: Caption(
                    str: model.name ?? '',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 运费查询
  void onQuery() {
    String msg = '';
    if (selectedWarehouse == null) {
      msg = '请选择出发地';
    } else if (selectedCountry == null) {
      msg = '请选择寄往国家';
    } else if (_weightController.text.isEmpty) {
      msg = '请输入重量';
    } else if (selectedCountry!.regionsCount! > 0 &&
        _postcodeController.text.isEmpty) {
      msg = '请输入邮编';
    } else if (selectedProps.isEmpty) {
      msg = '请选择货物属性';
    }
    if (msg.isNotEmpty) {
      Util.showToast(msg);
      return;
    }
    Map params = {
      "warehouse": selectedWarehouse,
      "country": selectedCountry,
      "area": selectedArea,
      "subArea": selectedSubArea,
      "props": selectedProps,
      "weight": _weightController.text,
      "postcode": _postcodeController.text,
    };
    Routers.push('/LineQueryPage', context, params);
  }

  // 查询按钮
  Widget queryBtn() {
    return GestureDetector(
      onTap: onQuery,
      child: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.only(
          top: 30,
          bottom: 10,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home/s_button.png'),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: const Caption(
          str: '查询报价',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildQueryItem(
    String label,
    String hintText,
    TextEditingController controller,
    FocusNode focusNode, {
    keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Caption(
            str: label,
            color: ColorConfig.primary,
            fontSize: ScreenUtil().setSp(18),
          ),
          Expanded(
            child: BaseInput(
              controller: controller,
              focusNode: focusNode,
              autoShowRemove: false,
              isCollapsed: true,
              textAlign: TextAlign.right,
              keyboardType: keyboardType ?? TextInputType.text,
              hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: ColorConfig.main,
              ),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
