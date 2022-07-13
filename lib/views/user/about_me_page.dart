import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/services/article_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
// import 'package:jiyun_app_client/event/application_event.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

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
        title: Caption(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Gaps.vGap20,
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: const LoadImage(
                        '',
                        fit: BoxFit.contain,
                        width: 90,
                        height: 90,
                        holderImg: "AboutMe/about-logo",
                        format: "png",
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10),
                  child: const Caption(
                    str: 'HJ EXPRESS',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Gaps.vGap10,
                const Text('        韩国汇景商社成立于2015年5月18日，是以仓储，物流，集运为主的一家商社。'),
                const Text(
                    '        商社成立以来秉承着，客户最大，信誉如金，良性竞争，有序发展的原则，坚持做韩国马来西亚商品互惠互换的纽带，让更多的马来西亚客人了解购买使用韩国商品是我们不变的宗旨。快速带给马来西亚客人更好的购物体验，为客户购物提供了更多的选择空间。带给客户更加便捷的购物体验，售前售中售后服务更加完善。五年来汇景商社在各位的帮助和鼓励下不断进步，未来五年汇景商社更不敢有丝毫懈怠，会倍加珍惜各位的厚爱，努力前行，不忘初心，下一个五年希望汇景商社能够继续陪伴各位左右。'),
                Gaps.vGap20,
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
                    itemCount: aboutList.length,
                  ),
                )
              : Container(),
          Gaps.vGap20,
          Column(
            children: const [
              Caption(
                str: 'Copyright©2021',
                color: ColorConfig.textGray,
              ),
              Caption(
                str: '韩国汇景商社 版权所有',
                color: ColorConfig.textGray,
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget renderItem(BuildContext context, index) {
    ArticleModel model = aboutList[index];

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
                          username: 'gh_4c98b7c6b461', path: model.content)
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
