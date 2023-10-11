import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/events/logined_event.dart';
import 'package:jiyun_app_client/events/notice_refresh_event.dart';
import 'package:jiyun_app_client/models/notice_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';

class InformationLogic extends GlobalLogic {
  final name = ''.obs;
  int pageIndex = 0;

  @override
  void onInit() {
    super.onInit();
    ApplicationEvent.getInstance().event.on<LoginedEvent>().listen((event) {
      loadList();
    });
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() {
    return CommonService.getNoticeList({
      'page': ++pageIndex,
    });
  }

  onDetail(NoticeModel model, int index) async {
    if (model.value == null) return;
    if (model.type == 1) {
      await BeeNav.push(BeeNav.parcelList, 2);
    } else if ([2, 3, 5, 6, 8].contains(model.type)) {
      await BeeNav.push(BeeNav.orderDetail, {'id': num.parse(model.value!)});
    } else if (model.type == 7) {
      await BeeNav.push(
          BeeNav.webview, {'type': 'notice', 'id': num.parse(model.value!)});
    }
    await onReadInfo(model.id, index);
  }

  // 设为已读
  onReadInfo(num id, int index) async {
    var res = await CommonService.onNoticeRead({
      'ids': [id]
    });
    if (res) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'operate', index: index, value: 1));
      ApplicationEvent.getInstance().event.fire(NoticeRefreshEvent());
    }
  }
}
