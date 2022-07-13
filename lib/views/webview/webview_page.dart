import 'dart:async';
import 'dart:core';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:flutter_html/flutter_html.dart';

//浏览器
class WebViewPage extends StatefulWidget {
  final Map arguments;

  const WebViewPage({Key? key, required this.arguments}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage>
    with TickerProviderStateMixin {
  //监听URL的改变
//   StreamSubscription<String> _onUrlChanged;
// //监听WebView的状态改变
//   StreamSubscription<WebViewStateChanged> _onStateChanged;
// //监听WebView的错误状态
//   StreamSubscription<WebViewHttpError> _onHttpError;
//   final flutterWebviewPlugin = new FlutterWebviewPlugin();

  final Completer<webview.WebViewController> _controller =
      Completer<webview.WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map map = widget.arguments;
    String url = map["url"];
    String title = map["title"];
    String time = map['time'] ?? "";
    return Scaffold(
      body: url.startsWith('http')
          ? SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              child: webview.WebView(
                initialUrl: url,
                javascriptMode: webview.JavascriptMode.unrestricted,
                // gestureNavigationEnabled: true,
                onWebViewCreated:
                    (webview.WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                // onPageStarted: (value) {
                //   EasyLoading.show();
                // },
                // onPageFinished: (value) {
                //   EasyLoading.dismiss();
                // },
                navigationDelegate: (request) {
                  if (request.url.startsWith('huijing://pay')) {
                    String query = 'huijing://pay?status=1'.split('?')[1];
                    Map params = Uri.splitQueryString(query);
                    Routers.pop(context, params);
                    return webview.NavigationDecision.prevent;
                  }
                  return webview.NavigationDecision.navigate;
                },
              ),
            )
          : SingleChildScrollView(
              child: Column(
              children: <Widget>[
                SizedBox(
                    width: ScreenUtil().screenWidth,
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Html(
                          style: {
                            "*": Style(
                                fontSize: FontSize.large,
                                lineHeight: LineHeight.number(1.2))
                          },
                          data: url,
                          // onLinkTap: (linkUrl) {},
                        ))),
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  height: 60,
                  child: Caption(
                    str: time,
                  ),
                )
              ],
            )),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        //设置为白色字体
        iconTheme: const IconThemeData(
          color: Colors.black, //修改颜色
        ),
        title: Caption(
          str: title,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
