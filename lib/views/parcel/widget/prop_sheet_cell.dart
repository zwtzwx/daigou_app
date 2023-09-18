import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

// 物品属性
class PropSheetCell extends StatefulWidget {
  const PropSheetCell({
    Key? key,
    required this.goodsPropsList,
    required this.propSingle,
    required this.onConfirm,
    this.prop,
  }) : super(key: key);
  final List<ParcelPropsModel> goodsPropsList;
  final bool propSingle;
  final List<ParcelPropsModel>? prop;
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
          height: 310.h,
          child: Column(children: <Widget>[
            Container(
              height: 40.h,
              margin: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: AppText(
                str: '物品属性'.ts,
                fontSize: 19,
              ),
            ),
            AppGaps.line,
            Container(
              height: 190.h,
              margin: EdgeInsets.only(right: 20, left: 20, top: 15.h),
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20.0, //水平子Widget之间间距
                    mainAxisSpacing: 20.0, //垂直子Widget之间间距
                    crossAxisCount: 2, //一行的Widget数量
                    childAspectRatio: 4 / 1,
                  ), // 宽高比例
                  itemCount: widget.goodsPropsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    ParcelPropsModel propmodel = widget.goodsPropsList[index];
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: selectProp.contains(propmodel.id)
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            border:
                                Border.all(width: 1, color: AppColors.line)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppText(
                              fontSize: 14,
                              str: propmodel.name!,
                              lines: 2,
                              color: AppColors.textDark,
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
                      color: AppColors.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(width: 1, color: AppColors.primary)),
                  alignment: Alignment.center,
                  height: 35.h,
                  child: AppText(
                    str: '确认'.ts,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ]));
    });
  }
}
