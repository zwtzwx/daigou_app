import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
  仓库地址
*/

class WareHouseAddress extends StatefulWidget {
  const WareHouseAddress({Key? key}) : super(key: key);
  @override
  WareHouseAddressState createState() => WareHouseAddressState();
}

class WareHouseAddressState extends State<WareHouseAddress>
    with SingleTickerProviderStateMixin {
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
            str: '仓库地址',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        body: const WareHouseArrdessList());
  }
}

// 仓库地址列表
class WareHouseArrdessList extends StatefulWidget {
  const WareHouseArrdessList({
    Key? key,
  }) : super(key: key);
  @override
  WareHouseArrdessListState createState() => WareHouseArrdessListState();
}

class WareHouseArrdessListState extends State<WareHouseArrdessList> {
  final GlobalKey<WareHouseArrdessListState> key = GlobalKey();
  late UserModel userDetailInfomodel;
  List<WareHouseModel> selectList = [];
  List<WareHouseModel> warehouseList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var data = await UserStorage.getUserInfo();
    setState(() {
      userDetailInfomodel = data!;
    });
    loadList();
  }

  loadList() async {
    EasyLoading.show();
    var dic = await WarehouseService.getList();
    setState(() {
      warehouseList = dic;
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorConfig.bgGray,
        child: ListView.builder(
            itemCount: warehouseList.length,
            itemBuilder: ((context, index) =>
                renderItem(index, warehouseList[index]))));
  }

  Widget renderItem(index, WareHouseModel model) {
    return Column(
      children: cellList(index, model),
    );
  }

  List<Widget> cellList(int index, WareHouseModel model) {
    List<String> titleList = ['', '收件人', '电话', '邮编', '详细地址', '温馨提示', ''];
    List<Widget> widgetList = [];
    String desWareHouse = '';
    for (var i = 0; i < titleList.length; i++) {
      String contents = '';
      switch (i) {
        case 1:
          contents = model.receiverName! +
              '(' +
              userDetailInfomodel.id.toString() +
              ')';
          break;
        case 2:
          contents = model.timezone! + model.phone!;
          break;
        case 3:
          contents = model.postcode!;
          break;
        case 4:
          contents =
              model.address! + '(' + userDetailInfomodel.id.toString() + ')';
          break;
        case 5:
          contents = model.tips!;
          break;
        default:
      }
      if (i != 0 && i != 6 && i != 5) {
        desWareHouse += titleList[i] + contents + '\n';
      }
      var view = i != 6
          ? Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  color: i == 0 ? ColorConfig.bgGray : ColorConfig.white,
                  height: i == 4 ? 89.5 : 39.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: i == 0 ? 6 : 2,
                        child: Caption(
                          str: i == 0 ? model.warehouseName! : titleList[i],
                          color: ColorConfig.textGray,
                        ),
                      ),
                      Expanded(
                          flex: i == 0 ? 6 : 7,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Caption(
                                  lines: 3,
                                  alignment: TextAlign.left,
                                  str: i == 0 ? '' : contents,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: i == 0 ? 2 : 1,
                          child: GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: contents));
                                Util.showToast('复制成功');
                              },
                              child: i == 5 || i == 0
                                  ? Container()
                                  : Container(
                                      height: 27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: ColorConfig.warningText,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                            width: 1, color: ColorConfig.line),
                                      ),
                                      child: const Caption(
                                        str: '复制',
                                        fontSize: 13,
                                        alignment: TextAlign.right,
                                        color: ColorConfig.textBlack,
                                        lines: 2,
                                      ),
                                    )))
                    ],
                  ),
                ),
                Gaps.line,
              ],
            )
          : GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: desWareHouse));
                Util.showToast('内容已复制');
              },
              child: Container(
                color: ColorConfig.bgGray,
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 10, right: 20, left: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorConfig.warningText,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(width: 1, color: ColorConfig.line),
                  ),
                  width: ScreenUtil().screenWidth - 40,
                  height: 40,
                  child: const Caption(
                    str: '一键复制仓库地址',
                    color: ColorConfig.textBlack,
                  ),
                ),
              ));
      widgetList.add(view);
    }
    return widgetList;
  }
}
