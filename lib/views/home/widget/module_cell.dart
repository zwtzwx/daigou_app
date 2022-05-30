// ignore_for_file: non_constant_identifier_names

/*
  功能模块按钮列表
  */
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

List<Map> ModuleDataList() {
  List<Map> list = [];
  List<String> listTitle = ['仓库地址', '开始集运', '注意事项', '运费试算'];
  List<String> listDesTitle = [
    '仓库地址，一键复制',
    '国际寄件，品质速递',
    '集运流程，常见问题',
    '超低运费，轻松试算',
  ];
  List<String> listImg = [
    'Home/仓库地址@3x',
    'Home/开始集运@3x',
    'Home/注意事项@3x',
    'Home/运费试算@3x',
  ];
  for (int i = 0; i < 4; i++) {
    Map<dynamic, dynamic> dic = {
      "title": listTitle[i],
      "EnTitle": listDesTitle[i],
      "ImgName": listImg[i],
    };
    list.add(dic);
  }
  return list;
}

Widget ModuleCell(BuildContext context) {
  return Container(
    color: ColorConfig.bgGray,
    child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0.0, //水平子Widget之间间距
          mainAxisSpacing: 0.0, //垂直子Widget之间间距
          crossAxisCount: 2, //一行的Widget数量
          childAspectRatio: 2.6,
        ), // 宽高比例
        itemCount: 4,
        itemBuilder: _buildGrideModuleView()),
  );
}

IndexedWidgetBuilder _buildGrideModuleView() {
  return (context, index) {
    return GestureDetector(
      onTap: () {
        // print(index);
        if (index == 0) {
          Routers.push('/WareHouseAddress', context);
        } else if (index == 1) {
          ApplicationEvent.getInstance()
              .event
              .fire(ChangePageIndexEvent(pageName: 'middle'));
          // if (notRemindFlag == '0' || notRemindFlag == '') {
          //   Routers.push('/BeganToFreight', context);
          // } else {

          // }
        } else if (index == 2) {
          Routers.push('/HelpSupportPage', context);
        } else if (index == 3) {
          Routers.push('/LineQueryPage', context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                blurRadius: 0.1, //阴影模糊程度
                spreadRadius: 0.4 //阴影扩散程度
                )
          ],
          color: ColorConfig.white,
          borderRadius: index == 2
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                )
              : index == 3
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    )
                  : const BorderRadius.all(Radius.circular(0)),
          border: Border.all(width: 0.3, color: ColorConfig.line),
        ),
        margin: index == 0 || index == 2
            ? const EdgeInsets.only(left: 10)
            : const EdgeInsets.only(right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 5, top: 0),
                child: LoadImage(
                  '',
                  fit: BoxFit.fitHeight,
                  holderImg: ModuleDataList()[index]['ImgName'],
                  format: "png",
                  height: 30,
                  width: 30,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 0, top: 10),
                        child: Caption(
                          fontWeight: FontWeight.bold,
                          str: ModuleDataList()[index]['title'],
                        ),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 0, top: 0),
                          child: Caption(
                            fontSize: 12,
                            lines: 2,
                            str: ModuleDataList()[index]['EnTitle'],
                          ))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  };
}
