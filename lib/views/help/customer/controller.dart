import 'package:shop_app_client/config/base_conctroller.dart';

class CustomerController extends GlobalController {
  List<Map<String, String>> customers = [
    {'name': '微信客服', 'icon': 'Home/wx-info', 'type': 'wx'},
    {'name': 'WhatsApp', 'icon': 'Home/whatsaspp-info', 'type': 'whatsapp'},
  ];
}
