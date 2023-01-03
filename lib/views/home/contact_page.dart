import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map> _contactList = [
  {'name': '广州仓库联系电话', 'value': '13016007007'},
  {'name': '阿拉木图仓库联系电话', 'value': '87082989077'},
  {'name': '投诉建议邮箱', 'value': '858080964@qq.com'},
  {'name': '加盟合作伙伴', 'value': '13247388866'},
  {'name': '业务咨询', 'value': '13247388866'},
];

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: ZHTextLine(
          str: Translation.t(context, '联系客服'),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.builder(
          itemCount: _contactList.length,
          itemBuilder: (context, index) {
            return contactItemCell(index, _contactList[index]);
          }),
    );
  }

  Widget contactItemCell(int index, Map item) {
    return GestureDetector(
      onTap: () {
        Uri uri = Uri(
          scheme: index == 2 ? 'mailto' : 'tel',
          path: item['value'],
        );
        launchUrl(uri);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: ColorConfig.bgGray,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZHTextLine(
              str: Translation.t(context, item['name']),
            ),
            Icon(
              index == 2 ? Icons.email : Icons.phone,
              color: ColorConfig.primary,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
