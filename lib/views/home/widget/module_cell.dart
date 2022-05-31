// ignore_for_file: non_constant_identifier_names

/*
  运费试算、仓库地址
  */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class ModuleCell extends StatefulWidget {
  const ModuleCell({Key? key}) : super(key: key);

  @override
  State<ModuleCell> createState() => _ModuleCellState();
}

class _ModuleCellState extends State<ModuleCell> {
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightNode = FocusNode();
  final TextEditingController _postcodeController = TextEditingController();
  final FocusNode _postcodeNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: 10, top: ScreenUtil().setHeight(125)),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(35),
            child: Row(
              children: [
                buildModuleTitle('运费试算', 0),
                buildModuleTitle('仓库地址', 1),
              ],
            ),
          ),
          buildQueryView(),
        ],
      ),
    );
  }

  Widget buildModuleTitle(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (index == 1) {
              ApplicationEvent.getInstance()
                  .event
                  .fire(ChangePageIndexEvent(pageName: 'warehouse'));
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == 0 ? Colors.white : ColorConfig.mainAlpha,
            borderRadius: BorderRadius.only(
              bottomLeft: index == 0 ? Radius.zero : const Radius.circular(20),
              topLeft: index == 0 ? const Radius.circular(20) : Radius.zero,
              topRight: index == 0 ? Radius.zero : const Radius.circular(20),
            ),
          ),
          child: Caption(
            str: title,
            color: index == 0 ? ColorConfig.textDark : ColorConfig.main,
          ),
        ),
      ),
    );
  }

  // 运费试算
  Widget buildQueryView() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: Column(
        children: [
          buildQueryAddress(),
          Gaps.line,
          buildQueryItem(
            '重量',
            '请输入重量，数字即可',
            _weightController,
            _weightNode,
            keyboardType: TextInputType.number,
          ),
          Gaps.line,
          buildQueryItem(
            '邮编',
            '请输入收件地址邮编',
            _postcodeController,
            _postcodeNode,
          ),
          Gaps.line,
          buildPropsView(),
          queryBtn(),
          SizedBox(
            child: Caption(
              str: '*运费试算仅为参考结果',
              fontSize: ScreenUtil().setSp(9),
              color: ColorConfig.main,
            ),
          ),
        ],
      ),
    );
  }

  // 仓库、收货地区
  Widget buildQueryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Column(
              children: [
                Caption(
                  str: '请选择',
                  color: ColorConfig.primary,
                  fontSize: ScreenUtil().setSp(18),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Caption(
                    str: '出发地',
                    color: ColorConfig.main,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: const LoadImage(
              'Home/arrow',
              fit: BoxFit.fitWidth,
              width: 60,
              format: 'png',
            ),
          ),
          GestureDetector(
            child: Column(
              children: [
                Caption(
                  str: '请选择',
                  color: ColorConfig.primary,
                  fontSize: ScreenUtil().setSp(18),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Caption(
                    str: '收货地区',
                    color: ColorConfig.main,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 物品属性
  Widget buildPropsView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          child: Caption(
            str: '货物属性',
            color: ColorConfig.main,
            fontSize: ScreenUtil().setSp(12),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(22),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorConfig.mainAlpha,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil().setWidth(70),
                  ),
                  child: Caption(
                    str: '肉制品',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorConfig.mainAlpha,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil().setWidth(70),
                  ),
                  child: Caption(
                    str: '书籍',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorConfig.mainAlpha,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil().setWidth(70),
                  ),
                  child: Caption(
                    str: '普货',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorConfig.mainAlpha,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil().setWidth(70),
                  ),
                  child: Caption(
                    str: '普货',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorConfig.mainAlpha,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil().setWidth(70),
                  ),
                  child: Caption(
                    str: '普货',
                    color: ColorConfig.primary,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 查询按钮
  Widget queryBtn() {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.only(
          top: 30,
          bottom: 10,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home/s_button.png'),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: const Caption(
          str: '查询报价',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildQueryItem(
    String label,
    String hintText,
    TextEditingController controller,
    FocusNode focusNode, {
    keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Caption(
            str: label,
            color: ColorConfig.primary,
            fontSize: ScreenUtil().setSp(18),
          ),
          Expanded(
            child: BaseInput(
              controller: controller,
              focusNode: focusNode,
              autoShowRemove: false,
              isCollapsed: true,
              textAlign: TextAlign.right,
              keyboardType: keyboardType ?? TextInputType.text,
              hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: ColorConfig.main,
              ),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
