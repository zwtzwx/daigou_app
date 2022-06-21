import 'package:dotted_border/dotted_border.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/logined_event.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '转运仓库',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: buildListItem,
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    if (index == 0) {
      return buildTopItem();
    } else if (index == 1) {
      return const WareHouseArrdessList();
    } else if (index == 5) {
      return const SizedBox(
        height: 40,
      );
    } else {
      return buildQuickItem(index - 2);
    }
  }

  Widget buildTopItem() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Column(
              children: const [
                LoadImage(
                  'PackageAndOrder/read-icon',
                  fit: BoxFit.fitWidth,
                  width: 60,
                ),
                Caption(
                  str: '转运必读',
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ApplicationEvent.getInstance()
                  .event
                  .fire(ChangePageIndexEvent(pageName: 'middle'));
            },
            child: Column(
              children: const [
                LoadImage(
                  'PackageAndOrder/start-icon',
                  fit: BoxFit.fitWidth,
                  width: 60,
                ),
                Caption(
                  str: '开始集运',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickItem(int index) {
    List<String> titles = ['添加国内快递单号', '提交打包包裹', '支付国际物流运费'];
    List<String> contents = [
      '当您的国内快递寄出后，请添加国内包裹单号到我们的系统中，我们收到货后，会将您的包裹上架。并为您提供免费签收和仓储服务。',
      '当您的包裹都到齐后，您可以选择要寄送的包裹向仓库提交打包申请，并选择您要寄送的渠道路线。',
      '当您的包裹打包完毕后，系统会提示请您支付运费，支付完成后我们会立即为您进行国际运输。',
    ];
    List<String> btnStrs = [
      '添加快递单号',
      '前往提交',
      '前往支付',
    ];
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  color: const Color(0xFF4452cd),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Caption(
                    str: '${index + 2}',
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.hGap10,
              Caption(
                str: titles[index],
                fontSize: 16,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 40,
              top: 10,
            ),
            child: Column(
              children: [
                Caption(
                  lines: 10,
                  str: contents[index],
                  fontSize: 12,
                  color: ColorConfig.main,
                ),
                Gaps.vGap10,
                GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      ApplicationEvent.getInstance()
                          .event
                          .fire(ChangePageIndexEvent(pageName: 'middle'));
                    } else if (index == 1) {
                      Routers.push('/InWarehouseParcelListPage', context);
                    } else {
                      Routers.push('/OrderListPage', context, {'index': 2});
                    }
                  },
                  child: DottedBorder(
                    radius: const Radius.circular(5),
                    color: ColorConfig.primary,
                    borderType: BorderType.RRect,
                    dashPattern: const [5, 2],
                    child: Container(
                      height: 53,
                      color: ColorConfig.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadImage(
                            index == 0
                                ? 'PackageAndOrder/add-icon2'
                                : 'PackageAndOrder/pass-icon',
                            width: 16,
                            height: 16,
                          ),
                          Gaps.hGap10,
                          Caption(
                            str: btnStrs[index],
                            color: ColorConfig.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
    ApplicationEvent.getInstance().event.on<LoginedEvent>().listen((event) {
      getData();
    });
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
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
      child: Column(
        children: [
          buildStationBox(),
          Gaps.vGap10,
          isLoading ? buildWarehouseList() : Gaps.empty,
        ],
      ),
    );
  }

  Widget buildStationBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  color: const Color(0xFF4452cd),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: const Caption(
                    str: '1',
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.hGap10,
              const Caption(
                str: '寄件到仓库',
                fontSize: 16,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Routers.push('/StationPage', context);
            },
            child: Row(
              children: [
                const Caption(
                  str: '查看海外自提点地址',
                  color: ColorConfig.main,
                  fontSize: 12,
                ),
                Gaps.hGap10,
                ClipOval(
                  child: Container(
                    color: ColorConfig.main,
                    width: 12,
                    height: 12,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWarehouseList() {
    return Container(
      height: 430,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          TabBar(
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
            controller: _tabController,
            labelColor: ColorConfig.primary,
            unselectedLabelColor: ColorConfig.textDark,
            indicatorColor: ColorConfig.primary,
            isScrollable: true,
            tabs: buildTabItem(),
          ),
          Gaps.line,
          Expanded(
              child: PageView.builder(
            key: const Key('pageView'),
            itemCount: warehouseList.length,
            controller: _pageController,
            onPageChanged: onPageChange,
            itemBuilder: renderItem,
          ))
        ],
      ),
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
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
      child: cellItem(model),
    );
  }

  Widget cellItem(WareHouseModel model) {
    List<String> labels = [
      '收件人',
      '手机号码',
      '收件地址',
      '免费仓储',
      '邮编',
    ];

    String storeStr = '无限制';
    if (model.freeStoreDays != null && model.freeStoreDays! > 0) {
      String storeFee =
          '${localModel?.currencySymbol}${(model.storeFee! / 100).toStringAsFixed(2)}';
      storeStr = '免费仓储${model.freeStoreDays}天，超期收费$storeFee/天';
    }
    List<String> contents = [
      model.receiverName! +
          (userDetailInfomodel != null ? '(${userDetailInfomodel!.id})' : ''),
      model.phone!,
      model.address! +
          (userDetailInfomodel != null ? '(${userDetailInfomodel!.id})' : ''),
      storeStr,
      model.postcode!,
    ];
    List<Widget> widgets = [];
    for (var i = 0; i < labels.length; i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Caption(
                str: labels[i],
                color: ColorConfig.main,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Caption(
                str: contents[i],
                lines: 4,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widgets,
        Container(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              if (userDetailInfomodel == null) {
                Routers.push('/LoginPage', context);
              } else {
                String copyStr =
                    '${labels[0]}：${contents[0]}\n${labels[1]}：${contents[1]}\n${labels[4]}：${contents[4]}\n${labels[2]}：${contents[2]}';
                Clipboard.setData(ClipboardData(text: copyStr))
                    .then((value) => EasyLoading.showSuccess('复制成功'));
              }
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ColorConfig.main),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const LoadImage(
                'PackageAndOrder/copy2',
                fit: BoxFit.contain,
                width: 14,
                height: 14,
              ),
            ),
          ),
        ),
        Gaps.vGap20,
        Gaps.line,
        Gaps.vGap20,
        const Caption(
          str: '温馨提示',
          color: ColorConfig.main,
          fontSize: 12,
        ),
        Gaps.vGap10,
        Caption(
          str: model.tips ?? '',
          color: ColorConfig.main,
          fontSize: 12,
          lines: 4,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
