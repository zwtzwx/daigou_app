import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

/*

  分类

*/

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, this.arguments}) : super(key: key);
  final Map? arguments;

  @override
  _CategoryPageState createState() {
    return _CategoryPageState();
  }
}

class _CategoryPageState extends State<CategoryPage> {
  _CategoryPageState();

  final ScrollController _scrollController = ScrollController();
  List<GoodsCategoryModel> selectedCategories = <GoodsCategoryModel>[];

  List<GoodsCategoryModel> data = <GoodsCategoryModel>[];

  @override
  void initState() {
    super.initState();
    data = widget.arguments!['categories'];
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _callback();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callback() async {
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          title: const Caption(
            str: '添加分类',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        bottomNavigationBar: SafeArea(
            child: Material(
                //底部栏整体的颜色
                color: ColorConfig.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 1, color: ColorConfig.primary)),
                      width: ScreenUtil().screenWidth / 3,
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 15, bottom: 15),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedCategories.clear();
                          });
                        },
                        child: const Caption(
                          str: '取消',
                          color: ColorConfig.textDark,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorConfig.primary,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 1, color: ColorConfig.primary)),
                      width: ScreenUtil().screenWidth / 3,
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 15, bottom: 15),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        child: const Caption(
                          str: '确定',
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (selectedCategories.isEmpty) {}
                          Navigator.of(context).pop(selectedCategories);
                        },
                      ),
                    )
                  ],
                ))),
        body: data.isNotEmpty
            ? ListView.builder(
                controller: _scrollController,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  GoodsCategoryModel categoryModel = data[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: SizedBox(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Caption(
                                str: categoryModel.name,
                              ),
                            ],
                          ),
                        ),
                        trailing: categoryModel.children!.isNotEmpty
                            ? categoryModel.select
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                  )
                            : selectedCategories.contains(categoryModel)
                                ? const Icon(
                                    Icons.check_circle,
                                    color: ColorConfig.primary,
                                  )
                                : const Icon(
                                    Icons.radio_button_unchecked,
                                  ),
                        onTap: () {
                          setState(() {
                            if (categoryModel.children!.isEmpty) {
                              if (selectedCategories.contains(categoryModel)) {
                                selectedCategories.remove(categoryModel);
                              } else {
                                selectedCategories.add(categoryModel);
                              }
                            } else {
                              categoryModel.select = !categoryModel.select;
                            }
                          });
                        },
                      ),
                      (categoryModel.select &&
                              categoryModel.children!.isNotEmpty)
                          ? ListView.builder(
                              itemBuilder: (BuildContext context, int index2) {
                                GoodsCategoryModel subCategroyModel =
                                    categoryModel.children![index2];
                                return Container(
                                    decoration: BoxDecoration(
                                        color: ColorConfig.white,
                                        border: Border(
                                          bottom: Divider.createBorderSide(
                                              context,
                                              color: ColorConfig.line,
                                              width: 1),
                                        )),
                                    child: ListTile(
                                      trailing: selectedCategories
                                              .contains(subCategroyModel)
                                          ? const Icon(
                                              Icons.check_circle,
                                              color: ColorConfig.primary,
                                            )
                                          : const Icon(
                                              Icons.radio_button_unchecked,
                                            ),
                                      title: SizedBox(
                                        height: 44,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Caption(
                                              str: subCategroyModel.name,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (selectedCategories
                                              .contains(subCategroyModel)) {
                                            selectedCategories
                                                .remove(subCategroyModel);
                                          } else {
                                            selectedCategories
                                                .add(subCategroyModel);
                                          }
                                          // Navigator.of(context).pop();
                                        });
                                      },
                                    ));
                              },
                              itemCount: categoryModel.children!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics())
                          : Container(), //禁用滑动事件),
                    ],
                  );
                })
            : Container());
  }
}
