import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';

class ContactCell extends StatefulWidget {
  const ContactCell({Key? key}) : super(key: key);

  @override
  State<ContactCell> createState() => _ContactCellState();
}

class _ContactCellState extends State<ContactCell>
    with AutomaticKeepAliveClientMixin {
  late double topOffset;
  bool maskShow = false;

  @override
  void initState() {
    super.initState();
    topOffset = 320.h;
  }

  onMaskShow() {
    bool value = !maskShow;
    setState(() {
      maskShow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Offstage(
                offstage: !maskShow,
                child: GestureDetector(
                  onTap: onMaskShow,
                  child: Container(
                    color: const Color(0x99000000),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 82.w,
              top: topOffset - 88.w - 35.w,
              child: Offstage(
                offstage: !maskShow,
                child: buildHelpList(),
              ),
            ),
            Positioned(
              right: 12.w,
              top: topOffset,
              child: GestureDetector(
                  onPanUpdate: (detail) {
                    onDrag(detail.delta);
                  },
                  onTap: onMaskShow,
                  child: ImgItem(
                    'Home/contact',
                    width: 50.w,
                    height: 50.w,
                  )),
            ),
          ],
        ));
  }

  Widget buildHelpList() {
    List<Map<String, dynamic>> list = [
      {
        'name': '微信',
        'icon': 'Home/wx-info',
      },
      {
        'name': 'WhatsApp',
        'icon': 'Home/whatsaspp-info',
      },
      {'name': '帮助中心', 'icon': 'Home/bzzc', 'route': BeeNav.help},
    ];
    return Column(
      children: list
          .map(
            (e) => GestureDetector(
              onTap: () {
                if (e['route'] != null) {
                  BeeNav.push(e['route']!, e['params']);
                } else if (e['icon'] == 'Home/zzgt') {
                  // CommonMethods.onContact();
                }
              },
              child: Container(
                height: 88.w,
                width: 88.w,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImgItem(
                      e['icon']!,
                      width: 38.w,
                    ),
                    2.verticalSpaceFromWidth,
                    AppText(
                      str: (e['name']! as String).ts,
                      fontSize: 12,
                      lines: 2,
                      alignment: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void onDrag(Offset offset) {
    double dy = 0;
    // 垂直方向偏移量不能小于0不能大于屏幕最大高度
    var maxTopOffset = ScreenUtil().statusBarHeight + 135.w;
    if (topOffset + offset.dy <= maxTopOffset) {
      dy = maxTopOffset;
    } else if (topOffset + offset.dy >= (1.sh - 230.h)) {
      dy = 1.sh - 230.h;
    } else {
      dy = topOffset + offset.dy;
    }
    setState(() {
      topOffset = dy;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
