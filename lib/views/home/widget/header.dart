import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/views/components/base_search.dart';
import 'package:shop_app_client/views/components/load_image.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(14.w, kToolbarHeight + 10.h, 14.w, 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child:
          GestureDetector(
            onTap: () {
              GlobalPages.push(GlobalPages.goodsCategory, arg: {'autoFocus': true});
            },
            child: const BaseSearch(readOnly: true),
          ),),
          Expanded(child:
          GestureDetector(
            onTap: (){
              GlobalPages.push(GlobalPages.notice);
            },
            child: LoadAssetImage(
              'Home/message',
              width: 22.w,
              height: 22.w,
            )
          )
          )
        ],
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.h + kToolbarHeight);
}
