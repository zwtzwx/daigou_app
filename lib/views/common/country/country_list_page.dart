/*

  区号选择、国家
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/common/hex_to_color.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/country_model.dart';
import 'package:huanting_shop/views/common/country/country_controller.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/search_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryListView extends GetView<CountryController> {
  const CountryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: AppText(
            str: '选择国家或地区'.ts,
            fontSize: 18,
          ),
          actions: [
            TextButton(
              onPressed: controller.onSearch,
              child: Obx(
                () => AppText(
                  str: !controller.isSearch.value ? '搜索'.ts : '取消'.ts,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.bgGray,
        body: Obx(() {
          return controller.isSearch.value
              ? Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      child: SearchCell(
                        hintText: '输入关键字查询',
                        onSearch: (str) {
                          controller.loadList(str);
                        },
                      ),
                    )
                  ],
                )
              : Stack(
                  children: <Widget>[
                    Obx(
                      () => controller.dataList.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 140,
                                  width: 140,
                                  child: ImgItem(
                                    '',
                                    fit: BoxFit.contain,
                                    holderImg: "Home/empty",
                                    format: "png",
                                  ),
                                ),
                                AppText(
                                  str: '没有匹配的国家'.ts,
                                  color: AppColors.textGrayC,
                                )
                              ],
                            ))
                          : Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: ListView.builder(
                                  controller: controller.scrollController,
                                  itemCount: controller.dataList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<CountryModel> cellList =
                                        controller.dataList[index].items;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        phoneCodeIndexName(
                                            context,
                                            index,
                                            controller.dataList[index].letter
                                                .toUpperCase()),
                                        ListView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              return GestureDetector(
                                                child: Container(
                                                  color: AppColors.white,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  height: 46,
                                                  width:
                                                      ScreenUtil().screenWidth -
                                                          50,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        AppText(
                                                          str: cellList[index2]
                                                              .timezone!,
                                                        ),
                                                        AppGaps.hGap10,
                                                        AppText(
                                                          str: cellList[index2]
                                                              .name!,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  CountryModel model =
                                                      cellList[index2];
                                                  controller
                                                      .onCountrySelect(model);
                                                },
                                              );
                                            },
                                            itemCount: cellList.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics()) //禁用滑动事件),
                                      ],
                                    );
                                  }),
                            ),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: ScreenUtil().screenWidth - 50,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          height: ScreenUtil().screenHeight,
                          width: 50,
                          child: Container(
                            color: Colors.transparent,
                            width: 30,
                            height: double.parse(
                                (35 * controller.dataList.length).toString()),
                            child: ListView.builder(
                              itemCount: controller.dataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      height: 35,
                                      width: 50,
                                      child: AppText(
                                        str: controller.dataList[index].letter,
                                        color: AppColors.main,
                                      )),
                                  onTap: () {
                                    var height = index * 25.0;
                                    for (int i = 0; i < index; i++) {
                                      height +=
                                          controller.dataList[i].items.length *
                                              46.0;
                                    }
                                    controller.scrollController.jumpTo(height);
                                  },
                                );
                              },
                            ),
                          ),
                        )),
                  ],
                );
        }));
  }

  Widget phoneCodeIndexName(BuildContext context, int index, String indexName) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 15),
      width: MediaQuery.of(context).size.width,
      height: 25,
      color: HexToColor('#F5F5F5'),
      child: AppText(
        str: indexName,
      ),
    );
  }
}
