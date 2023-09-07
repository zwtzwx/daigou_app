import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/coordinate_model.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/group/widget/distance_widget.dart';

class PublicGroupItemCell extends StatelessWidget {
  const PublicGroupItemCell({
    Key? key,
    required this.model,
    this.coordinate,
  }) : super(key: key);
  final GroupModel model;
  final CoordinateModel? coordinate;

  void _toGroupDetail(BuildContext context) {
    Routers.push(Routers.goodsDetail, {'id': model.id});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toGroupDetail(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 9,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ZHTextLine(
              str: model.code ?? model.orderSn ?? '',
              fontWeight: FontWeight.bold,
            ),
            Sized.vGap10,
            Row(
              children: [
                Expanded(
                  child: ZHTextLine(
                    str: model.leader?.name ?? '',
                  ),
                ),
                coordinate != null && model.coordinate != null
                    ? DistanceWidget(
                        startPosition: coordinate!,
                        endPosition: model.coordinate!,
                      )
                    : Sized.empty,
              ],
            ),
            Sized.vGap10,
            Sized.line,
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: ZHTextLine(
                str: model.name!,
                fontWeight: FontWeight.bold,
                lines: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ZHTextLine(
                    str: model.warehouseName ?? '',
                  ),
                  Column(
                    children: [
                      ZHTextLine(
                        str: model.expressLine?.referenceTime ?? '',
                        color: BaseStylesConfig.green,
                        fontSize: 12,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: LoadImage(
                          'Group/arrow',
                          format: 'jpg',
                          width: 100,
                        ),
                      ),
                      ZHTextLine(
                        str: model.expressLine?.name ?? '',
                        color: BaseStylesConfig.groupText,
                        fontSize: 10,
                      )
                    ],
                  ),
                  ZHTextLine(
                    str: model.country ?? '',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                children: [
                  ZHTextLine(
                    str: '地址'.ts,
                    color: BaseStylesConfig.textGrayC,
                    fontSize: 13,
                  ),
                  Sized.hGap10,
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: ZHTextLine(
                        str: (model.address!.area != null
                                ? '${model.address!.area!.name} '
                                : '') +
                            (model.address!.subArea != null
                                ? '${model.address!.subArea!.name} '
                                : '') +
                            '${model.address!.street} ${model.address!.doorNo} ${model.address!.postcode} ${model.address!.city}',
                        fontSize: 13,
                        lines: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Sized.line,
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ZHTextLine(
                    str: '截团时间'.ts,
                    color: BaseStylesConfig.textGrayC,
                    fontSize: 13,
                  ),
                  ZHTextLine(
                    str: model.endTime ?? '',
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            Sized.line,
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              model.membersAvatar!.asMap().keys.map((index) {
                            return Transform.translate(
                              offset: Offset(
                                -(14 * index).toDouble(),
                                0,
                              ),
                              child: ClipOval(
                                child: LoadImage(
                                  model.membersAvatar![index],
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Sized.hGap5,
                      ZHTextLine(
                        str: '已有{count}人加入此团'
                            .tsArgs({'count': model.membersCount.toString()}),
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                MainButton(
                  text: '去参团',
                  fontSize: 14,
                  borderRadis: 999,
                  fontWeight: FontWeight.bold,
                  backgroundColor: BaseStylesConfig.primary,
                  onPressed: () {
                    _toGroupDetail(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
