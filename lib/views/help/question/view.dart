import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/article_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/help/question/controller.dart';

class BeeQusView extends GetView<BeeQusLogic> {
  const BeeQusView({Key? key}) : super(key: key);
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
            str: controller.pageTitle.value.inte,
          ),
        ),
      ),
      backgroundColor: AppStyles.bgGray,
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
        GlobalPages.push(GlobalPages.webview, arg: {
          'url': model.content,
          'title': model.title,
          'time': '',
        });
      },
      child: Obx(
        () => controller.type.value == 1
            ? Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                decoration: const BoxDecoration(
                  color: AppStyles.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: AppStyles.line,
                          style: BorderStyle.solid)),
                ),
                child: AppText(
                  str: model.title,
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  color: AppStyles.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: AppStyles.line,
                          style: BorderStyle.solid)),
                ),
                // height: 100,
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    ImgItem(
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
                            color: AppStyles.textBlack,
                          ),
                        ),
                        SizedBox(
                          child: AppText(
                            str: model.updatedAt!,
                            color: AppStyles.textGrayC,
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
