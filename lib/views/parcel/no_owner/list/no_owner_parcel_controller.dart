import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';

class NoOwnerParcelController extends BaseController {
  final TextEditingController keywordController = TextEditingController();

  final FocusNode focusNode = FocusNode();
  int pageIndex = 0;

  // 搜索
  onSearch() {
    ApplicationEvent.getInstance()
        .event
        .fire(ListRefreshEvent(type: 'refresh'));
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> params = {
      "page": (++pageIndex),
      'keyword': keywordController.text
    };

    var data = ParcelService.getOnOwnerList(params);
    return data;
  }

  void toDetail(ParcelModel model) {
    Routers.push(Routers.noOwnerDetail, {'order': model});
  }
}
