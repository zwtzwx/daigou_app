import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class GroupItemCell extends StatelessWidget {
  const GroupItemCell({
    Key? key,
    required this.groupModel,
    required this.localizationModel,
    this.onConfirm,
  }) : super(key: key);
  final GroupModel groupModel;
  final LocalizationModel? localizationModel;
  final Function? onConfirm;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onConfirm != null) {
          onConfirm!(groupModel.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              str: groupModel.code ?? '',
              fontWeight: FontWeight.bold,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: groupModel.name!,
                ),
                ZHTextLine(
                  str: Util.getGroupStatusName(groupModel.status!).ts,
                  color: groupModel.status == 0
                      ? BaseStylesConfig.primary
                      : BaseStylesConfig.textBlack,
                ),
              ],
            ),
            Sized.vGap15,
            Sized.line,
            Sized.vGap15,
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
                    str: groupModel.warehouseName ?? '',
                  ),
                  Column(
                    children: [
                      ZHTextLine(
                        str: groupModel.expressLine?.referenceTime ?? '',
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
                        str: groupModel.expressLine?.name ?? '',
                        color: BaseStylesConfig.groupText,
                        fontSize: 12,
                      )
                    ],
                  ),
                  ZHTextLine(
                    str: groupModel.country ?? '',
                  ),
                ],
              ),
            ),
            Sized.vGap10,
            ZHTextLine(
              str: groupModel.address!.receiverName +
                  ' ${groupModel.address!.timezone}${groupModel.address!.phone}',
              fontSize: 14,
            ),
            ZHTextLine(
              str: (groupModel.address!.area != null
                      ? '${groupModel.address!.area!.name} '
                      : '') +
                  (groupModel.address!.subArea != null
                      ? '${groupModel.address!.subArea!.name} '
                      : '') +
                  '${groupModel.address!.street} ${groupModel.address!.doorNo} ${groupModel.address!.postcode} ${groupModel.address!.city}',
              fontSize: 14,
              lines: 4,
            ),
            Sized.vGap5,
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: BaseStylesConfig.textBlack,
                ),
                children: [
                  TextSpan(
                    text: '已入库包裹重量'.ts + '：',
                    style: const TextStyle(color: BaseStylesConfig.textGray),
                  ),
                  TextSpan(
                    text: ((groupModel.packageWeight ?? 0) / 1000)
                            .toStringAsFixed(2) +
                        (localizationModel?.weightSymbol ?? ''),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
