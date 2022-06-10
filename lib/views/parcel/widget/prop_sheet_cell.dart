import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class PropSheetCell extends StatefulWidget {
  const PropSheetCell({
    Key? key,
    required this.goodsPropsList,
    required this.propSingle,
    required this.onConfirm,
    this.prop,
  }) : super(key: key);
  final List<GoodsPropsModel> goodsPropsList;
  final bool propSingle;
  final List<GoodsPropsModel>? prop;
  final Function onConfirm;
  @override
  State<PropSheetCell> createState() => _PropSheetCellState();
}

class _PropSheetCellState extends State<PropSheetCell> {
  late List<int> selectProp;

  @override
  void initState() {
    super.initState();
    if (widget.prop != null) {
      selectProp = widget.prop!.map((e) => e.id).toList();
    } else {
      selectProp = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context1, setBottomSheetState) {
      return SizedBox(
          height: 320,
          child: Column(children: <Widget>[
            Container(
              height: 44,
              margin: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: const Caption(
                str: '物品属性',
                fontSize: 19,
              ),
            ),
            Gaps.line,
            Container(
              height: 190,
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20.0, //水平子Widget之间间距
                    mainAxisSpacing: 20.0, //垂直子Widget之间间距
                    crossAxisCount: 3, //一行的Widget数量
                    childAspectRatio: 2.6,
                  ), // 宽高比例
                  itemCount: widget.goodsPropsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    GoodsPropsModel propmodel = widget.goodsPropsList[index];
                    return GestureDetector(
                      onTap: () {
                        int id = widget.goodsPropsList[index].id;
                        setBottomSheetState(() {
                          if (selectProp.contains(id)) {
                            selectProp.remove(id);
                          } else {
                            if (widget.propSingle) {
                              selectProp.isEmpty
                                  ? (selectProp.insert(0, id))
                                  : (selectProp[0] = id);
                            } else {
                              selectProp.add(id);
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: selectProp.contains(propmodel.id)
                                ? ColorConfig.primary
                                : ColorConfig.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            border:
                                Border.all(width: 1, color: ColorConfig.line)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Caption(
                              fontSize: 14,
                              str: propmodel.name!,
                              color: selectProp.contains(propmodel.id)
                                  ? Colors.white
                                  : ColorConfig.textDark,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectProp.isNotEmpty) {
                      var props = widget.goodsPropsList
                          .where((ele) => selectProp.contains(ele.id))
                          .toList();
                      widget.onConfirm(props);
                    }
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  decoration: BoxDecoration(
                      color: ColorConfig.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(width: 1, color: ColorConfig.primary)),
                  alignment: Alignment.center,
                  height: 40,
                  child: const Caption(
                    str: '确定',
                    color: Colors.white,
                  ),
                )),
          ]));
    });
  }
}
