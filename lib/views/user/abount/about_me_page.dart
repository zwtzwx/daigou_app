import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/article_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app_client/views/user/abount/about_me_controller.dart';

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
        backgroundColor: Color(0xffFDCFCF),
        // elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: AppText(
          // str: '关于我们'.inte,
          color: AppStyles.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      body: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFDCFCF), Color(0xFFF5FAFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5],
            )
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70,bottom: 20),
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                image:DecorationImage(
                    image:AssetImage('assets/images/Center/about-logo.png')
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child:  AppText(
                str: 'Daigou.pro'.inte,
                fontSize: 16,
                color: Color(0xff333333),
              ),
            ),
            GestureDetector(
              onTap: (){
                  controller.showUpdateDialog();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15,right: 20,top: 20,bottom: 10),
                      child: Row(
                        children: [
                          AppText(
                            str: '当前版本'.inte,
                            fontSize: 16,
                            color: Color(0xff222222),
                          ),
                          Expanded(child: SizedBox()),
                          Obx(()=>AppText(
                            str: controller.nowVersion.value.inte,
                            fontSize: 16,
                            color: Color(0xff222222),
                          ))
                        ],
                      ),
                    ),
                    Obx(
                          () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: renderItem,
                        itemCount: controller.aboutList.length,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderItem(BuildContext context, index) {
    ArticleModel model = controller.aboutList[index];
    return Container(
        // color: AppStyles.white,
        child: ListTile(
          title: AppText(
            str: model.title,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
            isThreeLine: false,
          onTap: () {
            GlobalPages.push(GlobalPages.webview, arg: {
              'url': model.content,
              'title': model.title,
              'time': model.createdAt
            });
          },
        ));
  }
}
