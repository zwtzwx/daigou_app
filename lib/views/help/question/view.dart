import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/help/question/controller.dart';

class QuestionPage extends GetView<QuestionController> {
  const QuestionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: controller.pageTitle.value.ts,
          ),
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.articles.length,
            itemBuilder: buildBottomListCell,
          ),
        ),
      ),
    );
  }

  Widget buildBottomListCell(BuildContext context, int index) {
    ArticleModel model = controller.articles[index];
    return GestureDetector(
      onTap: () async {
        Routers.push(Routers.webview, {
          'url': model.content,
          'title': model.title,
          'time': model.createdAt
        });
      },
      child: Obx(
        () => controller.type.value == 1
            ? Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: AppColors.line,
                          style: BorderStyle.solid)),
                ),
                child: AppText(
                  str: model.title,
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: AppColors.line,
                          style: BorderStyle.solid)),
                ),
                // height: 100,
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    LoadImage(
                      model.cover.isNotEmpty ? model.coverFullPath : '',
                      width: 80,
                      height: 40,
                    ),
                    AppGaps.hGap10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          child: AppText(
                            str: model.title,
                            fontSize: 18,
                            color: AppColors.textBlack,
                          ),
                        ),
                        SizedBox(
                          child: AppText(
                            str: model.updatedAt!,
                            color: AppColors.textGrayC,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
