import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/localization_model.dart';
import 'package:huanting_shop/models/parcel_model.dart';
import 'package:huanting_shop/views/components/base_dialog.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/button/plain_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';

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
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
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
                            10.horizontalSpace,
                            AppText(
                              fontSize: 16,
                              str: model.expressNum!,
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
                            5.horizontalSpace,
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14.sp,
                              color: AppColors.textGrayC9,
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
                        AppText(
                          str: model.warehouse?.warehouseName ?? '',
                        ),
                        ImgItem(
                          'Home/ship',
                          width: 80.w,
                        ),
                        AppText(
                          str: model.country?.name ?? '',
                        ),
                      ],
                    ),
                    25.verticalSpaceFromWidth,
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
                          10.verticalSpaceFromWidth,
                          AppText(
                            str: '${model.packageName} ' +
                                (model.packageValue!).rate(),
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpaceFromWidth,
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: AppText(
                              str: '称重重量'.ts +
                                  '：${((model.countWeight ?? 0) / 1000).toStringAsFixed(2)}${localModel?.weightSymbol}',
                              fontSize: 13,
                              color: AppColors.textGrayC9,
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
                              color: AppColors.textGrayC9,
                            ),
                          )
                        : AppGaps.empty,
                    AppText(
                      str: '提交时间'.ts + '：${model.createdAt ?? ''}',
                      fontSize: 13,
                      color: AppColors.textGrayC9,
                    ),
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: AppText(
                              str: '入库时间'.ts + '：${model.inStorageAt ?? ''}',
                              fontSize: 13,
                              color: AppColors.textGrayC9,
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
                                    color: AppColors.textGrayC9,
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
                                          color: AppColors.textGrayC9,
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
                                            color: AppColors.textGrayC9,
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
              10.verticalSpaceFromWidth,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        model.status == 1
                            ? SizedBox(
                                height: 30.h,
                                child: HollowButton(
                                  text: '删除',
                                  borderColor: AppColors.textGray,
                                  textColor: AppColors.textNormal,
                                  onPressed: () async {
                                    var data = await BaseDialog.confirmDialog(
                                        context, '确定要删除吗'.ts + '？');
                                    if (data != null) {
                                      onDeleteParcel!();
                                    }
                                  },
                                ),
                              )
                            : AppGaps.empty,
                        10.horizontalSpace,
                        SizedBox(
                          height: 30.h,
                          child: BeeButton(
                            text: model.notConfirmed == 1 ? '补全信息' : '修改',
                            onPressed: () {
                              BeeNav.push(BeeNav.editParcel,
                                  {'id': model.id, 'edit': true});
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              10.verticalSpaceFromWidth,
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
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: AppText(
          str: element.name ?? '',
          fontSize: 12,
          color: Colors.white,
        ),
      ));
    });
    return widgets;
  }
}
