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
          onConfirm!();
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
            AppText(
              str: groupModel.code ?? '',
              fontWeight: FontWeight.bold,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: groupModel.name!,
                ),
                AppText(
                  str: CommonMethods.getGroupStatusName(groupModel.status!).ts,
                  color: groupModel.status == 0
                      ? AppColors.primary
                      : AppColors.textBlack,
                ),
              ],
            ),
            AppGaps.vGap15,
            AppGaps.line,
            AppGaps.vGap15,
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    str: groupModel.warehouseName ?? '',
                  ),
                  Column(
                    children: [
                      AppText(
                        str: groupModel.expressLine?.referenceTime ?? '',
                        color: AppColors.green,
                        fontSize: 12,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ImgItem(
                          'Group/arrow',
                          format: 'jpg',
                          width: 100,
                        ),
                      ),
                      AppText(
                        str: groupModel.expressLine?.name ?? '',
                        color: AppColors.groupText,
                        fontSize: 12,
                      )
                    ],
                  ),
                  AppText(
                    str: groupModel.country ?? '',
                  ),
                ],
              ),
            ),
            AppGaps.vGap10,
            AppText(
              str: groupModel.address!.receiverName +
                  ' ${groupModel.address!.timezone}${groupModel.address!.phone}',
              fontSize: 14,
            ),
            AppText(
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
            AppGaps.vGap5,
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textBlack,
                ),
                children: [
                  TextSpan(
                    text: '已入库包裹重量'.ts + '：',
                    style: const TextStyle(color: AppColors.textGray),
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
