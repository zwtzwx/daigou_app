import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/services/article_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class QuestionPage extends StatefulWidget {
  final Map arguments;

  const QuestionPage({Key? key, required this.arguments}) : super(key: key);
  @override
  QuestionPageState createState() => QuestionPageState();
}

class QuestionPageState extends State<QuestionPage> {
  List<ArticleModel> articles = [];
  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    getPageTitle();
    loadList();
  }

  loadList() async {
    EasyLoading.show();
    var data = await ArticleService.getList({'type': widget.arguments['type']});
    EasyLoading.dismiss();
    setState(() {
      articles = data;
    });
  }

  void getPageTitle() {
    var type = widget.arguments['type'];
    String _pageTitle = '';
    switch (type) {
      case 1:
        _pageTitle = '常见问题';
        break;
      case 2:
        _pageTitle = '禁运物品';
        break;
      case 3:
        _pageTitle = '入门教程';
        break;
    }
    setState(() {
      pageTitle = _pageTitle;
    });
  }

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
          title: Caption(
            str: Translation.t(context, pageTitle),
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        body: SafeArea(
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: buildBottomListCell,
          ),
        ));
  }

  Widget buildBottomListCell(BuildContext context, int index) {
    ArticleModel model = articles[index];
    return GestureDetector(
        onTap: () async {
          Routers.push('/webview', context, {
            'url': model.content,
            'title': model.title,
            'time': model.createdAt
          });
        },
        child: widget.arguments['type'] == 1
            ? Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                decoration: const BoxDecoration(
                  color: ColorConfig.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: ColorConfig.line,
                          style: BorderStyle.solid)),
                ),
                child: Caption(
                  str: model.title,
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  color: ColorConfig.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: ColorConfig.line,
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
                    Gaps.hGap10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          child: Caption(
                            str: model.title,
                            fontSize: 18,
                            color: ColorConfig.textBlack,
                          ),
                        ),
                        SizedBox(
                          child: Caption(
                            str: model.updatedAt!,
                            color: ColorConfig.textGrayC,
                          ),
                        ),
                      ],
                    ),
                  ],
                )));
  }
}
