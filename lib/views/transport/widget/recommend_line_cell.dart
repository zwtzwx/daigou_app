// 超值线路组件
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/home/widget/title_cell.dart';

class RecommandShipLinesCell extends StatefulWidget {
  const RecommandShipLinesCell({
    Key? key,
    this.localModel,
  }) : super(key: key);
  final LocalizationModel? localModel;

  @override
  _RecommandShipLinesState createState() => _RecommandShipLinesState();
}

class _RecommandShipLinesState extends State<RecommandShipLinesCell>
    with AutomaticKeepAliveClientMixin {
  List<ShipLineModel> lineList = [];

  List<CountryModel> countryList = [];
  CountryModel? countryModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCountries();
    loadData();
    // ApplicationEvent.getInstance().event.on<HomeRefreshEvent>().listen((event) {
    //   loadData();
    // });
  }

  void getCountries() async {
    var data = await CommonService.getCountryList();
    data.insert(0, CountryModel(id: 0, name: '全部'));
    setState(() {
      countryList = data;
      countryModel = data.first;
    });
  }

  Future<void> loadData() async {
    Map result = await ShipLineService.getList({
      'is_great_value': 1,
      'country_id': (countryModel?.id ?? 0) != 0 ? countryModel?.id : ''
    });
    setState(() {
      lineList = result['list'];
      isLoading = false;
    });
  }

  showCountryPicker() {
    Picker(
      height: 150.h,
      cancelText: '取消'.ts,
      confirmText: '确认'.ts,
      adapter: PickerDataAdapter(
        data: countryList
            .map(
              (e) => PickerItem(
                text: ZHTextLine(
                  str: e.name ?? '',
                ),
                value: e.id!,
              ),
            )
            .toList(),
      ),
      onConfirm: (picker, selected) {
        setState(() {
          countryModel = countryList[selected.first];
          isLoading = true;
        });
        loadData();
      },
    ).showModal(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        TitleCell(
          title: '精选线路',
          other: GestureDetector(
            onTap: showCountryPicker,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
              margin: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  ZHTextLine(
                    str: countryModel?.name ?? '',
                    color: const Color(0xff555555),
                    fontSize: 12,
                  ),
                  3.horizontalSpace,
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xff555555),
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 220.h,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: isLoading
              ? const Skeleton(
                  type: SkeletonType.goodsSkeleton,
                )
              : Swiper(
                  itemHeight: 220.h,
                  itemCount: (lineList.length / 2).ceil(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return layoutSubViews(index);
                  },
                  autoplay: lineList.length > 2,
                  loop: lineList.length > 2,
                ),
        ),
      ],
    );
  }

  Widget layoutSubViews(int index) {
    List<ShipLineModel> indexList = lineList.sublist(
        index * 2, (index * 2) + 2 > lineList.length ? null : (index * 2) + 2);

    var swiperView = SizedBox(
      height: 220.h,
      child: Row(children: _buildGrideForRoute(indexList)),
    );
    return swiperView;
  }

  _buildGrideForRoute(List<ShipLineModel> lineList) {
    List<Widget> lineCell = [];

    for (ShipLineModel lineItem in lineList) {
      var view = lineItemCell(lineItem);
      lineCell.add(view);
    }
    lineCell.insert(1, 12.horizontalSpace);
    return lineCell;
  }

  Widget lineItemCell(ShipLineModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      width: (1.sw - 36.w) / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEEEEEE),
            offset: const Offset(0, 2),
            blurRadius: 7.r,
          ),
        ],
      ),
      child: Column(
        children: [
          LoadImage(
            model.icon?.icon ?? '',
            width: 70.w,
          ),
          3.verticalSpace,
          ZHTextLine(
            str: model.name,
            fontWeight: FontWeight.bold,
          ),
          3.verticalSpace,
          ZHTextLine(
            str: model.region?.referenceTime ?? '',
            fontSize: 12,
            color: const Color(0xff555555),
          ),
          Expanded(
              child: Center(
            child: Text.rich(
              TextSpan(
                  style: TextStyle(
                    color: const Color(0xFFFA6363),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: widget.localModel?.currencySymbol ?? '',
                    ),
                    TextSpan(
                      text: model.basePrice,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: '起'.ts,
                    ),
                  ]),
            ),
          )),
          SizedBox(
            width: 90.w,
            child: MainButton(
              text: '更多',
              borderRadis: 999,
              fontSize: 14,
              onPressed: () {
                // Routers.push(
                //     '/LineDetailPage', context, {'id': model.id, 'type': 1});
              },
            ),
          ),
          8.verticalSpace,
          SizedBox(
            height: 28.h,
            child: ZHTextLine(
              str: '接受'.ts + '：' + model.propStr,
              fontSize: 12,
              color: BaseStylesConfig.textGrayC9,
              lines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
