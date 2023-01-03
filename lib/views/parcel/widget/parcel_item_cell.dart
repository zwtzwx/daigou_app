import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class ParcelItemCell extends StatelessWidget {
  const ParcelItemCell({
    Key? key,
    required this.model,
    this.index,
    this.localizationInfo,
  }) : super(key: key);
  final ParcelModel model;
  final int? index;
  final LocalizationModel? localizationInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Routers.push(
              '/PackageDetailPage', context, {'id': model.id, 'edit': false});
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
              Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  margin: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const LoadImage(
                            'PackageAndOrder/package',
                            width: 23,
                            height: 23,
                          ),
                          Gaps.hGap10,
                          ZHTextLine(
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
                                      title: Translation.t(context, '异常件提示'),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 15),
                                        child: ZHTextLine(
                                          str: model.exceptionalRemark!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.red[700],
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: ZHTextLine(
                                      str: Translation.t(context, '异常件'),
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
              Gaps.line,
              model.remark != null && model.remark!.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: ZHTextLine(
                        str: model.remark!,
                        color: ColorConfig.textRed,
                        lines: 30,
                      ),
                    )
                  : Gaps.empty,
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
                            Gaps.vGap20,
                            ZHTextLine(
                              str: model.warehouse?.warehouseName ?? '',
                            )
                          ],
                        ),
                        Column(
                          children: [
                            const LoadImage(
                              'PackageAndOrder/fly',
                              width: 24,
                              height: 24,
                            ),
                            Gaps.vGap4,
                            ZHTextLine(
                              str: model.status == 1
                                  ? Translation.t(context, '等待称重')
                                  : Translation.t(context, '已入库'),
                              color: ColorConfig.primary,
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
                            Gaps.vGap20,
                            ZHTextLine(
                              str: model.country?.name ?? '',
                            )
                          ],
                        ),
                      ],
                    ),
                    Gaps.vGap15,
                    Gaps.line,
                    Gaps.vGap10,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: ColorConfig.bgGray,
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
                          Gaps.vGap10,
                          ZHTextLine(
                            str: '${model.packageName} ' +
                                (model.packageValue! / 100).toStringAsFixed(2),
                          ),
                        ],
                      ),
                    ),
                    Gaps.vGap10,
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: ZHTextLine(
                              str: Translation.t(context, '称重重量') +
                                  '：${((model.countWeight ?? 0) / 1000).toStringAsFixed(2)}${localizationInfo?.weightSymbol}',
                              fontSize: 13,
                              color: ColorConfig.textGray,
                            ),
                          )
                        : Gaps.empty,
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: ZHTextLine(
                              str: Translation.t(context, '入库尺寸') +
                                  '：'
                                      '${((model.length ?? 0) / 100).toStringAsFixed(2)}*'
                                      '${((model.width ?? 0) / 100).toStringAsFixed(2)}*'
                                      '${((model.height ?? 0) / 100).toStringAsFixed(2)}${localizationInfo?.lengthSymbol}',
                              fontSize: 13,
                              color: ColorConfig.textGray,
                            ),
                          )
                        : Gaps.empty,
                    ZHTextLine(
                      str: Translation.t(context, '提交时间') +
                          '：${model.createdAt}',
                      fontSize: 13,
                      color: ColorConfig.textGray,
                    ),
                    model.status == 2
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: ZHTextLine(
                              str: Translation.t(context, '入库时间') +
                                  '：${model.inStorageAt}',
                              fontSize: 13,
                              color: ColorConfig.textGray,
                            ),
                          )
                        : Gaps.empty,
                    model.status == 2 &&
                            (model.warehouse?.freeStoreDays ?? 0) > 0 &&
                            (model.inStorageAt != null ||
                                model.weighedAt != null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '${Translation.t(context, '免费仓储')}：',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: ColorConfig.textGray,
                                  ),
                                ),
                                model.freeTime! >= 0
                                    ? TextSpan(
                                        text: Translation.t(
                                          context,
                                          '还剩{freeTime}天，超期收费{price}/天',
                                          value: {
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
                                          color: ColorConfig.textGray,
                                        ),
                                      )
                                    : TextSpan(children: [
                                        TextSpan(
                                          text: Translation.t(
                                            context,
                                            '已超期{freeTime}天',
                                            value: {
                                              'freeTime': -model.freeTime!
                                            },
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: ColorConfig.textRed,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '，' +
                                              Translation.t(
                                                context,
                                                '超期收费{price}/天',
                                                value: {
                                                  'price': ((model.warehouse
                                                                  ?.storeFee ??
                                                              0) /
                                                          100)
                                                      .toStringAsFixed(2),
                                                },
                                              ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: ColorConfig.textGray,
                                          ),
                                        ),
                                      ])
                              ]),
                            ),
                          )
                        : Gaps.empty,
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
                            ? PlainButton(
                                text: '删除',
                                onPressed: () async {
                                  var data = await BaseDialog.confirmDialog(
                                      context,
                                      Translation.t(context, '确定要删除吗') + '？');
                                  if (data != null) {
                                    if (await ParcelService.delete(model.id!)) {
                                      Util.showToast(
                                          Translation.t(context, '删除包裹成功'));
                                      ApplicationEvent.getInstance().event.fire(
                                          ListRefreshEvent(
                                              type: 'delete', index: index));
                                      ApplicationEvent.getInstance()
                                          .event
                                          .fire(OrderCountRefreshEvent());
                                    } else {
                                      Util.showToast(
                                          Translation.t(context, '删除包裹失败'));
                                    }
                                  }
                                },
                              )
                            : Gaps.empty,
                        Gaps.hGap10,
                        PlainButton(
                          text: model.notConfirmed == 1 ? '补全信息' : '修改',
                          onPressed: () {
                            Routers.push('/EditParcelPage', context,
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
          border: Border.all(color: ColorConfig.primary),
        ),
        child: ZHTextLine(
          str: element.name ?? '',
          fontSize: 12,
          color: ColorConfig.primary,
        ),
      ));
    });
    return widgets;
  }
}
