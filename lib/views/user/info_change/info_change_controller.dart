import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/country_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/user_model.dart';
import 'package:shop_app_client/services/user_service.dart';

class BeeInfoLogic extends GlobalController {
  final textEditingController = TextEditingController();

  // 姓名
  final name = "".obs;
  // 姓名
  final TextEditingController nameController = TextEditingController();
}
