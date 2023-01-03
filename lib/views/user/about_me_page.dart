import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/services/article_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late List<ArticleModel> aboutList;
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
        title: ZHTextLine(
          str: Translation.t(context, '关于我们'),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          isLoading
              ? Container(
                  color: ColorConfig.bgGray,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: renderItem,
                    controller: _scrollController,
                    itemCount: aboutList.length,
                  ),
                )
              : Container(),
        ],
      )),
    );
  }

  Widget renderItem(BuildContext context, index) {
    ArticleModel model = aboutList[index];

    return Container(
        color: ColorConfig.white,
        child: ListTile(
          title: ZHTextLine(
            str: model.title,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Routers.push('/webview', context, {
              'url': model.content,
              'title': model.title,
              'time': model.createdAt
            });
          },
        ));
  }
}
