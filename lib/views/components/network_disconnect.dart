import 'package:flutter/material.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';

class NetWorkDisconnect extends StatefulWidget {
  const NetWorkDisconnect({Key? key, required this.onPressed}) : super(key: key);
  final Function onPressed;

  @override
  _NetWorkDisconnectState createState() => _NetWorkDisconnectState();
}

class _NetWorkDisconnectState extends State<NetWorkDisconnect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white
      ),
      height: ScreenUtil().screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            width: ScreenUtil().screenWidth,
            height: 300.h,
            decoration: BoxDecoration(
              image:DecorationImage(
                  image:AssetImage('assets/images/Home/net-disconnect.png')
              ),
            ),
            child: AppText(
              str: '暂无网络 请重新尝试'.inte+'~',
              fontSize: 12,
              color: Color(0xff4F4F4F),
            ),
          ),
          9.verticalSpace,
          SizedBox(
            height: 30,
            child: BeeButton(
              text: '点此刷新',
              fontSize: 12,
              backgroundColor: Color(0xffFFD9D8),
              textColor: const Color(0xffF44247),
              onPressed: () {
                widget.onPressed();
              },
            ),
          )
        ],
      ),
    );
  }
}
