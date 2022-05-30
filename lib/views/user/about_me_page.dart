import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/change_page_index_event.dart';
import 'package:jiyun_app_client/events/home_refresh_event.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/services/article_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
// import 'package:jiyun_app_client/event/application_event.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:provider/provider.dart';

/*
  关于我们
*/

class AboutMePage extends StatefulWidget {
  const AboutMePage({Key? key}) : super(key: key);
  @override
  AboutMePageState createState() => AboutMePageState();
}

class AboutMePageState extends State<AboutMePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  late Map<dynamic, dynamic>? aboutList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadListData();
  }

  loadListData() async {
    var data = await ArticleService.getList({'type': 5});
    setState(() {
      aboutList = data;
      isLoading = true;
    });
  }

  // getArticleList
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '关于我们',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onDoubleTap: () async {
                    // String data = await UserStorage.getEnvironment();
                    // String env = data == 'dev' ? 'production' : 'dev';
                    // await UserStorage.setEnvironment(env);
                    // Provider.of<Model>(context, listen: false)
                    //     .setEnvironment(env);
                    // UserStorage.clearToken();
                    // //清除TOKEN
                    // Provider.of<Model>(context, listen: false).loginOut();
                    // ApplicationEvent.getInstance()
                    //     .event
                    //     .fire(HomeRefreshEvent());
                    // ApplicationEvent.getInstance()
                    //     .event
                    //     .fire(ChangePageIndexEvent(pageName: 'home'));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 2),
                    child: const LoadImage(
                      '',
                      fit: BoxFit.contain,
                      width: 90,
                      height: 90,
                      holderImg: "PackageAndOrder/defalutIMG@3x",
                      format: "png",
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  padding: const EdgeInsets.only(top: 10),
                  child: const Caption(
                    str: 'BeeGoPlus集运',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height: 35,
                  padding: const EdgeInsets.only(top: 10),
                  child: const Caption(
                    str: '信赖源自真诚，服务赢的未来',
                    fontSize: 14,
                    color: ColorConfig.textGray,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  color: ColorConfig.bgGray,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: renderItem,
                    controller: _scrollController,
                    itemCount: aboutList!["dataList"].length,
                  ),
                )
              : Container(),
          const SizedBox(
            child: Caption(
              str: 'Copyright@2021 上海必购家信息技术有限公司',
              fontSize: 13,
            ),
          ),
        ],
      )),
    );
  }

  Widget renderItem(BuildContext context, index) {
    ArticleModel model = aboutList!["dataList"][index];

    return Container(
        color: ColorConfig.white,
        child: ListTile(
          title: Caption(
            str: model.title,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            if (model.content.startsWith('/pages')) {
              fluwx.isWeChatInstalled.then((installed) {
                if (installed) {
                  fluwx
                      .launchWeChatMiniProgram(
                          username: 'gh_e9afa1eee63a', path: model.content)
                      .then((data) {
                    // print("---》$data");
                  });
                } else {
                  Util.showToast("请先安装微信");
                }
              });
            } else {
              Routers.push('/webview', context, {
                'url': model.content,
                'title': model.title,
                'time': model.createdAt
              });
            }
          },
        ));
  }
}
