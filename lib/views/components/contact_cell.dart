import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class ContactCell extends StatefulWidget {
  const ContactCell({Key? key}) : super(key: key);

  @override
  State<ContactCell> createState() => _ContactCellState();
}

class _ContactCellState extends State<ContactCell>
    with AutomaticKeepAliveClientMixin {
  late double leftOffset;
  late double topOffset;
  @override
  void initState() {
    super.initState();
    leftOffset = 1.sw - 45.w;
    topOffset = 1.sh - 180.h;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Positioned(
      left: leftOffset,
      top: topOffset,
      child: GestureDetector(
        onTap: () async {
          // var showWechat = await isWeChatInstalled;
          // BaseDialog.customerDialog(context, showWechat);
        },
        onPanUpdate: (detail) {
          _calcOffset(detail.delta);
        },
        onPanEnd: (detail) {},
        child: SizedBox(
            child: LoadImage(
          'Home/contact',
          width: 45.w,
          height: 45.w,
        )),
      ),
    );
  }

  void _calcOffset(Offset offset) {
    var screenWidth = ScreenUtil().screenWidth;
    var screentHeight = ScreenUtil().screenHeight;
    double dx = 0;
    double dy = 0;
    // 水平方向偏移量不能小于0不能大于屏幕最大宽度
    if (leftOffset + offset.dx <= 0) {
      dx = 0;
    } else if (leftOffset + offset.dx >= (screenWidth - 50)) {
      dx = screenWidth - 50;
    } else {
      dx = leftOffset + offset.dx;
    }
    // 垂直方向偏移量不能小于0不能大于屏幕最大高度
    if (topOffset + offset.dy <= ScreenUtil().statusBarHeight) {
      dy = ScreenUtil().statusBarHeight;
    } else if (topOffset + offset.dy >= (screentHeight - 150)) {
      dy = screentHeight - 150;
    } else {
      dy = topOffset + offset.dy;
    }
    setState(() {
      leftOffset = dx;
      topOffset = dy;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
