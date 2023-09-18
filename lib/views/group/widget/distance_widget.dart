import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/coordinate_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class DistanceWidget extends StatelessWidget {
  const DistanceWidget({
    Key? key,
    required this.startPosition,
    required this.endPosition,
  }) : super(key: key);
  final CoordinateModel startPosition;
  final CoordinateModel endPosition;

  calcDistance() {
    double meters = Geolocator.distanceBetween(
      startPosition.latitude!,
      startPosition.longitude!,
      endPosition.latitude!,
      endPosition.longitude!,
    );
    return meters.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return AppText(
      str: calcDistance() + ' miles',
      fontSize: 12,
      color: AppColors.green,
    );
  }
}
