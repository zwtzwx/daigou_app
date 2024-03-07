import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';

class ActionSheet extends StatelessWidget {
  const ActionSheet({
    Key? key,
    required this.datas,
    required this.onSelected,
  }) : super(key: key);
  final List<String> datas;
  final Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...datas.asMap().entries.map(
                (e) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    border: Border(
                      top: e.key != 0
                          ? const BorderSide(
                              color: Color(0xFFECECEC), width: 0.5)
                          : BorderSide.none,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                    title: AppText(
                      str: e.value,
                      alignment: TextAlign.center,
                    ),
                    onTap: () {
                      onSelected(e.key);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.bgGray, width: 8),
              ),
            ),
            child: SafeArea(
              child: ListTile(
                contentPadding: EdgeInsets.only(top: 5.h),
                onTap: () {
                  Navigator.pop(context);
                },
                title: AppText(
                  str: '取消'.ts,
                  alignment: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
