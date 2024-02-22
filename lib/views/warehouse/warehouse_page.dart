import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/warehouse_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/warehouse/warehouse_controller.dart';

/*
  仓库地址
*/

class BeeCangKuPage extends GetView<BeeCangKuLogic> {
  const BeeCangKuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: AppText(
          str: '仓库地址'.ts,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: buildListItem,
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    if (index == 0) {
      return bannerCell();
    } else {
      return listCell();
    }
  }

  Widget bannerCell() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      color: AppColors.warningText,
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
          ),
          AppGaps.hGap5,
          Expanded(
            child: AppText(
              str: '收件人后面的字母和数字是您的唯一标识快递单务必填写'.ts,
              color: Colors.white,
              fontSize: 13,
              lines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget listCell() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.warehouseList.length,
          itemBuilder: renderItem,
        ),
      ),
    );
  }

  Widget renderItem(BuildContext context, int index) {
    WareHouseModel model = controller.warehouseList[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: cellItem(model),
    );
  }

  Widget cellItem(WareHouseModel model) {
    List<String> labels = [
      '收件人',
      '手机号码',
      '收件地址',
      '邮政编码',
      '免费仓储',
    ];

    String storeStr = '无限制'.ts;
    if (model.freeStoreDays != null && model.freeStoreDays! > 0) {
      String storeFee = (model.storeFee! / 100).toStringAsFixed(2);
      storeStr = '免费仓储{day}天超期收费{fee}/天'
          .tsArgs({'day': model.freeStoreDays, 'fee': storeFee});
    }
    List<String> contents = [
      model.receiverName!,
      model.phone!,
      model.address!,
      model.postcode!,
      storeStr,
    ];
    List<Widget> widgets = [];
    for (var i = 0; i < labels.length; i++) {
      widgets.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.line),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: AppText(
                str: labels[i].ts,
                color: AppColors.textGrayC9,
                fontSize: 14,
                lines: 3,
              ),
            ),
            Expanded(
              child: AppText(
                str: contents[i],
                lines: 4,
              ),
            ),
            i < 4
                ? Container(
                    margin: EdgeInsets.only(left: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        controller.onCopyData(contents[i]);
                      },
                      child: LoadAssetImage(
                        'Transport/ico_fz',
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                  )
                : AppGaps.empty,
          ],
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                str: model.warehouseName!,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        ...widgets,
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                str: '温馨提示'.ts + '：',
                fontSize: 12,
              ),
              AppGaps.vGap5,
              AppText(
                str: model.tips ?? '',
                fontSize: 12,
                lines: 4,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          height: 50,
          color: AppColors.bgGray,
          child: BeeButton(
            text: '一键复制仓库地址',
            onPressed: () {
              String copyStr =
                  '${labels[0]}：${contents[0]}\n${labels[1]}：${contents[1]}\n${labels[3]}：${contents[3]}\n${labels[2]}：${contents[2]}';
              controller.onCopyData(copyStr);
            },
          ),
        ),
      ],
    );
  }
}
