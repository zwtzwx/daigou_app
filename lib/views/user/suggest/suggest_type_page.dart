import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
 * 投诉建议类型
 */

class SuggestTypePage extends StatefulWidget {
  const SuggestTypePage({Key? key}) : super(key: key);

  @override
  State<SuggestTypePage> createState() => _SuggestTypePageState();
}

class _SuggestTypePageState extends State<SuggestTypePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _typeList = [
    "费用问题",
    "下单流程",
    "相关活动问题",
    "包裹签收问题",
    "收到包裹有问题",
    "轨迹显示签收但未收到包裹",
    "客服服务问题",
    "商务合作",
    "其他问题",
  ];

  List<Widget> buildTypeItem() {
    List<Widget> list = [];
    _typeList.asMap().keys.forEach((index) {
      String title = _typeList[index];
      list.add(GestureDetector(
        onTap: () {
          Routers.push('/SuggestPage', context, {"title": title});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: index == _typeList.length - 1
                  ? BorderSide.none
                  : const BorderSide(color: ColorConfig.line),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Caption(
                  str: title,
                  fontSize: 14,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: ColorConfig.textGrayC,
                size: 14,
              ),
            ],
          ),
        ),
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConfig.bgGray,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '投诉建议',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: buildTypeItem(),
          ),
        ),
      ),
    );
  }
}
