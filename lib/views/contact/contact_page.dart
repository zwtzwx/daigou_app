import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/contact/contact_controller.dart';

class ContactView extends StatelessWidget {
  ContactView({Key? key}) : super(key: key);
  final controller = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: ZHTextLine(
          str: '联系客服'.ts,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.builder(
        itemCount: controller.contactList.length,
        itemBuilder: (context, index) {
          return contactItemCell(
            index,
            controller.contactList[index],
          );
        },
      ),
    );
  }

  Widget contactItemCell(int index, Map item) {
    return GestureDetector(
      onTap: () {
        controller.onContact(index);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: BaseStylesConfig.bgGray,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZHTextLine(
              str: (item['name'] as String).ts,
            ),
            Icon(
              index == 2 ? Icons.email : Icons.phone,
              color: BaseStylesConfig.primary,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
