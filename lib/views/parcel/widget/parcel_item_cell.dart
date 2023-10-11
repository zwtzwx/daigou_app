import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class BeePackageItem extends StatelessWidget {
  const BeePackageItem({
    Key? key,
    required this.model,
    this.index,
    this.onChecked,
    this.checkedIds,
    this.localModel,
    this.onDeleteParcel,
  }) : super(key: key);
  final ParcelModel model;
  final int? index;
  final Function? onChecked;
  final List<int>? checkedIds;
  final LocalizationModel? localModel;
  final Function? onDeleteParcel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          BeeNav.push(BeeNav.parcelDetail, {'id': model.id, 'edit': false});
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: Colors.white),
          ),
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    height: 30,
                    margin: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            model.status == 2
                                ? (model.notConfirmed == 1
                                    ? const Icon(
                                        Icons.error_outline,
                                        color: AppColors.textRed,
                                      )
                                    : Obx(
                                        () => SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child: Checkbox(
                                            value: (checkedIds ?? [])
                                                .contains(model.id),
                                            shape: const CircleBorder(),
                                            activeColor: AppColors.primary,
                                            checkColor: Colors.black,
                                            onChanged: (value) {
                                              if (onChecked != null) {
                                                onChecked!(model.id);
                                              }
                                            },
                                          ),
                                        ),
                                      ))
                                : AppGaps.empty,
                            model.status == 2
                                ? 5.horizontalSpace
                                : AppGaps.empty,
                            const ImgItem(
                              'PackageAndOrder/package',
                              width: 23,
                              height: 23,
                            ),
                            AppGaps.hGap10,
                            AppText(
                              fontSize: 16,
                              str: model.expressNum!,
                              color: HexToColor('#8a8a8a'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            model.isExceptional == 1
                                ? GestureDetector(
                                    onTap: () {
                                      BaseDialog.normalDialog(
                                        context,
                                        title: '异常件提示'.ts,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 15),
                                          child: AppText(
                                            str: model.exceptionalRemark!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.red[700],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      child: AppText(
                                        str: '异常件'.ts,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : Container(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: HexToColor('#8a8a8a'),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              AppGaps.line,
              model.remark != null && model.remark!.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: AppText(
                        str: model.remark!,
                        color: AppColors.textRed,
                        lines: 30,
                      ),
                    )
                  : AppGaps.empty,
              Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: const Color(0xFF9bbf4d),
                                width: 8,
                                height: 8,
                              ),
                            ),
                            AppGaps.vGap20,
                            AppText(
                              str: model.warehouse?.warehouseName ?? '',
                            )
                          ],
                        ),
                        Column(
                          children: [
                            const ImgItem(
                              'PackageAndOrder/fly',
                              width: 24,
                              height: 24,
                            ),
                            AppGaps.vGap4,
                            AppText(
                              str: model.status == 1 ? '等待称重'.ts : '已入库'.ts,
                              color: AppColors.primary,
                              fontSize: 14,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: const Color(0xFFff4326),
                                width: 8,
                                height: 8,
                              ),
                            ),
                            AppGaps.vGap20,
                            AppText(
                              str: model.country?.name ?? '',
                            )
                          ],
                        ),
                      ],
                    ),
                    AppGaps.vGap15,
                    AppGaps.line,
                    AppGaps.vGap10,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.bgGray,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: buildPropList(),
                          ),
                          AppGaps.vGap10,
                          AppText(
                            str: '${model.packageName} ' +
                                (model.packageValue!).rate(),
                          ),
                        ],
                      ),
                    ),
                    AppGaps.vGap10,
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: AppText(
                              str: '称重重量'.ts +
                                  '：${((model.countWeight ?? 0) / 1000).toStringAsFixed(2)}${localModel?.weightSymbol}',
                              fontSize: 13,
                              color: AppColors.textGray,
                            ),
                          )
                        : AppGaps.empty,
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: AppText(
                              str: '入库尺寸'.ts +
                                  '：'
                                      '${((model.length ?? 0) / 100).toStringAsFixed(2)}*'
                                      '${((model.width ?? 0) / 100).toStringAsFixed(2)}*'
                                      '${((model.height ?? 0) / 100).toStringAsFixed(2)}${localModel?.lengthSymbol}',
                              fontSize: 13,
                              color: AppColors.textGray,
                            ),
                          )
                        : AppGaps.empty,
                    AppText(
                      str: '提交时间'.ts + '：${model.createdAt ?? ''}',
                      fontSize: 13,
                      color: AppColors.textGray,
                    ),
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: AppText(
                              str: '入库时间'.ts + '：${model.inStorageAt ?? ''}',
                              fontSize: 13,
                              color: AppColors.textGray,
                            ),
                          )
                        : AppGaps.empty,
                    model.status == 2 &&
                            (model.warehouse?.freeStoreDays ?? 0) > 0 &&
                            (model.inStorageAt != null ||
                                model.weighedAt != null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '${'免费仓储'.ts}：',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                model.freeTime! >= 0
                                    ? TextSpan(
                                        text: '还剩{freeTime}天，超期收费{price}/天'
                                            .tsArgs(
                                          {
                                            'freeTime': model.freeTime,
                                            'price':
                                                ((model.warehouse?.storeFee ??
                                                            0) /
                                                        100)
                                                    .toStringAsFixed(2),
                                          },
                                        ),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textGray,
                                        ),
                                      )
                                    : TextSpan(children: [
                                        TextSpan(
                                          text: '已超期{freeTime}天'.tsArgs(
                                            {'freeTime': -model.freeTime!},
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textRed,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '，' +
                                              '超期收费{price}/天'.tsArgs(
                                                {
                                                  'price': ((model.warehouse
                                                                  ?.storeFee ??
                                                              0) /
                                                          100)
                                                      .toStringAsFixed(2),
                                                },
                                              ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textGray,
                                          ),
                                        ),
                                      ])
                              ]),
                            ),
                          )
                        : AppGaps.empty,
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        model.status == 1
                            ? HollowButton(
                                text: '删除',
                                textColor: AppColors.textRed,
                                borderRadis: 999,
                                fontSize: 14,
                                borderColor: AppColors.textRed,
                                onPressed: () async {
                                  var data = await BaseDialog.confirmDialog(
                                      context, '确定要删除吗'.ts + '？');
                                  if (data != null) {
                                    onDeleteParcel!();
                                  }
                                },
                              )
                            : AppGaps.empty,
                        AppGaps.hGap10,
                        HollowButton(
                          textColor: Colors.black,
                          borderRadis: 999,
                          fontSize: 14,
                          text: model.notConfirmed == 1 ? '补全信息' : '修改',
                          onPressed: () {
                            BeeNav.push(BeeNav.editParcel,
                                {'id': model.id, 'edit': true});
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // 属性列表
  List<Widget> buildPropList() {
    List<Widget> widgets = [];
    model.prop?.forEach((element) {
      widgets.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
        ),
        child: AppText(
          str: element.name ?? '',
          fontSize: 12,
          color: AppColors.primary,
        ),
      ));
    });
    return widgets;
  }
}
