import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    Key? key,
    this.appBar,
    this.primary = true,
    this.backgroundColor = AppColors.bgGray,
    required this.body,
    this.bottomNavigationBar,
    required this.getPageData,
  }) : super(key: key);
  final PreferredSizeWidget? appBar;
  final bool primary;
  final Color backgroundColor;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Function getPageData;

  Future<dynamic> onPageLoad() async {
    await getPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      primary: primary,
      appBar: appBar,
      backgroundColor: AppColors.bgGray,
      bottomNavigationBar: bottomNavigationBar,
      body: FutureBuilder(
        future: onPageLoad(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('请求完成');
            if (snapshot.hasError && snapshot.error is UnAuthenticateEvent) {
              return Center(
                child: Column(
                  children: [
                    AppText(
                      str: '网络出现问题',
                    ),
                    PlainButton(text: '重新请求'),
                  ],
                ),
              );
            } else {
              return body;
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
