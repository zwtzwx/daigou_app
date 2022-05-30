/*
  公告
  */
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/home/widget/announcement_widget.dart';

// ignore: non_constant_identifier_names
Widget AnnouncementCell(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: ColorConfig.line, width: 0.6),
      ),
    ),
    height: 50,
    child: Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 35,
            right: 0,
            left: 0,
            child: Container(
              color: ColorConfig.white,
            )),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 10, left: 10, top: 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                    blurRadius: 0.1, //阴影模糊程度
                    spreadRadius: 0.4 //阴影扩散程度
                    )
              ],
              // border: new Border.all(width: 1, color: AppColor.line),
            ),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: const Icon(
                      Icons.volume_up_outlined,
                      color: ColorConfig.warningTextDark,
                    )),
                const Expanded(
                  child: AnnouncementWidget(),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
