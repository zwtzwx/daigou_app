import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/events/language_change_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/services/group_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/group/widget/countdown_widget.dart';
import 'package:jiyun_app_client/views/home/widget/title_cell.dart';

class RecommendGroupCell extends StatefulWidget {
  const RecommendGroupCell({Key? key, this.size = 1}) : super(key: key);
  final int size;

  @override
  State<RecommendGroupCell> createState() => _RecommendGroupCellState();
}

class _RecommendGroupCellState extends State<RecommendGroupCell>
    with AutomaticKeepAliveClientMixin {
  List<GroupModel> groupList = [];

  @override
  void initState() {
    super.initState();
    getList();
    ApplicationEvent.getInstance().event.on<PageRefreshEvent>().listen((event) {
      if (event.page == 'transport') {
        getList();
      }
    });
    ApplicationEvent.getInstance()
        .event
        .on<LanguageChangeEvent>()
        .listen((event) {
      getList();
    });
  }

  void getList() async {
    var data = await GroupService.getPublicGroups({'size': widget.size});
    if (data['dataList'] != null) {
      setState(() {
        groupList = data['dataList'];
      });
    }
  }

  void onDetail(int id) {
    Routers.push(Routers.groupDetail, {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleCell(
          title: '精选拼团活动',
          onMore: () {
            Routers.push(Routers.groupCenter);
          },
        ),
        ...groupList.map(
          (group) => GestureDetector(
            onTap: () {
              onDetail(group.id!);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 7.r,
                    color: const Color(0xFFF2E9E2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFF5EA), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            str: group.name ?? '',
                          ),
                        ),
                        5.horizontalSpace,
                        AppText(
                          str: group.code ?? '',
                          color: AppColors.textNormal,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            ClipOval(
                              child: LoadImage(
                                group.leader?.avatar ?? '',
                                width: 44.w,
                                height: 44.w,
                              ),
                            ),
                            5.verticalSpace,
                            AppText(
                              str: group.leader?.name ?? '',
                              fontSize: 11,
                            )
                          ],
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: const LinearGradient(
                                    colors: [Colors.white, Color(0xFFFFFAF8)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0, 1],
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFFFEFEA),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppText(
                                            str: group.expressLine
                                                    ?.referenceTime ??
                                                '',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFFA3A3A3),
                                        ),
                                        3.horizontalSpace,
                                        AppText(
                                          str: group.address
                                                  ?.getShortContent() ??
                                              '',
                                          fontSize: 10,
                                          color: AppColors.textNormal,
                                        ),
                                      ],
                                    ),
                                    5.verticalSpace,
                                    AppText(
                                      str: group.expressLine?.name ?? '',
                                      color: AppColors.textNormal,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                              5.verticalSpace,
                              AppText(
                                str: '拼邮可运'.ts +
                                    '：' +
                                    (group.expressLine?.propStr ?? ''),
                                lines: 5,
                                color: AppColors.textGrayC9,
                                fontSize: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        SizedBox(
                          width: (group.membersCount ?? 0) < 3
                              ? 40.w + ((group.membersCount ?? 0) - 1 * 10.w)
                              : 40.w,
                          height: 20.w,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: group.membersAvatar!
                                .sublist(
                                  0,
                                  group.membersCount! > 2
                                      ? 2
                                      : group.membersCount!,
                                )
                                .asMap()
                                .keys
                                .map(
                                  (index) => Positioned(
                                    left: index * 10.w,
                                    child: ClipOval(
                                      child: LoadImage(
                                        group.membersAvatar![index],
                                        width: 20.w,
                                        height: 20.w,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        3.horizontalSpace,
                        Expanded(
                          child: AppText(
                            str: '已有{count}人加入此团'.tsArgs(
                              {'count': group.membersCount.toString()},
                            ),
                            color: AppColors.textNormal,
                            fontSize: 10,
                          ),
                        ),
                        MainButton(
                          text: '参团',
                          fontSize: 14,
                          borderRadis: 999,
                          onPressed: () {
                            onDetail(group.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        AppText(
                          str: '截止时间'.ts + '：',
                          fontSize: 10,
                          color: AppColors.textNormal,
                        ),
                        CountdownWidget(
                          total: group.endUntil ?? 0,
                          color: const Color(0xFFFD5959),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
