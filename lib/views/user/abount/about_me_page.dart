import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/article_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huanting_shop/views/user/abount/about_me_controller.dart';

/*
  关于我们
*/

class BeePage extends GetView<BeeLogic> {
  const BeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: AppText(
          str: '关于我们'.ts,
          color: AppColors.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: renderItem,
          itemCount: controller.aboutList.length,
        ),
      ),
    );
  }

  Widget renderItem(BuildContext context, index) {
    ArticleModel model = controller.aboutList[index];

    return Container(
        color: AppColors.white,
        child: ListTile(
          title: AppText(
            str: model.title,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            BeeNav.push(BeeNav.webview, {
              'url': model.content,
              'title': model.title,
              'time': model.createdAt
            });
          },
        ));
  }
}
