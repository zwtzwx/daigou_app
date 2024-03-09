import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/services/group_service.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';

class CountdownDelay extends StatefulWidget {
  const CountdownDelay({
    Key? key,
    required this.onConfirm,
    required this.id,
  }) : super(key: key);
  final Function onConfirm;
  final int id;

  @override
  State<CountdownDelay> createState() => _CountdownDelayState();
}

class _CountdownDelayState extends State<CountdownDelay> {
  int days = 1;

  void onDayChange(int step) {
    if (step < 0 && days == 1) return;
    setState(() {
      days += step;
    });
  }

  void onSubmit() async {
    EasyLoading.show();
    var res = await GroupService.onDayDelay(widget.id, {
      'days': days,
    });
    EasyLoading.dismiss();
    if (res['ok']) {
      EasyLoading.showSuccess(res['msg']);
      Navigator.pop(context);
      widget.onConfirm();
    } else {
      EasyLoading.showError(res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              str: '延长拼团天数'.inte,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            AppGaps.vGap15,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppText(
                    str: '延长'.inte,
                    fontSize: 14,
                  ),
                ),
                AppGaps.hGap15,
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppStyles.line,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            onDayChange(-1);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.transparent,
                            child: const Icon(Icons.remove),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                vertical: BorderSide(
                                  color: AppStyles.line,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: AppText(
                              str: days.toString(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            onDayChange(1);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.transparent,
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AppGaps.vGap20,
            SizedBox(
              height: 45,
              child: BeeButton(
                text: '确认',
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
