/*

  区号选择、国家
*/

import 'dart:async';

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryListPage extends StatefulWidget {
  final Map? arguments;
  const CountryListPage({Key? key, this.arguments}) : super(key: key);

  @override
  _CountryListPageState createState() {
    return _CountryListPageState();
  }
}

class _CountryListPageState extends State<CountryListPage> {
  final ScrollController _scrollController = ScrollController();

  List<AlphabeticalCountryModel> dataList = [];

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    created();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      created();
    });
  }

  loadList(String str) async {
    EasyLoading.show(status: Translation.t(context, '搜索中'));
    var tmp = await CommonService.getCountryListByAlphabetical({
      'keyword': str,
      'warehouse_id': widget.arguments?['warehouseId'] ?? '',
    });

    setState(() {
      dataList = tmp;
    });
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    super.dispose();
  }

  created() async {
    EasyLoading.show(status: Translation.t(context, '加载中'));
    loadList("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, '选择国家或地区'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  isSearch = !isSearch;
                  if (isSearch) {
                    created();
                  }
                });
              },
              child: Caption(
                str: !isSearch
                    ? Translation.t(context, '搜索')
                    : Translation.t(context, '取消'),
              ))
        ],
      ),
      backgroundColor: ColorConfig.bgGray,
      body: isSearch
          ? Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: SearchBar(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSearch: (str) {},
                    onSearchClick: (str) {
                      loadList(str);
                    },
                  ),
                )
              ],
            )
          : Stack(
              children: <Widget>[
                dataList.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 140,
                            width: 140,
                            child: LoadImage(
                              '',
                              fit: BoxFit.contain,
                              holderImg: "Home/empty",
                              format: "png",
                            ),
                          ),
                          Caption(
                            str: Translation.t(context, '没有匹配的国家'),
                            color: ColorConfig.textGrayC,
                          )
                        ],
                      ))
                    : Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: dataList.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<CountryModel> cellList =
                                  dataList[index].items;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  phoneCodeIndexName(context, index,
                                      dataList[index].letter.toUpperCase()),
                                  ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index2) {
                                        return GestureDetector(
                                          child: Container(
                                            color: ColorConfig.white,
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            height: 46,
                                            width:
                                                ScreenUtil().screenWidth - 50,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Caption(
                                                    str: cellList[index2]
                                                        .timezone!,
                                                  ),
                                                  Gaps.hGap10,
                                                  Caption(
                                                    str: cellList[index2].name!,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            CountryModel model =
                                                cellList[index2];
                                            if (widget.arguments != null &&
                                                model.areas != null &&
                                                model.areas!.isNotEmpty) {
                                              // 选择子区域
                                              var data = await Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return _AreaListPage(
                                                  countryModel: model,
                                                );
                                              }));
                                              if (data != null && data is Map) {
                                                data['country'] = model;
                                                Navigator.of(context).pop(data);
                                              }
                                            } else {
                                              Navigator.of(context).pop(model);
                                            }
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
                        height: double.parse((35 * dataList.length).toString()),
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  height: 35,
                                  width: 50,
                                  child: Caption(
                                    str: dataList[index].letter,
                                    color: ColorConfig.main,
                                  )),
                              onTap: () {
                                setState(() {});
                                var height = index * 25.0;
                                for (int i = 0; i < index; i++) {
                                  height += dataList[i].items.length * 46.0;
                                }
                                _scrollController.jumpTo(height);
                              },
                            );
                          },
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}

Widget phoneCodeIndexName(BuildContext context, int index, String indexName) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 15),
    width: MediaQuery.of(context).size.width,
    height: 25,
    color: HexToColor('#F5F5F5'),
    child: Caption(
      str: indexName,
    ),
  );
}

// 二三级区域
class _AreaListPage extends StatefulWidget {
  final CountryModel countryModel;
  const _AreaListPage({
    Key? key,
    required this.countryModel,
  }) : super(key: key);

  @override
  State<_AreaListPage> createState() => __AreaListPageState();
}

class __AreaListPageState extends State<_AreaListPage> {
  final ScrollController _scrollController = ScrollController();

  AreaModel? area;
  String pageTitle = '';

  // 区域列表
  List<AreaModel>? showAreas;

  @override
  initState() {
    super.initState();
    getPageTitle();
    getAreas();
  }

  void getPageTitle() {
    setState(() {
      if (area != null) {
        pageTitle = area!.name;
      } else {
        pageTitle = widget.countryModel.name!;
      }
    });
  }

  void getAreas() {
    setState(() {
      if (area != null) {
        showAreas = area!.areas;
      } else {
        showAreas = widget.countryModel.areas;
      }
    });
  }

  // 选择区域
  void onArea(AreaModel model) {
    Map<String, dynamic> params;
    if (area == null) {
      setState(() {
        area = model;
        if (model.areas != null && model.areas!.isNotEmpty) {
          Timer(const Duration(milliseconds: 500), () {
            getAreas();
            getPageTitle();
            _scrollController.jumpTo(0);
          });
        } else {
          params = {"area": area};
          Navigator.pop(context, params);
        }
      });
    } else {
      params = {"area": area, "subArea": model};
      Navigator.pop(context, params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Caption(
          str: pageTitle,
          fontSize: 18,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: showAreas?.length ?? 0,
        itemBuilder: (context, int index) {
          AreaModel model = showAreas![index];
          return Column(
            children: [
              ListTile(
                title: Caption(
                  str: model.name,
                ),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                selectedColor: ColorConfig.primary,
                trailing: area?.id == model.id
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: ColorConfig.primary,
                      )
                    : null,
                onTap: () {
                  onArea(model);
                },
              ),
              Gaps.line,
            ],
          );
        },
      ),
    );
  }
}
