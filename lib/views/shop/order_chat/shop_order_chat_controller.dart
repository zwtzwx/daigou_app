import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/shop/consult_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';

class ShopOrderChatController extends BaseController {
  int page = 0;

  loadData({type}) async {
    page = 0;
    return await loadMoreData();
  }

  loadMoreData() async {
    var params = {'page': ++page, 'size': 10};

    var data = await ShopService.getMessage(params);
    return data;
  }

  void onDetail(ConsultModel model) {
    Routers.push(Routers.shopOrderChatDetail, {'consult': model});
  }
}
