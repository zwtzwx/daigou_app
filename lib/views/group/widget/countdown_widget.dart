import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({
    Key? key,
    required this.total,
    this.fontSize = 13,
    this.color = AppStyles.groupText,
    this.showSeconds = true,
    this.fontWeight = FontWeight.normal,
    this.orderPay = false,
  }) : super(key: key);
  final int total;
  final double fontSize;
  final Color color;
  final bool showSeconds;
  final FontWeight fontWeight;
  final bool orderPay;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  int day = 0;
  int hour = 0;
  int minutes = 0;
  int seconds = 0;
  int endUntil = 0;

  @override
  void initState() {
    super.initState();

    endUntil = widget.total;
    setTimer();
  }

  void setTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        day = (endUntil / (24 * 60 * 60)).floor();
        hour = (endUntil / 3600 % 24).floor();
        minutes = (endUntil / 60 % 60).floor();
        seconds = (endUntil % 60).floor();
      });
      endUntil--;
      if (endUntil <= 0) {
        _timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.total != endUntil) {
      setState(() {
        endUntil = widget.total;
      });
      _timer.cancel();
      setTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderPay) {
      return RichText(
          text: TextSpan(
              style: TextStyle(
                fontSize: 12.sp,
                color: AppStyles.textGrayC9,
              ),
              children: [
            TextSpan(
              text: '支付剩余'.inte,
            ),
            TextSpan(
              text: day > 0 ? '$day' : '',
              style: const TextStyle(
                color: AppStyles.textRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: day > 0 ? '天'.inte : '',
            ),
            TextSpan(
              text: hour > 0 ? '$hour' : '',
              style: const TextStyle(
                color: AppStyles.textRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: hour > 0 ? '小时'.inte : '',
            ),
            TextSpan(
              text: '$minutes',
              style: const TextStyle(
                color: AppStyles.textRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '分'.inte,
            ),
            TextSpan(
              text: '$seconds',
              style: const TextStyle(
                color: AppStyles.textRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '秒'.inte,
            ),
          ]));
    }
    return widget.showSeconds
        ? AppText(
            str: (day > 0 ? '$day ${'天'.inte} ' : '') +
                '${padTime(hour)}:${padTime(minutes)}:${padTime(seconds)}',
            fontSize: widget.fontSize,
            color: widget.color,
            fontWeight: widget.fontWeight,
          )
        : AppText(
            str: '剩余'.inte +
                (day > 0
                    ? '$day${'天'.inte}$hour${'小时'.inte}'
                    : '$hour${'小时'.inte}$minutes${'分钟'.inte}'),
            fontSize: widget.fontSize,
            color: widget.color,
          );
  }

  String padTime(int time) {
    if (time < 10) return '0$time';
    return time.toString();
  }
}
