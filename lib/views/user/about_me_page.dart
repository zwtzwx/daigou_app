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
                    str: '包裹集运系统',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Gaps.vGap10,
                const Text('        包裹集运系统是深圳通晓网络科技有限公司旗下的软件品牌。'),
                const Text(
                    '        深圳通晓网络科技有限公司（以下简称通晓科技）是一家专业专注服务于跨境供应链高科技企业，公司成立前身及创始人和原班团队已经在跨境物流、电商、仓储行业有了多年的软件研发实施经验，同时早期产品已经成熟运行于市场多年，并有很多的客户经验及沉淀技术基础。'),
                const Text(
                    '        通晓科技以物流供应商的信息化建设者，智慧供应链开拓者为公司愿景，提供跨境物流专线FBA系统，国际小包系统，国际集运系统、智慧云仓系统、商城系统、配送系统等解决方案，并与之相关的系统能完整打通形成完整的供应链的整体解决方案。'),
                const Text(
                    '        通晓科技以物流供应商的信息化建设者，智慧供应链开拓者为公司愿景，提供跨境物流专线FBA系统，国际小包系统，国际集运系统、智慧云仓系统、商城系统、配送系统等解决方案，并与之相关的系统能完整打通形成完整的供应链的整体解决方案。'),
                const Text('        通晓科技总部位于深圳，软件研发中心位于长沙，在广州等多地也有办事处。'),
                const Text(
                    '        包裹集运系统作为通晓科技软件品牌，将着力于打通跨境供应链各个环节，为跨境供应链企业提高工作效率，降低软件使用成本，降低软件难度为使命，为更多的企业服务。'),
                const Text('        欢迎体验咨询，联系电话：15576601706'),
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
