import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/user/abount/about_me_controller.dart';

/*
  关于我们
*/

class AboutMeView extends GetView<AboutMeController> {
  const AboutMeView({Key? key}) : super(key: key);

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
            Routers.push(Routers.webview, {
              'url': model.content,
              'title': model.title,
              'time': model.createdAt
            });
          },
        ));
  }
}
