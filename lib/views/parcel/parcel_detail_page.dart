/*
  已入库包裹详情
*/

import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/*
  包裹详情
*/

class PackageDetailPage extends StatefulWidget {
  final Map arguments;
  const PackageDetailPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  PackageDetailPageState createState() => PackageDetailPageState();
}

class PackageDetailPageState extends State<PackageDetailPage>
    with SingleTickerProviderStateMixin {
  bool isLoadingLocal = false;
  bool isEdit = false;
  bool _valueEdit = false;

  late ParcelModel parcelModel;
  WareHouseModel? wareHouseModel;
  CountryModel? countryModel;
  GoodsPropsModel? goodsPropsModel;

  late LocalizationModel? localizationInfo;

  String categoriesStr = '';
  // 金额输入框
  final TextEditingController _packageMoneyController = TextEditingController();
  final FocusNode _packageMoney = FocusNode();

  bool get wantKeepAlive => true;

  late int parcelId;

  @override
  void initState() {
    super.initState();
    parcelId = widget.arguments['id'];
    isEdit = widget.arguments['edit'];

    created();
  }

  created() async {
    EasyLoading.show();
    var data = await ParcelService.getDetail(parcelId);
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        parcelModel = data;
        if (data.categories != null) {
          for (GoodsCategoryModel item in data.categories!) {
            if (categoriesStr.isEmpty) {
              categoriesStr += item.name;
            } else {
              categoriesStr += '、' + item.name;
            }
          }
        }
        isLoadingLocal = true;
      });
    }
  }

  // 修改包裹价值
  void updatePrice() async {
    if (_valueEdit && _packageMoneyController.text.isEmpty) {
      Util.showToast('请输入包裹价值');
      return;
    }
    if (_valueEdit) {
      List props = parcelModel.prop!.map((e) => e.id).toList();
      double value = double.parse(_packageMoneyController.text) * 100;
      Map<String, dynamic> params = {
        'prop_id': props,
        'express_num': parcelModel.expressNum,
        'package_value': value
      };
      EasyLoading.show();
      bool data = await ParcelService.update(parcelModel.id!, params);
      EasyLoading.dismiss();
      if (data) {
        EasyLoading.showSuccess('修改成功');
        ApplicationEvent.getInstance()
            .event
            .fire(ListRefreshEvent(type: 'reset'));
      } else {
        EasyLoading.showError('修改失败');
      }
      setState(() {
        parcelModel.packageValue = data ? value : parcelModel.packageValue;
        _valueEdit = false;
      });
    } else {
      setState(() {
        _valueEdit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Caption(
            str: '包裹详情',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isLoadingLocal
            ? WillPopScope(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        buildTopBox(),
                        buildMiddleBox(),
                        buildBottomBox()
                      ],
                    ),
                  ),
                ),
                onWillPop: () async {
                  Navigator.pop(context, parcelModel.packageValue);
                  return false;
                })
            : Container());
  }

  // 快递单号、快递名称
  Widget buildTopBox() {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConfig.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 80,
                  child: Caption(
                    str: '快递名称',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: parcelModel.expressName ?? '',
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 80,
                  child: Caption(
                    str: '快递单号',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: parcelModel.expressNum ?? '',
                ),
              ],
            ),
          ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  child: const Caption(
                    str: '包裹名称',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: parcelModel.packageName!,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  child: const Caption(
                    str: '包裹价值',
                    color: ColorConfig.textNormal,
                  ),
                ),
                isEdit
                    ? buildEditPackageValue()
                    : Caption(
                        str: localizationInfo!.currencySymbol +
                            (parcelModel.packageValue! / 100)
                                .toStringAsFixed(2))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  child: const Caption(
                    str: '包裹数量',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: parcelModel.qty.toString(),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  child: const Caption(
                    str: '包裹类型',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: Caption(
                    str: categoriesStr,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  child: const Caption(
                    str: '包裹属性',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Caption(
                  str: parcelModel.prop != null && parcelModel.prop!.isNotEmpty
                      ? parcelModel.prop!.first.name!
                      : '',
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 80,
                  child: const Caption(
                    str: '包裹备注',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      parcelModel.remark ?? '无',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: (parcelModel.packagePictures != null &&
                      parcelModel.packagePictures!.isNotEmpty)
                  ? double.infinity
                  : 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 80,
                  child: Caption(
                    str: '包裹照片',
                    color: ColorConfig.textNormal,
                  ),
                ),
                parcelModel.packagePictures != null
                    ? Expanded(
                        child: Container(
                          color: ColorConfig.white,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5.0, //水平子Widget之间间距
                                mainAxisSpacing: 5.0, //垂直子Widget之间间距
                                crossAxisCount: 3, //一行的Widget数量
                                childAspectRatio: 1,
                              ), // 宽高比例
                              itemCount: parcelModel.packagePictures!.length,
                              itemBuilder: _buildGrideBtnView(
                                  parcelModel.packagePictures!)),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 包裹价值
  Widget buildEditPackageValue() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: _valueEdit
                ? SizedBox(
                    child: BaseInput(
                      hintText: "请输入包裹价值",
                      // contentPadding: const EdgeInsets.only(bottom: 12),
                      textAlign: TextAlign.left,
                      controller: _packageMoneyController,
                      focusNode: _packageMoney,
                      contentPadding: const EdgeInsets.only(right: 10),
                      isCollapsed: true,
                      autoShowRemove: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                : Caption(
                    str: localizationInfo!.currencySymbol +
                        (parcelModel.packageValue! / 100).toStringAsFixed(2),
                  ),
          ),
          GestureDetector(
            onTap: () {
              updatePrice();
            },
            child: Caption(
              str: _valueEdit ? '确认' : '修改',
              color: ColorConfig.warningTextDark,
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
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 80,
                  child: Caption(
                    str: '发往国家',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ColorConfig.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Caption(
                          str: parcelModel.country != null
                              ? parcelModel.country!.name!
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 80,
                  child: Caption(
                    str: '发往仓库',
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ColorConfig.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Caption(
                          str: parcelModel.warehouse != null
                              ? parcelModel.warehouse!.warehouseName!
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView(List<String> imgList) {
    return (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: imgList, //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
        },
        child: Container(
          color: ColorConfig.white,
          child: LoadImage(
            imgList[index],
            fit: BoxFit.contain,
            width: 50,
            height: 50,
          ),
        ),
      );
    };
  }
}
