import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactController extends BaseController {
  List<Map> contactList = [
    {'name': '广州仓库联系电话', 'value': '13016007007'},
    {'name': '阿拉木图仓库联系电话', 'value': '87079699077'},
    {'name': '投诉建议邮箱', 'value': '858080964@qq.com'},
    {'name': '加盟合作伙伴', 'value': '13247388866'},
    {'name': '业务咨询', 'value': '13247388866'},
  ];

  // 联系客服
  onContact(int index) {
    Uri uri = Uri(
      scheme: index == 2 ? 'mailto' : 'tel',
      path: contactList[index]['value'],
    );
    launchUrl(uri);
  }
}
