import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/group_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class MemberGroupParcelInfo extends StatefulWidget {
  const MemberGroupParcelInfo({
    Key? key,
    required this.model,
    required this.onChooseParcel,
    required this.onHasParcel,
    required this.onBack,
    this.localModel,
  }) : super(key: key);
  final GroupModel model;
  final Function onChooseParcel;
  final LocalizationModel? localModel;
  final Function onHasParcel;
  final Function onBack;

  @override
  State<MemberGroupParcelInfo> createState() => _MemberGroupParcelInfoState();
}

class _MemberGroupParcelInfoState extends State<MemberGroupParcelInfo> {
  List<ParcelModel> parcelList = [];
  WareHouseModel? warehouse;

  @override
  initState() {
    super.initState();
    getPackages();
    getDefaultWarehouse();
  }

  // 已加入拼团的包裹
  void getPackages() async {
    var data = await GroupService.getGroupAddedParcelsDetail(widget.model.id!);
    if (data['dataList'] != null) {
      setState(() {
        parcelList = data['dataList'];

        widget.onHasParcel(data['dataList'].isNotEmpty);
      });
    }
  }

  // 获取默认仓库地址
  getDefaultWarehouse() async {
    var res = await WarehouseService.getDefaultWarehouse();
    if (res != null) {
      setState(() {
        warehouse = res;
      });
    }
  }

  // 退回拼团包裹
  void onParcelBack(int id) async {
    EasyLoading.show();
    var res = await GroupService.onGroupParcelReturn(widget.model.id!, {
      'package_ids': [id]
    });
    if (res['ok']) {
      getPackages();
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          widget.model.order != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          str: '我的参团信息'.ts,
                          fontWeight: FontWeight.bold,
                        ),
                        AppText(
                          str: CommonMethods.getOrderStatusName(
                              widget.model.order!.status),
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ],
                    ),
                    AppGaps.vGap20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ImgItem(
                          'Group/group',
                          width: 20,
                        ),
                        AppGaps.hGap10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              str: widget.model.order!.orderSn,
                              fontWeight: FontWeight.bold,
                            ),
                            AppGaps.vGap4,
                            AppText(
                              str: widget.model.order!.createdAt,
                              color: AppColors.textGrayC9,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppGaps.vGap20,
                  ],
                )
              : AppGaps.empty,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      str: '我要参团包裹'.ts + ' (${parcelList.length})',
                      fontWeight: FontWeight.bold,
                      lines: 4,
                    ),
                  ),
                  !widget.model.isSubmitted!
                      ? GestureDetector(
                          onTap: () {
                            widget.onChooseParcel(getPackages);
                          },
                          child: Row(
                            children: [
                              AppText(
                                str: '选择拼团包裹'.ts,
                                fontWeight: FontWeight.bold,
                                color: AppColors.groupText,
                              ),
                              AppGaps.hGap10,
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: AppColors.groupText,
                              ),
                            ],
                          ),
                        )
                      : AppGaps.empty,
                ],
              ),
              ...parcelList.map((e) => parcelItemCell(e)).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget parcelItemCell(ParcelModel parcel) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            blurRadius: 9,
            color: Color(0x1A000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: parcel.expressNum ?? '',
                  fontWeight: FontWeight.bold,
                ),
                !widget.model.isSubmitted!
                    ? GestureDetector(
                        onTap: () {
                          onParcelBack(parcel.id!);
                        },
                        child: AppText(
                          str: '退回'.ts,
                          fontSize: 13,
                          color: AppColors.green,
                        ),
                      )
                    : AppGaps.empty,
              ],
            ),
          ),
          AppGaps.line,
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...parcel.prop!.map((e) => propItemCell(e)).toList(),
                    AppText(
                      str: parcel.packageName!,
                      fontSize: 12,
                    ),
                    AppText(
                      str: parcel.packageValue!.rate(),
                      fontSize: 12,
                    ),
                  ],
                ),
                AppGaps.vGap15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoItem(
                      '称重重量',
                      ((parcel.packageWeight ?? 0) / 1000).toStringAsFixed(2) +
                          (widget.localModel?.weightSymbol ?? ''),
                    ),
                    infoItem(
                      '入库尺寸',
                      ((parcel.length ?? 0) / 100).toStringAsFixed(2) +
                          '*' +
                          ((parcel.width ?? 0) / 100).toStringAsFixed(2) +
                          '*' +
                          ((parcel.height ?? 0) / 100).toStringAsFixed(2) +
                          ' ' +
                          (widget.localModel?.lengthSymbol ?? ''),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget propItemCell(ParcelPropsModel prop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBE4),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: AppText(
        str: prop.name!,
        color: AppColors.groupText,
        fontSize: 10,
      ),
    );
  }

  Widget infoItem(String title, String content) {
    return Row(
      children: [
        AppText(
          str: title.ts + '：',
          fontSize: 11,
        ),
        AppText(
          str: content,
          fontSize: 11,
          color: AppColors.groupText,
        ),
      ],
    );
  }
}
