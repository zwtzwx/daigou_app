import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

/*
  仓库地址、
*/

class WarehousePage extends StatefulWidget {
  const WarehousePage({Key? key}) : super(key: key);
  @override
  WarehousePageState createState() => WarehousePageState();
}

class WarehousePageState extends State<WarehousePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: ZHTextLine(
          str: Translation.t(context, '仓库地址'),
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: buildListItem,
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    if (index == 0) {
      return buildTopItem();
    } else {
      return const WareHouseArrdessList();
    }
  }

  Widget buildTopItem() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      color: ColorConfig.warningText,
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
          ),
          Gaps.hGap5,
          Expanded(
            child: ZHTextLine(
              str: Translation.t(context, '收件人后面的字母和数字是您的唯一标识快递单务必填写'),
              color: Colors.white,
              fontSize: 13,
              lines: 2,
            ),
          ),
        ],
      ),
    );
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

class WareHouseArrdessListState extends State<WareHouseArrdessList>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<WareHouseArrdessListState> key = GlobalKey();

  UserModel? userDetailInfomodel;
  List<WareHouseModel> selectList = [];
  List<WareHouseModel> warehouseList = [];
  TabController? _tabController;
  final PageController _pageController = PageController();
  LocalizationModel? localModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    localModel = Provider.of<Model>(context, listen: false).localizationInfo;
    getData();
    loadList();
  }

  @override
  dispose() {
    _tabController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  getData() async {
    var data = await UserStorage.getUserInfo();
    setState(() {
      userDetailInfomodel = data;
    });
  }

  loadList() async {
    EasyLoading.show();
    var dic = await WarehouseService.getList();
    EasyLoading.dismiss();
    setState(() {
      warehouseList = dic;
      _tabController = TabController(length: dic.length, vsync: this);
      isLoading = true;
    });
  }

  onPageChange(int index) {
    _tabController?.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          isLoading ? buildWarehouseList() : Gaps.empty,
        ],
      ),
    );
  }

  Widget buildWarehouseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: warehouseList.length,
      itemBuilder: renderItem,
    );
  }

  List<Widget> buildTabItem() {
    List<Widget> widgets = [];
    for (var i = 0; i < warehouseList.length; i++) {
      WareHouseModel model = warehouseList[i];
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(model.warehouseName!),
      ));
    }
    return widgets;
  }

  Widget renderItem(BuildContext context, int index) {
    WareHouseModel model = warehouseList[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: cellItem(model),
    );
  }

  Widget cellItem(WareHouseModel model) {
    List<String> labels = [
      '收件人',
      '手机号码',
      '收件地址',
      '邮政编码',
      '免费仓储',
    ];

    String storeStr = Translation.t(context, '无限制');
    if (model.freeStoreDays != null && model.freeStoreDays! > 0) {
      String storeFee = (model.storeFee! / 100).toStringAsFixed(2);
      storeStr = Translation.t(context, '免费仓储{day}天超期收费{fee}/天',
          value: {'day': model.freeStoreDays, 'fee': storeFee});
    }
    List<String> contents = [
      model.receiverName! +
          (userDetailInfomodel != null ? '(HJ${userDetailInfomodel!.id})' : ''),
      model.phone!,
      model.address! +
          (userDetailInfomodel != null ? '(HJ${userDetailInfomodel!.id})' : ''),
      model.postcode!,
      storeStr,
    ];
    List<Widget> widgets = [];
    for (var i = 0; i < labels.length; i++) {
      widgets.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: ColorConfig.line),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ZHTextLine(
                str: Translation.t(context, labels[i]),
                color: ColorConfig.textGray,
                fontSize: 16,
                lines: 3,
              ),
            ),
            Expanded(
              child: ZHTextLine(
                str: contents[i],
                lines: 4,
                fontSize: 16,
              ),
            ),
            i < 4
                ? Container(
                    padding: const EdgeInsets.only(left: 15),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: ColorConfig.line),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: contents[i]))
                            .then((value) => EasyLoading.showSuccess(
                                Translation.t(context, '复制成功')));
                      },
                      child: ZHTextLine(
                        str: Translation.t(context, '复制'),
                        color: ColorConfig.primary,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Gaps.empty,
          ],
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZHTextLine(
                str: model.warehouseName!,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        ...widgets,
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ZHTextLine(
                str: Translation.t(context, '温馨提示') + '：',
                fontSize: 12,
              ),
              Gaps.vGap5,
              ZHTextLine(
                str: model.tips ?? '',
                fontSize: 12,
                lines: 4,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          height: 50,
          color: ColorConfig.bgGray,
          child: MainButton(
            text: '一键复制仓库地址',
            onPressed: () {
              String copyStr =
                  '${labels[0]}：${contents[0]}\n${labels[1]}：${contents[1]}\n${labels[4]}：${contents[4]}\n${labels[2]}：${contents[2]}';
              Clipboard.setData(ClipboardData(text: copyStr)).then((value) =>
                  EasyLoading.showSuccess(Translation.t(context, '复制成功')));
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
