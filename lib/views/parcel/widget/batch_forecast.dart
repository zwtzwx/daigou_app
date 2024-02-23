import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';

class BatchForecast extends StatefulWidget {
  const BatchForecast({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);
  final Function(List<String> value) onConfirm;

  @override
  State<BatchForecast> createState() => _BatchForecastState();
}

class _BatchForecastState extends State<BatchForecast> {
  final TextEditingController numController = TextEditingController();

  void onAdd() {
    if (numController.text.trim().isEmpty) {
      EasyLoading.showToast('请输入单号'.ts);
      return;
    }
    List<String> nums = numController.text
        .trim()
        .split('\n')
        .where((e) => e.isNotEmpty)
        .map((e) => e.replaceAll(' ', ''))
        .toList();
    widget.onConfirm(nums);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: BaseInput(
                controller: numController,
                focusNode: null,
                board: true,
                contentPadding: EdgeInsets.all(10.w),
                hintText: '每个单号一行，最多20个单号'.ts,
                maxLines: 5,
                autoShowRemove: false,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLength: 800,
              ),
            ),
            10.verticalSpaceFromWidth,
            SizedBox(
              width: double.infinity,
              height: 36.h,
              child: BeeButton(
                text: '添加',
                fontWeight: FontWeight.bold,
                onPressed: onAdd,
              ),
            )
          ],
        ),
      ),
    );
  }
}
