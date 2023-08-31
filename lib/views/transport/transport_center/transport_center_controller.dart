import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';

class TransportCenterController extends BaseController {
  Future<void> handleRefresh() async {
    ApplicationEvent.getInstance()
        .event
        .fire(PageRefreshEvent(page: 'transport'));
  }
}
