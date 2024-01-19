import 'package:huanting_shop/services/shop_service.dart';

class GoodsCommentModel {
  String? displayUserNick;
  String? actionSku;
  String? rateContent;
  String? rateDate;
  List<String>? pics;

  GoodsCommentModel.fromJson(Map<String, dynamic> json) {
    displayUserNick = json['display_user_nick'];
    actionSku = json['auction_sku'];
    rateContent = json['rate_content'];
    rateDate = json['rate_date'];
    if (json['pics'] is List) {
      pics = [];
      for (var pic in json['pics']) {
        pics!.add(pic.startsWith('http') ? pic : 'https:$pic');
      }
    }
  }

  Future<void> onTranslate() {
    var spuTask = ShopService.getTranslate(actionSku ?? '').then((res) {
      if (res != null) {
        actionSku = res;
      }
    });
    var contentTask = ShopService.getTranslate(rateContent ?? '').then((res) {
      if (res != null) {
        rateContent = res;
      }
    });
    return Future.wait([spuTask, contentTask]);
  }
}
