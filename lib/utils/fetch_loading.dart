import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_controller.dart';

class fetchLoading {
  final String type;
  fetchLoading({required this.type});

  // 页面数据
  Map<String, dynamic> pageData = {};
  // 返回一个data-Map
  void fetchData(Map<String, dynamic> data) {
    if(type == 'goods_details') {
        print('请求接口数据');
        EasyLoading.show();
        //实例化一个Future放到新的页面

    }
  }

}