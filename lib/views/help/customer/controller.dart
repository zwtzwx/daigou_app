import 'package:huanting_shop/config/base_conctroller.dart';

class CustomerController extends GlobalLogic {
  List<Map<String, String>> customers = [
    {'name': '微信客服', 'icon': 'Home/wx-info', 'type': 'wx'},
    {'name': 'WhatsApp', 'icon': 'Home/whatsaspp-info', 'type': 'whatsapp'},
  ];
}
