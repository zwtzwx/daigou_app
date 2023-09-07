import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
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
    this.localModel,
  }) : super(key: key);
  final GroupModel model;
  final Function onChooseParcel;
  final LocalizationModel? localModel;
  final Function onHasParcel;

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
        if (data['dataList'].isNotEmpty) {
          widget.onHasParcel();
        }
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

  void onCopyWarehouse() {
    var userInfo = Get.find<UserInfoModel>().userInfo.value;
    var name = '收件人：(${userInfo!.id})${warehouse?.warehouseName ?? ''}\n';
    var phone = '手机号码：${warehouse?.phone}\n';
    var postcode = '邮编：${warehouse?.postcode}\n';
    var address = '收货地址：${warehouse?.address}';
    Clipboard.setData(ClipboardData(text: '$name$phone$postcode$address'))
        .then((value) => EasyLoading.showSuccess('复制成功'.ts));
  }

  // 退回拼团包裹
  void onParcelBack(int id) async {
    EasyLoading.show();
    var res = await GroupService.onGroupParcelReturn(widget.model.id!, {
      'package_ids': [id]
    });
    EasyLoading.dismiss();
    if (res['ok']) {
      await EasyLoading.showSuccess(res['msg']);
      getPackages();
    } else {
      EasyLoading.showError(res['msg']);
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
                        ZHTextLine(
                          str: '我的参团信息'.ts,
                          fontWeight: FontWeight.bold,
                        ),
                        ZHTextLine(
                          str: Util.getOrderStatusName(
                              widget.model.order!.status),
                          fontWeight: FontWeight.bold,
                          color: BaseStylesConfig.green,
                        ),
                      ],
                    ),
                    Sized.vGap20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoadImage(
                          'Group/group',
                          width: 20,
                        ),
                        Sized.hGap10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ZHTextLine(
                              str: widget.model.order!.orderSn,
                              fontWeight: FontWeight.bold,
                            ),
                            Sized.vGap4,
                            ZHTextLine(
                              str: widget.model.order!.createdAt,
                              color: BaseStylesConfig.textGrayC9,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Sized.vGap20,
                  ],
                )
              : Sized.empty,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ZHTextLine(
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
                              ZHTextLine(
                                str: '选择拼团包裹'.ts,
                                fontWeight: FontWeight.bold,
                                color: BaseStylesConfig.groupText,
                              ),
                              Sized.hGap10,
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: BaseStylesConfig.groupText,
                              ),
                            ],
                          ),
                        )
                      : Sized.empty,
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
                ZHTextLine(
                  str: parcel.expressNum ?? '',
                  fontWeight: FontWeight.bold,
                ),
                !widget.model.isSubmitted!
                    ? GestureDetector(
                        onTap: () {
                          onParcelBack(parcel.id!);
                        },
                        child: ZHTextLine(
                          str: '退回'.ts,
                          fontSize: 13,
                          color: BaseStylesConfig.green,
                        ),
                      )
                    : Sized.empty,
              ],
            ),
          ),
          Sized.line,
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
                    ZHTextLine(
                      str: parcel.packageName!,
                      fontSize: 12,
                    ),
                    ZHTextLine(
                      str: parcel.packageValue!.rate(),
                      fontSize: 12,
                    ),
                  ],
                ),
                Sized.vGap15,
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
      child: ZHTextLine(
        str: prop.name!,
        color: BaseStylesConfig.groupText,
        fontSize: 10,
      ),
    );
  }

  Widget infoItem(String title, String content) {
    return Row(
      children: [
        ZHTextLine(
          str: title.ts + '：',
          fontSize: 11,
        ),
        ZHTextLine(
          str: content,
          fontSize: 11,
          color: BaseStylesConfig.groupText,
        ),
      ],
    );
  }
}
