import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/warehouse/warehouse_controller.dart';

/*
  仓库地址、
*/

class WarehouseView extends GetView<WarehouseController> {
  const WarehouseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: ZHTextLine(
          str: '仓库地址'.ts,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
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
      color: BaseStylesConfig.warningText,
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
          ),
          Sized.hGap5,
          Expanded(
            child: ZHTextLine(
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
      model.receiverName! +
          (controller.userModel != null ? '(${controller.userModel!.id})' : ''),
      model.phone!,
      model.address! +
          (controller.userModel != null ? '(${controller.userModel!.id})' : ''),
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
            bottom: BorderSide(color: BaseStylesConfig.line),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ZHTextLine(
                str: labels[i].ts,
                color: BaseStylesConfig.textGray,
                fontSize: 16,
                lines: 3,
              ),
            ),
            Expanded(
              child: ZHTextLine(
                str: contents[i],
                lines: 4,
                fontSize: 16,
              ),
            ),
            i < 4
                ? Container(
                    padding: const EdgeInsets.only(left: 15),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: BaseStylesConfig.line),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        controller.onCopy(contents[i]);
                      },
                      child: ZHTextLine(
                        str: '复制'.ts,
                        color: BaseStylesConfig.primary,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Sized.empty,
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
              ZHTextLine(
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
              ZHTextLine(
                str: '温馨提示'.ts + '：',
                fontSize: 12,
              ),
              Sized.vGap5,
              ZHTextLine(
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
          color: BaseStylesConfig.bgGray,
          child: MainButton(
            text: '一键复制仓库地址',
            onPressed: () {
              String copyStr =
                  '${labels[0]}：${contents[0]}\n${labels[1]}：${contents[1]}\n${labels[4]}：${contents[4]}\n${labels[2]}：${contents[2]}';
              controller.onCopy(copyStr);
            },
          ),
        ),
      ],
    );
  }
}
