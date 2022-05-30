/*

  区号选择、国家
*/

import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryListPage extends StatefulWidget {
  const CountryListPage({Key? key}) : super(key: key);

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
    EasyLoading.show(status: '搜索中...');
    var tmp =
        await CommonService.getCountryListByAlphabetical({'keyword': str});

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
    EasyLoading.show(status: '加载中...');
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
        title: const Caption(
          str: '选择国家或地区',
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
                str: !isSearch ? '搜索' : '取消',
              ))
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: isSearch
          ? Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: SearchBar(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSearch: (str) {
                      print(str);
                    },
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
                        children: const <Widget>[
                          SizedBox(
                            height: 140,
                            width: 140,
                            child: LoadImage(
                              '',
                              fit: BoxFit.contain,
                              holderImg: "PackageAndOrder/暂无内容@3x",
                              format: "png",
                            ),
                          ),
                          Caption(
                            str: '没有匹配的国家',
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
                                          onTap: () {
                                            Navigator.of(context)
                                                .pop(cellList[index2]);
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
    //  Padding(
    //   child: Text(indexName,
    //       style: TextStyle(fontSize: 20, color: Color(0xff434343))),
    //   padding: EdgeInsets.symmetric(vertical: 10),
    // ),
  );
}
