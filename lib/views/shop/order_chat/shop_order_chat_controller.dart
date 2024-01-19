import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/shop/consult_model.dart';
import 'package:huanting_shop/services/shop_service.dart';

class ShopOrderChatController extends GlobalLogic {
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
    BeeNav.push(BeeNav.shopOrderChatDetail, {'consult': model});
  }
}
