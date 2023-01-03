// 轮播图组件
import 'package:flutter/cupertino.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/models/ads_pic_model.dart';
import 'package:jiyun_app_client/models/language_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/provider/language_provider.dart';
import 'package:jiyun_app_client/services/language_service.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:provider/provider.dart';

class BannerCell extends StatefulWidget {
  const BannerCell({Key? key, this.onFansUrl}) : super(key: key);
  final Function? onFansUrl;

  @override
  HomeAdsState createState() => HomeAdsState();
}

class HomeAdsState extends State<BannerCell>
    with AutomaticKeepAliveClientMixin {
  List<AdsPicModel> adList = [];
  List<LanguageModel> langList = [];
  // UserModel? userInfo;

  @override
  void initState() {
    super.initState();
    getLanguages();
  }

  @override
  bool get wantKeepAlive => true;

  // 获取语言列表
  getLanguages() async {
    var data = await LanguageService.getLanguage();
    setState(() {
      langList = data;
    });
  }

  // 获取用户信息
  void getUserInfo() {
    // setState(() {
    //   userInfo = Provider.of<Model>(context, listen: false).userInfo;
    // });
  }

  // 获取用户信息

  showLanguage() async {
    var code = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: langList.map((e) {
            return CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, e.languageCode);
                },
                child: Text(
                  e.name,
                ));
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              Translation.t(context, '取消'),
            ),
          ),
        );
      },
    );
    if (code != null) {
      String languge =
          Provider.of<LanguageProvider>(context, listen: false).languge;
      if (code == languge) return;
      await LanguageStore.setLanguage(code);
      ApplicationEvent.getInstance().event.fire(HomeRefreshEvent());
      Provider.of<LanguageProvider>(context, listen: false).setLanguage(code);
      Provider.of<LanguageProvider>(context, listen: false).loadTranslations();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    UserModel? userInfo = Provider.of<Model>(context, listen: true).userInfo;
    return Stack(
      children: [
        const SizedBox(
          child: LoadImage(
            'Home/bg',
            fit: BoxFit.fitWidth,
          ),
        ),
        buildLanguageView(),
        userInfo != null ? buildUserInfoCell(userInfo) : Gaps.empty,
      ],
    );
  }

  // 支持语言
  Widget buildLanguageView() {
    String language = Provider.of<LanguageProvider>(context).languge;
    var codeList = language.split('_');
    String codeStr = codeList.length > 1 ? codeList[1] : codeList[0];
    return Positioned(
      left: 10,
      top: ScreenUtil().statusBarHeight + 10,
      child: GestureDetector(
        onTap: showLanguage,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0x33000000),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4DFFFFFF)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ZHTextLine(
                  str: codeStr,
                ),
              ),
              Gaps.hGap15,
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 个人信息
  Widget buildUserInfoCell(UserModel? userInfo) {
    return Positioned(
      left: 10,
      right: 10,
      top: ScreenUtil().statusBarHeight + 60,
      child: Row(
        children: [
          Row(
            children: [
              ClipOval(
                child: LoadImage(
                  userInfo!.avatar.isNotEmpty ? userInfo.avatar : 'AboutMe/u',
                  width: 80,
                  height: 80,
                ),
              ),
              Gaps.hGap15,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil().screenWidth - 120,
                    ),
                    child: ZHTextLine(
                      str: userInfo.name,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      lines: 2,
                    ),
                  ),
                  Gaps.vGap4,
                  ZHTextLine(
                    str: userInfo.phone ?? userInfo.email ?? '',
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
