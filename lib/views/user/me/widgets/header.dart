import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/components/caption.dart';

class MeHeader extends StatelessWidget implements PreferredSizeWidget {
  const MeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, kToolbarHeight + 10.h, 16.w, 10.h),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Center/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        height: 25.h,
        child: Row(
          children: [
            Expanded(
              child: AppText(
                str: 'emwlemlwmel',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            10.horizontalSpace,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 45.h);
}
